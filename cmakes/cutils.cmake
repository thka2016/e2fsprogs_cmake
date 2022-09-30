# 220929
set(source_dir ${CMAKE_SOURCE_DIR}/system/core/libcutils)

# cutils_sockets
set(cutils_sockets_src
        ${source_dir}/sockets.cpp)
if (WIN32)
    set(cutils_sockets_src ${cutils_sockets_src}
            ${source_dir}/socket_inaddr_any_server_windows.cpp
            ${source_dir}/socket_network_client_windows.cpp
            ${source_dir}/sockets_windows.cpp)
    # -l ws2_32
else()
    set(cutils_sockets_src ${cutils_sockets_src}
            # ${source_dir}/android_get_control_file.cpp # android
            ${source_dir}/socket_inaddr_any_server_unix.cpp
            ${source_dir}/socket_local_client_unix.cpp
            ${source_dir}/socket_local_server_unix.cpp
            ${source_dir}/socket_network_client_unix.cpp
            ${source_dir}/sockets_unix.cpp)
    # target_link_libraries(cutils_sockets PRIVATE libbase) # android
    set(cutils_sockets_cflags -D_GNU_SOURCE)
endif ()
add_library(cutils_sockets ${cutils_sockets_src})
target_include_directories(cutils_sockets PRIVATE
        ${source_dir}/include)
target_compile_options(cutils_sockets PRIVATE
        ${libcutils_sockets_cflags})
#target_link_libraries(cutils_sockets PRIVATE liblog)


# cutils
set(cutils_src
        ${source_dir}/config_utils.cpp
        ${source_dir}/iosched_policy.cpp
        ${source_dir}/load_file.cpp
        ${source_dir}/native_handle.cpp
        ${source_dir}/properties.cpp
        ${source_dir}/record_stream.cpp
        ${source_dir}/strlcpy.c
        ${source_dir}/threads.cpp

        ${source_dir}/canned_fs_config.cpp
        ${source_dir}/fs_config.cpp)
if (WIN32)
    #    set(cutils_src ${cutils_src}
    #            cutils/trace-host.cpp)
    set(cutils_cflags ${cutils_cflags} -D_GNU_SOURCE)
else()
    set(cutils_src ${cutils_src}
            ${source_dir}/fs.cpp
            ${source_dir}/hashmap.cpp
            ${source_dir}/multiuser.cpp
            ${source_dir}/str_parms.cpp

            ${source_dir}/ashmem-host.cpp
            ${source_dir}/canned_fs_config.cpp
            ${source_dir}/fs_config.cpp
            ${source_dir}/trace-host.cpp)

    # android
    #    set(cutils_src ${cutils_src}
    #            ${source_dir}/android_reboot.cpp
    #            ${source_dir}/ashmem-dev.cpp
    #            ${source_dir}/klog.cpp
    #            ${source_dir}/partition_utils.cpp
    #            ${source_dir}/qtaguid.cpp # vendor,product partition exclude
    #            ${source_dir}/trace-dev.cpp
    #            ${source_dir}/uevent.cpp)
endif ()
add_library(cutils ${cutils_src})
target_include_directories(cutils PRIVATE
        ${source_dir}/include
        ${CMAKE_SOURCE_DIR}/system/libbase/include
        ${CMAKE_SOURCE_DIR}/system/logging/liblog/include
        ${CMAKE_SOURCE_DIR}/system/core/libutils/include)
target_compile_options(cutils PRIVATE
        ${cutils_cflags}
        -DANDROID_FDSAN_OWNER_TYPE_NATIVE_HANDLE=ANDROID_FDSAN_OWNER_TYPE_GENERIC_00 # fix ndk version old
        )
#target_link_libraries(libcutils PRIVATE libcutils_sockets liblog libbase)
