# Container Image with layer 2 compatibility - for Layer 3 Switches
ARG ALPINE_VERSION
FROM "docker.io/library/alpine:${ALPINE_VERSION}"
EXPOSE 22 
RUN apk add arp-scan \
    vlan 
