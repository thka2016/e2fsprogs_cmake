/*
 * Copyright (C) 2020 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "LogBufferTest.h"

#include <unistd.h>

#include <limits>
#include <memory>
#include <regex>
#include <vector>

#include <android-base/stringprintf.h>
#include <android-base/strings.h>

#include "LogBuffer.h"
#include "LogReaderThread.h"
#include "LogWriter.h"

using android::base::Join;
using android::base::Split;
using android::base::StringPrintf;

char* android::uidToName(uid_t) {
    return nullptr;
}

static std::vector<std::string> CompareLoggerEntries(const logger_entry& expected,
                                                     const logger_entry& result, bool ignore_len) {
    std::vector<std::string> errors;
    if (!ignore_len && expected.len != result.len) {
        errors.emplace_back(
                StringPrintf("len: expected %" PRIu16 " vs %" PRIu16, expected.len, result.len));
    }
    if (expected.hdr_size != result.hdr_size) {
        errors.emplace_back(StringPrintf("hdr_size: %" PRIu16 " vs %" PRIu16, expected.hdr_size,
                                         result.hdr_size));
    }
    if (expected.pid != result.pid) {
        errors.emplace_back(
                StringPrintf("pid: expected %" PRIi32 " vs %" PRIi32, expected.pid, result.pid));
    }
    if (expected.tid != result.tid) {
        errors.emplace_back(
                StringPrintf("tid: expected %" PRIu32 " vs %" PRIu32, expected.tid, result.tid));
    }
    if (expected.sec != result.sec) {
        errors.emplace_back(
                StringPrintf("sec: expected %" PRIu32 " vs %" PRIu32, expected.sec, result.sec));
    }
    if (expected.nsec != result.nsec) {
        errors.emplace_back(
                StringPrintf("nsec: expected %" PRIu32 " vs %" PRIu32, expected.nsec, result.nsec));
    }
    if (expected.lid != result.lid) {
        errors.emplace_back(
                StringPrintf("lid: expected %" PRIu32 " vs %" PRIu32, expected.lid, result.lid));
    }
    if (expected.uid != result.uid) {
        errors.emplace_back(
                StringPrintf("uid: expected %" PRIu32 " vs %" PRIu32, expected.uid, result.uid));
    }
    return errors;
}

static std::string MakePrintable(std::string in) {
    if (in.size() > 80) {
        in = in.substr(0, 80) + "...";
    }
    std::string result;
    for (const char c : in) {
        if (isprint(c)) {
            result.push_back(c);
        } else {
            result.append(StringPrintf("\\%02x", static_cast<int>(c) & 0xFF));
        }
    }
    return result;
}

static std::string CompareMessages(const std::string& expected, const std::string& result) {
    if (expected == result) {
        return {};
    }
    size_t diff_index = 0;
    for (; diff_index < std::min(expected.size(), result.size()); ++diff_index) {
        if (expected[diff_index] != result[diff_index]) {
            break;
        }
    }

    if (diff_index < 80) {
        auto expected_short = MakePrintable(expected);
        auto result_short = MakePrintable(result);
        return StringPrintf("msg: expected '%s' vs '%s'", expected_short.c_str(),
                            result_short.c_str());
    }

    auto expected_short = MakePrintable(expected.substr(diff_index));
    auto result_short = MakePrintable(result.substr(diff_index));
    return StringPrintf("msg: index %zu: expected '%s' vs '%s'", diff_index, expected_short.c_str(),
                        result_short.c_str());
}

static std::string CompareRegexMessages(const std::string& expected, const std::string& result) {
    auto expected_pieces = Split(expected, std::string("\0", 1));
    auto result_pieces = Split(result, std::string("\0", 1));

    if (expected_pieces.size() != 3 || result_pieces.size() != 3) {
        return StringPrintf(
                "msg: should have 3 null delimited strings found %d in expected, %d in result: "
                "'%s' vs '%s'",
                static_cast<int>(expected_pieces.size()), static_cast<int>(result_pieces.size()),
                MakePrintable(expected).c_str(), MakePrintable(result).c_str());
    }
    if (expected_pieces[0] != result_pieces[0]) {
        return StringPrintf("msg: tag/priority mismatch expected '%s' vs '%s'",
                            MakePrintable(expected_pieces[0]).c_str(),
                            MakePrintable(result_pieces[0]).c_str());
    }
    std::regex expected_tag_regex(expected_pieces[1]);
    if (!std::regex_search(result_pieces[1], expected_tag_regex)) {
        return StringPrintf("msg: message regex mismatch expected '%s' vs '%s'",
                            MakePrintable(expected_pieces[1]).c_str(),
                            MakePrintable(result_pieces[1]).c_str());
    }
    if (expected_pieces[2] != result_pieces[2]) {
        return StringPrintf("msg: nothing expected after final null character '%s' vs '%s'",
                            MakePrintable(expected_pieces[2]).c_str(),
                            MakePrintable(result_pieces[2]).c_str());
    }
    return {};
}

void CompareLogMessages(const std::vector<LogMessage>& expected,
                        const std::vector<LogMessage>& result) {
    EXPECT_EQ(expected.size(), result.size());
    size_t end = std::min(expected.size(), result.size());
    size_t num_errors = 0;
    for (size_t i = 0; i < end; ++i) {
        auto errors =
                CompareLoggerEntries(expected[i].entry, result[i].entry, expected[i].regex_compare);
        auto msg_error = expected[i].regex_compare
                                 ? CompareRegexMessages(expected[i].message, result[i].message)
                                 : CompareMessages(expected[i].message, result[i].message);
        if (!msg_error.empty()) {
            errors.emplace_back(msg_error);
        }
        if (!errors.empty()) {
            GTEST_LOG_(ERROR) << "Mismatch log message " << i << "\n" << Join(errors, "\n");
            ++num_errors;
        }
    }
    EXPECT_EQ(0U, num_errors);
}

void FixupMessages(std::vector<LogMessage>* messages) {
    for (auto& [entry, message, _] : *messages) {
        entry.hdr_size = sizeof(logger_entry);
        entry.len = message.size();
    }
}

TEST_P(LogBufferTest, smoke) {
    std::vector<LogMessage> log_messages = {
            {{
                     .pid = 1,
                     .tid = 1,
                     .sec = 1234,
                     .nsec = 323001,
                     .lid = LOG_ID_MAIN,
                     .uid = 0,
             },
             "smoke test"},
    };
    FixupMessages(&log_messages);
    LogMessages(log_messages);

    auto flush_result = FlushMessages();
    EXPECT_EQ(2ULL, flush_result.next_sequence);
    CompareLogMessages(log_messages, flush_result.messages);
}

TEST_P(LogBufferTest, smoke_with_reader_thread) {
    std::vector<LogMessage> log_messages = {
            {{.pid = 1, .tid = 2, .sec = 10000, .nsec = 20001, .lid = LOG_ID_MAIN, .uid = 0},
             "first"},
            {{.pid = 10, .tid = 2, .sec = 10000, .nsec = 20002, .lid = LOG_ID_MAIN, .uid = 0},
             "second"},
            {{.pid = 100, .tid = 2, .sec = 10000, .nsec = 20003, .lid = LOG_ID_KERNEL, .uid = 0},
             "third"},
            {{.pid = 10, .tid = 2, .sec = 10000, .nsec = 20004, .lid = LOG_ID_MAIN, .uid = 0},
             "fourth"},
            {{.pid = 1, .tid = 2, .sec = 10000, .nsec = 20005, .lid = LOG_ID_RADIO, .uid = 0},
             "fifth"},
            {{.pid = 2, .tid = 2, .sec = 10000, .nsec = 20006, .lid = LOG_ID_RADIO, .uid = 0},
             "sixth"},
            {{.pid = 3, .tid = 2, .sec = 10000, .nsec = 20007, .lid = LOG_ID_RADIO, .uid = 0},
             "seventh"},
            {{.pid = 4, .tid = 2, .sec = 10000, .nsec = 20008, .lid = LOG_ID_MAIN, .uid = 0},
             "eighth"},
            {{.pid = 5, .tid = 2, .sec = 10000, .nsec = 20009, .lid = LOG_ID_CRASH, .uid = 0},
             "nineth"},
            {{.pid = 6, .tid = 2, .sec = 10000, .nsec = 20011, .lid = LOG_ID_MAIN, .uid = 0},
             "tenth"},
    };
    FixupMessages(&log_messages);
    LogMessages(log_messages);

    auto read_log_messages = ReadLogMessagesNonBlockingThread({});
    CompareLogMessages(log_messages, read_log_messages);
}

// Generate random messages, set the 'sec' parameter explicit though, to be able to track the
// expected order of messages.
LogMessage GenerateRandomLogMessage(uint32_t sec) {
    auto rand_uint32 = [](int max) -> uint32_t { return rand() % max; };
    logger_entry entry = {
            .hdr_size = sizeof(logger_entry),
            .pid = rand() % 5000,
            .tid = rand_uint32(5000),
            .sec = sec,
            .nsec = rand_uint32(NS_PER_SEC),
            .lid = rand_uint32(LOG_ID_STATS),
            .uid = rand_uint32(100000),
    };

    // See comment in ChattyLogBuffer::Log() for why this is disallowed.
    if (entry.nsec % 1000 == 0) {
        ++entry.nsec;
    }

    if (entry.lid == LOG_ID_EVENTS) {
        entry.lid = LOG_ID_KERNEL;
    }

    std::string message;
    char priority = ANDROID_LOG_INFO + rand() % 2;
    message.push_back(priority);

    int tag_length = 2 + rand() % 10;
    for (int i = 0; i < tag_length; ++i) {
        message.push_back('a' + rand() % 26);
    }
    message.push_back('\0');

    int msg_length = 2 + rand() % 1000;
    for (int i = 0; i < msg_length; ++i) {
        message.push_back('a' + rand() % 26);
    }
    message.push_back('\0');

    entry.len = message.size();

    return {entry, message};
}

std::vector<LogMessage> GenerateRandomLogMessages(size_t count) {
    srand(1);
    std::vector<LogMessage> log_messages;
    for (size_t i = 0; i < count; ++i) {
        log_messages.emplace_back(GenerateRandomLogMessage(i));
    }
    return log_messages;
}

TEST_P(LogBufferTest, random_messages) {
    auto log_messages = GenerateRandomLogMessages(1000);
    LogMessages(log_messages);

    auto read_log_messages = ReadLogMessagesNonBlockingThread({});
    CompareLogMessages(log_messages, read_log_messages);
}

TEST_P(LogBufferTest, read_last_sequence) {
    std::vector<LogMessage> log_messages = {
            {{.pid = 1, .tid = 2, .sec = 10000, .nsec = 20001, .lid = LOG_ID_MAIN, .uid = 0},
             "first"},
            {{.pid = 10, .tid = 2, .sec = 10000, .nsec = 20002, .lid = LOG_ID_MAIN, .uid = 0},
             "second"},
            {{.pid = 100, .tid = 2, .sec = 10000, .nsec = 20003, .lid = LOG_ID_MAIN, .uid = 0},
             "third"},
    };
    FixupMessages(&log_messages);
    LogMessages(log_messages);

    std::vector<LogMessage> expected_log_messages = {log_messages.back()};
    auto read_log_messages = ReadLogMessagesNonBlockingThread({.sequence = 3});
    CompareLogMessages(expected_log_messages, read_log_messages);
}

TEST_P(LogBufferTest, clear_logs) {
    // Log 3 initial logs.
    std::vector<LogMessage> log_messages = {
            {{.pid = 1, .tid = 2, .sec = 10000, .nsec = 20001, .lid = LOG_ID_MAIN, .uid = 0},
             "first"},
            {{.pid = 10, .tid = 2, .sec = 10000, .nsec = 20002, .lid = LOG_ID_MAIN, .uid = 0},
             "second"},
            {{.pid = 100, .tid = 2, .sec = 10000, .nsec = 20003, .lid = LOG_ID_MAIN, .uid = 0},
             "third"},
    };
    FixupMessages(&log_messages);
    LogMessages(log_messages);

    // Connect a blocking reader.
    auto blocking_reader = TestReaderThread({.non_block = false}, *this);

    // Wait up to 250ms for the reader to read the first 3 logs.
    constexpr int kMaxRetryCount = 50;
    int count = 0;
    for (; count < kMaxRetryCount; ++count) {
        usleep(5000);
        auto lock = std::lock_guard{logd_lock};
        if (reader_list_.running_reader_threads().back()->start() == 4) {
            break;
        }
    }
    ASSERT_LT(count, kMaxRetryCount);

    // Clear the log buffer.
    log_buffer_->Clear(LOG_ID_MAIN, 0);

    // Log 3 more logs.
    std::vector<LogMessage> after_clear_messages = {
            {{.pid = 1, .tid = 2, .sec = 10000, .nsec = 20001, .lid = LOG_ID_MAIN, .uid = 0},
             "4th"},
            {{.pid = 10, .tid = 2, .sec = 10000, .nsec = 20002, .lid = LOG_ID_MAIN, .uid = 0},
             "5th"},
            {{.pid = 100, .tid = 2, .sec = 10000, .nsec = 20003, .lid = LOG_ID_MAIN, .uid = 0},
             "6th"},
    };
    FixupMessages(&after_clear_messages);
    LogMessages(after_clear_messages);

    // Wait up to 250ms for the reader to read the 3 additional logs.
    for (count = 0; count < kMaxRetryCount; ++count) {
        usleep(5000);
        auto lock = std::lock_guard{logd_lock};
        if (reader_list_.running_reader_threads().back()->start() == 7) {
            break;
        }
    }
    ASSERT_LT(count, kMaxRetryCount);

    ReleaseAndJoinReaders();

    // Check that we have read all 6 messages.
    std::vector<LogMessage> expected_log_messages = log_messages;
    expected_log_messages.insert(expected_log_messages.end(), after_clear_messages.begin(),
                                 after_clear_messages.end());
    CompareLogMessages(expected_log_messages, blocking_reader.read_log_messages());

    // Finally, Flush messages and ensure that only the 3 logs after the clear remain in the buffer.
    auto flush_after_clear_result = FlushMessages();
    EXPECT_EQ(7ULL, flush_after_clear_result.next_sequence);
    CompareLogMessages(after_clear_messages, flush_after_clear_result.messages);
}

TEST_P(LogBufferTest, tail100_nonblocking_1000total) {
    auto log_messages = GenerateRandomLogMessages(1000);
    LogMessages(log_messages);

    constexpr int kTailCount = 100;
    std::vector<LogMessage> expected_log_messages{log_messages.end() - kTailCount,
                                                  log_messages.end()};
    auto read_log_messages = ReadLogMessagesNonBlockingThread({.tail = kTailCount});
    CompareLogMessages(expected_log_messages, read_log_messages);
}

TEST_P(LogBufferTest, tail100_blocking_1000total_then1000more) {
    auto log_messages = GenerateRandomLogMessages(1000);
    LogMessages(log_messages);

    constexpr int kTailCount = 100;
    auto blocking_reader = TestReaderThread({.non_block = false, .tail = kTailCount}, *this);

    std::vector<LogMessage> expected_log_messages{log_messages.end() - kTailCount,
                                                  log_messages.end()};

    std::vector<LogMessage> actual = blocking_reader.WaitForMessages(expected_log_messages.size());
    CompareLogMessages(expected_log_messages, actual);

    // Log more messages
    log_messages = GenerateRandomLogMessages(1000);
    LogMessages(log_messages);
    expected_log_messages.insert(expected_log_messages.end(), log_messages.begin(),
                                 log_messages.end());

    // Wait for the reader to have read the new messages.
    actual = blocking_reader.WaitForMessages(expected_log_messages.size());
    CompareLogMessages(expected_log_messages, actual);

    ReleaseAndJoinReaders();

    // Final check that no extraneous logs were logged.
    CompareLogMessages(expected_log_messages, blocking_reader.read_log_messages());
}

TEST_P(LogBufferTest, tail100_nonblocking_50total) {
    auto log_messages = GenerateRandomLogMessages(50);
    LogMessages(log_messages);

    constexpr int kTailCount = 100;
    auto read_log_messages = ReadLogMessagesNonBlockingThread({.tail = kTailCount});
    CompareLogMessages(log_messages, read_log_messages);
}

TEST_P(LogBufferTest, tail100_blocking_50total_then1000more) {
    auto log_messages = GenerateRandomLogMessages(50);
    LogMessages(log_messages);

    constexpr int kTailCount = 100;
    auto blocking_reader = TestReaderThread({.non_block = false, .tail = kTailCount}, *this);

    std::vector<LogMessage> expected_log_messages = log_messages;

    // Wait for the reader to have read the messages.
    std::vector<LogMessage> actual = blocking_reader.WaitForMessages(expected_log_messages.size());
    CompareLogMessages(expected_log_messages, actual);

    // Log more messages
    log_messages = GenerateRandomLogMessages(1000);
    LogMessages(log_messages);
    expected_log_messages.insert(expected_log_messages.end(), log_messages.begin(),
                                 log_messages.end());

    // Wait for the reader to have read the new messages.
    actual = blocking_reader.WaitForMessages(expected_log_messages.size());
    CompareLogMessages(expected_log_messages, actual);

    ReleaseAndJoinReaders();

    // Final check that no extraneous logs were logged.
    CompareLogMessages(expected_log_messages, blocking_reader.read_log_messages());
}

INSTANTIATE_TEST_CASE_P(LogBufferTests, LogBufferTest, testing::Values("serialized", "simple"));
