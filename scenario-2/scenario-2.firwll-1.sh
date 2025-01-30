#!/bin/bash
#
# Script made with the help of the following  references:
#      1 - https://www.youtube.com/watch?v=0nkgC3F2VM0
#      2 - https://serverfault.com/questions/30026/whitelist-allowed-ips-in-out-using-iptables
#      3 - https://serverfault.com/questions/623996/how-to-enable-traceroute-in-linux-machine
#      4 - https://www.digitalocean.com/community/tutorials/iptables-essentials-common-firewall-rules-and-commands
#      5 - https://serverfault.com/questions/1119981/iptables-allow-dns-resolution
#      6 - https://tecadmin.net/configuring-nat-masquerading-with-iptables/#:~:text=Steps%20by%20Step%20Guide%201%20Step%201%3A%20Enable,4%20Step%204%3A%20Save%20the%20iptables%20Rules%20
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
# * REJECT means to drop the packet and inform about it.
# * QUEUE means to pass the packet to userspace.
# * RETURN means stop traversing this chain and resume at the next rule in the previous (calling) chain.
#
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
## Rejects tracepaths from the firewall
#iptables -I INPUT -i eth0 -p udp --dport 33434:33474 -j REJECT

# Allowing DNS from the firewall and anywhere inside 
for chainType in FORWARD INPUT ; do 
  for protocol in tcp udp ; do 
    for portType in --dport --sport ; do 
      iptables -A $chainType -i eth0 -p $protocol $portType 53 -j ACCEPT
    done
  done
done

# Applying rules for ports SMTPS and HTTPS to VLANs 10 and 20
for sourceIp in 172.16.1.0/24-587-REJECT 172.16.2.0/24-587-ACCEPT 172.16.1.0/24-443-ACCEPT 172.16.2.0/24-443-REJECT ; do 
  triad=(${sourceIp//-/\ })
  for portType in --dport --sport ; do 
    iptables -A FORWARD -i eth0 -p tcp -s ${triad[0]} $portType ${triad[1]} -j ${triad[2]}
  done
done
