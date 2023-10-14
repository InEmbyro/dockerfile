# Docker build command
# docker build -t crow/ubuntu:latest -f ./ubuntu-tool-chain.Dockerfile .

FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y curl libncurses5-dev qemu-system-arm gcc-arm-linux-gnueabi

RUN apt-get install -y xz-utils bzip2
RUN apt-get install -y libncurses5-dev gcc make git exuberant-ctags bc libssl-dev

CMD ["/bin/bash"]