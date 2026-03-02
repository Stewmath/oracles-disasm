FROM cimg/base:stable

RUN sudo apt-get update
RUN sudo apt-get install -y cmake python3 python3-yaml

WORKDIR /home/circleci

RUN git clone https://github.com/vhelin/wla-dx
RUN cd wla-dx && git checkout v10.6 && cmake . && make wla-gb wlalink
RUN cp wla-dx/binaries/* ~/bin/

WORKDIR /home/circleci/project
