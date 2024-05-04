#!/bin/bash

set -e
cd "$(dirname "$0")/.."
COMMAND=${1:-build}

# defaults
export SOURCE_DATE_EPOCH=1707904372
export KBUILD_BUILD_TIMESTAMP='Wed Feb 14 10:52:52 CET 2024'
export KBUILD_BUILD_USER=george
export KBUILD_BUILD_HOST=george

rm -rf userpatches
ln -s ./build-scripts/DLZ-customise userpatches

./compile.sh $COMMAND \
\
    BOARD=mydyt507h \
    BRANCH=current \
    RELEASE=jammy \
\
    BUILD_MINIMAL=no \
    BUILD_DESKTOP=yes \
    DESKTOP_ENVIRONMENT=cinnamon \
    DESKTOP_ENVIRONMENT_CONFIG_NAME=config_base \
    DESKTOP_APPGROUPS_SELECTED='3dsupport browsers' \
\
    INSTALL_HEADERS=no \
    USE_GITHUB_UBOOT_MIRROR=yes \
    USE_TORRENT=no \
    KERNEL_CONFIGURE=no \
    BUILD_KSRC=no \
    KERNEL_GIT=shallow \
    ARTIFACT_IGNORE_CACHE=yes \
    SKIP_ARMBIAN_REPO=yes \
    BOOT_LOGO=yes \
    IGNORE_UPDATES=no \

# BUILD_ONLY=default # what was this for?
