FROM alpine:3.14

ENV VERSION 1.5.1
ENV GTEST_VERSION 1.11.0
ENV FLAC_VERSION 1.3.3

RUN apk update \
  # Setup build dependencies
  && apk add --virtual build-dependencies \
  cmake \
  make \
  automake \
  # Setup runtime dependencies
  && apk add \
  boost-dev \
  g++ \
  gcc \
  gd-dev \
  libid3tag-dev \
  libmad-dev \
  libsndfile-dev \
  # Static dependencies
  zlib-static \
  libpng-static \
  boost-static \
  # FLAC
  autoconf \
  libtool \
  gettext \
  && wget https://github.com/xiph/flac/archive/${FLAC_VERSION}.tar.gz -O flac.tar.gz \
  && tar xzf flac.tar.gz \
  && rm -f flac.tar.gz \
  && cd flac-${FLAC_VERSION} \
  && ./autogen.sh \
  && ./configure --enable-shared=no \
  && make \
  && make install \
  && cd .. \
  # Download audiowaveform
  && wget https://github.com/bbc/audiowaveform/archive/refs/tags/${VERSION}.tar.gz \
  && tar xzf ${VERSION}.tar.gz \
  && rm -f ${VERSION}.tar.gz \
  && mv audiowaveform-${VERSION} audiowaveform \
  && cd audiowaveform \
  # Download/Install googletest
  && wget https://github.com/google/googletest/archive/release-${GTEST_VERSION}.tar.gz \
  && tar xzf release-${GTEST_VERSION}.tar.gz \
  && rm -f release-${GTEST_VERSION}.tar.gz \
  && ln -s googletest-release-${GTEST_VERSION} googletest \
  # Build audiowaveform
  && mkdir build \
  && cd build \
  && cmake BUILD_STATIC=1 .. \
  && make \
  && cp audiowaveform* /bin \
  && apk del build-dependencies \
  && rm -rf /var/cache/apk/* \
  && rm -rf /audiowaveform

ENTRYPOINT ["audiowaveform"]

CMD ["--help"]
