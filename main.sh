#!/bin/bash
#
# Parameters
# $1 = Scenario Number
# $@ without $1 = Suplementary options
scenarioNumber=$1
suplementaryOptions=$( echo -n $@ | sed -E "s/$1\s*\b//g" )

# Load .env parameters
alpineVersion="3.21.2"
fwFlag=1
optionsAvailable="'--clear' or '--fw-off'"
if [[ -f "./.env" ]] ; then
    source "./.env"
else
    echo "ERROR 1: File '.env' doesn't exist in current directory. Please, create one based on 'template.env'." 1>&2
    exit 1 
fi

# Parse scenario number
if [[ -z ${scenarioNumber} ]] ; then 
    echo "ERROR 2: Missing parameter \$1." 
    exit 2
fi
if ! [[ ${scenarioNumber} =~ ^[1-4]$ ]] ; then
    echo "ERROR 3: Parameter \$1 = '$1'; needs to be '1', '2', '3' or '4', and optionally followed by ${optionsAvailable}."
    exit 3
fi

# Assure WSL2 is enabled for network promiscuity whenever needed
if [[ -d "/mnt/c/Users" ]] && [[ $( find /mnt/c/Users -maxdepth 2 -name '.wslconfig' | wc -l ) -lt 1 ]] ; then
    echo -e "[wsl2]\nnetworkingMode=mirrored" > "/mnt/c/Users/Public/.wslconfig" && \
    echo -e "WARN 1: No .wslconfig file found; therefore, one were created on '/mnt/c/Users/Public/'.\nWSL must be manually restarted for this change to be applied."
fi 

# Function to load option parameters
loadOptionsArguments() {
    while [ "$#" -gt 0 ] ; do 
        if ! [[ $1 =~ ^--[\-a-z]* ]] ; then 
            echo "ERROR 4: Option argument '$1' is not acceptable. Options available are: ${optionsAvailable}."
            exit 4
        elif [[ $1 == "--clear" ]] ; then
            source ./scenario-${scenarioNumber}/scenario-${scenarioNumber}.clean.sh
            exit 0
        elif [[ $1 == "--fw-off" ]] ; then
            fwFlag=0
            echo "WARN 2: Scenario-${scenarioNumber} will have disabled firewall rules."
            shift
        else
            echo "ERROR 5: Option argument '$1' is not supported. Options available are: ${optionsAvailable}."
            exit 5
        fi
    done
}

# Main program
loadOptionsArguments ${suplementaryOptions}
source ./scenario-${scenarioNumber}/scenario-${scenarioNumber}.sh ${alpineVersion} ${fwFlag}
exit 0
