vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO samtools/htslib
    REF "${VERSION}"
    SHA512 459af7d11f5ad2e15a07b393d36c15c9498ec709b301e62155ae31588bf40f7a536286a79b7324286f9d4dd337bf523cb22a0d15094c97a87207ad1aea1bdbc7
    HEAD_REF develop
    PATCHES
        0001-htscodecs-non-submodule.patch
)

vcpkg_from_github(
    OUT_SOURCE_PATH htscodecs_SOURCE_PATH
    REPO samtools/htscodecs
    REF v1.6.0
    SHA512 7533570b8b1cad0b9ed118170e5a9ff34fdde40b090f4ba3756f7899e2cd7230f8172425ecf6bd7b83b0b0b1a2a24f3d21795db7f0bc2c3add0a55342b970d1a
    HEAD_REF master
)

file(COPY ${htscodecs_SOURCE_PATH}/. DESTINATION ${SOURCE_PATH}/htscodecs)

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
        ${CONFIG_OPTIONS}
)

vcpkg_install_make()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_fixup_pkgconfig()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
