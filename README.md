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

This Dockerfile is to setup the environment, build linux kernel, and busybox. Then, run QEMU with the built kernel and the filesystem.

The details refers to [ubuntu-kernel](ubuntu-kernel-dockerfile.md)
