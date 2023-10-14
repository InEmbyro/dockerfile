# Dockerfile Collection
This collection is to maintain different Dockerfile.

## Dockerfile, ubuntu-tool-chain.Dockerfile

### Description

* This dockerfile uses ubuntu:latest from Docker hub as the base image
* Create Ubuntu environment.
* Install necessary arm toolchain for building Linux kernel
* Install package for arm QEMU

### Usage

```
docker build -t crow/ubuntu:latest -f ./ubuntu-tool-chain.Dockerfile .
```

## Dockerfile, ubuntu-kernel.Dockerfile

### Description
* This dockerfile uses the image that is created by ubuntu-tool-chain.Dockerfile as the base image.
* Install necessary software packages for building busybox and linux kernel.
* Download source code of busybox-1.36.1 and linux-5.15.134
* Generate env-setup.sh, makeFolder.sh, and makeInitramfs.sh
* The intention of this Dockerfile is to practice building ARM Linux kernel and launch it in the QEMU.

### Usage

First of all, use this Dockefile to create the image, `crow/ubuntu:kernel`. Run the image, and do the below setps inside the container.

**Setup Environment**

Use `env-setup.sh` to setup the environment variables.

```
cd $STAGE \
. env-setup.sh
```

**Build Busybox**

Build the busybox and install it. The source code of the busybox is in the `$STAGE`. The target folder of the busybox is `$TOP/obj/busybox-arm`. We use "static linking in Busybox". 

The configuraiton is executed in the source code folder, and the target should be set to the target folder. The `static linking in Busybox` should be enabled in `make menuconfig`.

```
make O=$TOP/obj/busybox-arm defconfig
make O=$TOP/obj/busybox-arm menuconfig
```

The busybox is built in the target folder.

```
cd $TOP/obj/busybox-arm
make -j4
make install
```

After busybox installation, execute the below scripts. The file system will be ready.

```
cd $STAGE
./makeFolder.sh
./makeInitramfs
```

**Build Linux kernel**

The source code is in the `$STAGE`. The target folder is `$TOP/obj/linux-arm-versatile_defconfig`. The reference configuration is `versatile_defconfig`.

The reference command is to build the kernel. The building command is executed in the source code folder, but the `O=` has to be set to the target folder.

```
make $TOP/obj/linux-arm-versatile_defconfig olddefconfig
```

Then, turn on the `Early printk` option.

```
make $TOP/obj/linux-arm-versatile_defconfig nconfig
```

```
--> Kernel hacking
[*] Early printk
```

Then, start to build the kernel

```
make $TOP/obj/linux-arm-versatile_defconfig -j4
```

**Launch the QEMU with the kernel and initrd**

Use the below command to launch the kernel and initrd in QEMU.
```
qemu-system-arm -M versatilepb  \
    -dtb $TOP/obj/linux-arm-versatile_defconfig/arch/arm/boot/dts/versatile-pb.dtb \
    -kernel $TOP/obj/linux-arm-versatile_defconfig/arch/arm/boot/zImage \
    -initrd $TOP/obj/initramfs.igz \
    -nographic -append "earlyprintk=serial,ttyS0 console=ttyAMA0"
```

Use **Ctrl + a**, **x** to terminate the QEMU.