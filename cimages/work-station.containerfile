# Container Image with common layer 7 utilities - for Work-Stations
ARG ALPINE_VERSION=3.21.2
FROM "docker.io/library/alpine:${ALPINE_VERSION}"
EXPOSE 22/tcp \
    161/udp 162/udp \
    443/tcp \
    587/tcp
RUN apk update \
    && apk add curl 
