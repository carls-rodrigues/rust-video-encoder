FROM rust:1.69.0-alpine3.17
ENV PATH="$PATH:/bin/bash" \
    BENTO4_BIN="/opt/bento4/bin" \
    PATH="$PATH:/opt/bento4/bin"

# FFMPEG
RUN apk add --update ffmpeg bash curl make

# Install Bento
# https://github.com/axiomatic-systems/Bento4/archive/refs/tags/v1.6.0-640.zip
WORKDIR /tmp/bento4
ENV BENTO4_BASE_URL="https://github.com/axiomatic-systems/Bento4/archive/refs/tags/" \
    BENTO4_VERSION="v1.6.0-640" \
    BENTO4_CHECKSUM="5378dbb374343bc274981d6e2ef93bce0851bda1" \
    BENTO4_TARGET="" \
    BENTO4_PATH="/opt/bento4" \
    BENTO4_TYPE="SRC"
    # download and unzip bento

RUN apk --update --upgrade add --no-cache curl unzip bash gcc g++ cmake && \
    wget https://github.com/axiomatic-systems/Bento4/archive/refs/tags/v1.6.0-640.zip && \
    mkdir -p ${BENTO4_PATH} && \
    ls && \
    unzip ./v1.6.0-640.zip -d ./ && \
    cp -R ./Bento4-1.6.0-640/* ${BENTO4_PATH} && \
    rm -rf v1.6.0-640.zip && \
    apk del unzip
    # don't do these steps if using binary install
RUN cd ${BENTO4_PATH} && \
     cmake -S . -B build -DCMAKE_BUILD_TYPE=Release  && \
     cmake --build build --config Release && \
     cd build && \
     make && \
     cp -R ${BENTO4_PATH}/build/CMakeFiles ${BENTO4_PATH}/bin && \
     cp -R ${BENTO4_PATH}/Source/Python/utils ${BENTO4_PATH}/utils && \
     cp -a ${BENTO4_PATH}/Source/Python/wrappers/. ${BENTO4_PATH}/bin

WORKDIR /rust/src

#Usando top apenas para segurar o processo rodando
ENTRYPOINT [ "top" ]