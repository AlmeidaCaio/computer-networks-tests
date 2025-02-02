# Container Image with common layer 4 utilities - for Firewalls
ARG ALPINE_VERSION
FROM "docker.io/library/alpine:${ALPINE_VERSION}"
EXPOSE 22 
RUN apk add iptables \
    tcpdump
