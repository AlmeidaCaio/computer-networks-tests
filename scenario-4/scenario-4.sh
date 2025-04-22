#!/bin/bash
#
# About it:
# * This is a network with 2 switches with VLANs 11, 21 and 31 to segregate traffic.
# * The VLANs exist to allow traffic among single segments of each switch, i.e., 172.20.00X.0/24 and 172.20.01X.0/24 respectively.
#
# References:
#    - https://community.synology.com/enu/forum/11/post/191645
#    - https://wiki.alpinelinux.org/wiki/VLAN
#    - https://superuser.com/questions/1670969/wsl2-make-available-visible-all-windows-network-adapters-inside-ubuntu#1671057
#    - https://learn.microsoft.com/en-us/windows/wsl/wsl-config#wslconfig
#    - https://stackoverflow.com/questions/30905674/newer-versions-of-docker-have-cap-add-what-caps-can-be-added
#
# Parameters:
# $1 = Alpine Version (e.g. "1.1.1")
# $2 = Load containers witdebugger images (boolean flag: "1" or "0")
# $3 = Load firewall configuration into firwll-1 (e.g. "1" or "0")
#
baseImageVersion=$1
dbgImageFlag=$2
enableFirewall=$3
if ! [[ ${enableFirewall} =~ ^[01]$ ]] ; then
    echo "ERROR 6: Parameter \$3 = '$3'; needs to be '0' or '1', since it's a boolean flag."
    exit 6
fi
imageNameFirewall="`[[ ${dbgImageFlag} == "1" ]] && imageBuilder 'debugger' || imageBuilder 'firewall'`"
imageNameSwitch="`[[ ${dbgImageFlag} == "1" ]] && imageBuilder 'debugger' || imageBuilder 'switch'`"
imageNameWorkStation="`[[ ${dbgImageFlag} == "1" ]] && imageBuilder 'debugger' || imageBuilder 'simple'`"
echo "-----------------------------------------------" && \
echo "-----------------NETWORK SETUP-----------------" && \
echo "-----------------------------------------------"
hostInterfaceLink="` ip link list | grep 'state UP' | grep 'eth' | head -n 1 | sed -E 's/^[0-9]+:\s*(\w+):.*$/\1/g' `"
sudo ip link set dev ${hostInterfaceLink} promisc on
docker network create --driver bridge --subnet 172.20.0.0/30 --gateway 172.20.0.1 --attachable subnet-vlan-001
docker network create --driver bridge --subnet 172.20.0.8/29 --gateway 172.20.0.9 --attachable p2p-svlans-001-0X1
docker network create --driver bridge --subnet 172.20.0.16/29 --gateway 172.20.0.17 --attachable p2p-svlans-001-1X1
docker network create --driver bridge --subnet 172.20.1.0/24 --gateway 172.20.1.1 --attachable subnet-vlan-011
docker network create --driver bridge --subnet 172.20.2.0/24 --gateway 172.20.2.1 --attachable subnet-vlan-021
docker network create --driver bridge --subnet 172.20.3.0/24 --gateway 172.20.3.1 --attachable subnet-vlan-031
docker network create --driver bridge --subnet 172.20.11.0/24 --gateway 172.20.11.1 --attachable subnet-vlan-111
docker network create --driver bridge --subnet 172.20.12.0/24 --gateway 172.20.12.1 --attachable subnet-vlan-121
docker network create --driver bridge --subnet 172.20.13.0/24 --gateway 172.20.13.1 --attachable subnet-vlan-131
docker container run -itd --rm -p 41230\:22 --cap-add NET_ADMIN --name firwll-0 --network subnet-vlan-001 --ip 172.20.0.2 ${imageNameFirewall} 
docker container run -itd --rm -p 41231\:22 --cap-add NET_ADMIN --cap-add SYS_ADMIN --name switch-0 --network p2p-svlans-001-0X1 --ip 172.20.0.11 ${imageNameSwitch} 
docker container run -itd --rm -p 41232\:22 --cap-add NET_ADMIN --cap-add SYS_ADMIN --name switch-1 --network p2p-svlans-001-1X1 --ip 172.20.0.19 ${imageNameSwitch}
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 172.20.0.10 p2p-svlans-001-0X1 firwll-0 
docker network connect --driver-opt com.docker.network.bridge.name=eth2 --ip 172.20.0.18 p2p-svlans-001-1X1 firwll-0 
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 172.20.1.2 subnet-vlan-011 switch-0
docker network connect --driver-opt com.docker.network.bridge.name=eth2 --ip 172.20.2.2 subnet-vlan-021 switch-0
docker network connect --driver-opt com.docker.network.bridge.name=eth3 --ip 172.20.3.2 subnet-vlan-031 switch-0 
docker network connect --driver-opt com.docker.network.bridge.name=eth1 --ip 172.20.11.2 subnet-vlan-111 switch-1
docker network connect --driver-opt com.docker.network.bridge.name=eth2 --ip 172.20.12.2 subnet-vlan-121 switch-1
docker network connect --driver-opt com.docker.network.bridge.name=eth3 --ip 172.20.13.2 subnet-vlan-131 switch-1 
docker container run -itd --rm -p 41233\:22 --cap-add NET_ADMIN --name workst-011 --network subnet-vlan-011 --ip 172.20.1.3 ${imageNameWorkStation} 
docker container run -itd --rm -p 41234\:22 --cap-add NET_ADMIN --name workst-021 --network subnet-vlan-021 --ip 172.20.2.3 ${imageNameWorkStation} 
docker container run -itd --rm -p 41235\:22 --cap-add NET_ADMIN --name workst-031 --network subnet-vlan-031 --ip 172.20.3.3 ${imageNameWorkStation} 
docker container run -itd --rm -p 41236\:22 --cap-add NET_ADMIN --name workst-111 --network subnet-vlan-111 --ip 172.20.11.3 ${imageNameWorkStation} 
docker container run -itd --rm -p 41237\:22 --cap-add NET_ADMIN --name workst-121 --network subnet-vlan-121 --ip 172.20.12.3 ${imageNameWorkStation} 
docker container run -itd --rm -p 41238\:22 --cap-add NET_ADMIN --name workst-131 --network subnet-vlan-131 --ip 172.20.13.3 ${imageNameWorkStation} 
docker container exec firwll-0 sh -c 'ip route change default via 172.20.0.1 dev eth0 && echo -e -n "\n\n[firwll-0] " && ping -c 1 -t 1 172.20.0.1'
docker container exec switch-0 sh -c 'ip route change default via 172.20.0.10 dev eth0 && echo -e -n "\n\n[switch-0] " && ping -c 1 -t 1 172.20.0.10'
docker container exec switch-1 sh -c 'ip route change default via 172.20.0.18 dev eth0 && echo -e -n "\n\n[switch-1] " && ping -c 1 -t 1 172.20.0.18'
docker container exec workst-011 sh -c 'ip route change default via 172.20.1.2 dev eth0 && echo -e -n "\n\n[workst-011] " && ping -c 1 -t 1 172.20.1.2'
docker container exec workst-021 sh -c 'ip route change default via 172.20.2.2 dev eth0 && echo -e -n "\n\n[workst-021] " && ping -c 1 -t 1 172.20.2.2'
docker container exec workst-031 sh -c 'ip route change default via 172.20.3.2 dev eth0 && echo -e -n "\n\n[workst-031] " && ping -c 1 -t 1 172.20.3.2'
docker container exec workst-111 sh -c 'ip route change default via 172.20.11.2 dev eth0 && echo -e -n "\n\n[workst-111] " && ping -c 1 -t 1 172.20.11.2'
docker container exec workst-121 sh -c 'ip route change default via 172.20.12.2 dev eth0 && echo -e -n "\n\n[workst-121] " && ping -c 1 -t 1 172.20.12.2'
docker container exec workst-131 sh -c 'ip route change default via 172.20.13.2 dev eth0 && echo -e -n "\n\n[workst-131] " && ping -c 1 -t 1 172.20.13.2'
docker container exec firwll-0 sh -c 'ip route add 172.20.1.0/24 via 172.20.0.11 dev eth1'
docker container exec firwll-0 sh -c 'ip route add 172.20.2.0/24 via 172.20.0.11 dev eth1'
docker container exec firwll-0 sh -c 'ip route add 172.20.3.0/24 via 172.20.0.11 dev eth1'
docker container exec firwll-0 sh -c 'ip route add 172.20.11.0/24 via 172.20.0.19 dev eth2'
docker container exec firwll-0 sh -c 'ip route add 172.20.12.0/24 via 172.20.0.19 dev eth2'
docker container exec firwll-0 sh -c 'ip route add 172.20.13.0/24 via 172.20.0.19 dev eth2'
echo "-----------------------------------------------" && \
echo "--------------NETWORK SETUP DONE!--------------" && \
echo "-----------------------------------------------"
echo "-----------------------------------------------" && \
echo "----------------SWITCHES SETUP-----------------" && \
echo "-----------------------------------------------"
for idx in 0 1 ; do 
    docker container cp "./$( find . -name "scenario-4.switch-${idx}.sh" -printf '%P' )" switch-${idx}:/ && \
    docker container exec switch-${idx} sh -v /scenario-4.switch-${idx}.sh && \
    echo "[switch-${idx}] File '/scenario-4.switch-${idx}.sh' loaded successfully." 
done 
echo "-----------------------------------------------" && \
echo "-------------SWITCHES SETUP DONE!--------------" && \
echo "-----------------------------------------------"
echo "-----------------------------------------------" && \
echo "----------------FIREWALL SETUP-----------------" && \
echo "-----------------------------------------------"
docker container cp "./$( find . -name 'scenario-4.firwll-0.sh' -printf '%P' )" firwll-0:/ && \
docker container exec firwll-0 sh -v /scenario-4.firwll-0.sh ${enableFirewall} && \
echo "[firwll-0] File '/scenario-4.firwll-0.sh' loaded successfully."
echo "-----------------------------------------------" && \
echo "-------------FIREWALL SETUP DONE!--------------" && \
echo "-----------------------------------------------"
. "./$( find . -name "scenario-4.tests.sh" -printf '%P' )" ${enableFirewall}
