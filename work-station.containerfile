# Container Image with common layer 7 utilities- for Work-Stations
FROM "docker.io/library/alpine:3.21.2"
EXPOSE 22 \
    443 \
    587
RUN apk add curl 
