FROM "docker.io/library/alpine:3.21.2"
EXPOSE 22 \
    443 \
    587
RUN apk add curl \
    frr \
    inetutils-telnet \
    iptables \
    iptstate \
    iputils-arping \
    iputils-clockdiff \
    iputils-ping \
    iputils-tracepath \
    openssh \
    tcpdump \
    vlan 
