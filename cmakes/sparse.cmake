# 220929
set(source_dir ${CMAKE_SOURCE_DIR}/system/core/libsparse)

# sparse
add_library(sparse
        ${source_dir}/backed_block.cpp
        ${source_dir}/output_file.cpp
        ${source_dir}/sparse.cpp
        ${source_dir}/sparse_crc32.cpp
        ${source_dir}/sparse_err.cpp
        ${source_dir}/sparse_read.cpp)
#target_compile_options(sparse PRIVATE -Werror)
#target_link_libraries(sparse PRIVATE
#        libz
#        libbase)
target_include_directories(sparse PRIVATE
        ${source_dir}/include
        ${CMAKE_SOURCE_DIR}/system/libbase/include)

# simg2img
add_executable(simg2img
        ${source_dir}/simg2img.cpp
        ${source_dir}/sparse_crc32.cpp)
target_link_libraries(simg2img PRIVATE
        sparse
        zlib
        base)
target_compile_options(simg2img PRIVATE -Werror)
target_include_directories(simg2img PRIVATE ${source_dir}/include)

# img2simg
add_executable(img2simg ${source_dir}/img2simg.cpp)
target_link_libraries(img2simg PRIVATE
        sparse
        zlib
        base)
target_compile_options(img2simg PRIVATE -Werror)
target_include_directories(img2simg PRIVATE ${source_dir}/include)

# append2simg
add_executable(append2simg ${source_dir}/append2simg.cpp)
target_link_libraries(append2simg PRIVATE
        sparse
        zlib
        base)
target_compile_options(append2simg PRIVATE -Werror)
target_include_directories(append2simg PRIVATE ${source_dir}/include)

add_dependencies(img2simg simg2img append2simg)
