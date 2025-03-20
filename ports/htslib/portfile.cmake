vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO samtools/htslib
    REF "${VERSION}"
    SHA512 6df1a493ac9f13cae5a510537bdf83aa9635a79efe635b8a5a5cbd89345c75c9a42e686c4f0497761ddfad3b86a9814ed35ba2ac340d0f1c7b5e2e186b152875
    HEAD_REF develop
    PATCHES
        0001-set-linkage.patch
        0002-pthread-flag.patch
        0003-no-tests.patch
        0004-fix-find-htscodecs.patch
        0001-fix-zlib-name.patch
        0002-fix-log-check.patch
        0003-fix-compile-errors.patch
        0004-ssize-max.patch
        0006-pthread.patch
        0008-static-sized-arrays.patch
        0009-stddef-h.patch
        0010-hfile.patch
        0011-pcre2-feature.patch
        0012-include-strings-h.patch
        0013-unistd-h.patch
        0014-time-h.patch
        0015-r-ok.patch
        0016-cli-patches.patch
        0017-dll.patch
        0018-hts-os.patch
        0019-dirent.patch
        0020-external-getopt.patch
        0021-install-path.patch
)

set(FEATURE_OPTIONS "")

macro(enable_feature feature switch)
    if("${feature}" IN_LIST FEATURES)
        list(APPEND FEATURE_OPTIONS "--enable-${switch}")
    else()
        list(APPEND FEATURE_OPTIONS "--disable-${switch}")
    endif()
endmacro()

enable_feature("bzip2" "bz2")
enable_feature("lzma" "lzma")
enable_feature("pcre2" "pcre2")

if("deflate" IN_LIST FEATURES)
    list(APPEND FEATURE_OPTIONS "--with-libdeflate")
else()
    list(APPEND FEATURE_OPTIONS "--without-libdeflate")
endif()

if (VCPKG_TARGET_IS_WINDOWS AND NOT VCPKG_TARGET_IS_MINGW)
    list(APPEND FEATURE_OPTIONS "--with-external-getopt")
    # Get gendef tool.
    vcpkg_acquire_msys(MSYS_ROOT
        NO_DEFAULT_PACKAGES
        DIRECT_PACKAGES
            "https://mirror.msys2.org/mingw/mingw32/mingw-w64-i686-tools-git-12.0.0.r576.g49111ba98-1-any.pkg.tar.zst"
            485ceba95124d1aa3086b103a71cb0c456eca6bc485d2f7694d10f668d4c2c046183b7b8c5e27333171ee2a6e8ca4de49adb4d7c6c4d05cbc0f7e28b3ad7728c)
    vcpkg_add_to_path("${MSYS_ROOT}/mingw32/bin")
endif()

vcpkg_configure_make(
    SOURCE_PATH "${SOURCE_PATH}"
    AUTOCONFIG
    OPTIONS
        --with-external-htscodecs
        --disable-libcurl
        --disable-gcs
        --disable-s3
        --disable-plugins
        ${FEATURE_OPTIONS}
)

vcpkg_install_make(
    INSTALL_TARGET install-${VCPKG_LIBRARY_LINKAGE}
)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_fixup_pkgconfig()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
