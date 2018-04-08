FROM multiarch/crossbuild:latest
LABEL description="See https://github.com/henry4k/crossbuild"

# Install python3:
COPY assets/install-python3 /install-python3
RUN apt-get update && \
    /install-python3 && \
    rm /install-python3

# Install ninja:
COPY assets/install-ninja /install-ninja
RUN /install-ninja && \
    rm /install-ninja

# Generate toolchain configs:
COPY assets/generate-toolchain-config /generate-toolchain-config
ENV CMAKE_TOOLCHAIN_DIR /root/.cmake/toolchains
RUN set -x; \
    apt-get install -qqy luarocks lua-filesystem && \
    luarocks install argparse && \
    luarocks install lua-path && \
    for triple in $(echo ${LINUX_TRIPLES} | tr "," " "); do \
        /generate-toolchain-config $triple; \
    done && \
    for triple in $(echo ${DARWIN_TRIPLES} | tr "," " "); do \
        /generate-toolchain-config $triple; \
    done && \
    for triple in $(echo ${WINDOWS_TRIPLES} | tr "," " "); do \
        /generate-toolchain-config $triple; \
    done && \
    rm /generate-toolchain-config

# Install meson and conan:
RUN set -x; \
    pip3 -q install meson conan

# Patch crossbuild:
COPY assets/crossbuild.patch /crossbuild.patch
RUN set -x; \
    patch -u /usr/bin/crossbuild </crossbuild.patch && \
    rm /crossbuild.patch

ENV ACB_SOURCE_DIR /source
ENV ACB_INSTALL_DIR /install
ENV ACB_BUILD_STEPS "'' test install"
ENV ACB_CONAN_INSTALL_ARGS ""
ENV ACB_MESON_ARGS ""
ENV ACB_CMAKE_ARGS ""
ENV ACB_NINJA_ARGS ""
COPY assets/autocrossbuild /usr/local/bin/autocrossbuild
CMD autocrossbuild
WORKDIR /build
