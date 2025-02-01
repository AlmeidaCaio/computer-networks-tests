# Container Image with common layer 4 utilities- for Firewalls
FROM "docker.io/library/alpine:3.21.2"
EXPOSE 22 
RUN apk add iptables \
    tcpdump
