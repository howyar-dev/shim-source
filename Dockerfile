# Shim 16.1 reproducible build environment
FROM ubuntu:22.04 AS shim-builder

ENV DEBIAN_FRONTEND=noninteractive

# Install minimal build toolchain (including bzip2 for decompression)
RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    make \
    gcc \
    binutils \
    gnu-efi \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Download official shim 16.1 source tarball
RUN wget https://github.com/rhboot/shim/releases/download/16.1/shim-16.1.tar.bz2 && \
    tar -jxvf shim-16.1.tar.bz2 && \
    rm shim-16.1.tar.bz2

# Copy certificate into source directory
COPY vendor.cer /build/shim-16.1/

WORKDIR /build/shim-16.1

# Build x86_64 version
RUN mkdir -p build-x64 && \
    cd build-x64 && \
    make -f ../Makefile \
        ARCH=x86_64 \
        VENDOR_CERT_FILE=../vendor.cer \
        DEFAULT_LOADER="\\\\osldr.efi" \
        ENABLE_SBAT=1 \
        TOPDIR=/build/shim-16.1

# Copy build artifact
RUN mkdir -p /output && \
    cp /build/shim-16.1/build-x64/shimx64.efi /output/

FROM scratch AS export-stage
COPY --from=shim-builder /output /
