#!/bin/sh
#
# About it:
# * XXXX set of tests to validate switch traffics:
#    1. Test to validate flow packets among devices inside same VLAN
#    2. Test to validate blockage of packets from VLAN X1 devices to exterior
#    3. Test to validate blockage of packets from any VLAN X1 devices to another different internal VLAN
#
# Parameters:
# -
#
# TODO Validations:
echo "------------------------------------------------" && \
echo "-----------------BRIDGES VLANS------------------" && \
echo "------------------------------------------------"
docker container exec switch-0 sh -c 'echo -e -n "\n\n[switch-0] " && bridge vlan show'
docker container exec switch-1 sh -c 'echo -e -n "\n\n[switch-1] " && bridge vlan show'
echo "------------------------------------------------" && \
echo "-----------TESTS FOR INTERNAL ROUTING-----------" && \
echo "------------------------------------------------"
docker container exec workst-011 sh -c 'echo -e -n "\n\n[workst-011] " && ping -c 1 -t 5 172.20.0.2'
docker container exec workst-021 sh -c 'echo -e -n "\n\n[workst-021] " && ping -c 1 -t 5 172.20.0.2'
docker container exec workst-031 sh -c 'echo -e -n "\n\n[workst-031] " && ping -c 1 -t 5 172.20.0.2'
docker container exec workst-111 sh -c 'echo -e -n "\n\n[workst-111] " && ping -c 1 -t 5 172.20.0.2'
docker container exec workst-121 sh -c 'echo -e -n "\n\n[workst-121] " && ping -c 1 -t 5 172.20.0.2'
docker container exec workst-131 sh -c 'echo -e -n "\n\n[workst-131] " && ping -c 1 -t 5 172.20.0.2'
echo -e '\n---[VLAN 11] checking route between 011 and 111---'
docker container exec workst-011 sh -c 'echo -e -n "\n\n[workst-011] " && traceroute -I -m 7 172.20.11.3'
docker container exec workst-111 sh -c 'echo -e -n "\n\n[workst-111] " && traceroute -I -m 7 172.20.1.3'
echo -e '\n---[VLAN 21] checking route between 021 and 121---'
docker container exec workst-021 sh -c 'echo -e -n "\n\n[workst-021] " && traceroute -I -m 7 172.20.12.3'
docker container exec workst-121 sh -c 'echo -e -n "\n\n[workst-121] " && traceroute -I -m 7 172.20.2.3'
echo -e '\n---[VLAN 31] checking route between 031 and 131---'
docker container exec workst-031 sh -c 'echo -e -n "\n\n[workst-031] " && traceroute -I -m 7 172.20.13.3'
docker container exec workst-131 sh -c 'echo -e -n "\n\n[workst-131] " && traceroute -I -m 7 172.20.3.3'
echo -e '\n---[VLAN 11 <--x--> VLAN 21] checking blockage between 011 and 021---'
docker container exec workst-011 sh -c 'echo -e -n "\n\n[workst-011] " && traceroute -I -m 7 172.20.2.3'
docker container exec workst-011 sh -c 'echo -e -n "\n\n[workst-011] " && traceroute -I -m 7 172.20.12.3'
docker container exec workst-111 sh -c 'echo -e -n "\n\n[workst-111] " && traceroute -I -m 7 172.20.12.3'
docker container exec workst-111 sh -c 'echo -e -n "\n\n[workst-111] " && traceroute -I -m 7 172.20.2.3'
docker container exec workst-021 sh -c 'echo -e -n "\n\n[workst-021] " && traceroute -I -m 7 172.20.1.3'
docker container exec workst-021 sh -c 'echo -e -n "\n\n[workst-021] " && traceroute -I -m 7 172.20.11.3'
docker container exec workst-121 sh -c 'echo -e -n "\n\n[workst-121] " && traceroute -I -m 7 172.20.11.3'
docker container exec workst-121 sh -c 'echo -e -n "\n\n[workst-121] " && traceroute -I -m 7 172.20.1.3'
echo -e '\n---[VLAN 21 <--x--> VLAN 31] checking blockage between 021 and 031---'
docker container exec workst-021 sh -c 'echo -e -n "\n\n[workst-021] " && traceroute -I -m 7 172.20.3.3'
docker container exec workst-021 sh -c 'echo -e -n "\n\n[workst-021] " && traceroute -I -m 7 172.20.13.3'
docker container exec workst-121 sh -c 'echo -e -n "\n\n[workst-121] " && traceroute -I -m 7 172.20.13.3'
docker container exec workst-121 sh -c 'echo -e -n "\n\n[workst-121] " && traceroute -I -m 7 172.20.3.3'
docker container exec workst-031 sh -c 'echo -e -n "\n\n[workst-031] " && traceroute -I -m 7 172.20.2.3'
docker container exec workst-031 sh -c 'echo -e -n "\n\n[workst-031] " && traceroute -I -m 7 172.20.12.3'
docker container exec workst-131 sh -c 'echo -e -n "\n\n[workst-131] " && traceroute -I -m 7 172.20.12.3'
docker container exec workst-131 sh -c 'echo -e -n "\n\n[workst-131] " && traceroute -I -m 7 172.20.2.3'
echo -e '\n---[VLAN 31 <--x--> VLAN 11] checking blockage between 031 and 011---'
docker container exec workst-031 sh -c 'echo -e -n "\n\n[workst-031] " && traceroute -I -m 7 172.20.1.3'
docker container exec workst-031 sh -c 'echo -e -n "\n\n[workst-031] " && traceroute -I -m 7 172.20.11.3'
docker container exec workst-131 sh -c 'echo -e -n "\n\n[workst-131] " && traceroute -I -m 7 172.20.11.3'
docker container exec workst-131 sh -c 'echo -e -n "\n\n[workst-131] " && traceroute -I -m 7 172.20.1.3'
docker container exec workst-011 sh -c 'echo -e -n "\n\n[workst-011] " && traceroute -I -m 7 172.20.3.3'
docker container exec workst-011 sh -c 'echo -e -n "\n\n[workst-011] " && traceroute -I -m 7 172.20.13.3'
docker container exec workst-111 sh -c 'echo -e -n "\n\n[workst-111] " && traceroute -I -m 7 172.20.13.3'
docker container exec workst-111 sh -c 'echo -e -n "\n\n[workst-111] " && traceroute -I -m 7 172.20.3.3'
