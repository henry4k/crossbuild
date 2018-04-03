FROM multiarch/crossbuild:latest
LABEL description="See https://github.com/henry4k/crossbuild"

# Install meson:
RUN set -x; \
    apt-get -qq update && \
    apt-get install -qqy python3-pip && \
    pip3 -q install meson

# Install ninja:
COPY install-ninja.sh /install-ninja.sh
RUN /install-ninja.sh && \
    rm /install-ninja.sh
