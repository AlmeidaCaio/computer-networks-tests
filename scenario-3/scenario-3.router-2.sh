#!/bin/sh
#
# Writes Zebra Configuration File and starts its Daemon
echo -e 'hostname router-2\npassword zebra\nenable password zebra\nlog file /var/log/quagga/zebra.log informational\nno log timestamp precision\n' > /etc/quagga/zebra.conf \
  && chown quagga\:quagga /etc/quagga/zebra.conf \
  && { zebra --config_file /etc/quagga/zebra.conf & }
#
# Writes OSPF V2 Configuration File and starts its Daemon
echo -n "log file /var/log/quagga/ospfd.log informational 
service advanced-vty
router ospf
 ospf router-id 172.22.0.2
 log-adjacency-changes
 redistribute kernel
 redistribute connected
 redistribute static
 neighbor 172.20.0.30
 neighbor 172.20.0.10
 network 172.22.0.0/22 area 0.0.0.2
 network 172.20.0.20/32 area 0.0.0.0
 area 0.0.0.0 range 172.20.0.0/24
 area 0.0.0.2 range 172.22.0.0/22

line vty
" > /etc/quagga/ospfd.conf \
  && chown quagga\:quagga /etc/quagga/ospfd.conf \
  && { ospfd --config_file /etc/quagga/ospfd.conf & }
