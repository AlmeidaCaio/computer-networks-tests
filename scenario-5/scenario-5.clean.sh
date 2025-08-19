#!/bin/sh
#
# Parameters
# -
#
echo "Cleaning by $0 started, await its completion."
for x in 6 5 4 3 2 1 ; do 
  docker network disconnect loopback-$x router-$x 
done 
docker network disconnect subnet-vlan-12 router-1
docker network disconnect subnet-vlan-12 router-2
docker network disconnect subnet-vlan-35 router-3
docker network disconnect subnet-vlan-46 router-4
docker network disconnect subnet-vlan-35 router-5
docker network disconnect subnet-vlan-46 router-6
docker network disconnect subnet-vlan-56 router-5 
docker network disconnect subnet-vlan-56 router-6 
docker container stop router-6 router-5 router-4 router-3 router-2 router-1 
docker container rm router-6 router-5 router-4 router-3 router-2 router-1 
docker network rm loopback-6 loopback-5 loopback-4 loopback-3 loopback-2 loopback-1 subnet-vlan-56 subnet-vlan-46 subnet-vlan-35 subnet-vlan-12
echo "Completed!"
