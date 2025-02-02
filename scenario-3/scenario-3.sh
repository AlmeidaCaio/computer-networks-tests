#!/bin/bash
#
# About it:
# * This is TODO; however, dynamic routes are loaded with OSPF.
#
# References:
#    - https://docs.frrouting.org/en/stable-10.2/ospfd.html
#    - https://www.networkacademy.io/ccna/ospf/ospf-best-path-selection
#
# Parameters:
# $1 = Alpine Version (e.g. "1.1.1")
#
baseImageVersion=$1
imageNameFirewall=cnt-simple\:1.00
imageNameRouter=cnt-router\:1.00
if [[ $( docker image ls --filter "reference=${imageNameRouter}" | wc -l ) -lt 2 ]] ; then
    docker image build -f ./cimages/router.containerfile --build-arg ALPINE_VERSION=${baseImageVersion} -t ${imageNameRouter} ./ 
fi
imageNameSwitch=cnt-simple\:1.00
if [[ $( docker image ls --filter "reference=${imageNameSwitch}" | wc -l ) -lt 2 ]] ; then
    docker image build -f ./cimages/.containerfile --build-arg ALPINE_VERSION=${baseImageVersion} -t ${imageNameSwitch} ./ 
fi
imageNameWorkStation=cnt-simple\:1.00
echo "-----------------------------------------------" && \
echo "-----------------NETWORK SETUP-----------------" && \
echo "-----------------------------------------------"
docker network create --driver bridge --subnet 172.20.0.0/24 --gateway 172.20.0.1 --attachable subnet-vlan-001
docker network create --driver bridge --subnet 172.21.0.0/29 --gateway 172.21.0.1 --attachable p2p-vlans-001-1X1
docker network create --driver bridge --subnet 172.22.0.0/29 --gateway 172.22.0.1 --attachable p2p-vlans-001-2X1
docker network create --driver bridge --subnet 172.23.0.0/29 --gateway 172.23.0.1 --attachable p2p-vlans-001-3X1
docker network create --driver bridge --subnet 172.21.1.0/24 --gateway 172.21.1.1 --attachable subnet-vlan-111
docker network create --driver bridge --subnet 172.22.1.0/24 --gateway 172.22.1.1 --attachable subnet-vlan-211
docker network create --driver bridge --subnet 172.23.1.0/24 --gateway 172.23.1.1 --attachable subnet-vlan-311
docker network create --driver bridge --subnet 172.21.2.0/24 --gateway 172.21.2.1 --attachable subnet-vlan-121
docker network create --driver bridge --subnet 172.22.2.0/24 --gateway 172.22.2.1 --attachable subnet-vlan-221
docker network create --driver bridge --subnet 172.23.2.0/24 --gateway 172.23.2.1 --attachable subnet-vlan-321
docker container run -itd -p 41230\:22 --cap-add NET_ADMIN --name firwll-0 --network subnet-vlan-001 --ip 172.20.0.2 ${imageNameFirewall}
docker container run -itd -p 41231\:22 --cap-add NET_ADMIN --name router-1 --network subnet-vlan-001 --ip 172.20.0.10 ${imageNameRouter}
docker container run -itd -p 41232\:22 --cap-add NET_ADMIN --name router-2 --network subnet-vlan-001 --ip 172.20.0.20 ${imageNameRouter}
docker container run -itd -p 41233\:22 --cap-add NET_ADMIN --name router-3 --network subnet-vlan-001 --ip 172.20.0.30 ${imageNameRouter}
docker container run -itd -p 41234\:22 --cap-add NET_ADMIN --name switch-11 --network p2p-vlans-001-1X1 --ip 172.21.0.3 ${imageNameSwitch}
docker container run -itd -p 41235\:22 --cap-add NET_ADMIN --name switch-12 --network p2p-vlans-001-1X1 --ip 172.21.0.4 ${imageNameSwitch}
docker container run -itd -p 41236\:22 --cap-add NET_ADMIN --name switch-21 --network p2p-vlans-001-2X1 --ip 172.22.0.3 ${imageNameSwitch}
docker container run -itd -p 41237\:22 --cap-add NET_ADMIN --name switch-22 --network p2p-vlans-001-2X1 --ip 172.22.0.4 ${imageNameSwitch}
docker container run -itd -p 41238\:22 --cap-add NET_ADMIN --name switch-31 --network p2p-vlans-001-3X1 --ip 172.23.0.3 ${imageNameSwitch}
docker container run -itd -p 41239\:22 --cap-add NET_ADMIN --name switch-32 --network p2p-vlans-001-3X1 --ip 172.23.0.4 ${imageNameSwitch}
docker container run -itd -p 41240\:22 --cap-add NET_ADMIN --name workst-a --network subnet-vlan-111 --ip 172.21.1.3 ${imageNameWorkStation}
docker container run -itd -p 41241\:22 --cap-add NET_ADMIN --name workst-b --network subnet-vlan-111 --ip 172.21.1.4 ${imageNameWorkStation}
docker container run -itd -p 41242\:22 --cap-add NET_ADMIN --name workst-c --network subnet-vlan-121 --ip 172.21.2.3 ${imageNameWorkStation}
docker container run -itd -p 41243\:22 --cap-add NET_ADMIN --name workst-d --network subnet-vlan-121 --ip 172.21.2.4 ${imageNameWorkStation}
docker container run -itd -p 41244\:22 --cap-add NET_ADMIN --name workst-e --network subnet-vlan-211 --ip 172.22.1.3 ${imageNameWorkStation}
docker container run -itd -p 41245\:22 --cap-add NET_ADMIN --name workst-f --network subnet-vlan-211 --ip 172.22.1.4 ${imageNameWorkStation}
docker container run -itd -p 41246\:22 --cap-add NET_ADMIN --name workst-g --network subnet-vlan-221 --ip 172.22.2.3 ${imageNameWorkStation}
docker container run -itd -p 41247\:22 --cap-add NET_ADMIN --name workst-h --network subnet-vlan-221 --ip 172.22.2.4 ${imageNameWorkStation}
docker container run -itd -p 41248\:22 --cap-add NET_ADMIN --name workst-i --network subnet-vlan-311 --ip 172.23.1.3 ${imageNameWorkStation}
docker container run -itd -p 41249\:22 --cap-add NET_ADMIN --name workst-j --network subnet-vlan-311 --ip 172.23.1.4 ${imageNameWorkStation}
docker container run -itd -p 41250\:22 --cap-add NET_ADMIN --name workst-k --network subnet-vlan-321 --ip 172.23.2.3 ${imageNameWorkStation}
docker container run -itd -p 41251\:22 --cap-add NET_ADMIN --name workst-l --network subnet-vlan-321 --ip 172.23.2.4 ${imageNameWorkStation}
# Adding Peer to Peer subnets for each primary nework
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 172.21.0.2 subnet-vlan-101 router-1 
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 172.22.0.2 subnet-vlan-201 router-2 
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 172.23.0.2 subnet-vlan-301 router-3 
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 172.21.1.2 subnet-vlan-111 switch-11 
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 172.21.2.2 subnet-vlan-121 switch-12 
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 172.22.1.2 subnet-vlan-211 switch-21 
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 172.22.2.2 subnet-vlan-221 switch-22 
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 172.23.1.2 subnet-vlan-311 switch-31 
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 172.23.2.2 subnet-vlan-321 switch-32  

# TODO
