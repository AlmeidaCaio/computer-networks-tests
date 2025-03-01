#!/bin/sh
#
# Parameters
# -
#
echo "Cleaning by $0 started, wait for its completion."
docker network disconnect vlan-131 switch-1
docker network disconnect vlan-121 switch-1
docker network disconnect vlan-111 switch-1
docker network disconnect vlan-031 switch-0
docker network disconnect vlan-021 switch-0
docker network disconnect vlan-011 switch-0
docker network disconnect p2p-vlans-001-1X1 firwll-0 
docker network disconnect p2p-vlans-001-0X1 firwll-0 
docker container stop switch-1 switch-0 firwll-0
docker network rm vlan-131 vlan-121 vlan-111 vlan-031 vlan-021 vlan-011 p2p-vlans-001-1X1 p2p-vlans-001-0X1 subnet-vlan-001
echo "Completed!"
