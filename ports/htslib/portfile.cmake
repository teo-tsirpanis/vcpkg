vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO samtools/htslib
    REF "${VERSION}"
    SHA512 459af7d11f5ad2e15a07b393d36c15c9498ec709b301e62155ae31588bf40f7a536286a79b7324286f9d4dd337bf523cb22a0d15094c97a87207ad1aea1bdbc7
    HEAD_REF develop
    PATCHES
        0001-fix-zlib-name.patch
        0002-fix-log-check.patch
        0003-fix-compile-errors.patch
        0004-ssize-max.patch
        0005-remove-unistd.patch
        0006-pthread.patch
        0007-ssize-t-2.patch
        0008-static-sized-arrays.patch
        0009-stddef-h.patch
        0010-hfile.patch
)

if(VCPKG_TARGET_IS_WINDOWS AND NOT VCPKG_TARGET_IS_MINGW)
    file(COPY "${CMAKE_CURRENT_LIST_DIR}/strings.h" DESTINATION "${SOURCE_PATH}")
endif()

set(CONFIG_OPTIONS)

if(NOT "bz2" IN_LIST FEATURES)
    list(APPEND CONFIG_OPTIONS "--disable-bz2")
endif()

if(NOT "lzma" IN_LIST FEATURES)
    list(APPEND CONFIG_OPTIONS "--disable-lzma")
endif()

if("libcurl" IN_LIST FEATURES)
    list(APPEND CONFIG_OPTIONS "--enable-libcurl")
endif()

if("plugins" IN_LIST FEATURES)
    list(APPEND CONFIG_OPTIONS "--enable-plugins")
endif()

vcpkg_configure_make(
    AUTOCONFIG
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        --with-external-htscodecs
        ${CONFIG_OPTIONS}
)

vcpkg_install_make()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_fixup_pkgconfig()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
