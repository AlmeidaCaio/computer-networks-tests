#!/bin/sh
#
# Parameters
# -
echo "Cleaning by $0 started, wait for its completion."
docker network disconnect p2p-vlans-001-011 router-1
docker network disconnect p2p-vlans-001-011 switch-1
docker network disconnect p2p-vlans-001-021 router-1
docker network disconnect p2p-vlans-001-021 switch-2
docker container stop router-1 switch-1 switch-2 workst-1 workst-2
docker container rm router-1 switch-1 switch-2 workst-1 workst-2
docker network rm subnet-vlan-001 subnet-vlan-011 subnet-vlan-021 p2p-vlans-001-011 p2p-vlans-001-021
echo "Completed!"
