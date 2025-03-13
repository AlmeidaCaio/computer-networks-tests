#!/bin/sh
#
# TODO: 
#   1) FIX RULES DUE TO DIFFERENT INTERFACE ETH0
#   2) Must add rules for SMTP, SSH and HTTPS!! 
#
# Flush netfilter configuration on bootup
iptables -F
iptables -t nat -F
iptables -X

# Setup firewall as a whitelist for incoming traffic (to firewall and its forwarding)
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT 

# Allowing loopback connections from the firewall
iptables -I INPUT -i lo -j ACCEPT

# Allowing pings and traceroutes from the firewall
for icmpType in 0 3 8 11 ; do 
  iptables -A INPUT -i eth0 -p icmp --icmp-type $icmpType -j ACCEPT 
done
# Allowing pings from subnetworks
for icmpType in 8 ; do 
  iptables -A FORWARD -i eth0 -p icmp --icmp-type $icmpType -j ACCEPT 
done
# Rejects tracepaths to the outside 
for chainType in FORWARD INPUT ; do 
  iptables -A $chainType -i eth0 -p udp --dport 33434:33474 -j REJECT
done

# Allowing DNS from the firewall and anywhere inside 
for chainType in FORWARD INPUT ; do 
  for protocol in tcp udp ; do 
    for portType in --dport --sport ; do 
      iptables -A $chainType -i eth0 -p $protocol $portType 53 -j ACCEPT
    done
  done
done
