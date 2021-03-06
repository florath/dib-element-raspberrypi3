#!/bin/bash

DIST=debian-minimal
RELEASE=stretch
export CDIB_RPI3_BASE_DIR=/home/dib/rpi3

set -e
set -x

#export DIB_DEBUG_TRACE="255"

export DIB_DEV_USER_PWDLESS_SUDO=yes
export DIB_DEV_USER_USERNAME="dib"
export DIB_DEV_USER_PASSWORD="dib"
export DIB_DEV_USER_SHELL="/bin/bash"

export DIB_RELEASE=${RELEASE}

export DIB_DISTRIBUTION_MIRROR=http://10.4.0.4:3142/debian
export DIB_APT_SOURCES_CONF="default:deb http://10.4.0.4:3142/debian ${RELEASE} main contrib non-free"

ADD_ELEMENTS="devuser rpi3"

export ELEMENTS_PATH=${PWD}
disk-image-create -a arm64 -t raw -o rpi3-${DIST}-${RELEASE} \
                  ${DIST} ${ADD_ELEMENTS} 2>&1 | tee o.log
