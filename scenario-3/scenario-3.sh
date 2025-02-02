#!/bin/bash
#
# About it:
# * This is TODO; however, dynamic routes are loaded with OSPF.
#
# References:
#    - https://docs.frrouting.org/en/stable-10.2/ospfd.html
#    - https://www.networkacademy.io/ccna/ospf/ospf-best-path-selection
#
# Parameters:
# $1 = Alpine Version (e.g. "1.1.1")
#
baseImageVersion=$1
imageNameRouter=cnt-router\:1.00
if [[ $( docker image ls --filter "reference=${imageNameRouter}" | wc -l ) -lt 2 ]] ; then
    docker image build -f ./cimages/router.containerfile --build-arg ALPINE_VERSION=${baseImageVersion} -t ${imageNameRouter} ./ 
fi
imageNameSwitch=cnt-switch-l3\:1.00
if [[ $( docker image ls --filter "reference=${imageNameSwitch}" | wc -l ) -lt 2 ]] ; then
    docker image build -f ./cimages/switch-l3.containerfile --build-arg ALPINE_VERSION=${baseImageVersion} -t ${imageNameSwitch} ./ 
fi
# TODO: Networks' configurations
