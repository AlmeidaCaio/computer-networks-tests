#!/bin/bash
#
# Parameters
# $1 = Scenario Number
scenarioNumber=$1
if [[ -z ${scenarioNumber} ]] ; then 
    echo "ERROR 1\ Missing parameter \$1." 
    exit 1
fi
if ! [[ ${scenarioNumber} =~ ^[12]$ ]] ; then
    echo "ERROR 2\ Parameter \$1 = '$1'; needs to be '1' or '2'." 
    exit 2
fi
docker image build -f ./Containerfile -t rede-testes\:1.00 ./ 
source ./scenario-${scenarioNumber}/scenario-${scenarioNumber}.sh 
exit 0
