
# Docker build command
# docker build -t crow/ubuntu:kernel -f ./ubuntu-kernel.Dockerfile .

FROM crow/ubuntu:latest

RUN apt-get update
RUN apt-get install -y wget flex bison file vim cpio

# The below section is for download package source code
ENV STAGE /root/rookies
ENV TOP $STAGE/linux-building
RUN mkdir -pv $STAGE
RUN mkdir -pv $TOP
RUN mkdir -pv $TOP/obj/linux-arm-versatile_defconfig
RUN mkdir -pv $TOP/obj/busybox-arm
RUN mkdir -pv $TOP/initramfs/arm-busybox

RUN cd $STAGE && wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.134.tar.xz
RUN cd $STAGE && wget https://busybox.net/downloads/busybox-1.36.1.tar.bz2

# Prepare the environment for buiding code
RUN printf "#!/bin/sh \n \
export ARCH=arm \n \
export CROSS_COMPILE=arm-linux-gnueabi-" > $STAGE/env-setup.sh
RUN chmod +x $STAGE/env-setup.sh

# Build the shell script to prepare filesystem.
RUN printf "mkdir -pv $TOP/initramfs/arm-busybox \n \
cd $TOP/initramfs/arm-busybox \n \
mkdir -pv {bin,dev,sbin,etc,proc,sys/kernel/debug,usr/{bin,sbin},lib,lib64,mnt/root,root} \n \
cp -av $TOP/obj/busybox-arm/_install/* $TOP/initramfs/arm-busybox \n \
cp -av /dev/{null,console,tty,sda1} $TOP/initramfs/arm-busybox/dev/ " > $STAGE/makeFolder.sh

#This script is only executed after "make install" of the busybox is complete.
RUN chmod +x $STAGE/makeFolder.sh

RUN printf "cd $TOP/initramfs/arm-busybox \n \
find . | cpio -H newc -o > ../initramfs.cpio \n \
cd .. \n \
cat initramfs.cpio | gzip > $TOP/obj/initramfs.igz" > $STAGE/makeInitramfs.sh

#This script is only executed after makeFolder.sh is executed.
RUN chmod +x $STAGE/makeInitramfs.sh

RUN printf "#!/bin/sh \n\
mount -t proc none /proc \n\
mount -t sysfs none /sys \n\
mount -t debugfs none /sys/kernel/debug \n\
echo -e \"\nBoot took $(cut -d' ' -f1 /proc/uptime) seconds\n\" \n \
exec /bin/sh" > $TOP/initramfs/arm-busybox/init
RUN chmod +x $TOP/initramfs/arm-busybox/init

CMD ["/bin/bash"]
