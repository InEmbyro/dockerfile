# Dockerfile Collection
This collection is to maintain different Dockerfile.

## Docker Usage

### volume 

To create a data volume with the name config_data.
```
docker volume create --name config_data
```

The volume created by docker can be shown by the command below.
```
docker volume list
```

Create a container with the created volume.
```
docker create --privileged -it --name trytrysee_1 -v config_data:/root/data crow/ubuntu:kernel-v2
```
* To create a container, named *trytrysee_1*.
* To mount the data volume which name is *config_data*. The volumen will be mounted to the path `/root/data`.

Share the volume with the other containers.
```
docker create --privileged -it --name trytrysee_2 --volumes-from trytrysee_1 crow/ubuntu:kernel
```
* To create new container, which name is *trytrysee_2*.
* The moutned volume will refer to the volumes that are used by the *trytrysee_1* container. In other words, the volume, config_data, will be mounted to the path `/root/backup`.

These two containers above will share the same volume *config_data*.

The source volume could be the real path of the host. For example, the below command will mount ${PWD} folder to the `/root/data/` of the container.
```
sudo docker create --privileged -it --rm -v ${PWD}:/root/backup crow/ubuntu:kernel-2
```

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

## Dockerfile, doxygen_env.dockerfile

This dockerfile is to setup the environment that is used to generate Doxygen document in the PDF format.
The output file name is refman.pdf.

### Usage

Use the below command to create the image.
```
docker build -t crow/ubuntu:doxygenT01 -f ./doxygen_env.dockerfile .
```

Once the image was created, you can use the below command to create the PDF file of Doxygen document. The `{DOXYGEN_CONFIG_FILE}` is the doxygen configuration file. The `$PWD` is the folder in which the source code is located. This example is in macOS or Ubuntu environment.
```
docker run --privileged -it --rm -v $PWD:/root/data crow/ubuntu:doxygenT01 /root/makepdf.sh {DOXYGEN_CONFIG_FILE}
```

## Dockerfile, ubuntu-sshserver.dockerfile

This dockerfile is to setup the environment buindling the software and to the ssh-server.

The details refers to [ubuntu-ssh-server](ubuntu-sshserver.dockerfile)
