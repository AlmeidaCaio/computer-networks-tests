#!/bin/sh
#
# Script analogous to the one in file "scenario-4.switch-1.sh"
#
#
# Bridge "br1" creation
ip link add name br1 type bridge vlan_filtering 1 vlan_default_pvid 0
#
# Setup network namespaces "ns1", "ns2" and "ns3"
for x in 1 2 3 ; do 
  ip address delete "172.20.1${x}.2/24" dev "eth$x"
  ip link set dev "eth$x" down
  ip link add name "vth$x" type veth peer "vth${x}.${x}1"
  ip netns add "ns$x"
  ip link set dev "eth$x" netns "ns$x"
  ip link set dev "vth${x}.${x}1" netns "ns$x"
  ip -netns "ns$x" link set dev "vth${x}.${x}1" up
  ip -netns "ns$x" address add "169.254.255.1${x}1/31" dev "vth${x}.${x}1"
  ip -netns "ns$x" route add default via "169.254.255.1${x}0" dev "vth${x}.${x}1"
  ip link set dev "vth$x" master br1
  bridge vlan add vid "${x}1" dev "vth$x" pvid untagged
  ip link set dev "vth$x" up
  ip -netns "ns$x" link set dev lo up
  ip -netns "ns$x" link set dev "eth$x" up
  ip -netns "ns$x" address add "172.20.1${x}.2/24" broadcast "172.20.1${x}.255" dev "eth$x"
done
# TODO:
# Must apply config to open ipvlans 172.20.12.0/24 (eth2) and 172.20.13.0/24 (eth3)
#
# Setup network namespace "ns0"
ip route delete default via 172.20.0.18 dev eth0
ip address delete 172.20.0.22/29 dev eth0
ip link set dev eth0 down
ip link add name vth0 type veth peer vth0.x
ip netns add ns0
ip link set dev eth0 netns ns0
ip link set dev vth0.x netns ns0
ip -netns ns0 link add link vth0.x name vth0.11 type vlan id 11 
ip -netns ns0 link add link vth0.x name vth0.21 type vlan id 21 
ip -netns ns0 link add link vth0.x name vth0.31 type vlan id 31 
ip -netns ns0 link set dev vth0.x up
ip -netns ns0 address add 169.254.255.110/31 dev vth0.11
ip -netns ns0 address add 169.254.255.120/31 dev vth0.21
ip -netns ns0 address add 169.254.255.130/31 dev vth0.31
ip -netns ns0 route add 172.20.11.0/24 via 169.254.255.111 dev vth0.11
ip -netns ns0 route add 172.20.12.0/24 via 169.254.255.121 dev vth0.21
ip -netns ns0 route add 172.20.13.0/24 via 169.254.255.131 dev vth0.31
ip link set dev vth0 master br1
bridge vlan add vid 11 dev vth0 
bridge vlan add vid 21 dev vth0 
bridge vlan add vid 31 dev vth0 
ip link set dev vth0 up
ip -netns ns0 link set dev lo up
ip -netns ns0 link set dev eth0 up
ip -netns ns0 address add 172.20.0.22/29 broadcast 172.20.0.23 dev eth0
ip -netns ns0 route add default via 172.20.0.18 dev eth0
#
# Bridge "br1" activation
ip link set dev br1 up
