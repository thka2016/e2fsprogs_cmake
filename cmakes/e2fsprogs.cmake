# 220929
project(e2fsprogs)
set(source_dir ${CMAKE_SOURCE_DIR}/external/e2fsprogs)

include_directories(
        ${source_dir}/lib)
add_compile_options(
        -Wall
#        -Werror
#        -Wno-error # darwin --
        -Wno-pointer-arith)
if (WIN32)
    add_compile_options(
            -Wno-typedef-redefinition
            -Wno-unused-parameter
            -Wunused-variable)
endif ()

add_library(ext2_blkid
        ${source_dir}/lib/blkid/cache.c
        ${source_dir}/lib/blkid/dev.c
        ${source_dir}/lib/blkid/devname.c
        ${source_dir}/lib/blkid/devno.c
        ${source_dir}/lib/blkid/getsize.c
        ${source_dir}/lib/blkid/llseek.c
        ${source_dir}/lib/blkid/probe.c
        ${source_dir}/lib/blkid/read.c
        ${source_dir}/lib/blkid/resolve.c
        ${source_dir}/lib/blkid/save.c
        ${source_dir}/lib/blkid/tag.c
        ${source_dir}/lib/blkid/version.c)
#target_link_libraries(ext2_blkid ext2_uuid)
if (WIN32)
    target_compile_options(ext2_blkid PRIVATE
            -Wno-error=typedef-redefinition # clang
            -Wno-pointer-to-int-cast
            -Wno-unused-variable)
    target_include_directories(ext2_blkid PRIVATE
            ${source_dir}/include/mingw)
else()
    target_compile_options(ext2_blkid PRIVATE
            -Wno-error=attributes
            -Wno-error=pointer-sign
            -Wno-unused-parameter
            -fno-strict-aliasing)
endif ()

add_library(ext2_e2p
        ${source_dir}/lib/e2p/encoding.c
        ${source_dir}/lib/e2p/errcode.c
        ${source_dir}/lib/e2p/feature.c
        ${source_dir}/lib/e2p/fgetflags.c
        ${source_dir}/lib/e2p/fsetflags.c
        ${source_dir}/lib/e2p/fgetproject.c
        ${source_dir}/lib/e2p/fsetproject.c
        ${source_dir}/lib/e2p/fgetversion.c
        ${source_dir}/lib/e2p/fsetversion.c
        ${source_dir}/lib/e2p/getflags.c
        ${source_dir}/lib/e2p/getversion.c
        ${source_dir}/lib/e2p/hashstr.c
        ${source_dir}/lib/e2p/iod.c
        ${source_dir}/lib/e2p/ljs.c
        ${source_dir}/lib/e2p/ls.c
        ${source_dir}/lib/e2p/mntopts.c
        ${source_dir}/lib/e2p/parse_num.c
        ${source_dir}/lib/e2p/pe.c
        ${source_dir}/lib/e2p/pf.c
        ${source_dir}/lib/e2p/ps.c
        ${source_dir}/lib/e2p/setflags.c
        ${source_dir}/lib/e2p/setversion.c
        ${source_dir}/lib/e2p/uuid.c
        ${source_dir}/lib/e2p/ostype.c
        ${source_dir}/lib/e2p/percent.c)
if (WIN32)
    target_compile_options(ext2_e2p PRIVATE
            -Wno-error=typedef-redefinition # clang
            -Wno-unused-variable)
    target_include_directories(ext2_e2p PRIVATE
            ${source_dir}/include/mingw)
#    target_link_libraries(ext2_e2p ws_32)
endif ()

add_library(ext2_com_err
        ${source_dir}/lib/et/error_message.c
        ${source_dir}/lib/et/et_name.c
        ${source_dir}/lib/et/init_et.c
        ${source_dir}/lib/et/com_err.c
        ${source_dir}/lib/et/com_right.c)
if (WIN32)
    target_compile_options(ext2_com_err PRIVATE
            -Wno-unused-variable)
endif ()

add_library(ext2fs
        ${source_dir}/lib/ext2fs/ext2_err.c
        ${source_dir}/lib/ext2fs/alloc.c
        ${source_dir}/lib/ext2fs/alloc_sb.c
        ${source_dir}/lib/ext2fs/alloc_stats.c
        ${source_dir}/lib/ext2fs/alloc_tables.c
        ${source_dir}/lib/ext2fs/atexit.c
        ${source_dir}/lib/ext2fs/badblocks.c
        ${source_dir}/lib/ext2fs/bb_inode.c
        ${source_dir}/lib/ext2fs/bitmaps.c
        ${source_dir}/lib/ext2fs/bitops.c
        ${source_dir}/lib/ext2fs/blkmap64_ba.c
        ${source_dir}/lib/ext2fs/blkmap64_rb.c
        ${source_dir}/lib/ext2fs/blknum.c
        ${source_dir}/lib/ext2fs/block.c
        ${source_dir}/lib/ext2fs/bmap.c
        ${source_dir}/lib/ext2fs/check_desc.c
        ${source_dir}/lib/ext2fs/crc16.c
        ${source_dir}/lib/ext2fs/crc32c.c
        ${source_dir}/lib/ext2fs/csum.c
        ${source_dir}/lib/ext2fs/closefs.c
        ${source_dir}/lib/ext2fs/dblist.c
        ${source_dir}/lib/ext2fs/dblist_dir.c
        ${source_dir}/lib/ext2fs/digest_encode.c
        ${source_dir}/lib/ext2fs/dirblock.c
        ${source_dir}/lib/ext2fs/dirhash.c
        ${source_dir}/lib/ext2fs/dir_iterate.c
        ${source_dir}/lib/ext2fs/dupfs.c
        ${source_dir}/lib/ext2fs/expanddir.c
        ${source_dir}/lib/ext2fs/ext_attr.c
        ${source_dir}/lib/ext2fs/extent.c
        ${source_dir}/lib/ext2fs/fallocate.c
        ${source_dir}/lib/ext2fs/fileio.c
        ${source_dir}/lib/ext2fs/finddev.c
        ${source_dir}/lib/ext2fs/flushb.c
        ${source_dir}/lib/ext2fs/freefs.c
        ${source_dir}/lib/ext2fs/gen_bitmap.c
        ${source_dir}/lib/ext2fs/gen_bitmap64.c
        ${source_dir}/lib/ext2fs/get_num_dirs.c
        ${source_dir}/lib/ext2fs/get_pathname.c
        ${source_dir}/lib/ext2fs/getsize.c
        ${source_dir}/lib/ext2fs/getsectsize.c
        ${source_dir}/lib/ext2fs/hashmap.c
        ${source_dir}/lib/ext2fs/i_block.c
        ${source_dir}/lib/ext2fs/icount.c
        ${source_dir}/lib/ext2fs/imager.c
        ${source_dir}/lib/ext2fs/ind_block.c
        ${source_dir}/lib/ext2fs/initialize.c
        ${source_dir}/lib/ext2fs/inline.c
        ${source_dir}/lib/ext2fs/inline_data.c
        ${source_dir}/lib/ext2fs/inode.c
        ${source_dir}/lib/ext2fs/io_manager.c
        ${source_dir}/lib/ext2fs/ismounted.c
        ${source_dir}/lib/ext2fs/link.c
        ${source_dir}/lib/ext2fs/llseek.c
        ${source_dir}/lib/ext2fs/lookup.c
        ${source_dir}/lib/ext2fs/mmp.c
        ${source_dir}/lib/ext2fs/mkdir.c
        ${source_dir}/lib/ext2fs/mkjournal.c
        ${source_dir}/lib/ext2fs/namei.c
        ${source_dir}/lib/ext2fs/native.c
        ${source_dir}/lib/ext2fs/newdir.c
        ${source_dir}/lib/ext2fs/nls_utf8.c
        ${source_dir}/lib/ext2fs/openfs.c
        ${source_dir}/lib/ext2fs/progress.c
        ${source_dir}/lib/ext2fs/punch.c
        ${source_dir}/lib/ext2fs/qcow2.c
        ${source_dir}/lib/ext2fs/rbtree.c
        ${source_dir}/lib/ext2fs/read_bb.c
        ${source_dir}/lib/ext2fs/read_bb_file.c
        ${source_dir}/lib/ext2fs/res_gdt.c
        ${source_dir}/lib/ext2fs/rw_bitmaps.c
        ${source_dir}/lib/ext2fs/sha256.c
        ${source_dir}/lib/ext2fs/sha512.c
        ${source_dir}/lib/ext2fs/swapfs.c
        ${source_dir}/lib/ext2fs/symlink.c
        ${source_dir}/lib/ext2fs/undo_io.c
        ${source_dir}/lib/ext2fs/unix_io.c
        ${source_dir}/lib/ext2fs/sparse_io.c
        ${source_dir}/lib/ext2fs/unlink.c
        ${source_dir}/lib/ext2fs/valid_blk.c
        ${source_dir}/lib/ext2fs/version.c
        # get rid of this?!
        ${source_dir}/lib/ext2fs/test_io.c)
#target_link_libraries(ext2fs
#        ext2_com_err
#        sparse
#        z)
target_include_directories(ext2fs PRIVATE
        ${CMAKE_SOURCE_DIR}/system/core/libsparse/include)
if (WIN32)
    target_include_directories(ext2fs PRIVATE
            ${source_dir}/include/mingw)
    target_compile_options(ext2fs PRIVATE
            -Wno-unused-parameter
            -Wno-error=typedef-redefinition # clang
            -Wno-error=cpp
            -Wno-format
            -Wno-unused-variable)
#    target_link_libraries(libext2fs ws2_32)
else()
    target_compile_options(ext2fs PRIVATE -Wno-unused-parameter)
endif ()

add_library(ext2_ss
        ${source_dir}/lib/ss/ss_err.c
        ${source_dir}/lib/ss/std_rqs.c
        ${source_dir}/lib/ss/invocation.c
        ${source_dir}/lib/ss/help.c
        ${source_dir}/lib/ss/execute_cmd.c
        ${source_dir}/lib/ss/listen.c
        ${source_dir}/lib/ss/parse.c
        ${source_dir}/lib/ss/error.c
        ${source_dir}/lib/ss/prompt.c
        ${source_dir}/lib/ss/request_tbl.c
        ${source_dir}/lib/ss/list_rqs.c
        ${source_dir}/lib/ss/pager.c
        ${source_dir}/lib/ss/requests.c
        ${source_dir}/lib/ss/data.c
        ${source_dir}/lib/ss/get_readline.c)
#target_link_libraries(ext2_ss ext2_com_err)

add_library(ext2_quota
        ${source_dir}/lib/support/dict.c
        ${source_dir}/lib/support/mkquota.c
        ${source_dir}/lib/support/parse_qtype.c
        ${source_dir}/lib/support/plausible.c
        ${source_dir}/lib/support/profile.c
        ${source_dir}/lib/support/profile_helpers.c
        ${source_dir}/lib/support/prof_err.c
        ${source_dir}/lib/support/quotaio.c
        ${source_dir}/lib/support/quotaio_tree.c
        ${source_dir}/lib/support/quotaio_v2.c)
#target_link_libraries(ext2_quota
#        ext2fs
#        ext2_blkid
#        ext2_com_err)

add_library(ext2_profile
        ${source_dir}/lib/support/prof_err.c
        ${source_dir}/lib/support/profile.c)
#target_link_libraries(ext2_profile ext2_com_err)

add_library(ext2_support
        ${source_dir}/lib/support/cstring.c)

add_library(ext2_uuid
        ${source_dir}/lib/uuid/clear.c
        ${source_dir}/lib/uuid/compare.c
        ${source_dir}/lib/uuid/copy.c
        ${source_dir}/lib/uuid/gen_uuid.c
        ${source_dir}/lib/uuid/isnull.c
        ${source_dir}/lib/uuid/pack.c
        ${source_dir}/lib/uuid/parse.c
        ${source_dir}/lib/uuid/unpack.c
        ${source_dir}/lib/uuid/unparse.c
        ${source_dir}/lib/uuid/uuid_time.c)
if (WIN32)
    target_include_directories(ext2_uuid PRIVATE
            ${source_dir}/include/mingw)
    target_compile_options(ext2_uuid PRIVATE
            -Wno-unused-function
            -Wno-unused-parameter
            -Wno-error
            -DUSE_MINGW)
else()
    target_compile_options(ext2_uuid PRIVATE
            -Wno-unused-function
            -Wno-unused-parameter)
endif ()

add_library(ext2_misc
        ${source_dir}/misc/create_inode.c)
#target_link_libraries(ext2_misc
#        ext2fs
#        ext2_com_err
#        ext2_quota)
if (WIN32)
    target_include_directories(ext2_misc PRIVATE
            ${source_dir}/include/mingw)
    target_compile_options(ext2_misc PRIVATE
            -Wno-unused-variable)
endif ()


# mke2fs
add_executable(mke2fs
        ${source_dir}/misc/mke2fs.c
        ${source_dir}/misc/util.c
        ${source_dir}/misc/mk_hugefiles.c
        ${source_dir}/misc/default_profile.c)
set(mke2fs_cflags
        -Wno-error=format
        -Wno-error=type-limits
        -Wno-format-extra-args)
set(mke2fs_libs
        ext2_blkid
        ext2_misc
        ext2_uuid
        ext2_quota
        ext2_com_err
        ext2_e2p
        ext2fs
        sparse
        base
        zlib)
set(mke2fs_include
        ${source_dir}/e2fsck)
if (WIN32)
    set(mke2fs_cflags ${mke2fs_cflags}
            -D_POSIX
            -D__USE_MINGW_ALARM
            # mke2fs.c has a warning from gcc which cannot be suppressed:
            # passing argument 3 of 'ext2fs_get_device_size' from
            # incompatible pointer type
            -Wno-error)
    set(mke2fs_include ${mke2fs_include} ${source_dir}/include/mingw)
    target_link_options(mke2fs PRIVATE -lws2_32)
endif ()
target_compile_options(mke2fs PRIVATE ${mke2fs_cflags})
target_link_libraries(mke2fs ${mke2fs_libs})
target_include_directories(mke2fs PRIVATE ${mke2fs_include})

# tune2fs
add_executable(tune2fs
        ${source_dir}/misc/tune2fs.c
        ${source_dir}/misc/util.c)
target_compile_options(tune2fs PRIVATE -DNO_RECOVERY)
target_include_directories(tune2fs PRIVATE ${source_dir}/e2fsck)
target_link_libraries(tune2fs
        ext2_blkid
        ext2_com_err
        ext2_quota
        ext2_uuid
        ext2_e2p
        ext2fs)

# tune2fs_lib
add_library(tune2fs_lib STATIC
        ${source_dir}/misc/tune2fs.c
        ${source_dir}/misc/util.c)
target_compile_options(tune2fs_lib PRIVATE -DNO_RECOVERY -DBUILD_AS_LIB)
target_include_directories(tune2fs_lib PRIVATE ${source_dir}/e2fsck)
target_link_libraries(tune2fs_lib
        ext2_blkid
        ext2_com_err
        ext2_quota
        ext2_uuid
        ext2_e2p
        ext2fs)

# badblocks
add_executable(badblocks ${source_dir}/misc/badblocks.c)
target_link_libraries(badblocks
        ext2fs
        ext2_com_err
        ext2_uuid
        ext2_blkid
        ext2_e2p)

# chattr-edfsprogs
add_executable(chattr-e2fsprogs ${source_dir}/misc/chattr.c)
target_link_libraries(chattr-e2fsprogs
        ext2_com_err
        ext2_e2p)

# lsattr-e2fsprogs
add_executable(lsattr-e2fsprogs ${source_dir}/misc/lsattr.c)
target_link_libraries(lsattr-e2fsprogs
        ext2_com_err
        ext2_e2p)

# blkid
add_executable(blkid ${source_dir}/misc/blkid.c)
target_link_libraries(blkid
        ext2fs
        ext2_blkid
        ext2_com_err
        ext2_e2p
        ext2_uuid)

# e4crypt
add_executable(e4crypt ${source_dir}/misc/e4crypt.c)
target_link_libraries(e4crypt
        ext2fs
        ext2_uuid)

# e2image
add_executable(e2image ${source_dir}/misc/e2image.c)
target_link_libraries(e2image
        ext2fs
        ext2_blkid
        ext2_com_err
        ext2_quota
        ext2_uuid)

# filefrag
add_executable(filefrag ${source_dir}/misc/filefrag.c)
target_link_libraries(filefrag ext2fs)

# e2freefrag
add_executable(e2freefrag ${source_dir}/misc/e2freefrag.c)
target_link_libraries(e2freefrag
        ext2fs
        ext2_com_err)

#add_subdirectory(resize)

# resize2fs
add_executable(resize2fs
        ${source_dir}/resize/extent.c
        ${source_dir}/resize/resize2fs.c
        ${source_dir}/resize/main.c
        ${source_dir}/resize/online.c
        ${source_dir}/resize/sim_progress.c
        ${source_dir}/resize/resource_track.c)
target_link_libraries(resize2fs
        ext2fs
        ext2_com_err
        ext2_e2p
        ext2_uuid
        ext2_blkid)

# e2fsdroid
set(e2fsdroid_src
        ${source_dir}/contrib/android/e2fsdroid.c
        ${source_dir}/contrib/android/block_range.c
        ${source_dir}/contrib/android/fsmap.c
        ${source_dir}/contrib/android/block_list.c
        ${source_dir}/contrib/android/base_fs.c
        ${source_dir}/contrib/android/perms.c
        ${source_dir}/contrib/android/basefs_allocator.c)
add_executable(e2fsdroid ${e2fsdroid_src})
#target_compile_options(e2fsdroid PRIVATE -U _WIN32)
target_include_directories(e2fsdroid PRIVATE
        ${source_dir}/lib/ext2fs
        ${source_dir}/misc
        ${CMAKE_SOURCE_DIR}/external/selinux/libselinux/include
        ${CMAKE_SOURCE_DIR}/system/core/libcutils/include)
if (WIN32)
    target_compile_options(e2fsdroid PRIVATE
            -U__ANDROID__
            -DWIN32)
else()
    target_compile_options(e2fsdroid PRIVATE
            -U__ANDROID__)
endif ()
target_link_options(e2fsdroid PRIVATE
        ${default_cflags})
set(e2fsdroid_libs
        ext2_com_err
        ext2_misc
        ext2fs
        sparse
        zlib
        cutils
        base
        selinux
        crypto
        log
        pcre2
        # libc++_static
        )
if (WIN32)
    set(e2fsdroid_libs ${e2fsdroid_libs} ws2_32)
endif ()
target_link_libraries(e2fsdroid ${e2fsdroid_libs})

# ext2simg
add_executable(ext2simg
        ${source_dir}/contrib/android/ext2simg.c)
target_link_libraries(ext2simg
        ext2fs
        ext2_com_err
        sparse
        base
        zlib)
target_include_directories(ext2simg PRIVATE
        ${CMAKE_SOURCE_DIR}/system/core/libsparse/include)
if (WIN32)
    target_include_directories(ext2simg PRIVATE
            ${source_dir}/include/mingw)
endif ()

# add_ext4_encrypt
add_executable(add_ext4_encrypt ${source_dir}/contrib/add_ext4_encrypt.c)
target_link_libraries(add_ext4_encrypt ${default_libs} ext2fs ext2_com_err)
target_compile_options(add_ext4_encrypt PRIVATE ${default_cflags})


# debugfs
add_executable(debugfs
        ${source_dir}/debugfs/debug_cmds.c
        ${source_dir}/debugfs/debugfs.c
        ${source_dir}/debugfs/util.c
        ${source_dir}/debugfs/ncheck.c
        ${source_dir}/debugfs/icheck.c
        ${source_dir}/debugfs/ls.c
        ${source_dir}/debugfs/lsdel.c
        ${source_dir}/debugfs/dump.c
        ${source_dir}/debugfs/set_fields.c
        ${source_dir}/debugfs/logdump.c
        ${source_dir}/debugfs/htree.c
        ${source_dir}/debugfs/unused.c
        ${source_dir}/debugfs/e2freefrag.c
        ${source_dir}/debugfs/filefrag.c
        ${source_dir}/debugfs/extent_cmds.c
        ${source_dir}/debugfs/extent_inode.c
        ${source_dir}/debugfs/zap.c
        ${source_dir}/debugfs/quota.c
        ${source_dir}/debugfs/xattrs.c
        ${source_dir}/debugfs/journal.c
        ${source_dir}/debugfs/revoke.c
        ${source_dir}/debugfs/recovery.c
        ${source_dir}/debugfs/do_journal.c)
target_compile_options(debugfs PRIVATE
        -Wno-unused-variable
        -fno-strict-aliasing
        -DDEBUGFS)
target_include_directories(debugfs PRIVATE
        ${source_dir}/misc
        ${source_dir}/e2fsck

        ${source_dir}/lib)
target_link_libraries(debugfs
        ext2_misc
        ext2fs
        ext2_blkid
        ext2_uuid
        ext2_ss
        ext2_quota
        ext2_com_err
        ext2_e2p
        ext2_support)

# e2fsck
add_executable(e2fsck
        ${source_dir}/e2fsck/e2fsck.c
        ${source_dir}/e2fsck/super.c
        ${source_dir}/e2fsck/pass1.c
        ${source_dir}/e2fsck/pass1b.c
        ${source_dir}/e2fsck/pass2.c
        ${source_dir}/e2fsck/pass3.c
        ${source_dir}/e2fsck/pass4.c
        ${source_dir}/e2fsck/pass5.c
        ${source_dir}/e2fsck/logfile.c
        ${source_dir}/e2fsck/journal.c
        ${source_dir}/e2fsck/recovery.c
        ${source_dir}/e2fsck/revoke.c
        ${source_dir}/e2fsck/badblocks.c
        ${source_dir}/e2fsck/util.c
        ${source_dir}/e2fsck/unix.c
        ${source_dir}/e2fsck/dirinfo.c
        ${source_dir}/e2fsck/dx_dirinfo.c
        ${source_dir}/e2fsck/ehandler.c
        ${source_dir}/e2fsck/problem.c
        ${source_dir}/e2fsck/message.c
        ${source_dir}/e2fsck/ea_refcount.c
        ${source_dir}/e2fsck/quota.c
        ${source_dir}/e2fsck/rehash.c
        ${source_dir}/e2fsck/region.c
        ${source_dir}/e2fsck/sigcatcher.c
        ${source_dir}/e2fsck/readahead.c
        ${source_dir}/e2fsck/extents.c
        ${source_dir}/e2fsck/encrypted_files.c)
target_compile_options(e2fsck PRIVATE
        ${default_cflags}
        -Wno-sign-compare
        -fno-strict-aliasing)
target_link_libraries(e2fsck
        ${default_libs}
        ext2fs
        ext2_blkid
        ext2_com_err
        ext2_uuid
        ext2_quota
        ext2_e2p)

add_custom_target(e2fsprogs DEPENDS
        e2fsdroid
        debugfs
        e2fsck
        mke2fs
        blkid
        add_ext4_encrypt
        ext2simg
        resize2fs
        e2freefrag
        filefrag
        e2image
        e4crypt
        lsattr-e2fsprogs
        chattr-e2fsprogs
        badblocks
        tune2fs)