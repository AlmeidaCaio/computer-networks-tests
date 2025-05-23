# Complete Container Image - for debugging
ARG ALPINE_VERSION
FROM "docker.io/library/alpine:${ALPINE_VERSION}"
EXPOSE 22 \
    443 \
    587
RUN apk update \
    && apk add arp-scan \
        curl \
        iproute2 \
        iptables \
        iptstate \
        iputils-arping \
        iputils-clockdiff \
        iputils-ping \
        iputils-tracepath \
        quagga \
        tcpdump \
    && mkdir /var/log/quagga \
    && chown quagga\:quagga /var/log/quagga \
    && sh -c "cat <( echo -e '### Sample of a Zebra daemon configuration file\n###\n### Check the reference link:\n###    - https://www.nongnu.org/quagga/docs/quagga.html#Basic-Config-Commands\n###\n## Below are examples of commands to be written in this file;\n## for them to take effect, uncomment them by removing the first character (either ! or #).\n!hostname Router\n!password zebra\n!enable password zebra\n!log file /var/log/quagga/zebra.log informational\n!no log timestamp precision\n!line vty\n!\n' ) > /etc/quagga/zebra-sample.conf" \
    && chown quagga\:quagga /etc/quagga/zebra-sample.conf \
    && sh -c "cat <( echo -e '### Sample of a OSPFv2 daemon configuration file\n###\n### Check the reference link:\n###    - https://www.nongnu.org/quagga/docs/quagga.html#OSPF-router\n###    - https://ixnfo.com/en/configuring-ospf-in-quagga.html#google_vignette\n###\n## Below are examples of commands to be written in this file;\n## for them to take effect, uncomment them by removing the first character (either ! or #).\n!hostname Router\n!password ospfd\n!log file /var/log/quagga/ospfd.log\n!service advanced-vty\n!\n!router ospf\n! ospf router-id 192.168.0.1\n! redistribute connected\n! passive-interface ppp0\n! network 192.168.0.0/24 area 0.0.0.0\n! network 10.0.0.0/16 area 0.0.0.0\n! network 192.168.1.0/24 area 0.0.0.1\n! area 0.0.0.0 authentication message-digest\n! area 0.0.0.0 range 10.0.0.0/16\n! area 0.0.0.0 range 192.168.0.0/24\n! area 0.0.0.1 authentication message-digest\n! area 0.0.0.1 range 10.2.0.0/16\n!\n!line vty\n!\n' ) > /etc/quagga/ospfd-sample.conf" \
    && chown quagga\:quagga /etc/quagga/ospfd-sample.conf
