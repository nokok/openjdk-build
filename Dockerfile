FROM adoptopenjdk/openjdk12:slim

LABEL maintainer "Noriyuki Kazusawa <nokok.kz@gmail.com>"

RUN apt-get update && apt-get install --no-install-recommends -y \
  curl mercurial build-essential zip unzip autoconf file \
  libx11-dev libxext-dev libxrender-dev libxrandr-dev \
  libxtst-dev libxt-dev libcups2-dev libfontconfig1-dev \
  libasound2-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /build

RUN hg clone http://hg.openjdk.java.net/jdk/jdk

WORKDIR /build/jdk/

ARG VENDOR_NAME
ENV VENDOR_NAME ${VENDOR_NAME:-Custom}

ARG VENDOR_URL
ENV VENDOR_URL ${VENDOR_URL:-http://example.com}

ARG VERSION_STRING
ENV VERSION_STRING ${VERSION_STRING:-Custom}

RUN bash configure

CMD make clean && bash configure \
      --disable-warnings-as-errors \
      --with-debug-level=release \
      --with-native-debug-symbols=none \
      --with-vendor-name=$VENDOR_NAME \
      --with-vendor-url=$VENDOR_URL \
      --with-vendor-version-string=$VERSION_STRING \
      --without-version-opt \
      --without-version-pre && make images
