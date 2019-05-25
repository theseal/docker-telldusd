# Heavely inspired/stolen from Hass.io:
# https://github.com/home-assistant/hassio-addons/blob/master/tellstick/Dockerfile
FROM alpine:3.7

ENV LANG C.UTF-8

RUN apk add --no-cache \
        confuse libftdi1 libstdc++ socat \
    && apk add --no-cache --virtual .build-dependencies \
        cmake build-base gcc doxygen confuse-dev argp-standalone libftdi1-dev git \
    && ln -s /usr/include/libftdi1/ftdi.h /usr/include/ftdi.h \
    && mkdir -p /usr/src \
    && cd /usr/src \
    && git clone -b master --depth 1 https://github.com/telldus/telldus \
    && cd telldus/telldus-core \
    && sed -i "/\<sys\/socket.h\>/a \#include \<sys\/select.h\>" common/Socket_unix.cpp \
    && cmake . -DBUILD_LIBTELLDUS-CORE=ON -DBUILD_TDADMIN=OFF -DBUILD_TDTOOL=ON -DGENERATE_MAN=OFF -DFORCE_COMPILE_FROM_TRUNK=ON -DFTDI_LIBRARY=/usr/lib/libftdi1.so \
    && make \
    && make install \
    && apk del .build-dependencies \
    && rm -rf /usr/src/telldus \
    && ln -fs /config/tellstick.conf /etc/

COPY run.sh /

CMD [ "/run.sh" ]

VOLUME ["/config"]

EXPOSE 50800
EXPOSE 50801
