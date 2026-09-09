# Container Image with layer 2 compatibility - for Layer 3 Switches
ARG ALPINE_VERSION=3.21.2
FROM "docker.io/library/alpine:${ALPINE_VERSION}"
EXPOSE 22/tcp \
    161/udp 162/udp 
RUN apk update \
    && apk add arp-scan \
        iproute2 
