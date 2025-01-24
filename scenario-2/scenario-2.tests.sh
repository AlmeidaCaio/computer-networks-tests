#!/bin/sh
#
# TODO: Colocar testes de validação - camada 4
docker container exec it firwll-1 tcpdump -i eth0 
docker container exec workst-1 curl -I -k -vvv "https://23.201.217.217:443/"
docker container exec workst-2 curl -I -k -vvv "https://172.16.1.3:22/"
