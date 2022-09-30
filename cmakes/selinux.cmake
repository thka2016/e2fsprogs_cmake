# 220929
set(source_dir ${CMAKE_SOURCE_DIR}/external/selinux)

# selinux
set(selinux_cflags
        -DBUILD_HOST
#        // Persistently stored patterns (pcre2) are architecture dependent.
#        // In particular paterns built on amd64 can not run on devices with armv7
#        // (32bit). Therefore, this feature stays off for now.
        -DNO_PERSISTENTLY_STORED_PATTERNS
        -DDISABLE_SETRANS
        -DDISABLE_BOOL
        -D_GNU_SOURCE
        -DNO_MEDIA_BACKEND
        -DNO_X_BACKEND
        -DNO_DB_BACKEND
        -Wall
#        -Werror
        -Wno-error=missing-noreturn
        -Wno-error=unused-function
        -Wno-error=unused-variable
        -DUSE_PCRE2
#        // 1003 corresponds to auditd, from system/core/logd/event.logtags
        -DAUDITD_LOG_TAG=1003)
add_library(selinux
        ${source_dir}/libselinux/src/android/android.c
        ${source_dir}/libselinux/src/avc.c
        ${source_dir}/libselinux/src/avc_internal.c
        ${source_dir}/libselinux/src/avc_sidtab.c
        ${source_dir}/libselinux/src/booleans.c
        ${source_dir}/libselinux/src/callbacks.c
        ${source_dir}/libselinux/src/canonicalize_context.c
        ${source_dir}/libselinux/src/checkAccess.c
        ${source_dir}/libselinux/src/check_context.c
        ${source_dir}/libselinux/src/compute_av.c
        ${source_dir}/libselinux/src/compute_create.c
        ${source_dir}/libselinux/src/compute_member.c
        ${source_dir}/libselinux/src/context.c
        ${source_dir}/libselinux/src/deny_unknown.c
        ${source_dir}/libselinux/src/disable.c
        ${source_dir}/libselinux/src/enabled.c
        ${source_dir}/libselinux/src/fgetfilecon.c
        ${source_dir}/libselinux/src/freecon.c
        ${source_dir}/libselinux/src/fsetfilecon.c
        ${source_dir}/libselinux/src/get_initial_context.c
        ${source_dir}/libselinux/src/getenforce.c
        ${source_dir}/libselinux/src/getfilecon.c
        ${source_dir}/libselinux/src/getpeercon.c
        ${source_dir}/libselinux/src/init.c
        ${source_dir}/libselinux/src/label.c
        ${source_dir}/libselinux/src/label_backends_android.c
        ${source_dir}/libselinux/src/label_file.c
        ${source_dir}/libselinux/src/label_support.c
        ${source_dir}/libselinux/src/lgetfilecon.c
        ${source_dir}/libselinux/src/load_policy.c
        ${source_dir}/libselinux/src/lsetfilecon.c
        ${source_dir}/libselinux/src/mapping.c
        ${source_dir}/libselinux/src/matchpathcon.c
        ${source_dir}/libselinux/src/policyvers.c
        ${source_dir}/libselinux/src/procattr.c
        ${source_dir}/libselinux/src/regex.c
        ${source_dir}/libselinux/src/reject_unknown.c
        ${source_dir}/libselinux/src/sestatus.c
        ${source_dir}/libselinux/src/setenforce.c
        ${source_dir}/libselinux/src/setfilecon.c
        ${source_dir}/libselinux/src/setrans_client.c
        ${source_dir}/libselinux/src/sha1.c
        ${source_dir}/libselinux/src/stringrep.c)
target_compile_options(selinux PRIVATE ${selinux_cflags})
target_include_directories(selinux PRIVATE
        ${source_dir}/libselinux/include
        ${source_dir}/libselinux/src
        ${source_dir}/libsepol/include
        ${CMAKE_SOURCE_DIR}/external/pcre/include
        ${CMAKE_SOURCE_DIR}/system/logging/liblog/include)
#target_link_libraries(selinux PRIVATE libpcre2)

add_library(sepol
        ${source_dir}/libsepol/src/assertion.c 
        ${source_dir}/libsepol/src/avrule_block.c 
        ${source_dir}/libsepol/src/avtab.c 
        ${source_dir}/libsepol/src/boolean_record.c 
        ${source_dir}/libsepol/src/booleans.c 
        ${source_dir}/libsepol/src/conditional.c 
        ${source_dir}/libsepol/src/constraint.c 
        ${source_dir}/libsepol/src/context.c 
        ${source_dir}/libsepol/src/context_record.c 
        ${source_dir}/libsepol/src/debug.c 
        ${source_dir}/libsepol/src/ebitmap.c 
        ${source_dir}/libsepol/src/expand.c 
        ${source_dir}/libsepol/src/handle.c 
        ${source_dir}/libsepol/src/hashtab.c 
        ${source_dir}/libsepol/src/hierarchy.c 
        ${source_dir}/libsepol/src/iface_record.c 
        ${source_dir}/libsepol/src/interfaces.c 
        ${source_dir}/libsepol/src/kernel_to_cil.c 
        ${source_dir}/libsepol/src/kernel_to_common.c 
        ${source_dir}/libsepol/src/kernel_to_conf.c 
        ${source_dir}/libsepol/src/link.c 
        ${source_dir}/libsepol/src/mls.c 
        ${source_dir}/libsepol/src/module.c 
        ${source_dir}/libsepol/src/module_to_cil.c 
        ${source_dir}/libsepol/src/node_record.c 
        ${source_dir}/libsepol/src/nodes.c 
        ${source_dir}/libsepol/src/optimize.c 
        ${source_dir}/libsepol/src/polcaps.c 
        ${source_dir}/libsepol/src/policydb.c 
        ${source_dir}/libsepol/src/policydb_convert.c 
        ${source_dir}/libsepol/src/policydb_public.c 
        ${source_dir}/libsepol/src/policydb_validate.c 
        ${source_dir}/libsepol/src/port_record.c 
        ${source_dir}/libsepol/src/ports.c 
        ${source_dir}/libsepol/src/services.c 
        ${source_dir}/libsepol/src/sidtab.c 
        ${source_dir}/libsepol/src/symtab.c 
        ${source_dir}/libsepol/src/user_record.c 
        ${source_dir}/libsepol/src/users.c 
        ${source_dir}/libsepol/src/util.c 
        ${source_dir}/libsepol/src/write.c 
        ${source_dir}/libsepol/cil/src/android.c 
        ${source_dir}/libsepol/cil/src/cil_binary.c 
        ${source_dir}/libsepol/cil/src/cil_build_ast.c 
        ${source_dir}/libsepol/cil/src/cil.c 
        ${source_dir}/libsepol/cil/src/cil_copy_ast.c 
        ${source_dir}/libsepol/cil/src/cil_find.c 
        ${source_dir}/libsepol/cil/src/cil_fqn.c 
        ${source_dir}/libsepol/cil/src/cil_lexer.l 
        ${source_dir}/libsepol/cil/src/cil_list.c 
        ${source_dir}/libsepol/cil/src/cil_log.c 
        ${source_dir}/libsepol/cil/src/cil_mem.c 
        ${source_dir}/libsepol/cil/src/cil_parser.c 
        ${source_dir}/libsepol/cil/src/cil_policy.c 
        ${source_dir}/libsepol/cil/src/cil_post.c 
        ${source_dir}/libsepol/cil/src/cil_reset_ast.c 
        ${source_dir}/libsepol/cil/src/cil_resolve_ast.c 
        ${source_dir}/libsepol/cil/src/cil_stack.c 
        ${source_dir}/libsepol/cil/src/cil_strpool.c 
        ${source_dir}/libsepol/cil/src/cil_symtab.c 
        ${source_dir}/libsepol/cil/src/cil_tree.c 
        ${source_dir}/libsepol/cil/src/cil_verify.c 
        ${source_dir}/libsepol/cil/src/cil_write_ast.c )
target_compile_options(sepol PRIVATE
        -DHAVE_REALLOCARRAY # bionic or musl
        -D_GNU_SOURCE
        -Wall
#        -Werror
        -W
        -Wundef
        -Wshadow
        -Wno-error=missing-noreturn
        -Wmissing-format-attribute)
target_include_directories(sepol PRIVATE
        ${source_dir}/libsepol/cil/src
        ${source_dir}/libsepol/src

        ${source_dir}/libsepol/cil/include
        ${source_dir}/libsepol/include)

# chkcon
add_executable(chkcon
        ${source_dir}/libsepol/utils/chkcon.c)
target_include_directories(chkcon PRIVATE
        ${source_dir}/libsepol/cil/src
        ${source_dir}/libsepol/src

        ${source_dir}/libsepol/cil/include
        ${source_dir}/libsepol/include)
target_link_libraries(chkcon sepol)

# sefcontext_compile
add_executable(sefcontext_compile ${selinux_src}
        ${source_dir}/libselinux/utils/sefcontext_compile.c)
target_compile_options(sefcontext_compile PRIVATE -DUSE_PCRE2)
target_include_directories(sefcontext_compile PRIVATE
        ${source_dir}/libselinux/include
        ${source_dir}/libselinux/src
        ${source_dir}/libsepol/include
        ${CMAKE_SOURCE_DIR}/external/pcre/include)
target_link_libraries(sefcontext_compile PRIVATE
        selinux sepol pcre2)
