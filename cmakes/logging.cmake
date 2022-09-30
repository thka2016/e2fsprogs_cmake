# 220929
set(source_dir ${CMAKE_SOURCE_DIR}/system/logging)

# liblog
set(log_src
         ${source_dir}/liblog/log_event_list.cpp
         ${source_dir}/liblog/log_event_write.cpp
         ${source_dir}/liblog/logger_name.cpp
         ${source_dir}/liblog/logger_read.cpp
         ${source_dir}/liblog/logger_write.cpp
         ${source_dir}/liblog/logprint.cpp
         ${source_dir}/liblog/properties.cpp)
if (NOT WIN32)
        set(liblog_src
                ${log_src}
                ${source_dir}/liblog/event_tag_map.cpp)
endif ()
add_library(log ${log_src})
target_include_directories(log PRIVATE
         ${source_dir}/liblog/include
        ${CMAKE_SOURCE_DIR}/system/core/libcutils/include
        ${CMAKE_SOURCE_DIR}/system/libbase/include)
target_compile_options(log PRIVATE
        -Wexit-time-destructors
        -DLIBLOG_LOG_TAG=1006
        -DSNET_EVENT_LOG_TAG=1397638484

        -U__ANDROID__)
