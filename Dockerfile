#FROM nvidia/cuda:8.0-runtime-ubuntu16.04
FROM nvidia/cuda:9.0-base-ubuntu17.04

MAINTAINER Chris Diehl <cultclassik@gmail.com>

ARG API_PORT="3333"
ARG GPU=0

# NVidia required
ARG RUNTIME="nvidia"
ENV NVIDIA_VISIBLE_DEVICES="${GPU}"

ENV WORKER="myminer"
ENV ETHACCT="0x96ae82e89ff22b3eff481e2499948c562354cb23"
ENV CUDAPH=4
ENV POOL1="us2.ethermine.org:4444"
ENV POOL2="us1.ethermine.org:4444"
ENV APIPORT="${API_PORT}"
ENV EMREL="https://github.com/ethereum-mining/ethminer/releases/download/v0.12.0/ethminer-0.12.0-Linux.tar.gz"

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

RUN wget --no-check-certificate $EMREL &&\
    tar -xvf ./*.tar.gz &&\
    rm *.tar.gz

RUN echo '/ethminer/bin/ethminer -RH -U -S $POOL1 -FS $POOL2 -O $ETHACCT.$WORKER --cuda-parallel-hash $CUDAPH --api-port $API_PORT' > start.sh

EXPOSE $API_PORT

ENTRYPOINT [ "/bin/bash", "/ethminer/start.sh"]
