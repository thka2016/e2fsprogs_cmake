# 220929
set(source_dir ${CMAKE_SOURCE_DIR}/external/zlib)

# zlib
add_library(zlib STATIC
        # Optimizations for x86-64
        #        ${source_dir}/adler32_simd.c
        #        ${source_dir}/crc32_simd.c
        #        ${source_dir}/crc_folding.c
        #        ${source_dir}/fill_window_sse.c

        # Common sources
        ${source_dir}/adler32.c
        ${source_dir}/compress.c
        ${source_dir}/cpu_features.c
        ${source_dir}/crc32.c
        ${source_dir}/deflate.c
        ${source_dir}/gzclose.c
        ${source_dir}/gzlib.c
        ${source_dir}/gzread.c
        ${source_dir}/gzwrite.c
        ${source_dir}/infback.c
        ${source_dir}/inffast.c
        ${source_dir}/inflate.c
        ${source_dir}/inftrees.c
        ${source_dir}/trees.c
        ${source_dir}/uncompr.c
        ${source_dir}/zutil.c)
if (WIN32)
    target_compile_definitions(zlib PRIVATE
            # Enable optimizations: cpu_features.c will enable them at runtime using __cpuid.
            #        ADLER32_SIMD_SSSE3
            #        CRC32_SIMD_SSE42_PCLMUL
            #        INFLATE_CHUNK_READ_64LE

            X86_WINDOWS
            ZLIB_CONST)
else()
    target_compile_definitions(zlib PRIVATE
            # Enable optimizations: cpu_features.c will enable them at runtime using __cpuid.
            #        ADLER32_SIMD_SSSE3
            #        CRC32_SIMD_SSE42_PCLMUL
            #        INFLATE_CHUNK_READ_64LE
            ZLIB_CONST)
endif ()
target_include_directories(zlib PRIVATE ${source_dir})
