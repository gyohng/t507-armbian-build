#!/bin/bash

export SOURCE_DATE_EPOCH=1707904372
export KBUILD_BUILD_TIMESTAMP='Wed Feb 14 10:52:52 CET 2024'
export KBUILD_BUILD_USER=george
export KBUILD_BUILD_HOST=george

bash ./compile.sh \
    CREATE_PATCHES=no \
    BOARD=okt507c \
    BRANCH=current \
    RELEASE=jammy \
    BUILD_ONLY=default \
    KERNEL_CONFIGURE=no \
    INSTALL_HEADERS=no \
    BUILD_DESKTOP=no \
    BUILD_MINIMAL=yes \
    IGNORE_UPDATES=no \
    USE_TORRENT=no \
    USE_GITHUB_UBOOT_MIRROR=yes \
    BUILD_KSRC=no \
    BOOT_LOGO=yes \
    SKIP_ARMBIAN_REPO=yes \
    KERNEL_GIT=shallow \
    ARTIFACT_IGNORE_CACHE=yes \
    "$@"
