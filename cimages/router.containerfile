# Container Image with specialized layer 3 utilities- for Routers
ARG ALPINE_VERSION
FROM "docker.io/library/alpine:${ALPINE_VERSION}"
EXPOSE 22 
RUN apk add frr 
