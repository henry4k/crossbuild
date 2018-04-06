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
    pip3 -q install meson conan && \
    mv /usr/local/bin/conan /usr/local/bin/conan-original && \
    mv /usr/local/bin/meson /usr/local/bin/meson-original
COPY assets/conan-wrapper /usr/local/bin/conan
COPY assets/meson-wrapper /usr/local/bin/meson

# Patch crossbuild:
COPY assets/crossbuild.patch /crossbuild.patch
RUN set -x; \
    patch -u /usr/bin/crossbuild </crossbuild.patch && \
    rm /crossbuild.patch
