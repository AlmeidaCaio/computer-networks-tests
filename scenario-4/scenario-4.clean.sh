#!/bin/sh
#
# Parameters
# -
#
echo "Cleaning by $0 started, await its completion."
docker network disconnect subnet-vlan-131 switch-1
docker network disconnect subnet-vlan-121 switch-1
docker network disconnect subnet-vlan-111 switch-1
docker network disconnect subnet-vlan-031 switch-0
docker network disconnect subnet-vlan-021 switch-0
docker network disconnect subnet-vlan-011 switch-0
docker network disconnect p2p-svlans-001-1X1 firwll-0 
docker network disconnect p2p-svlans-001-0X1 firwll-0 
docker container stop workst-131 workst-121 workst-111 workst-031 workst-021 workst-011 switch-1 switch-0 firwll-0 
docker network rm subnet-vlan-131 subnet-vlan-121 subnet-vlan-111 subnet-vlan-031 subnet-vlan-021 subnet-vlan-011 p2p-svlans-001-1X1 p2p-svlans-001-0X1 subnet-vlan-001
echo "Completed!"
