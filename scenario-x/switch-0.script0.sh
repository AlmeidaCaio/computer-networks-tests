#!/bin/sh
#
# Script adapted from: https://www.youtube.com/watch?v=a8ghZoBZcE0
#
# NOTES: 
#   1) File must be executable
#   2) Source it at a SH CLI terminal of an Alpine Linux
#   3) Capabilities "CAP_" which must be activated/added: NET_ADMIN, SYS_ADMIN:
#         e.g.: docker container run -itd --rm --name test --cap-add NET_ADMIN --cap-add SYS_ADMIN alpine:3.21.2
#   4) The bridge consists of 4 addresses within 2 distinct VLANs
#
#
if [ $( apk info | grep -E '^iproute2$' | wc -l ) == "0" ] ; then { apk add iproute2 ; } ; fi
ip link add name br0 type bridge vlan_filtering 1 vlan_default_pvid 0
for x in 1 2 3 4 ; do 
  ip link add name "vth$x" type veth peer "vth_$x"
  ip netns add "ns$x"
  ip link set dev "vth_$x" netns "ns$x"
  ip -netns "ns$x" link set dev "vth_$x" up
  ip -netns "ns$x" address add "192.168.10.$x/24" dev "vth_$x"
  ip link set dev "vth$x" master br0
  bridge vlan add vid "$(( $x % 2 + 1 ))" dev "vth$x" pvid untagged
  ip link set dev "vth$x" up
  if [ $x -le 2 ] ; then 
    ip -netns "ns$x" link set dev lo up
  fi
done
ip link set dev br0 up
# Validations below
bridge vlan show
for x in 1 2 3 4 ; do 
  echo "--------"
  for y in 1 2 3 4 ; do 
    echo -e -n "\n [ns$x to 192.168.10.$y] "
    if [ $x -eq $y ] ; then 
      echo -n "LOOPBACK "
    elif [ $(( $y % 2 )) -eq 1 ] ; then 
      echo -n "VLAN 2 "
    else 
      echo -n "VLAN 1 "
    fi
    aux="`ip netns exec "ns$x" ping -c 1 -t 1 "192.168.10.$y"`"
    if [ $(echo $aux | grep '100% packet loss' | wc -l) == "0" ] ; then 
      echo "SUCCESS"
    else 
      echo "FAIL"
    fi
  done
done
