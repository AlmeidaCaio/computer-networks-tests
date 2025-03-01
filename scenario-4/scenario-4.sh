#!/bin/bash
#
# About it:
# * TODO
#
# References:
#    - https://ipwithease.com/how-to-set-up-and-use-macvlan-network/
#    - https://community.synology.com/enu/forum/11/post/191645
#    - https://wiki.alpinelinux.org/wiki/VLAN
#
# Parameters:
# $1 = Alpine Version (e.g. "1.1.1")
# $2 = Load firewall configuration into firwll-0 (e.g. "1" or "0")
#
baseImageVersion=$1
enableFirewall=$2
if ! [[ ${enableFirewall} =~ ^[01]$ ]] ; then
    echo "ERROR 6: Parameter \$2 = '$2'; needs to be '0' or '1', since it's a boolean flag."
    exit 6
fi
imageNameFirewall=cnt-firewall\:1.00
if [[ $( docker image ls --filter "reference=${imageNameFirewall}" | wc -l ) -lt 2 ]] ; then
    docker image build -f ./cimages/firewall.containerfile --build-arg ALPINE_VERSION=${baseImageVersion} -t ${imageNameFirewall} ./ 
fi
imageNameSwitch=cnt-switch\:1.00
if [[ $( docker image ls --filter "reference=${imageNameSwitch}" | wc -l ) -lt 2 ]] ; then
    docker image build -f ./cimages/switch-l3.containerfile --build-arg ALPINE_VERSION=${baseImageVersion} -t ${imageNameSwitch} ./ 
fi
imageNameWorkStation=cnt-simple\:1.00
if [[ $( docker image ls --filter "reference=${imageNameWorkStation}" | wc -l ) -lt 2 ]] ; then
    docker image build -f ./cimages/.containerfile --build-arg ALPINE_VERSION=${baseImageVersion} -t ${imageNameWorkStation} ./ 
fi
echo "-----------------------------------------------" && \
echo "-----------------NETWORK SETUP-----------------" && \
echo "-----------------------------------------------"
## TODO
echo "-----------------------------------------------" && \
echo "--------------NETWORK SETUP DONE!--------------" && \
echo "-----------------------------------------------"
# Firewall setup
if [[ ${enableFirewall} == "1" ]] ; then
    echo "-----------------------------------------------" && \
    echo "----------------FIREWALL SETUP-----------------" && \
    echo "-----------------------------------------------"
    docker container cp "./$( find . -name 'scenario-4.firwll-0.sh' -printf '%P' )" firwll-0:/ && \
    docker container exec firwll-0 sh -v /scenario-4.firwll-0.sh && \
    echo "[firwll-0] File '/scenario-4.firwll-0.sh' loaded successfully." && \
    echo "-----------------------------------------------" && \
    echo "-------------FIREWALL SETUP DONE!--------------" && \
    echo "-----------------------------------------------"
fi
echo "-----------------------------------------------" && \
echo "----------------SWITCHES SETUP-----------------" && \
echo "-----------------------------------------------"
## TODO
echo "-----------------------------------------------" && \
echo "-------------SWITCHES SETUP DONE!--------------" && \
echo "-----------------------------------------------"
