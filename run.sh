#!/bin/sh
# Heavely inspired/stolen from Hass.io:
# https://github.com/home-assistant/hassio-addons/blob/master/tellstick/Dockerfile

set -e

if [ -f /tmp/TelldusClient ]; then
    rm /tmp/TelldusClient
fi

if [ -f /tmp/TelldusEvents ]; then
    rm /tmp/TelldusEvents
fi


socat TCP-LISTEN:50800,reuseaddr,fork UNIX-CONNECT:/tmp/TelldusClient &
socat TCP-LISTEN:50801,reuseaddr,fork UNIX-CONNECT:/tmp/TelldusEvents &

/usr/local/sbin/telldusd --nodaemon
