# Container Image with common layer 7 utilities - for Work-Stations
ARG ALPINE_VERSION
FROM "docker.io/library/alpine:${ALPINE_VERSION}"
EXPOSE 22 \
    443 \
    587
RUN apk update \
    && apk add curl 
