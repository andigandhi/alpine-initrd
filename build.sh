#!/bin/bash

set -e -x

pushd .
cd docker/ && docker build -t lucks/alpine-builder .
popd

sudo rm -rf alpine/ &&
  mkdir alpine

sudo docker run -t -i --rm -v "$PWD/alpine/:/alpine/" lucks/alpine-builder

# enable ttyS0 and add it as secure tty
sed -i 's/#\(ttyS0.*\)/\1/' alpine/etc/inittab
echo ttyS0 >> alpine/etc/securetty

sudo cp docker/compile-dislocker.sh alpine/

cd alpine/ && \
   chroot . /bin/ash
#  sudo find . | sudo cpio -o -H newc | xz -C crc32 -z -9 --threads=0 -c - > ../alpine-initrd.xz
