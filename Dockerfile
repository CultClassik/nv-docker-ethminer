FROM nvidia/cuda:8.0-runtime-ubuntu16.04

MAINTAINER Chris Diehl <cultclassik@gmail.com>

ARG workername="miner"
ARG ethacct="0x96ae82e89ff22b3eff481e2499948c562354cb23.$docker_host-nvd"
ARG cudaph=4
ARG pool1="us2.ethermine.org:4444"
ARG pool2="us1.ethermine.org:4444"

ENV emrel="https://github.com/ethereum-mining/ethminer/releases/latest"

ENV GPU_FORCE_64BIT_PTR=0
ENV GPU_MAX_HEAP_SIZE=100
ENV GPU_USE_SYNC_OBJECTS=1
ENV GPU_MAX_ALLOC_PERCENT=100
ENV GPU_SINGLE_ALLOC_PERCENT=100

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /ethminer

WORKDIR /ethminer

RUN wget --no-check-certificate $emrel &&\
    pwd && ll &&\
    tar -xvf ./*.tar.gz &&\
    rm *.tar.gz

RUN echo "#!/bin/bash \n /ethminer/bin/ethminer -U -S ${pool1} -FS ${pool2} -O ${ethacct} --cuda-parallel-hash ${cudaph}" > start.sh

ENTRYPOINT [ "/bin/bash", "/ethminer/start.sh"]