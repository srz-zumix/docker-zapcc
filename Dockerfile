FROM ubuntu:18.04

LABEL maintainer "srz_zumix <https://github.com/srz-zumix>"

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update -q -y && \
    apt-get install -y --no-install-recommends software-properties-common apt-transport-https && \
    apt-get update -q -y && \
    apt-get install -y --no-install-recommends \
        make cmake build-essential ninja-build git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN git clone https://github.com/yrnkrn/zapcc.git llvm
WORKDIR /tmp/build
RUN cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_WARNINGS=OFF \
        -DCMAKE_CXX_FLAGS="--param ggc-min-heapsize=32768 --param ggc-min-expand=64" \
        ../llvm && \
    ninja && ninja install

ENV CXX=zapcc++
ENV CC=zapcc
ENTRYPOINT ["zapcc"]
