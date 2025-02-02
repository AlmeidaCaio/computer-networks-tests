#!/bin/sh
#
# Parameters
# -
#
echo "Cleaning by $0 started, wait for its completion."
docker network disconnect p2p-vlans-001-1X1 router-1 
docker network disconnect p2p-vlans-001-2X1 router-2 
docker network disconnect p2p-vlans-001-3X1 router-3 
docker network disconnect subnet-vlan-111 switch-11 
docker network disconnect subnet-vlan-121 switch-12 
docker network disconnect subnet-vlan-211 switch-21 
docker network disconnect subnet-vlan-221 switch-22 
docker network disconnect subnet-vlan-311 switch-31 
docker network disconnect subnet-vlan-321 switch-32  
docker container stop firwll-0 router-1 router-2 router-3 switch-11 switch-12 switch-21 switch-22 switch-31 switch-32 workst-a workst-b workst-c workst-d workst-e workst-f workst-g workst-h workst-i workst-j workst-k workst-l
docker container rm firwll-0 router-1 router-2 router-3 switch-11 switch-12 switch-21 switch-22 switch-31 switch-32 workst-a workst-b workst-c workst-d workst-e workst-f workst-g workst-h workst-i workst-j workst-k workst-l
docker network rm subnet-vlan-001 p2p-vlans-001-1X1 p2p-vlans-001-2X1 p2p-vlans-001-3X1 subnet-vlan-111 subnet-vlan-211 subnet-vlan-311 subnet-vlan-121 subnet-vlan-221 subnet-vlan-321
echo "Completed!"
