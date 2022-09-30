# 220929
set(source_dir ${CMAKE_SOURCE_DIR}/system/libbase)

# libbase
set(base_src
        ${source_dir}/abi_compatibility.cpp
        ${source_dir}/chrono_utils.cpp
        ${source_dir}/posix_strerror_r.cpp
        ${source_dir}/file.cpp
        ${source_dir}/hex.cpp
        ${source_dir}/logging.cpp
        ${source_dir}/mapped_file.cpp
        ${source_dir}/parsebool.cpp
        ${source_dir}/parsenetaddress.cpp
        ${source_dir}/process.cpp
        ${source_dir}/properties.cpp
        ${source_dir}/stringprintf.cpp
        ${source_dir}/strings.cpp
        ${source_dir}/threads.cpp
        ${source_dir}/test_utils.cpp)
if (WIN32)
    set(base_src ${base_src}
            ${source_dir}/errors_windows.cpp
            ${source_dir}/utf8.cpp)
else()
    set(base_src ${base_src}
            ${source_dir}/errors_unix.cpp
            ${source_dir}/cmsg.cpp)
endif ()
add_library(base ${base_src})
target_include_directories(base PRIVATE
        ${source_dir}/include
        ${CMAKE_SOURCE_DIR}/system/logging/liblog/include)
target_compile_options(base PRIVATE
        -Wexit-time-destructors
        -D_FILE_OFFSET_BITS=64)
