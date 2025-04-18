#!/bin/sh
#
# References:
#    - https://github.com/moby/moby/pull/42626
#    - https://www.rfc-editor.org/rfc/rfc3021
#    - https://www.man7.org/linux/man-pages/man8/ip-link.8.html
#
# Parameters:
# $1 = Load iptables configurations into firwll-0 (e.g. "1" or "0")
#
firewallFlag=$1
# Setup network interfaces - VLANs 11, 21 and 31 on switch-0
ip route delete 172.20.1.0/24 dev eth1
ip route delete 172.20.2.0/24 dev eth1
ip route delete 172.20.3.0/24 dev eth1
ip address delete 172.20.0.10/29 dev eth1
ip link set dev eth1 down
ip link add link eth1 name eth1.11 type vlan id 11 reorder_hdr off
ip link add link eth1 name eth1.21 type vlan id 21 reorder_hdr off
ip link add link eth1 name eth1.31 type vlan id 31 reorder_hdr off
ip address add 172.20.0.10/31 dev eth1.11
ip address add 172.20.0.12/31 dev eth1.21
ip address add 172.20.0.14/31 dev eth1.31
ip link set dev eth1 up
ip link set dev eth1.11 up
ip link set dev eth1.21 up
ip link set dev eth1.31 up
#
# Setup network interfaces - VLANs 11, 21 and 31 on switch-1
ip route delete 172.20.11.0/24 dev eth2
ip route delete 172.20.12.0/24 dev eth2
ip route delete 172.20.13.0/24 dev eth2
ip address delete 172.20.0.18/29 dev eth2
ip link set dev eth2 down
ip link add link eth2 name eth2.11 type vlan id 11 reorder_hdr off
ip link add link eth2 name eth2.21 type vlan id 21 reorder_hdr off
ip link add link eth2 name eth2.31 type vlan id 31 reorder_hdr off
ip address add 172.20.0.18/31 dev eth2.11
ip address add 172.20.0.20/31 dev eth2.21
ip address add 172.20.0.22/31 dev eth2.31
ip link set dev eth2 up
ip link set dev eth2.11 up
ip link set dev eth2.21 up
ip link set dev eth2.31 up
#
# Setup routes
ip route add 172.20.1.0/24 via 172.20.0.11 dev eth1.11
ip route add 172.20.2.0/24 via 172.20.0.13 dev eth1.21
ip route add 172.20.3.0/24 via 172.20.0.15 dev eth1.31
ip route add 172.20.11.0/24 via 172.20.0.19 dev eth2.11
ip route add 172.20.12.0/24 via 172.20.0.21 dev eth2.21
ip route add 172.20.13.0/24 via 172.20.0.23 dev eth2.31
#
# Validate downlinks
for destis in 172.20.0.10 172.20.0.11 172.20.0.12 172.20.0.13 172.20.0.14 172.20.0.15 \
  172.20.0.18 172.20.0.19 172.20.0.20 172.20.0.21 172.20.0.22 172.20.0.23 \
  172.20.1.2 172.20.2.2 172.20.3.2 172.20.11.2 172.20.12.2 172.20.13.2 ; do 
    sleep 1
    ping -c 1 ${destis}
done 
for destis in 172.20.1.3 172.20.2.3 172.20.3.3 172.20.11.3 172.20.12.3 172.20.13.3 ; do
    sleep 2
    traceroute -I -m 3 -n ${destis}
done
#
#
if [ ${firewallFlag} == "1" ] ; then
    #
    # Flush netfilter configuration on bootup
    iptables -F
    iptables -t nat -F
    iptables -X
    #
    # Setup firewall as a whitelist for incoming traffic (to firewall and its forwarding)
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT 
    #
    # Allowing loopback connections from the firewall
    iptables -I INPUT -i lo -j ACCEPT
    #
    # Allowing pings and traceroutes from the firewall
    for interface in eth1 eth2 ; do 
      for icmpType in 0 3 8 11 ; do 
        iptables -A INPUT -i $interface -p icmp --icmp-type $icmpType -j ACCEPT 
      done
    done
    # Rejects tracepaths to the outside 
    for chainType in FORWARD INPUT ; do 
      iptables -A $chainType -i eth0 -p udp --dport 33434\:33474 -j REJECT
    done
    #
    # Allowing DNS from the firewall and anywhere inside 
    for chainType in FORWARD INPUT ; do 
      for protocol in tcp udp ; do 
        for portType in --dport --sport ; do 
          iptables -A $chainType -p $protocol $portType 53 -j ACCEPT
        done
      done
    done
    #
    # Rules to allow any packets between subnets with same VLANs
    for item in 172.20.1.0/24-172.20.11.0/24-ACCEPT 172.20.1.0/24-172.20.12.0/24-REJECT 172.20.1.0/24-172.20.13.0/24-REJECT \
      172.20.2.0/24-172.20.11.0/24-REJECT 172.20.2.0/24-172.20.12.0/24-ACCEPT 172.20.2.0/24-172.20.13.0/24-REJECT \
        172.20.3.0/24-172.20.11.0/24-REJECT 172.20.3.0/24-172.20.12.0/24-REJECT 172.20.3.0/24-172.20.13.0/24-ACCEPT
    do 
      vlanId1stDigit="` echo -n ${item} | sed -E 's/^.*\.1?([1-3])\.0\/.*$/\1/g' `"
      srcSubnet="` echo -n ${item} | sed -E 's/^([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2})-.*$/\1/g' `"
      dstSubnet="` echo -n ${item} | sed -E 's/^.*-([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2})-.*$/\1/g' `"
      fwActionTarget="` echo -n ${item} | sed -E 's/^.*-([A-Z]+)$/\1/g' `"
      for protocol in "icmp --icmp-type 8" "sctp" "tcp" "udp" ; do 
        iptables -A FORWARD -i "eth1.${vlanId1stDigit}1" -o "eth2.${vlanId1stDigit}1" -p ${protocol} -s ${srcSubnet} -d ${dstSubnet} -j ${fwActionTarget}
        iptables -A FORWARD -i "eth2.${vlanId1stDigit}1" -o "eth1.${vlanId1stDigit}1" -p ${protocol} -s ${dstSubnet} -d ${srcSubnet} -j ${fwActionTarget}
      done
    done
fi 
