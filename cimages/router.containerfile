# Container Image with specialized layer 3 utilities - for Routers
ARG ALPINE_VERSION
FROM "docker.io/library/alpine:${ALPINE_VERSION}"
EXPOSE 22 
RUN apk add frr
RUN sed -i 's/ospfd=no/ospfd=yes/g' /etc/frr/daemons \
    && sed -i 's/#MAX_FDS=1024/MAX_FDS=1024/g' /etc/frr/daemons \ 
    && sh -c '/usr/lib/frr/zebra &' \
    && sh -c '/usr/lib/frr/ospfd --apiserver --config_file /etc/frr/ospfd.conf --daemon --group frr --limit-fds 100 --user frr &' 
