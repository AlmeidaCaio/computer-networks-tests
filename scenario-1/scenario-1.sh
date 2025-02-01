#!/bin/bash
#
# About it:
# * This is a simple network arrangement to allow containers to behave as l3-switches among themselves.
# Currently, this setup only have layer 3 configurations with static routes.
#
# Parameters:
# $1 = Alpine Version (e.g. "1.1.1")
#
baseImageVersion=$1
imageName=tst-switch-l3\:1.00
if [[ $( docker image ls --filter "reference=${imageName}" | wc -l ) -lt 2 ]] ; then
    docker image build -f ./cimages/switch-l3.containerfile --build-arg ALPINE_VERSION=${baseImageVersion} -t ${imageName} ./ 
fi
# Networks' configurations
docker network create --driver bridge --subnet 172.16.0.0/30 --attachable subnet-vlan-001
docker network create --driver bridge --subnet 172.16.1.0/29 --attachable subnet-vlan-011
docker network create --driver bridge --subnet 172.16.2.0/29 --attachable subnet-vlan-021
docker network create --driver bridge --subnet 172.16.255.0/29 --attachable p2p-vlans-001-011
docker network create --driver bridge --subnet 172.16.255.8/29 --attachable p2p-vlans-001-021
# Devices' instatiations inside their primary networks
docker container run -itd -p 41234\:22 --cap-add NET_ADMIN --name router-1 --network subnet-vlan-001 --ip 172.16.0.2 ${imageName} \
    && echo "[router-1] net.ipv4.ip_forward=$(docker container exec router-1 sh -c 'cat /proc/sys/net/ipv4/ip_forward')"
docker container run -itd -p 41235\:22 --cap-add NET_ADMIN --name switch-1 --network subnet-vlan-011 --ip 172.16.1.2 ${imageName} \
    && echo "[switch-1] net.ipv4.ip_forward=$(docker container exec switch-1 sh -c 'cat /proc/sys/net/ipv4/ip_forward')"
docker container run -itd -p 41236\:22 --cap-add NET_ADMIN --name switch-2 --network subnet-vlan-021 --ip 172.16.2.2 ${imageName} \
    && echo "[switch-2] net.ipv4.ip_forward=$(docker container exec switch-2 sh -c 'cat /proc/sys/net/ipv4/ip_forward')"
docker container run -itd -p 41237\:22 --cap-add NET_ADMIN --name workst-1 --network subnet-vlan-011 --ip 172.16.1.3 ${imageName} \
    && echo "[workst-1] net.ipv4.ip_forward=$(docker container exec workst-1 sh -c 'cat /proc/sys/net/ipv4/ip_forward')"
docker container run -itd -p 41238\:22 --cap-add NET_ADMIN --name workst-2 --network subnet-vlan-021 --ip 172.16.2.3 ${imageName} \
    && echo "[workst-2] net.ipv4.ip_forward=$(docker container exec workst-2 sh -c 'cat /proc/sys/net/ipv4/ip_forward')"
# Adding Peer to Peer subnets for each primary nework
docker network connect --ip 172.16.255.2 p2p-vlans-001-011 router-1
docker network connect --ip 172.16.255.3 p2p-vlans-001-011 switch-1
docker network connect --ip 172.16.255.10 p2p-vlans-001-021 router-1
docker network connect --ip 172.16.255.11 p2p-vlans-001-021 switch-2
# Alters default gateway from Docker's standard to custom containers (routers or l3-switches)
echo -e '\n\n[router-1] ping to docker\x27s gtw:' \
    && docker container exec router-1 sh -c 'ip route change default via 172.16.0.1 dev eth0 && ping -c 1 -t 1 172.16.0.1'
echo -e '\n\n[switch-1] ping to router-1:' \
    && docker container exec switch-1 sh -c 'ip route change default via 172.16.255.2 dev eth1 && ping -c 1 -t 1 172.16.0.2'
echo -e '\n\n[switch-2] ping to router-1:' \
    && docker container exec switch-2 sh -c 'ip route change default via 172.16.255.10 dev eth1 && ping -c 1 -t 1 172.16.0.2'
echo -e '\n\n[workst-1] ping to switch-1:' \
    && docker container exec workst-1 sh -c 'ip route change default via 172.16.1.2 dev eth0 && ping -c 1 -t 1 172.16.1.2'
echo -e '\n\n[workst-2] ping to switch-2:' \
    && docker container exec workst-2 sh -c 'ip route change default via 172.16.2.2 dev eth0 && ping -c 1 -t 1 172.16.2.2'
# Adds static routes to the router
echo -e '\n\n[router-1] ping to workst-1:' \
    && docker container exec router-1 sh -c 'ip route add 172.16.1.0/24 via 172.16.255.3 dev eth1 && ping -c 1 -t 2 172.16.1.3'
echo -e '\n\n[router-1] ping to workst-2:' \
    && docker container exec router-1 sh -c 'ip route add 172.16.2.0/24 via 172.16.255.11 dev eth2 && ping -c 1 -t 2 172.16.2.3'
# Final validations
echo -e '\n\n[workst-1] ping to router-1:' \
    && docker container exec workst-1 sh -c 'ping -c 1 -t 2 172.16.0.2'
echo -e '\n\n[workst-2] ping to router-1:' \
    && docker container exec workst-2 sh -c 'ping -c 1 -t 2 172.16.0.2'
echo -e '\n\n[workst-1] ping to workst-2:' \
    && docker container exec workst-1 sh -c 'ping -c 1 -t 4 172.16.2.3'
echo -e '\n\n[workst-2] ping to workst-1:' \
    && docker container exec workst-2 sh -c 'ping -c 1 -t 4 172.16.1.3'
