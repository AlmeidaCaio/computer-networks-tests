#!/bin/bash
#
# ref.: https://www.youtube.com/watch?v=0nkgC3F2VM0
#
# NOTES: 
#   1) File must be executable
#   2) Source it at a bash cli terminal
#   3) Validate changes with "iptables -nvL", and
#   4) with "iptables -t nat -nvL POSTROUTING"
#
lan="enp0s3"
wan="enp0s8"
lannet="192.168.10.0/24"
wannet="192.168.0.0/24"

#FLUSH NETFILTER CONFIGURATION ON BOOTUP
iptables -F
iptables -t nat -F
iptables -X

#DEFAULT POLICY
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT 

#FIREWALL DEST TRAFFIC POLICY
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT 
iptables -A INPUT -i $lan -p icmp -j ACCEPT 
iptables -A INPUT -i $lan -p udp --dport 67 -j ACCEPT 

#NETWORK lan->wan TRAFFIC POLICY
iptables -A FORWARD -i $lan -s $lannet -o $wan -j ACCEPT 
iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT

#NETWORK lan->wan NAT POLICY 
iptables -t nat -A POSTROUTING -s $lannet -o $wan -j MASQUERADE 
