# Container Image with specialized layer 3 utilities - for Routers
ARG ALPINE_VERSION
FROM "docker.io/library/alpine:${ALPINE_VERSION}"
EXPOSE 22 
RUN apk add quagga \
    && mkdir /var/log/quagga \
    && chown quagga\:quagga /var/log/quagga \
    && sh -c "cat <( echo -e '### Sample of a Zebra daemon configuration file\n###\n### Check the reference link:\n###    - https://www.nongnu.org/quagga/docs/quagga.html#Basic-Config-Commands\n###\n## Below are examples of commands to be written in this file;\n## for them to take effect, uncomment them by removing the first character (either ! or #).\n!hostname Router\n!password zebra\n!enable password zebra\n!log file /var/log/quagga/zebra.log informational\n!no log timestamp precision\n' ) > /etc/quagga/zebra-sample.conf" \
    && chown quagga\:quagga /etc/quagga/zebra-sample.conf

    # TODO: add sample conf to ospfd
    