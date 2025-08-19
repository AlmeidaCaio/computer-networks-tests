#!/bin/bash
#
# About it (WIP):
# * This is a network with 6 routers.
# * The VLANs exist to allow neighboring communication among routers behind same Autonomous Systems
#
# References:
#    - https://www.nongnu.org/quagga/docs/quagga.html#BGP
#
# Parameters:
# $1 = Load containers with debugger image (boolean flag: "1" or "0")
#
dbgImageFlag=$1
imageNameRouter="`[[ ${dbgImageFlag} == "1" ]] && imageBuilder 'debugger' || imageBuilder 'router'`"
echo "-----------------------------------------------" && \
echo "-----------------NETWORK SETUP-----------------" && \
echo "-----------------------------------------------"
docker network create --driver bridge --subnet 10.1.12.0/24 --gateway 10.1.12.254 --attachable subnet-vlan-12
docker network create --driver bridge --subnet 10.1.35.0/24 --gateway 10.1.35.254 --attachable subnet-vlan-35
docker network create --driver bridge --subnet 10.1.46.0/24 --gateway 10.1.46.254 --attachable subnet-vlan-46
docker network create --driver bridge --subnet 10.1.56.0/24 --gateway 10.1.56.254 --attachable subnet-vlan-56
docker container run -itd -p 41231\:179 --cap-add NET_ADMIN --name router-1 --network subnet-vlan-12 --ip 10.1.12.1 ${imageNameRouter} 
docker container run -itd -p 41232\:179 --cap-add NET_ADMIN --name router-2 --network subnet-vlan-12 --ip 10.1.12.2 ${imageNameRouter} 
docker container run -itd -p 41233\:179 --cap-add NET_ADMIN --name router-3 --network subnet-vlan-35 --ip 10.1.35.3 ${imageNameRouter} 
docker container run -itd -p 41234\:179 --cap-add NET_ADMIN --name router-4 --network subnet-vlan-46 --ip 10.1.46.4 ${imageNameRouter} 
docker container run -itd -p 41235\:179 --cap-add NET_ADMIN --name router-5 --network subnet-vlan-35 --ip 10.1.35.5 ${imageNameRouter} 
docker container run -itd -p 41236\:179 --cap-add NET_ADMIN --name router-6 --network subnet-vlan-46 --ip 10.1.46.6 ${imageNameRouter} 
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 10.1.56.5 subnet-vlan-56 router-5 
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 10.1.56.6 subnet-vlan-56 router-6 
docker network create --driver bridge --subnet 1.1.1.0/31 --gateway 1.1.1.0 --attachable loopback-1 --internal
docker network create --driver bridge --subnet 2.2.2.2/31 --gateway 2.2.2.3 --attachable loopback-2 --internal
docker network create --driver bridge --subnet 3.3.3.2/31 --gateway 3.3.3.2 --attachable loopback-3 --internal
docker network create --driver bridge --subnet 4.4.4.4/31 --gateway 4.4.4.5 --attachable loopback-4 --internal
docker network create --driver bridge --subnet 5.5.5.4/31 --gateway 5.5.5.4 --attachable loopback-5 --internal
docker network create --driver bridge --subnet 6.6.6.6/31 --gateway 6.6.6.7 --attachable loopback-6 --internal
docker network connect --driver-opt com.docker.network.bridge.name=lo1 --ip 1.1.1.1 loopback-1 router-1
docker network connect --driver-opt com.docker.network.bridge.name=lo2 --ip 2.2.2.2 loopback-2 router-2
docker network connect --driver-opt com.docker.network.bridge.name=lo3 --ip 3.3.3.3 loopback-3 router-3
docker network connect --driver-opt com.docker.network.bridge.name=lo4 --ip 4.4.4.4 loopback-4 router-4
docker network connect --driver-opt com.docker.network.bridge.name=lo5 --ip 5.5.5.5 loopback-5 router-5
docker network connect --driver-opt com.docker.network.bridge.name=lo6 --ip 6.6.6.6 loopback-6 router-6
# TODO
