# Dockerfile, ubuntu-sshserver.dockerfile

## Description
* This dockerfile uses the image, ubuntu:latest.
* Setup the ssh-server and export the port 22.
* Also, create a user for logging the environment remotely.

## Usage

Use the below command to create the docker image
```
docker build -t crow/ubuntu:sshd -f ./ubuntu-sshserver.dockerfile .
``````
Use the below command to start the build environment with ssh-server.# 

```
docker run --privileged -d --rm -p 22:22 -v $PWD:/home/wuser/data crow/ubuntu:sshd
```

* The above command will occupy the port 22 of the host. If you woudl like to reserve the port you can use "-P" instead of "-p 22:22"
* In order to develop your code inside the environemnt, the `${PWD}` folder will be mounted to /home/wuser/data. Of course, you can change it by yourself. Or, you can use various ways, e.g., volume data.

## Internal Account

The username is `wuser` and the password is `sshserver`. You can use this account to login to the Container.

