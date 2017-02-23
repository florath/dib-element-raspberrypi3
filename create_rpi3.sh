#!/bin/bash

DIST=debian-minimal
RELEASE=stretch
export CDIB_RPI3_BASE_DIR=/home/dib/rpi3

set -e

export DIB_DEBUG_TRACE="255"

export DIB_DEV_USER_PWDLESS_SUDO=yes
export DIB_DEV_USER_USERNAME="dib"
export DIB_DEV_USER_PASSWORD="dib"
export DIB_DEV_USER_SHELL="/bin/bash"
export DIB_ETHERNET_DEVICE_NAMES="ens3"

export DIB_RELEASE=${RELEASE}

case ${DIST} in
    debian*)
	mirror=debian
	;;
    ubuntu*)
	mirror=ubuntu
	;;
esac

export DIB_BLOCK_DEVICE_DEFAULT_CONFIG="
- local_loop:
    name: image0

- partitioning:
   base: image0
   label: mbr
   partitions:
     - name: root
       flags: [ boot, primary ]
       size: 100%
"

DIB_BLOCK_DEVICE_CONFIG=${DIB_BLOCK_DEVICE_CONFIG:-${DIB_BLOCK_DEVICE_DEFAULT_CONFIG}}
export DIB_BLOCK_DEVICE_CONFIG

export DIB_DISTRIBUTION_MIRROR=http://10.4.0.4:3142/${mirror}
export DIB_APT_SOURCES_CONF="default:deb http://10.4.0.4:3142/${mirror} ${RELEASE} main contrib non-free"

ADDPKGS="-p iproute2,systemd-sysv,openssh-server,net-tools,ifupdown,isc-dhcp-client"

ADD_ELEMENTS="devuser rpikernel"

export ELEMENTS_PATH=${PWD}
disk-image-create -x -a arm64 --image-size=5G ${ADDPKGS} -o rpi3-${DIST}-${RELEASE} ${DIST} ${ADD_ELEMENTS} 2>&1 | tee o.log
