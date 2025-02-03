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
# $2 = Load firewall configuration into firwll-0 (e.g. "1" or "0")
#
baseImageVersion=$1
enableFirewall=$2
imageNameFirewall=cnt-firewall\:1.00
if [[ $( docker image ls --filter "reference=${imageNameFirewall}" | wc -l ) -lt 2 ]] ; then
    docker image build -f ./cimages/firewall.containerfile --build-arg ALPINE_VERSION=${baseImageVersion} -t ${imageNameFirewall} ./ 
fi
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
docker container run -itd --rm -p 41230\:22 --cap-add NET_ADMIN --name firwll-0 --network subnet-vlan-001 --ip 172.20.0.2 ${imageNameFirewall}
docker container run -itd --rm -p 41231\:22 --cap-add NET_ADMIN --name router-1 --network subnet-vlan-001 --ip 172.20.0.10 ${imageNameRouter} --privileged 
docker container run -itd --rm -p 41232\:22 --cap-add NET_ADMIN --name router-2 --network subnet-vlan-001 --ip 172.20.0.20 ${imageNameRouter} --privileged 
docker container run -itd --rm -p 41233\:22 --cap-add NET_ADMIN --name router-3 --network subnet-vlan-001 --ip 172.20.0.30 ${imageNameRouter} --privileged 
docker container run -itd --rm -p 41234\:22 --cap-add NET_ADMIN --name switch-11 --network p2p-vlans-001-1X1 --ip 172.21.0.3 ${imageNameSwitch}
docker container run -itd --rm -p 41235\:22 --cap-add NET_ADMIN --name switch-12 --network p2p-vlans-001-1X1 --ip 172.21.0.4 ${imageNameSwitch}
docker container run -itd --rm -p 41236\:22 --cap-add NET_ADMIN --name switch-21 --network p2p-vlans-001-2X1 --ip 172.22.0.3 ${imageNameSwitch}
docker container run -itd --rm -p 41237\:22 --cap-add NET_ADMIN --name switch-22 --network p2p-vlans-001-2X1 --ip 172.22.0.4 ${imageNameSwitch}
docker container run -itd --rm -p 41238\:22 --cap-add NET_ADMIN --name switch-31 --network p2p-vlans-001-3X1 --ip 172.23.0.3 ${imageNameSwitch}
docker container run -itd --rm -p 41239\:22 --cap-add NET_ADMIN --name switch-32 --network p2p-vlans-001-3X1 --ip 172.23.0.4 ${imageNameSwitch}
docker container run -itd --rm -p 41240\:22 --cap-add NET_ADMIN --name workst-a --network subnet-vlan-111 --ip 172.21.1.3 ${imageNameWorkStation}
docker container run -itd --rm -p 41241\:22 --cap-add NET_ADMIN --name workst-b --network subnet-vlan-111 --ip 172.21.1.4 ${imageNameWorkStation}
docker container run -itd --rm -p 41242\:22 --cap-add NET_ADMIN --name workst-c --network subnet-vlan-121 --ip 172.21.2.3 ${imageNameWorkStation}
docker container run -itd --rm -p 41243\:22 --cap-add NET_ADMIN --name workst-d --network subnet-vlan-121 --ip 172.21.2.4 ${imageNameWorkStation}
docker container run -itd --rm -p 41244\:22 --cap-add NET_ADMIN --name workst-e --network subnet-vlan-211 --ip 172.22.1.3 ${imageNameWorkStation}
docker container run -itd --rm -p 41245\:22 --cap-add NET_ADMIN --name workst-f --network subnet-vlan-211 --ip 172.22.1.4 ${imageNameWorkStation}
docker container run -itd --rm -p 41246\:22 --cap-add NET_ADMIN --name workst-g --network subnet-vlan-221 --ip 172.22.2.3 ${imageNameWorkStation}
docker container run -itd --rm -p 41247\:22 --cap-add NET_ADMIN --name workst-h --network subnet-vlan-221 --ip 172.22.2.4 ${imageNameWorkStation}
docker container run -itd --rm -p 41248\:22 --cap-add NET_ADMIN --name workst-i --network subnet-vlan-311 --ip 172.23.1.3 ${imageNameWorkStation}
docker container run -itd --rm -p 41249\:22 --cap-add NET_ADMIN --name workst-j --network subnet-vlan-311 --ip 172.23.1.4 ${imageNameWorkStation}
docker container run -itd --rm -p 41250\:22 --cap-add NET_ADMIN --name workst-k --network subnet-vlan-321 --ip 172.23.2.3 ${imageNameWorkStation}
docker container run -itd --rm -p 41251\:22 --cap-add NET_ADMIN --name workst-l --network subnet-vlan-321 --ip 172.23.2.4 ${imageNameWorkStation}
# Adding Peer to Peer subnets for each primary nework
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 172.21.0.2 p2p-vlans-001-1X1 router-1 
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 172.22.0.2 p2p-vlans-001-2X1 router-2 
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 172.23.0.2 p2p-vlans-001-3X1 router-3 
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 172.21.1.2 subnet-vlan-111 switch-11 
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 172.21.2.2 subnet-vlan-121 switch-12 
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 172.22.1.2 subnet-vlan-211 switch-21 
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 172.22.2.2 subnet-vlan-221 switch-22 
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 172.23.1.2 subnet-vlan-311 switch-31 
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 172.23.2.2 subnet-vlan-321 switch-32  
# Alters default gateway from Docker's standard to custom containers (routers or l3-switches)
docker container exec firwll-0 sh -c 'echo -e -n "\n\n[firwll-1] " && ping -c 1 -t 1 172.20.0.1'
docker container exec router-1 sh -c 'ip route change default via 172.20.0.2 dev eth0 && echo -e -n "\n\n[router-1] " && ping -c 1 -t 1 172.20.0.2'
docker container exec router-2 sh -c 'ip route change default via 172.20.0.2 dev eth0 && echo -e -n "\n\n[router-2] " && ping -c 1 -t 1 172.20.0.2'
docker container exec router-3 sh -c 'ip route change default via 172.20.0.2 dev eth0 && echo -e -n "\n\n[router-3] " && ping -c 1 -t 1 172.20.0.2'
docker container exec switch-11 sh -c 'ip route change default via 172.21.0.2 dev eth0 && echo -e -n "\n\n[switch-11] " && ping -c 1 -t 1 172.21.0.2'
docker container exec switch-12 sh -c 'ip route change default via 172.21.0.2 dev eth0 && echo -e -n "\n\n[switch-12] " && ping -c 1 -t 1 172.21.0.2'
docker container exec switch-21 sh -c 'ip route change default via 172.22.0.2 dev eth0 && echo -e -n "\n\n[switch-21] " && ping -c 1 -t 1 172.22.0.2'
docker container exec switch-22 sh -c 'ip route change default via 172.22.0.2 dev eth0 && echo -e -n "\n\n[switch-22] " && ping -c 1 -t 1 172.22.0.2'
docker container exec switch-31 sh -c 'ip route change default via 172.23.0.2 dev eth0 && echo -e -n "\n\n[switch-31] " && ping -c 1 -t 1 172.23.0.2'
docker container exec switch-32 sh -c 'ip route change default via 172.23.0.2 dev eth0 && echo -e -n "\n\n[switch-32] " && ping -c 1 -t 1 172.23.0.2'
docker container exec workst-a sh -c 'ip route change default via 172.21.1.2 dev eth0 && echo -e -n "\n\n[workst-a] " && ping -c 1 -t 1 172.21.1.2'
docker container exec workst-b sh -c 'ip route change default via 172.21.1.2 dev eth0 && echo -e -n "\n\n[workst-b] " && ping -c 1 -t 1 172.21.1.2' 
docker container exec workst-c sh -c 'ip route change default via 172.21.2.2 dev eth0 && echo -e -n "\n\n[workst-c] " && ping -c 1 -t 1 172.21.2.2' 
docker container exec workst-d sh -c 'ip route change default via 172.21.2.2 dev eth0 && echo -e -n "\n\n[workst-d] " && ping -c 1 -t 1 172.21.2.2' 
docker container exec workst-e sh -c 'ip route change default via 172.22.1.2 dev eth0 && echo -e -n "\n\n[workst-e] " && ping -c 1 -t 1 172.22.1.2' 
docker container exec workst-f sh -c 'ip route change default via 172.22.1.2 dev eth0 && echo -e -n "\n\n[workst-f] " && ping -c 1 -t 1 172.22.1.2' 
docker container exec workst-g sh -c 'ip route change default via 172.22.2.2 dev eth0 && echo -e -n "\n\n[workst-g] " && ping -c 1 -t 1 172.22.2.2' 
docker container exec workst-h sh -c 'ip route change default via 172.22.2.2 dev eth0 && echo -e -n "\n\n[workst-h] " && ping -c 1 -t 1 172.22.2.2' 
docker container exec workst-i sh -c 'ip route change default via 172.23.1.2 dev eth0 && echo -e -n "\n\n[workst-i] " && ping -c 1 -t 1 172.23.1.2' 
docker container exec workst-j sh -c 'ip route change default via 172.23.1.2 dev eth0 && echo -e -n "\n\n[workst-j] " && ping -c 1 -t 1 172.23.1.2' 
docker container exec workst-k sh -c 'ip route change default via 172.23.2.2 dev eth0 && echo -e -n "\n\n[workst-k] " && ping -c 1 -t 1 172.23.2.2' 
docker container exec workst-l sh -c 'ip route change default via 172.23.2.2 dev eth0 && echo -e -n "\n\n[workst-l] " && ping -c 1 -t 1 172.23.2.2' 
# TODO:
#    - Set-up OSPF
echo "-----------------------------------------------" && \
echo "--------------NETWORK SETUP DONE!--------------" && \
echo "-----------------------------------------------"
# Firewall setup
if ! [[ ${enableFirewall} =~ ^[01]$ ]] ; then
    echo "ERROR 5: Scenario-3's parameter \$2 = '$2'; needs to be '0' or '1', since it's a boolean flag."
    exit 5
fi
if [[ ${enableFirewall} == "1" ]] ; then
    echo "-----------------------------------------------" && \
    echo "----------------FIREWALL SETUP-----------------" && \
    echo "-----------------------------------------------"
    docker container cp "./$( find . -name 'scenario-3.firwll-0.sh' -printf '%P' )" firwll-0:/ && \
    docker container exec firwll-0 sh /scenario-3.firwll-0.sh && \
    echo "[firwll-0] File '/scenario-3.firwll-0.sh' loaded successfully." && \
    echo "-----------------------------------------------" && \
    echo "-------------FIREWALL SETUP DONE!--------------" && \
    echo "-----------------------------------------------"
    # TODO: run tests
fi
