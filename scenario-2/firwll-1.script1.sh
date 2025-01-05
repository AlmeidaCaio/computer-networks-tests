#!/bin/bash
#
# Script made with the help of the following  references:
#      1 - https://www.youtube.com/watch?v=0nkgC3F2VM0
#      2 - https://serverfault.com/questions/30026/whitelist-allowed-ips-in-out-using-iptables
#
# NOTES: 
#   1) File must be executable
#   2) Source it at a bash cli terminal
#   3) Validate changes with "iptables -nvL", and
#   4) with "iptables -t nat -nvL POSTROUTING"
#
# About "Targets" in iptables:
# * ACCEPT means to let the packet through.
# * DROP means to drop the packet on the floor.
# * QUEUE means to pass the packet to userspace.
# * RETURN means stop traversing this chain and resume at the next rule in the previous (calling) chain.
#
#
# Flush netfilter configuration on bootup
iptables -F
iptables -t nat -F
iptables -X

## Check default policies
#oldPolicies="`iptables -S | sed -E 's/^-P/§-P/g'`"
#echo ${oldPolicies} | sed -E 's/§/\n/g' | tail -n 3

# Setup firewall as a whitelist for incoming traffic (to firewall and its forwarding)
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT 

# Allowing loopback connections from the firewall
iptables -A INPUT -i lo -j ACCEPT

# Allowing pings to the firewall
iptables -A INPUT -i eth0 -p icmp -j ACCEPT 

## TODO: iptstate 
