FROM "docker.io/library/alpine:3.20.3"
EXPOSE 80 \
    443 \
    8080
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
    tcpdump
