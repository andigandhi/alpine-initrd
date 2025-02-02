#!/bin/ash

set -e

ALPINE_VERSION="edge"
ROOTDIR="/alpine"

apk --arch x86_64 -X http://dl-cdn.alpinelinux.org/alpine/${ALPINE_VERSION}/main/ -U --allow-untrusted --root ${ROOTDIR} --initdb add alpine-base openssh ethtool ruby ruby-libs musl fuse-common mbedtls mbedtls-dev mbedtls-utils git gcc libc-dev linux-headers make cmake
apk --arch x86_64 -X http://dl-cdn.alpinelinux.org/alpine/${ALPINE_VERSION}/community/ -U --allow-untrusted --root ${ROOTDIR} --initdb add fuse fuse-dev
# apk --arch x86_64 -X http://dl-cdn.alpinelinux.org/alpine/${ALPINE_VERSION}/testing/ -U --allow-untrusted --root ${ROOTDIR} --initdb add dislocker-libs dislocker
cp /etc/apk/repositories $ROOTDIR/etc/apk/

# Only for debugging
echo "nameserver 9.9.9.9" > $ROOTDIR/etc/resolv.conf

# boot
for d in hostname procfs sysfs urandom hwdrivers; do
  ln -vs "/etc/init.d/${d}" $ROOTDIR/etc/runlevels/boot/
done

# default
for d in sshd; do
  ln -vs "/etc/init.d/${d}" $ROOTDIR/etc/runlevels/default/
done

# local
ln -vs /etc/init.d/local $ROOTDIR/etc/runlevels/default/

cp -v /init $ROOTDIR/
cp -v /dhcp.start $ROOTDIR/etc/local.d/

echo initrd >> $ROOTDIR/etc/hostname

echo >> $ROOTDIR/etc/ssh/sshd_config
echo PermitRootLogin yes >> $ROOTDIR/etc/ssh/sshd_config
echo PermitEmptyPasswords yes >> "$ROOTDIR"/etc/ssh/sshd_config
