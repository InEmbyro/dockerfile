
# Docker build command
# Use the below command to create the docker image
#   docker build -t crow/ubuntu:sshd -f ./ubuntu-sshserver.dockerfile .
# Use the below command to start the build environment with ssh-server.# 
#   docker run --privileged -d --rm -p 22:22 -v $PWD:/home/wuser/data crow/ubuntu:sshd
#   --  The above command will occupy the port 22 of the host. If you woudl like to reserve the port you can 
#       use "-P" instead of "-p 22:22"
#   Note: You should run the command above in the folder that you want to use inside the container.

FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y build-essential cmake vim xz-utils flex bison git

WORKDIR /root/

RUN apt-get install -y openssh-server
RUN printf "#!/bin/sh \n \
groupadd wgroup \n \
useradd -g wgroup wuser \n \
echo 'wuser:sshserver' | chpasswd \n\
mkdir -pv /run/sshd \n \
mkdir -pv /home/wuser \n \
chown wuser:wgroup /home/wuser \n \
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \n" > /root/setup.sh

RUN chmod +x /root/setup.sh
RUN . ./setup.sh && rm /root/setup.sh

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
