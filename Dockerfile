FROM php:5.6-alpine

# install protobuf
RUN apk add --update-cache --no-cache --virtual build-dependencies \
        autoconf \
        automake \
        ca-certificates \
        curl \
        g++ \
        gcc \
        libtool \
        make \
        wget \
    && mkdir -p /usr/local/src \
    && wget -O - https://github.com/google/protobuf/archive/v3.0.0-beta-2.tar.gz \
       | tar -zxf - -C /usr/local/src \
    && cd /usr/local/src/protobuf-3.0.0-beta-2 \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install \
    && cd /usr/local/src \
    && rm -rf /usr/local/src/protobuf-3.0.0-beta-2 \
    && apk del build-dependencies

RUN apk add --update-cache --no-cache git

# install composer
RUN wget -O - https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ADD composer.json /root/.composer/composer.json

RUN composer global install --prefer-dist
ENV PATH /root/.composer/vendor/bin:$PATH

# CMD ["protoc-gen-php", "--help"];
