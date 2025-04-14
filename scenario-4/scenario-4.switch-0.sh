#!/bin/sh
#
# Script made with the help of the following references:
#      0 - https://www.youtube.com/watch?v=a8ghZoBZcE0&t=848s
#      1 - https://www.youtube.com/watch?v=9-Uw2TexMuI
#      2 - https://docs.bisdn.de/network_configuration/vlan_bridging.html#systemd-networkd
#      3 - https://www.man7.org/linux/man-pages/man8/ip-link.8.html
#      4 - https://www.man7.org/linux/man-pages/man8/bridge.8.html
#      5 - https://developers.redhat.com/blog/2017/09/14/vlan-filter-support-on-bridge#with_vlan_filtering
#      6 - https://paulgorman.org/technical/linux-iproute2-cheatsheet.html#Add%20an%20interface%20to%20bridge
#      7 - https://networkengineering.stackexchange.com/questions/2035/when-is-31-recommended-over-30-in-p2p-links
#      8 - https://networkengineering.stackexchange.com/questions/24749/what-is-link-local-addressing
#
# NOTES: 
#   0) "Tap" interfaces were created to capture frame receival.
#   1) This switch is Layer 3; that is, bridges were created with assigned IP addresses
#   2) The bridge interfaces created are specific for each physical one
#   3) VLANs were used to isolate traffic between eth1, eth2 and eth3 interfaces
#
#
if [ $( apk info | grep -E '^ethtool$' | wc -l ) == "0" ] ; then { apk add ethtool ; } ; fi
if [ $( apk info | grep -E '^tcpdump$' | wc -l ) == "0" ] ; then { apk add tcpdump ; } ; fi
# Bridge "br0" creation
ip link add name br0 type bridge vlan_filtering 1 vlan_default_pvid 0
#
# Setup network namespaces "ns1", "ns2" and "ns3"
for x in 1 2 3 ; do 
  ip address delete "172.20.${x}.2/24" dev "eth$x"
  ip link set dev "eth$x" down
  ip link add name "vth${x}.${x}1" type veth peer "vth$x"
  ip netns add "ns$x"
  ip link set dev "eth$x" netns "ns$x"
  ip link set dev "vth$x" netns "ns$x"
  ip -netns "ns$x" link set dev "vth$x" up
  ip -netns "ns$x" address add "169.254.255.${x}/29" broadcast 169.254.255.7 dev "vth$x"
  ip -netns "ns$x" route add default via 169.254.255.6 dev "vth$x"
  ip link set dev "vth${x}.${x}1" master br0
  bridge vlan add vid "${x}1" dev "vth${x}.${x}1" pvid untagged
  ip link set dev "vth${x}.${x}1" up
  ip -netns "ns$x" link set dev lo up
  ip -netns "ns$x" link set dev "eth$x" up
  ip -netns "ns$x" address add "172.20.${x}.2/24" broadcast "172.20.${x}.255" dev "eth$x"
done
# TODO:
# Must apply config to open ipvlan 172.20.3.0/24 (eth3)
#
# Setup network namespace "ns0"
#ip route delete default via 172.20.0.10 dev eth0
#ip address delete 172.20.0.14/29 dev eth0
#ip link set dev eth0 down
ip link add name vth0.x type veth peer vth0
#ip -netns ns0 link add link vth0.x name vth0.11 type vlan id 11 reorder_hdr off
#ip -netns ns0 link add link vth0.x name vth0.21 type vlan id 21 reorder_hdr off
#ip -netns ns0 link add link vth0.x name vth0.31 type vlan id 31 reorder_hdr off
ip link set dev vth0 up
ip address add 169.254.255.6/29 broadcast 169.254.255.7 dev vth0
ip route add 172.20.1.0/24 via 169.254.255.1 dev vth0
ip route add 172.20.2.0/24 via 169.254.255.2 dev vth0
ip route add 172.20.3.0/24 via 169.254.255.3 dev vth0
ip link set dev vth0.x master br0
bridge vlan add vid 11 dev vth0.x 
bridge vlan add vid 21 dev vth0.x 
bridge vlan add vid 31 dev vth0.x 
ip link set dev vth0.x up
#ip -netns ns0 link set dev lo up
#ip -netns ns0 link set dev eth0 up
#ip -netns ns0 address add 172.20.0.14/29 broadcast 172.20.0.15 dev eth0
#ip -netns ns0 route add default via 172.20.0.10 dev eth0
#
# Bridge "br0" activation
ip link set dev br0 up
