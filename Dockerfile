#FROM nvidia/cuda:11.2.0-devel-ubuntu18.04
FROM nvidia/cuda:8.0-devel-ubuntu16.04
MAINTAINER Anthony Tatowicz


ENV DEBIAN_FRONTEND=noninteractive 

WORKDIR /opt

# Package and dependency setup
RUN apt-get update \
    && apt-get -qy install software-properties-common \
    && add-apt-repository ppa:ethereum/ethereum -y \
    && apt-get update \
    && apt-get install -qy git \
     cmake \
     libcryptopp-dev \
     libleveldb-dev \
     libjsoncpp-dev \
     libjsonrpccpp-dev \
     libboost-all-dev \
     libgmp-dev \
     libreadline-dev \
     libcurl4-gnutls-dev \
     ocl-icd-libopencl1 \
     opencl-headers \
     mesa-common-dev \
     libmicrohttpd-dev \
     build-essential

# Git repo set up
RUN git clone https://github.com/ethereum-mining/ethminer.git; \
    cd ethminer; \
    git checkout tags/v0.12.0

# Build
RUN cd ethminer; \
    mkdir build; \
    cd build; \
    cmake .. -DETHASHCUDA=ON -DETHASHCL=OFF -DETHSTRATUM=ON; \
    cmake --build .; \
    make install;

# Env setup
ENV GPU_FORCE_64BIT_PTR=0
ENV GPU_MAX_HEAP_SIZE=100
ENV GPU_USE_SYNC_OBJECTS=1
ENV GPU_MAX_ALLOC_PERCENT=100
ENV GPU_SINGLE_ALLOC_PERCENT=100


#ENTRYPOINT ["/usr/local/bin/ethminer", "-U"]
