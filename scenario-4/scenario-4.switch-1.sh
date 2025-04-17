#!/bin/sh
#
# Script analogous to the one in file "scenario-4.switch-0.sh"
#
#
# Bridge "br1" creation
ip link add name br1 type bridge vlan_filtering 1 vlan_default_pvid 0
ip route delete default via 172.20.0.18 dev eth0
ip address delete 172.20.0.19/29 dev eth0
ip link set dev eth0 down
ip link set dev eth0 master br1
bridge vlan add vid 11 dev eth0
bridge vlan add vid 21 dev eth0
bridge vlan add vid 31 dev eth0
#
# Setup network namespaces "ns1", "ns2" and "ns3"
for x in 1 2 3 ; do 
  ip address delete "172.20.1${x}.2/24" dev "eth$x"
  ip link set dev "eth$x" down
  ip link add name "vth${x}.${x}1" type veth peer "vth$x"
  ip netns add "ns$x"
  ip link set dev "eth$x" netns "ns$x"
  ip link set dev "vth$x" netns "ns$x"
  ip -netns "ns$x" address add "172.20.0.$(( ${x} * 2 + 17 ))/31" dev "vth$x"
  ip -netns "ns$x" link set dev "vth$x" up
  ip -netns "ns$x" route add default via "172.20.0.$(( ${x} * 2 + 16 ))" dev "vth$x"
  ip link set dev "vth${x}.${x}1" master br1
  bridge vlan add vid "${x}1" dev "vth${x}.${x}1" pvid untagged
  ip link set dev "vth${x}.${x}1" up
  ip -netns "ns$x" link set dev lo up
  ip -netns "ns$x" address add "172.20.1${x}.2/24" broadcast "172.20.1${x}.255" dev "eth$x"
  ip -netns "ns$x" link set dev "eth$x" up
done
# TODO:
# Must apply config to open ipvlans 172.20.12.0/24 (eth2) and 172.20.13.0/24 (eth3)
#
# Activation
ip link set dev eth0 up
ip link set dev br1 up
#
# Validate downlinks
ip netns exec ns1 ping -c 1 172.20.0.19
ip netns exec ns1 ping -c 1 172.20.11.2
ip netns exec ns1 ping -c 1 172.20.11.3
ip netns exec ns2 ping -c 1 172.20.0.21
ip netns exec ns2 ping -c 1 172.20.12.2
ip netns exec ns2 ping -c 1 172.20.12.3
ip netns exec ns3 ping -c 1 172.20.0.23
ip netns exec ns3 ping -c 1 172.20.13.2
ip netns exec ns3 ping -c 1 172.20.13.3
