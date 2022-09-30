# 220929
set(source_dir ${CMAKE_SOURCE_DIR}/external/pcre)

add_library(pcre2
        ${source_dir}/src/pcre2_auto_possess.c
        ${source_dir}/src/pcre2_compile.c
        ${source_dir}/src/pcre2_config.c
        ${source_dir}/src/pcre2_context.c
        ${source_dir}/src/pcre2_convert.c
        ${source_dir}/src/pcre2_dfa_match.c
        ${source_dir}/src/pcre2_error.c
        ${source_dir}/src/pcre2_extuni.c
        ${source_dir}/src/pcre2_find_bracket.c
        ${source_dir}/src/pcre2_maketables.c
        ${source_dir}/src/pcre2_match.c
        ${source_dir}/src/pcre2_match_data.c
        ${source_dir}/src/pcre2_jit_compile.c
        ${source_dir}/src/pcre2_newline.c
        ${source_dir}/src/pcre2_ord2utf.c
        ${source_dir}/src/pcre2_pattern_info.c
        ${source_dir}/src/pcre2_script_run.c
        ${source_dir}/src/pcre2_serialize.c
        ${source_dir}/src/pcre2_string_utils.c
        ${source_dir}/src/pcre2_study.c
        ${source_dir}/src/pcre2_substitute.c
        ${source_dir}/src/pcre2_substring.c
        ${source_dir}/src/pcre2_tables.c
        ${source_dir}/src/pcre2_ucd.c
        ${source_dir}/src/pcre2_valid_utf.c
        ${source_dir}/src/pcre2_xclass.c
        ${source_dir}/src/pcre2_chartables.c)
target_compile_options(pcre2 PRIVATE
        -DHAVE_CONFIG_H
        -Wall
        -Werror
        -DPCRE2_CODE_UNIT_WIDTH=8)
