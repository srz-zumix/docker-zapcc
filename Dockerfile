ARG UBUNTU_VERSION=latest
FROM ubuntu:$UBUNTU_VERSION
ARG UBUNTU_VERSION

LABEL maintainer "srz_zumix <https://github.com/srz-zumix>"

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
WORKDIR /tmp/build
RUN apt-get update -q -y && \
    apt-get install -y --no-install-recommends software-properties-common apt-transport-https gpg-agent && \
    add-apt-repository -y "ppa:git-core/ppa" && \
    apt-get update -q -y && \
    apt-get install -y --no-install-recommends \
        make cmake build-essential ninja-build git libc6 && \
    apt-get clean && \
    git clone https://github.com/yrnkrn/zapcc.git ../llvm && \
    cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_WARNINGS=OFF \
        -DCMAKE_CXX_FLAGS="--param ggc-min-heapsize=32768 --param ggc-min-expand=64" \
        ../llvm && \
    ninja && ninja install && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /
RUN rm -rf /tmp/build

ENV CXX=zapcc++
ENV CC=zapcc
ENTRYPOINT ["zapcc"]
