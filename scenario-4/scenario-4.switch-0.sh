#!/bin/sh
#
# TODO: Re do everything!
#
# Below is an example of VLAN Interfaces implementation (aka "VlanIf implementation")
docker container exec switch-0 sh -c 'ip address delete 172.20.1.2/24 dev eth1'
docker container exec switch-0 sh -c 'ip link set dev eth1 down'
docker container exec switch-0 sh -c 'ip link add link eth1 name eth1.31 type vlan id 31 protocol 802.1Q'
docker container exec switch-0 sh -c 'ip address add 172.20.1.2/24 broadcast 172.20.1.255 dev eth1.31'
docker container exec switch-0 sh -c 'ip link set dev eth1 up'
docker container exec switch-0 sh -c 'ip link set dev eth1.31 up'

docker container exec workst-011 sh -c 'ip address delete 172.20.1.3/24 dev eth0'
docker container exec workst-011 sh -c 'ip link set dev eth0 down'
docker container exec workst-011 sh -c 'ip link add link eth0 name eth0.31 type vlan id 31 protocol 802.1Q'
docker container exec workst-011 sh -c 'ip address add 172.20.1.3/24 broadcast 172.20.1.255 dev eth0.31'
docker container exec workst-011 sh -c 'ip link set dev eth0 up'
docker container exec workst-011 sh -c 'ip link set dev eth0.31 up'
docker container exec workst-011 sh -c 'ip route add default via 172.20.1.2 dev eth0.31'


docker container exec switch-0 sh -c 'ip address delete 172.20.2.2/24 dev eth2'
docker container exec switch-0 sh -c 'ip link set dev eth2 down'
docker container exec switch-0 sh -c 'ip link add link eth2 name eth2.31 type vlan id 31 protocol 802.1Q'
docker container exec switch-0 sh -c 'ip address add 172.20.2.2/24 broadcast 172.20.2.255 dev eth2.31'
docker container exec switch-0 sh -c 'ip link set dev eth2 up'
docker container exec switch-0 sh -c 'ip link set dev eth2.31 up'

docker container exec workst-021 sh -c 'ip address delete 172.20.2.3/24 dev eth0'
docker container exec workst-021 sh -c 'ip link set dev eth0 down'
docker container exec workst-021 sh -c 'ip link add link eth0 name eth0.31 type vlan id 31 protocol 802.1Q'
docker container exec workst-021 sh -c 'ip address add 172.20.2.3/24 broadcast 172.20.2.255 dev eth0.31'
docker container exec workst-021 sh -c 'ip link set dev eth0 up'
docker container exec workst-021 sh -c 'ip link set dev eth0.31 up'
docker container exec workst-021 sh -c 'ip route add default via 172.20.2.2 dev eth0.31'


docker container exec workst-011 sh -c 'echo -e -n "\n\n[workst-011] " && ping -c 1 -t 3 172.20.2.3'
docker container exec workst-021 sh -c 'echo -e -n "\n\n[workst-021] " && ping -c 1 -t 3 172.20.1.3'

docker container exec workst-011 sh -c 'echo -e -n "\n\n[workst-011] " && traceroute -I -m 4 172.20.2.3'
docker container exec workst-021 sh -c 'echo -e -n "\n\n[workst-021] " && traceroute -I -m 4 172.20.1.3'
