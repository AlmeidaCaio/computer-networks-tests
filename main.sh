#!/bin/bash
#
# Parameters
# $1 = Scenario Number
# $2 = Suplementary option
scenarioNumber=$1
suplementaryOption=$2

imageName=rede-testes\:1.02
fwFlag=1
if [[ -z ${scenarioNumber} ]] ; then 
    echo "ERROR 1: Missing parameter \$1." 
    exit 1
fi
if ! [[ ${scenarioNumber} =~ ^[12]$ ]] ; then
    echo "ERROR 2: Parameter \$1 = '$1'; needs to be '1' or '2', and optionally followed by '--clean' or '--fw-off'."
    exit 2
fi
if [[ ${suplementaryOption} == "--clean" ]] ; then
    source ./scenario-${scenarioNumber}/scenario-${scenarioNumber}.clean.sh
    exit 0
fi
if [[ ${suplementaryOption} == "--fw-off" ]] ; then
    echo "WARN 1: Scenario-${scenarioNumber} will have disabled firewall rules."
    fwFlag=0
fi
if [[ $( docker image ls --filter "reference=${imageName}" | wc -l ) -lt 2 ]] ; then
    docker image build -f ./containerfile -t ${imageName} ./ 
fi
source ./scenario-${scenarioNumber}/scenario-${scenarioNumber}.sh ${imageName} ${fwFlag}
exit 0
