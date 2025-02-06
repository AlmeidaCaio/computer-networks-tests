#!/bin/sh
#
# Writes Zebra Configuration File and starts its Daemon
echo -e 'hostname Router\npassword zebra\nenable password zebra\nlog file /var/log/quagga/zebra.log informational\nno log timestamp precision\n' > /etc/quagga/zebra.conf \
  && chown quagga\:quagga /etc/quagga/zebra.conf \
  && { zebra --config_file /etc/quagga/zebra.conf & }
#
# Writes OSPF V2 Configuration File and starts its Daemon
echo -e 'hostname Router\npassword ospfd\nlog file /var/log/quagga/ospfd.log\nservice advanced-vty\n\nrouter ospf\n ospf router-id 172.22.0.2\n neighbor 172.20.0.2\n \n network 172.22.0.0/24 area 0.0.0.1\n network 172.20.0.20/32 area 0.0.0.0\n ospf opaque-lsa\n\n' > /etc/quagga/ospfd.conf
  && chown quagga\:quagga /etc/quagga/ospfd.conf \
  && { ospfd --config_file /etc/quagga/ospfd.conf & }
