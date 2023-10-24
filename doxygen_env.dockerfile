
# Docker build command
# Use the below command to create the docker image
#   docker build -t crow/ubuntu:doxygenT01 -f ./doxygen_env.dockerfile .
# Use the below command to generate doxygen document in PDF format.
#   docker run --privileged -it --rm -v $PWD:/root/data crow/ubuntu:doxygenT01 /root/makepdf.sh {DOXYGEN_CONFIG_FILE}
#   Note: You should run the command above in the source code that you want to generate doxygen document.

FROM crow/ubuntu:latest

RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y cmake vim xz-utils flex bison

RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC
RUN apt-get install -y texlive-latex-base
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y tzdata
RUN apt-get install -y preview-latex-style texlive-latex-extra texlive-latex-recommended preview-latex-style texlive-latex-extra texlive-latex-recommended graphviz

ARG WORKDIR /root
WORKDIR $WORKDIR
RUN git clone https://github.com/doxygen/doxygen.git
RUN mkdir -pv $WORKDIR/doxygen/build
RUN cd $WORKDIR/doxygen/build && cmake -G "Unix Makefiles" ..
RUN cd $WORKDIR/doxygen/build && make -j4 && make install
RUN cd / && rm -rf $WORKDIR/doxygen

RUN printf "#!/bin/bash \n \
cd /root/data \n \
doxygen -u \$1 \n \
doxygen \$1 \n \
make -C doc/latex \n \
cp doc/latex/refman.pdf /root/data \n \
" > /root/makepdf.sh

RUN chmod +x /root/makepdf.sh

CMD ["/bin/bash"]
