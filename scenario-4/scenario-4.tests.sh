#!/bin/bash
#
# About it:
# * Set of tests to validate traffic among each device. It enphasizes VLAN restrictions.
#
# Parameters:
# -
#
echo "------------------------------------------------" && \
echo "------------------IP ADDRESSES------------------" && \
echo "------------------------------------------------"
docker container exec firwll-0   sh -c 'echo -e "\n\n[firwll-0] ip address show" && ip address show'
docker container exec switch-0   sh -c 'echo -e "\n\n[switch-0.ns1] ip address show" && ip -netns ns1 address show'
docker container exec switch-0   sh -c 'echo -e "\n\n[switch-0.ns2] ip address show" && ip -netns ns2 address show'
docker container exec switch-0   sh -c 'echo -e "\n\n[switch-0.ns3] ip address show" && ip -netns ns3 address show'
docker container exec switch-1   sh -c 'echo -e "\n\n[switch-1.ns1] ip address show" && ip -netns ns1 address show'
docker container exec switch-1   sh -c 'echo -e "\n\n[switch-1.ns2] ip address show" && ip -netns ns2 address show'
docker container exec switch-1   sh -c 'echo -e "\n\n[switch-1.ns3] ip address show" && ip -netns ns3 address show'
docker container exec workst-011 sh -c 'echo -e "\n\n[workst-011] ip address show" && ip address show'
docker container exec workst-021 sh -c 'echo -e "\n\n[workst-021] ip address show" && ip address show'
docker container exec workst-031 sh -c 'echo -e "\n\n[workst-031] ip address show" && ip address show'
docker container exec workst-111 sh -c 'echo -e "\n\n[workst-111] ip address show" && ip address show'
docker container exec workst-121 sh -c 'echo -e "\n\n[workst-121] ip address show" && ip address show'
docker container exec workst-131 sh -c 'echo -e "\n\n[workst-131] ip address show" && ip address show'
echo "------------------------------------------------" && \
echo "------------------BRIDGE VLANS------------------" && \
echo "------------------------------------------------"
docker container exec switch-0 sh -c 'echo -e "\n\n[switch-0] bridge vlan show" && bridge vlan show'
docker container exec switch-1 sh -c 'echo -e "\n\n[switch-1] bridge vlan show" && bridge vlan show'
echo "------------------------------------------------" && \
echo "-----------TESTS FOR INTERNAL ROUTING-----------" && \
echo "------------------------------------------------"
expectedValues="1|1|1|1|1|1|1|1|1|
1|1|1|1|1|1|0|0|0|
1|1|1|0|0|0|1|1|1|
1|1|0|1|0|0|1|0|0|
1|1|0|0|1|0|0|1|0|
1|1|0|0|0|1|0|0|1|
1|0|1|1|0|0|1|0|0|
1|0|1|0|1|0|0|1|0|
1|0|1|0|0|1|0|0|1"
val=(${expectedValues//\|/\ })
if [[ ${#val[@]} -lt 81 ]] ; then 
    echo "ERROR 7: ICMP Ping expected values qty is lower than 81." 1>&2
    exit 7
fi
echo -e -n "\nExpected ICMP Pings reachability among hosts:" && \
echo -e -n "\n                1 => reachable" && \
echo -e "\n                0 => not reachable" && \
echo '|          |firwll-0|switch-0|switch-1|workst-011|workst-021|workst-031|workst-111|workst-121|workst-131|' && \
echo '|----------|--------|--------|--------|----------|----------|----------|----------|----------|----------|' && \
echo "|  firwll-0|       ${val[0]}|       ${val[1]}|       ${val[2]}|         ${val[3]}|         ${val[4]}|         ${val[5]}|         ${val[6]}|         ${val[7]}|         ${val[8]}|" && \
echo "|  switch-0|       ${val[9]}|       ${val[10]}|       ${val[11]}|         ${val[12]}|         ${val[13]}|         ${val[14]}|         ${val[15]}|         ${val[16]}|         ${val[17]}|" && \
echo "|  switch-1|       ${val[18]}|       ${val[19]}|       ${val[20]}|         ${val[21]}|         ${val[22]}|         ${val[23]}|         ${val[24]}|         ${val[25]}|         ${val[26]}|" && \
echo "|workst-011|       ${val[27]}|       ${val[28]}|       ${val[29]}|         ${val[30]}|         ${val[31]}|         ${val[32]}|         ${val[33]}|         ${val[34]}|         ${val[35]}|" && \
echo "|workst-021|       ${val[36]}|       ${val[37]}|       ${val[38]}|         ${val[39]}|         ${val[40]}|         ${val[41]}|         ${val[42]}|         ${val[43]}|         ${val[44]}|" && \
echo "|workst-031|       ${val[45]}|       ${val[46]}|       ${val[47]}|         ${val[48]}|         ${val[49]}|         ${val[50]}|         ${val[51]}|         ${val[52]}|         ${val[53]}|" && \
echo "|workst-111|       ${val[54]}|       ${val[55]}|       ${val[56]}|         ${val[57]}|         ${val[58]}|         ${val[59]}|         ${val[60]}|         ${val[61]}|         ${val[62]}|" && \
echo "|workst-121|       ${val[63]}|       ${val[64]}|       ${val[65]}|         ${val[66]}|         ${val[67]}|         ${val[68]}|         ${val[69]}|         ${val[70]}|         ${val[71]}|" && \
echo "|workst-131|       ${val[72]}|       ${val[73]}|       ${val[74]}|         ${val[75]}|         ${val[76]}|         ${val[77]}|         ${val[78]}|         ${val[79]}|         ${val[80]}|" && \
echo -e '\n\n'
evaluateIcmpPing() {
    # Parameters:
    #     $1 <- Container's name or Id
    #     $2 <- IP address destination
    #     $3 <- Boolean flag expected for ping ('1' or '0')
    #     $4 <- [Optional] Network Namespace name (iproute2 netns)
    #
    # Returns:
    #     "---OK---" | "--FAIL--"
    #
    containerName=$1
    destIp=$2
    pingFlag=$3
    netnsName="`[[ -z $4 ]] && echo -n '' || echo -n "ip netns exec $4"`"
    aux="`docker container exec ${containerName} sh -c "echo -n '\n[${containerName}] ' && ${netnsName} ping -c 2 ${destIp}"`"
    echo -e -n ${aux} 1>&2
    if [[ $(echo ${aux} | grep -E ' 5?0% packet loss' | wc -l) == "${pingFlag}" ]] ; then
        echo -n "---OK---"
    else
        echo -n "--FAIL--"
    fi
    exit 0
}
ip_fw="172.20.0.2"
ip_sa="172.20.0.11" ; ip_sb="172.20.0.13" ; ip_sc="172.20.0.15"
ip_SA="172.20.0.19" ; ip_SB="172.20.0.21" ; ip_SC="172.20.0.23"
ip_w1="172.20.1.3"
ip_w2="172.20.2.3"
ip_w3="172.20.3.3"
ip_W1="172.20.11.3"
ip_W2="172.20.12.3"
ip_W3="172.20.13.3"
allResults=''
for triad in "firwll-0|${ip_fw}|${val[0]}|" \
    "firwll-0|${ip_sa}|${val[1]}|" \
    "firwll-0|${ip_SA}|${val[2]}|" \
    "firwll-0|${ip_w1}|${val[3]}|" \
    "firwll-0|${ip_w2}|${val[4]}|" \
    "firwll-0|${ip_w3}|${val[5]}|" \
    "firwll-0|${ip_W1}|${val[6]}|" \
    "firwll-0|${ip_W2}|${val[7]}|" \
    "firwll-0|${ip_W3}|${val[8]}|" \
    "switch-0|${ip_fw}|${val[9]}|ns1" \
    "switch-0|${ip_sb}|${val[10]}|ns2" \
    "switch-0|${ip_SC}|${val[11]}|ns3" \
    "switch-0|${ip_w1}|${val[12]}|ns1" \
    "switch-0|${ip_w2}|${val[13]}|ns2" \
    "switch-0|${ip_w3}|${val[14]}|ns3" \
    "switch-0|${ip_W1}|${val[15]}|ns1" \
    "switch-0|${ip_W2}|${val[16]}|ns2" \
    "switch-0|${ip_W3}|${val[17]}|ns3" \
    "switch-1|${ip_fw}|${val[18]}|ns1" \
    "switch-1|${ip_sb}|${val[19]}|ns2" \
    "switch-1|${ip_SC}|${val[20]}|ns3" \
    "switch-1|${ip_w1}|${val[21]}|ns1" \
    "switch-1|${ip_w2}|${val[22]}|ns2" \
    "switch-1|${ip_w3}|${val[23]}|ns3" \
    "switch-1|${ip_W1}|${val[24]}|ns1" \
    "switch-1|${ip_W2}|${val[25]}|ns2" \
    "switch-1|${ip_W3}|${val[26]}|ns3" \
    "workst-011|${ip_fw}|${val[27]}|" \
    "workst-011|${ip_sa}|${val[28]}|" \
    "workst-011|${ip_SA}|${val[29]}|" \
    "workst-011|${ip_w1}|${val[30]}|" \
    "workst-011|${ip_w2}|${val[31]}|" \
    "workst-011|${ip_w3}|${val[32]}|" \
    "workst-011|${ip_W1}|${val[33]}|" \
    "workst-011|${ip_W2}|${val[34]}|" \
    "workst-011|${ip_W3}|${val[35]}|" \
    "workst-021|${ip_fw}|${val[36]}|" \
    "workst-021|${ip_sb}|${val[37]}|" \
    "workst-021|${ip_SB}|${val[38]}|" \
    "workst-021|${ip_w1}|${val[39]}|" \
    "workst-021|${ip_w2}|${val[40]}|" \
    "workst-021|${ip_w3}|${val[41]}|" \
    "workst-021|${ip_W1}|${val[42]}|" \
    "workst-021|${ip_W2}|${val[43]}|" \
    "workst-021|${ip_W3}|${val[44]}|" \
    "workst-031|${ip_fw}|${val[45]}|" \
    "workst-031|${ip_sc}|${val[46]}|" \
    "workst-031|${ip_SC}|${val[47]}|" \
    "workst-031|${ip_w1}|${val[48]}|" \
    "workst-031|${ip_w2}|${val[49]}|" \
    "workst-031|${ip_w3}|${val[50]}|" \
    "workst-031|${ip_W1}|${val[51]}|" \
    "workst-031|${ip_W2}|${val[52]}|" \
    "workst-031|${ip_W3}|${val[53]}|" \
    "workst-111|${ip_fw}|${val[54]}|" \
    "workst-111|${ip_sa}|${val[55]}|" \
    "workst-111|${ip_SA}|${val[56]}|" \
    "workst-111|${ip_w1}|${val[57]}|" \
    "workst-111|${ip_w2}|${val[58]}|" \
    "workst-111|${ip_w3}|${val[59]}|" \
    "workst-111|${ip_W1}|${val[60]}|" \
    "workst-111|${ip_W2}|${val[61]}|" \
    "workst-111|${ip_W3}|${val[62]}|" \
    "workst-121|${ip_fw}|${val[63]}|" \
    "workst-121|${ip_sb}|${val[64]}|" \
    "workst-121|${ip_SB}|${val[65]}|" \
    "workst-121|${ip_w1}|${val[66]}|" \
    "workst-121|${ip_w2}|${val[67]}|" \
    "workst-121|${ip_w3}|${val[68]}|" \
    "workst-121|${ip_W1}|${val[69]}|" \
    "workst-121|${ip_W2}|${val[70]}|" \
    "workst-121|${ip_W3}|${val[71]}|" \
    "workst-131|${ip_fw}|${val[72]}|" \
    "workst-131|${ip_sc}|${val[73]}|" \
    "workst-131|${ip_SC}|${val[74]}|" \
    "workst-131|${ip_w1}|${val[75]}|" \
    "workst-131|${ip_w2}|${val[76]}|" \
    "workst-131|${ip_w3}|${val[77]}|" \
    "workst-131|${ip_W1}|${val[78]}|" \
    "workst-131|${ip_W2}|${val[79]}|" \
    "workst-131|${ip_W3}|${val[80]}|"
do 
    triadArray=(${triad//\|/\ })
    allResults+="`echo -n "$(evaluateIcmpPing ${triadArray[@]}) "`"
done
x=(${allResults})
echo -e -n "\n\n\nICMP Pings conformity with the expected among hosts:" && \
echo -e -n "\n               OK => valid"
echo -e "\n             FAIL => not valid" && \
echo "|          |firwll-0|switch-0|switch-1|workst-011|workst-021|workst-031|workst-111|workst-121|workst-131|" && \
echo "|----------|--------|--------|--------|----------|----------|----------|----------|----------|----------|" && \
echo "| firwll-0 |${x[0]}|${x[1]}|${x[2]}|-${x[3]}-|-${x[4]}-|-${x[5]}-|-${x[6]}-|-${x[7]}-|-${x[8]}-|" && \
echo "| switch-0 |${x[9]}|${x[10]}|${x[11]}|-${x[12]}-|-${x[13]}-|-${x[14]}-|-${x[15]}-|-${x[16]}-|-${x[17]}-|" && \
echo "| switch-1 |${x[18]}|${x[19]}|${x[20]}|-${x[21]}-|-${x[22]}-|-${x[23]}-|-${x[24]}-|-${x[25]}-|-${x[26]}-|" && \
echo "|workst-011|${x[27]}|${x[28]}|${x[29]}|-${x[30]}-|-${x[31]}-|-${x[32]}-|-${x[33]}-|-${x[34]}-|-${x[35]}-|" && \
echo "|workst-021|${x[36]}|${x[37]}|${x[38]}|-${x[39]}-|-${x[40]}-|-${x[41]}-|-${x[42]}-|-${x[43]}-|-${x[44]}-|" && \
echo "|workst-031|${x[45]}|${x[46]}|${x[47]}|-${x[48]}-|-${x[49]}-|-${x[50]}-|-${x[51]}-|-${x[52]}-|-${x[53]}-|" && \
echo "|workst-111|${x[54]}|${x[55]}|${x[56]}|-${x[57]}-|-${x[58]}-|-${x[59]}-|-${x[60]}-|-${x[61]}-|-${x[62]}-|" && \
echo "|workst-121|${x[63]}|${x[64]}|${x[65]}|-${x[66]}-|-${x[67]}-|-${x[68]}-|-${x[69]}-|-${x[70]}-|-${x[71]}-|" && \
echo "|workst-131|${x[72]}|${x[73]}|${x[74]}|-${x[75]}-|-${x[76]}-|-${x[77]}-|-${x[78]}-|-${x[79]}-|-${x[80]}-|" && \
echo -e '\n\n' && \
echo "------------------------------------------------" && \
echo "------------------TRACE ROUTES------------------" && \
echo "------------------------------------------------" && \
echo -e '\n---[VLAN 11] checking route between 011 and 111---'
docker container exec workst-011 sh -c "echo -e -n '\n\n[workst-011] ' && traceroute -I -m 4 -n ${ip_W1}"
docker container exec workst-111 sh -c "echo -e -n '\n\n[workst-111] ' && traceroute -I -m 4 -n ${ip_w1}"
echo -e '\n---[VLAN 21] checking route between 021 and 121---'
docker container exec workst-021 sh -c "echo -e -n '\n\n[workst-021] ' && traceroute -I -m 4 -n ${ip_W2}"
docker container exec workst-121 sh -c "echo -e -n '\n\n[workst-121] ' && traceroute -I -m 4 -n ${ip_w2}"
echo -e '\n---[VLAN 31] checking route between 031 and 131---'
docker container exec workst-031 sh -c "echo -e -n '\n\n[workst-031] ' && traceroute -I -m 4 -n ${ip_W3}"
docker container exec workst-131 sh -c "echo -e -n '\n\n[workst-131] ' && traceroute -I -m 4 -n ${ip_w3}"
echo -e '\n---[VLAN 11 <--x--> VLAN 21] checking blockage between 011 and 021---'
docker container exec workst-011 sh -c "echo -e -n '\n\n[workst-011] ' && traceroute -I -m 4 -n ${ip_w2}"
docker container exec workst-011 sh -c "echo -e -n '\n\n[workst-011] ' && traceroute -I -m 4 -n ${ip_W2}"
docker container exec workst-111 sh -c "echo -e -n '\n\n[workst-111] ' && traceroute -I -m 4 -n ${ip_W2}"
docker container exec workst-111 sh -c "echo -e -n '\n\n[workst-111] ' && traceroute -I -m 4 -n ${ip_w2}"
docker container exec workst-021 sh -c "echo -e -n '\n\n[workst-021] ' && traceroute -I -m 4 -n ${ip_w1}"
docker container exec workst-021 sh -c "echo -e -n '\n\n[workst-021] ' && traceroute -I -m 4 -n ${ip_W1}"
docker container exec workst-121 sh -c "echo -e -n '\n\n[workst-121] ' && traceroute -I -m 4 -n ${ip_W1}"
docker container exec workst-121 sh -c "echo -e -n '\n\n[workst-121] ' && traceroute -I -m 4 -n ${ip_w1}"
echo -e '\n---[VLAN 21 <--x--> VLAN 31] checking blockage between 021 and 031---'
docker container exec workst-021 sh -c "echo -e -n '\n\n[workst-021] ' && traceroute -I -m 4 -n ${ip_w3}"
docker container exec workst-021 sh -c "echo -e -n '\n\n[workst-021] ' && traceroute -I -m 4 -n ${ip_W3}"
docker container exec workst-121 sh -c "echo -e -n '\n\n[workst-121] ' && traceroute -I -m 4 -n ${ip_W3}"
docker container exec workst-121 sh -c "echo -e -n '\n\n[workst-121] ' && traceroute -I -m 4 -n ${ip_w3}"
docker container exec workst-031 sh -c "echo -e -n '\n\n[workst-031] ' && traceroute -I -m 4 -n ${ip_w2}"
docker container exec workst-031 sh -c "echo -e -n '\n\n[workst-031] ' && traceroute -I -m 4 -n ${ip_W2}"
docker container exec workst-131 sh -c "echo -e -n '\n\n[workst-131] ' && traceroute -I -m 4 -n ${ip_W2}"
docker container exec workst-131 sh -c "echo -e -n '\n\n[workst-131] ' && traceroute -I -m 4 -n ${ip_w2}"
echo -e '\n---[VLAN 31 <--x--> VLAN 11] checking blockage between 031 and 011---'
docker container exec workst-031 sh -c "echo -e -n '\n\n[workst-031] ' && traceroute -I -m 4 -n ${ip_w1}"
docker container exec workst-031 sh -c "echo -e -n '\n\n[workst-031] ' && traceroute -I -m 4 -n ${ip_W1}"
docker container exec workst-131 sh -c "echo -e -n '\n\n[workst-131] ' && traceroute -I -m 4 -n ${ip_W1}"
docker container exec workst-131 sh -c "echo -e -n '\n\n[workst-131] ' && traceroute -I -m 4 -n ${ip_w1}"
docker container exec workst-011 sh -c "echo -e -n '\n\n[workst-011] ' && traceroute -I -m 4 -n ${ip_w3}"
docker container exec workst-011 sh -c "echo -e -n '\n\n[workst-011] ' && traceroute -I -m 4 -n ${ip_W3}"
docker container exec workst-111 sh -c "echo -e -n '\n\n[workst-111] ' && traceroute -I -m 4 -n ${ip_W3}"
docker container exec workst-111 sh -c "echo -e -n '\n\n[workst-111] ' && traceroute -I -m 4 -n ${ip_w3}"
echo -e "\n\n"
echo "------------------------------------------------" && \
echo "------------------OBSERVATIONS------------------" && \
echo "------------------------------------------------" && \
echo -e "Sometimes, the Network takes a while to stabilize and load all routes;\ntherefore, if any ICMP ping result has given 'FAIL', wait some minutes and re-execute this file;\nsince different results may be obtained."
