#!/bin/sh
#
# About it:
# * This is a simple network arrangement to allow containers to behave as l3-switches among themselves.
# Currently, this setup is based on scenario-1 with an addition to a firewall attached to router-1.
#
# Parameters:
# $1 = Container's Image Name with its version (name\:version)
#
imageName=$1
# Networks' configurations
docker network create --driver bridge --subnet 172.16.0.0/29 --gateway 172.16.0.1 --attachable subnet-vlan-001
docker network create --driver bridge --subnet 172.16.1.0/29 --gateway 172.16.1.1 --attachable subnet-vlan-011
docker network create --driver bridge --subnet 172.16.2.0/29 --gateway 172.16.2.1 --attachable subnet-vlan-021
docker network create --driver bridge --opt com.docker.network.bridge.name=eth1 --subnet 172.16.255.0/29 --gateway 172.16.255.1 --attachable p2p-vlans-001-011
docker network create --driver bridge --opt com.docker.network.bridge.name=eth2 --subnet 172.16.255.8/29 --gateway 172.16.255.9 --attachable p2p-vlans-001-021
# Devices' instatiations inside their primary networks
docker container run -itd -p 41231\:80 -p 41232\:443 -p 41233\:8080 --cap-add NET_ADMIN --name firwll-1 --network subnet-vlan-001 --ip 172.16.0.6 ${imageName}
docker container run -itd -p 41234\:80 -p 41235\:443 -p 41236\:8080 --cap-add NET_ADMIN --name router-1 --network subnet-vlan-001 --ip 172.16.0.2 ${imageName}
docker container run -itd -p 41237\:80 -p 41238\:443 -p 41239\:8080 --cap-add NET_ADMIN --name switch-1 --network subnet-vlan-011 --ip 172.16.1.2 ${imageName}
docker container run -itd -p 41243\:80 -p 41244\:443 -p 41245\:8080 --cap-add NET_ADMIN --name switch-2 --network subnet-vlan-021 --ip 172.16.2.2 ${imageName}
docker container run -itd -p 41240\:80 -p 41241\:443 -p 41242\:8080 --cap-add NET_ADMIN --name workst-1 --network subnet-vlan-011 --ip 172.16.1.3 ${imageName}
docker container run -itd -p 41246\:80 -p 41247\:443 -p 41248\:8080 --cap-add NET_ADMIN --name workst-2 --network subnet-vlan-021 --ip 172.16.2.3 ${imageName}
# Adding Peer to Peer subnets for each primary nework
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 172.16.255.2 p2p-vlans-001-011 router-1
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 172.16.255.3 p2p-vlans-001-011 switch-1
docker network connect --driver-opt com.docker.network.bridge.name=eth2 --ip 172.16.255.10 p2p-vlans-001-021 router-1
docker network connect --driver-opt com.docker.network.bridge.name=eth2 --ip 172.16.255.11 p2p-vlans-001-021 switch-2
# Alters default gateway from Docker's standard to custom containers (routers or l3-switches)
docker container exec firwll-1 sh -c 'echo -e -n "\n\n[firwll-1] " && ping -c 1 -t 1 172.16.0.1'
docker container exec router-1 sh -c 'ip route change default via 172.16.0.6 dev eth0 && echo -e -n "\n\n[router-1] " && ping -c 1 -t 1 172.16.0.6'
docker container exec switch-1 sh -c 'ip route change default via 172.16.255.2 dev eth1 && echo -e -n "\n\n[switch-1] " && ping -c 1 -t 1 172.16.0.2'
docker container exec switch-2 sh -c 'ip route change default via 172.16.255.10 dev eth1 && echo -e -n "\n\n[switch-2] " && ping -c 1 -t 1 172.16.0.2'
docker container exec workst-1 sh -c 'ip route change default via 172.16.1.2 dev eth0 && echo -e -n "\n\n[workst-1] " && ping -c 1 -t 1 172.16.1.2'
docker container exec workst-2 sh -c 'ip route change default via 172.16.2.2 dev eth0 && echo -e -n "\n\n[workst-2] " && ping -c 1 -t 1 172.16.2.2'
# Adds static routes to the router 
docker container exec router-1 sh -c 'ip route add 172.16.1.0/29 via 172.16.255.3 dev eth1 && echo -e -n "\n\n[router-1] " && ping -c 1 -t 2 172.16.1.3'
docker container exec router-1 sh -c 'ip route add 172.16.2.0/29 via 172.16.255.11 dev eth2 && echo -e -n "\n\n[router-1] " && ping -c 1 -t 2 172.16.2.3'
# Adds static routes to the firewall
docker container exec firwll-1 sh -c 'ip route add 172.16.1.0/29 via 172.16.0.2 dev eth0 && echo -e -n "\n\n[firwll-1] " && ping -c 1 -t 3 172.16.1.3'
docker container exec firwll-1 sh -c 'ip route add 172.16.2.0/29 via 172.16.0.2 dev eth0 && echo -e -n "\n\n[firwll-1] " && ping -c 1 -t 3 172.16.2.3'
docker container exec firwll-1 sh -c 'ip route add 172.16.255.0/28 via 172.16.0.2 dev eth0'
# Final validations
docker container exec firwll-1 sh -c 'echo -e -n "\n\n[firwll-1] " && ping -c 1 -t 2 172.16.1.2'
docker container exec firwll-1 sh -c 'echo -e -n "\n\n[firwll-1] " && ping -c 1 -t 2 172.16.2.2'
docker container exec workst-1 sh -c 'echo -e -n "\n\n[workst-1] " && ping -c 1 -t 2 172.16.0.2'
docker container exec workst-1 sh -c 'echo -e -n "\n\n[workst-1] " && ping -c 1 -t 3 172.16.0.6'
docker container exec workst-1 sh -c 'echo -e -n "\n\n[workst-1] " && ping -c 1 -t 4 172.16.2.3'
docker container exec workst-2 sh -c 'echo -e -n "\n\n[workst-2] " && ping -c 1 -t 2 172.16.0.2'
docker container exec workst-2 sh -c 'echo -e -n "\n\n[workst-2] " && ping -c 1 -t 3 172.16.0.6'
docker container exec workst-2 sh -c 'echo -e -n "\n\n[workst-2] " && ping -c 1 -t 4 172.16.1.3'
docker container exec switch-1 sh -c 'echo -e -n "\n\n[switch-1] " && ping -c 1 -t 2 172.16.0.6'
docker container exec switch-2 sh -c 'echo -e -n "\n\n[switch-2] " && ping -c 1 -t 2 172.16.0.6'
