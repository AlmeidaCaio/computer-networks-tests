#!/bin/sh
#
# About it:
# * Set of tests to validate traffic among each device. It enphasizes VLAN restrictions.
#
# Parameters:
# -
#
echo "------------------------------------------------" && \
echo "------------------ TCP  DUMPS ------------------" && \
echo "------------------------------------------------"
docker container exec firwll-0 sh -c "{ tcpdump -e -i eth0 -n -vvv &> eth0.firwll-0.log & } && echo \$!"
docker container exec firwll-0 sh -c "{ tcpdump -e -i eth1 -n -vvv &> eth1.firwll-0.log & } && echo \$!"
docker container exec firwll-0 sh -c "{ tcpdump -e -i eth2 -n -vvv &> eth2.firwll-0.log & } && echo \$!"
docker container exec switch-0 sh -c "{ tcpdump -e -i lo -n -vvv &> lo.switch-0.log & } && echo \$!"
docker container exec switch-0 sh -c "{ tcpdump -e -i br0 -n -vvv &> br0.switch-0.log & } && echo \$!"
docker container exec switch-0 sh -c "{ tcpdump -e -i vth0 -n -vvv &> vth0.switch-0.log & } && echo \$!"
docker container exec switch-0 sh -c "{ tcpdump -e -i vth1 -n -vvv &> vth1.switch-0.log & } && echo \$!"
docker container exec switch-0 sh -c "{ tcpdump -e -i vth2 -n -vvv &> vth2.switch-0.log & } && echo \$!"
docker container exec switch-0 sh -c "{ tcpdump -e -i vth3 -n -vvv &> vth3.switch-0.log & } && echo \$!"
docker container exec switch-0 sh -c "{ ip netns exec ns0 tcpdump -e -i lo -n -vvv &> lo0.switch-0.log & } && echo \$!"
docker container exec switch-0 sh -c "{ ip netns exec ns0 tcpdump -e -i eth0 -n -vvv &> eth0.switch-0.log & } && echo \$!"
docker container exec switch-0 sh -c "{ ip netns exec ns0 tcpdump -e -i vth0.x -n -vvv &> vth0.x.switch-0.log & } && echo \$!"
docker container exec switch-0 sh -c "{ ip netns exec ns0 tcpdump -e -i vth0.11 -n -vvv &> vth0.11.switch-0.log & } && echo \$!"
docker container exec switch-0 sh -c "{ ip netns exec ns0 tcpdump -e -i vth0.21 -n -vvv &> vth0.21.switch-0.log & } && echo \$!"
docker container exec switch-0 sh -c "{ ip netns exec ns0 tcpdump -e -i vth0.31 -n -vvv &> vth0.31.switch-0.log & } && echo \$!"
docker container exec switch-0 sh -c "{ ip netns exec ns1 tcpdump -e -i lo -n -vvv &> lo1.switch-0.log & } && echo \$!"
docker container exec switch-0 sh -c "{ ip netns exec ns1 tcpdump -e -i eth1 -n -vvv &> eth1.switch-0.log & } && echo \$!"
docker container exec switch-0 sh -c "{ ip netns exec ns1 tcpdump -e -i vth1.11 -n -vvv &> vth1.11.switch-0.log & } && echo \$!"
docker container exec switch-0 sh -c "{ ip netns exec ns2 tcpdump -e -i lo -n -vvv &> lo2.switch-0.log & } && echo \$!"
docker container exec switch-0 sh -c "{ ip netns exec ns2 tcpdump -e -i eth2 -n -vvv &> eth2.switch-0.log & } && echo \$!"
docker container exec switch-0 sh -c "{ ip netns exec ns2 tcpdump -e -i vth2.21 -n -vvv &> vth2.21.switch-0.log & } && echo \$!"
docker container exec switch-0 sh -c "{ ip netns exec ns3 tcpdump -e -i lo -n -vvv &> lo3.switch-0.log & } && echo \$!"
docker container exec switch-0 sh -c "{ ip netns exec ns3 tcpdump -e -i eth3 -n -vvv &> eth3.switch-0.log & } && echo \$!"
docker container exec switch-0 sh -c "{ ip netns exec ns3 tcpdump -e -i vth3.31 -n -vvv &> vth3.31.switch-0.log & } && echo \$!"
docker container exec switch-1 sh -c "{ tcpdump -e -i lo -n -vvv &> lo.switch-1.log & } && echo \$!"
docker container exec switch-1 sh -c "{ tcpdump -e -i br1 -n -vvv &> br1.switch-1.log & } && echo \$!"
docker container exec switch-1 sh -c "{ tcpdump -e -i vth0 -n -vvv &> vth0.switch-1.log & } && echo \$!"
docker container exec switch-1 sh -c "{ tcpdump -e -i vth1 -n -vvv &> vth1.switch-1.log & } && echo \$!"
docker container exec switch-1 sh -c "{ tcpdump -e -i vth2 -n -vvv &> vth2.switch-1.log & } && echo \$!"
docker container exec switch-1 sh -c "{ tcpdump -e -i vth3 -n -vvv &> vth3.switch-1.log & } && echo \$!"
docker container exec switch-1 sh -c "{ ip netns exec ns0 tcpdump -e -i lo -n -vvv &> lo0.switch-1.log & } && echo \$!"
docker container exec switch-1 sh -c "{ ip netns exec ns0 tcpdump -e -i eth0 -n -vvv &> eth0.switch-1.log & } && echo \$!"
docker container exec switch-1 sh -c "{ ip netns exec ns0 tcpdump -e -i vth0.x -n -vvv &> vth0.x.switch-1.log & } && echo \$!"
docker container exec switch-1 sh -c "{ ip netns exec ns0 tcpdump -e -i vth0.11 -n -vvv &> vth0.11.switch-1.log & } && echo \$!"
docker container exec switch-1 sh -c "{ ip netns exec ns0 tcpdump -e -i vth0.21 -n -vvv &> vth0.21.switch-1.log & } && echo \$!"
docker container exec switch-1 sh -c "{ ip netns exec ns0 tcpdump -e -i vth0.31 -n -vvv &> vth0.31.switch-1.log & } && echo \$!"
docker container exec switch-1 sh -c "{ ip netns exec ns0 tcpdump -e -i lo -n -vvv &> lo1.switch-1.log & } && echo \$!"
docker container exec switch-1 sh -c "{ ip netns exec ns1 tcpdump -e -i eth1 -n -vvv &> eth1.switch-1.log & } && echo \$!"
docker container exec switch-1 sh -c "{ ip netns exec ns1 tcpdump -e -i vth1.11 -n -vvv &> vth1.11.switch-1.log & } && echo \$!"
docker container exec switch-1 sh -c "{ ip netns exec ns2 tcpdump -e -i lo -n -vvv &> lo2.switch-1.log & } && echo \$!"
docker container exec switch-1 sh -c "{ ip netns exec ns2 tcpdump -e -i eth2 -n -vvv &> eth2.switch-1.log & } && echo \$!"
docker container exec switch-1 sh -c "{ ip netns exec ns2 tcpdump -e -i vth2.21 -n -vvv &> vth2.21.switch-1.log & } && echo \$!"
docker container exec switch-1 sh -c "{ ip netns exec ns3 tcpdump -e -i lo -n -vvv &> lo3.switch-1.log & } && echo \$!"
docker container exec switch-1 sh -c "{ ip netns exec ns3 tcpdump -e -i eth3 -n -vvv &> eth3.switch-1.log & } && echo \$!"
docker container exec switch-1 sh -c "{ ip netns exec ns3 tcpdump -e -i vth3.31 -n -vvv &> vth3.31.switch-1.log & } && echo \$!"
echo "------------------------------------------------" && \
echo "------------------BRIDGE VLANS------------------" && \
echo "------------------------------------------------"
docker container exec switch-0 sh -c 'echo -e "\n\n[switch-0] bridge vlan show" && bridge vlan show'
docker container exec switch-1 sh -c 'echo -e "\n\n[switch-1] bridge vlan show" && bridge vlan show'
echo "------------------------------------------------" && \
echo "-----------TESTS FOR INTERNAL ROUTING-----------" && \
echo "------------------------------------------------" && \
echo -e -n "\nExpected ICMP Pings reachability among hosts:" && \
echo -e -n "\n                1 => reachable" && \
echo -e "\n                0 => not reachable" && \
echo '|          |firwll-0|switch-0|switch-1|workst-011|workst-021|workst-031|workst-111|workst-121|workst-131|' && \
echo '|----------|--------|--------|--------|----------|----------|----------|----------|----------|----------|' && \
echo '|  firwll-0|       1|       1|       1|         1|         1|         1|         1|         1|         1|' && \
echo '|  switch-0|       1|       1|       1|         1|         1|         1|         0|         0|         0|' && \
echo '|  switch-1|       1|       1|       1|         0|         0|         0|         1|         1|         1|' && \
echo '|workst-011|       1|       1|       0|         1|         0|         0|         1|         0|         0|' && \
echo '|workst-021|       1|       1|       0|         0|         1|         0|         0|         1|         0|' && \
echo '|workst-031|       1|       1|       0|         0|         0|         1|         0|         0|         1|' && \
echo '|workst-111|       1|       0|       1|         1|         0|         0|         1|         0|         0|' && \
echo '|workst-121|       1|       0|       1|         0|         1|         0|         0|         1|         0|' && \
echo '|workst-131|       1|       0|       1|         0|         0|         1|         0|         0|         1|' && \
echo -e '\n\n'
ip_fw="172.20.0.2"
ip_s0="172.20.0.14"
ip_s1="172.20.0.22"
ip_w1="172.20.1.3"
ip_w2="172.20.2.3"
ip_w3="172.20.3.3"
ip_W1="172.20.11.3"
ip_W2="172.20.12.3"
ip_W3="172.20.13.3"
passed="---OK---"
failed="--FAIL--"
aux="`docker container exec firwll-0 sh -c "echo -e -n '\n\n[firwll-0] ' && ping -c 1 ${ip_fw}"`" ; echo -e ${aux} ; fw_fw="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec firwll-0 sh -c "echo -e -n '\n\n[firwll-0] ' && ping -c 1 ${ip_s0}"`" ; echo -e ${aux} ; fw_s0="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec firwll-0 sh -c "echo -e -n '\n\n[firwll-0] ' && ping -c 1 ${ip_s1}"`" ; echo -e ${aux} ; fw_s1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec firwll-0 sh -c "echo -e -n '\n\n[firwll-0] ' && ping -c 1 ${ip_w1}"`" ; echo -e ${aux} ; fw_w1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec firwll-0 sh -c "echo -e -n '\n\n[firwll-0] ' && ping -c 1 ${ip_w2}"`" ; echo -e ${aux} ; fw_w2="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec firwll-0 sh -c "echo -e -n '\n\n[firwll-0] ' && ping -c 1 ${ip_w3}"`" ; echo -e ${aux} ; fw_w3="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec firwll-0 sh -c "echo -e -n '\n\n[firwll-0] ' && ping -c 1 ${ip_W1}"`" ; echo -e ${aux} ; fw_W1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec firwll-0 sh -c "echo -e -n '\n\n[firwll-0] ' && ping -c 1 ${ip_W2}"`" ; echo -e ${aux} ; fw_W2="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec firwll-0 sh -c "echo -e -n '\n\n[firwll-0] ' && ping -c 1 ${ip_W3}"`" ; echo -e ${aux} ; fw_W3="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec switch-0 sh -c "echo -e -n '\n\n[switch-0] ' && ping -c 1 ${ip_fw}"`" ; echo -e ${aux} ; s0_fw="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec switch-0 sh -c "echo -e -n '\n\n[switch-0] ' && ping -c 1 ${ip_s0}"`" ; echo -e ${aux} ; s0_s0="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec switch-0 sh -c "echo -e -n '\n\n[switch-0] ' && ping -c 1 ${ip_s1}"`" ; echo -e ${aux} ; s0_s1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec switch-0 sh -c "echo -e -n '\n\n[switch-0] ' && ping -c 1 ${ip_w1}"`" ; echo -e ${aux} ; s0_w1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec switch-0 sh -c "echo -e -n '\n\n[switch-0] ' && ping -c 1 ${ip_w2}"`" ; echo -e ${aux} ; s0_w2="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec switch-0 sh -c "echo -e -n '\n\n[switch-0] ' && ping -c 1 ${ip_w3}"`" ; echo -e ${aux} ; s0_w3="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec switch-0 sh -c "echo -e -n '\n\n[switch-0] ' && ping -c 1 ${ip_W1}"`" ; echo -e ${aux} ; s0_W1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec switch-0 sh -c "echo -e -n '\n\n[switch-0] ' && ping -c 1 ${ip_W2}"`" ; echo -e ${aux} ; s0_W2="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec switch-0 sh -c "echo -e -n '\n\n[switch-0] ' && ping -c 1 ${ip_W3}"`" ; echo -e ${aux} ; s0_W3="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec switch-1 sh -c "echo -e -n '\n\n[switch-1] ' && ping -c 1 ${ip_fw}"`" ; echo -e ${aux} ; s1_fw="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec switch-1 sh -c "echo -e -n '\n\n[switch-1] ' && ping -c 1 ${ip_s0}"`" ; echo -e ${aux} ; s1_s0="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec switch-1 sh -c "echo -e -n '\n\n[switch-1] ' && ping -c 1 ${ip_s1}"`" ; echo -e ${aux} ; s1_s1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec switch-1 sh -c "echo -e -n '\n\n[switch-1] ' && ping -c 1 ${ip_w1}"`" ; echo -e ${aux} ; s1_w1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec switch-1 sh -c "echo -e -n '\n\n[switch-1] ' && ping -c 1 ${ip_w2}"`" ; echo -e ${aux} ; s1_w2="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec switch-1 sh -c "echo -e -n '\n\n[switch-1] ' && ping -c 1 ${ip_w3}"`" ; echo -e ${aux} ; s1_w3="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec switch-1 sh -c "echo -e -n '\n\n[switch-1] ' && ping -c 1 ${ip_W1}"`" ; echo -e ${aux} ; s1_W1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec switch-1 sh -c "echo -e -n '\n\n[switch-1] ' && ping -c 1 ${ip_W2}"`" ; echo -e ${aux} ; s1_W2="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec switch-1 sh -c "echo -e -n '\n\n[switch-1] ' && ping -c 1 ${ip_W3}"`" ; echo -e ${aux} ; s1_W3="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-011 sh -c "echo -e -n '\n\n[workst-011] ' && ping -c 1 ${ip_fw}"`" ; echo -e ${aux} ; w1_fw="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-011 sh -c "echo -e -n '\n\n[workst-011] ' && ping -c 1 ${ip_s0}"`" ; echo -e ${aux} ; w1_s0="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-011 sh -c "echo -e -n '\n\n[workst-011] ' && ping -c 1 ${ip_s1}"`" ; echo -e ${aux} ; w1_s1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-011 sh -c "echo -e -n '\n\n[workst-011] ' && ping -c 1 ${ip_w1}"`" ; echo -e ${aux} ; w1_w1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-011 sh -c "echo -e -n '\n\n[workst-011] ' && ping -c 1 ${ip_w2}"`" ; echo -e ${aux} ; w1_w2="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-011 sh -c "echo -e -n '\n\n[workst-011] ' && ping -c 1 ${ip_w3}"`" ; echo -e ${aux} ; w1_w3="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-011 sh -c "echo -e -n '\n\n[workst-011] ' && ping -c 1 ${ip_W1}"`" ; echo -e ${aux} ; w1_W1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-011 sh -c "echo -e -n '\n\n[workst-011] ' && ping -c 1 ${ip_W2}"`" ; echo -e ${aux} ; w1_W2="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-011 sh -c "echo -e -n '\n\n[workst-011] ' && ping -c 1 ${ip_W3}"`" ; echo -e ${aux} ; w1_W3="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-021 sh -c "echo -e -n '\n\n[workst-021] ' && ping -c 1 ${ip_fw}"`" ; echo -e ${aux} ; w2_fw="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-021 sh -c "echo -e -n '\n\n[workst-021] ' && ping -c 1 ${ip_s0}"`" ; echo -e ${aux} ; w2_s0="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-021 sh -c "echo -e -n '\n\n[workst-021] ' && ping -c 1 ${ip_s1}"`" ; echo -e ${aux} ; w2_s1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-021 sh -c "echo -e -n '\n\n[workst-021] ' && ping -c 1 ${ip_w1}"`" ; echo -e ${aux} ; w2_w1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-021 sh -c "echo -e -n '\n\n[workst-021] ' && ping -c 1 ${ip_w2}"`" ; echo -e ${aux} ; w2_w2="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-021 sh -c "echo -e -n '\n\n[workst-021] ' && ping -c 1 ${ip_w3}"`" ; echo -e ${aux} ; w2_w3="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-021 sh -c "echo -e -n '\n\n[workst-021] ' && ping -c 1 ${ip_W1}"`" ; echo -e ${aux} ; w2_W1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-021 sh -c "echo -e -n '\n\n[workst-021] ' && ping -c 1 ${ip_W2}"`" ; echo -e ${aux} ; w2_W2="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-021 sh -c "echo -e -n '\n\n[workst-021] ' && ping -c 1 ${ip_W3}"`" ; echo -e ${aux} ; w2_W3="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-031 sh -c "echo -e -n '\n\n[workst-031] ' && ping -c 1 ${ip_fw}"`" ; echo -e ${aux} ; w3_fw="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-031 sh -c "echo -e -n '\n\n[workst-031] ' && ping -c 1 ${ip_s0}"`" ; echo -e ${aux} ; w3_s0="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-031 sh -c "echo -e -n '\n\n[workst-031] ' && ping -c 1 ${ip_s1}"`" ; echo -e ${aux} ; w3_s1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-031 sh -c "echo -e -n '\n\n[workst-031] ' && ping -c 1 ${ip_w1}"`" ; echo -e ${aux} ; w3_w1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-031 sh -c "echo -e -n '\n\n[workst-031] ' && ping -c 1 ${ip_w2}"`" ; echo -e ${aux} ; w3_w2="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-031 sh -c "echo -e -n '\n\n[workst-031] ' && ping -c 1 ${ip_w3}"`" ; echo -e ${aux} ; w3_w3="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-031 sh -c "echo -e -n '\n\n[workst-031] ' && ping -c 1 ${ip_W1}"`" ; echo -e ${aux} ; w3_W1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-031 sh -c "echo -e -n '\n\n[workst-031] ' && ping -c 1 ${ip_W2}"`" ; echo -e ${aux} ; w3_W2="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-031 sh -c "echo -e -n '\n\n[workst-031] ' && ping -c 1 ${ip_W3}"`" ; echo -e ${aux} ; w3_W3="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-111 sh -c "echo -e -n '\n\n[workst-111] ' && ping -c 1 ${ip_fw}"`" ; echo -e ${aux} ; W1_fw="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-111 sh -c "echo -e -n '\n\n[workst-111] ' && ping -c 1 ${ip_s0}"`" ; echo -e ${aux} ; W1_s0="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-111 sh -c "echo -e -n '\n\n[workst-111] ' && ping -c 1 ${ip_s1}"`" ; echo -e ${aux} ; W1_s1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-111 sh -c "echo -e -n '\n\n[workst-111] ' && ping -c 1 ${ip_w1}"`" ; echo -e ${aux} ; W1_w1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-111 sh -c "echo -e -n '\n\n[workst-111] ' && ping -c 1 ${ip_w2}"`" ; echo -e ${aux} ; W1_w2="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-111 sh -c "echo -e -n '\n\n[workst-111] ' && ping -c 1 ${ip_w3}"`" ; echo -e ${aux} ; W1_w3="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-111 sh -c "echo -e -n '\n\n[workst-111] ' && ping -c 1 ${ip_W1}"`" ; echo -e ${aux} ; W1_W1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-111 sh -c "echo -e -n '\n\n[workst-111] ' && ping -c 1 ${ip_W2}"`" ; echo -e ${aux} ; W1_W2="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-111 sh -c "echo -e -n '\n\n[workst-111] ' && ping -c 1 ${ip_W3}"`" ; echo -e ${aux} ; W1_W3="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-121 sh -c "echo -e -n '\n\n[workst-121] ' && ping -c 1 ${ip_fw}"`" ; echo -e ${aux} ; W2_fw="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-121 sh -c "echo -e -n '\n\n[workst-121] ' && ping -c 1 ${ip_s0}"`" ; echo -e ${aux} ; W2_s0="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-121 sh -c "echo -e -n '\n\n[workst-121] ' && ping -c 1 ${ip_s1}"`" ; echo -e ${aux} ; W2_s1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-121 sh -c "echo -e -n '\n\n[workst-121] ' && ping -c 1 ${ip_w1}"`" ; echo -e ${aux} ; W2_w1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-121 sh -c "echo -e -n '\n\n[workst-121] ' && ping -c 1 ${ip_w2}"`" ; echo -e ${aux} ; W2_w2="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-121 sh -c "echo -e -n '\n\n[workst-121] ' && ping -c 1 ${ip_w3}"`" ; echo -e ${aux} ; W2_w3="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-121 sh -c "echo -e -n '\n\n[workst-121] ' && ping -c 1 ${ip_W1}"`" ; echo -e ${aux} ; W2_W1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-121 sh -c "echo -e -n '\n\n[workst-121] ' && ping -c 1 ${ip_W2}"`" ; echo -e ${aux} ; W2_W2="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-121 sh -c "echo -e -n '\n\n[workst-121] ' && ping -c 1 ${ip_W3}"`" ; echo -e ${aux} ; W2_W3="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-131 sh -c "echo -e -n '\n\n[workst-131] ' && ping -c 1 ${ip_fw}"`" ; echo -e ${aux} ; W3_fw="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-131 sh -c "echo -e -n '\n\n[workst-131] ' && ping -c 1 ${ip_s0}"`" ; echo -e ${aux} ; W3_s0="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-131 sh -c "echo -e -n '\n\n[workst-131] ' && ping -c 1 ${ip_s1}"`" ; echo -e ${aux} ; W3_s1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-131 sh -c "echo -e -n '\n\n[workst-131] ' && ping -c 1 ${ip_w1}"`" ; echo -e ${aux} ; W3_w1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-131 sh -c "echo -e -n '\n\n[workst-131] ' && ping -c 1 ${ip_w2}"`" ; echo -e ${aux} ; W3_w2="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-131 sh -c "echo -e -n '\n\n[workst-131] ' && ping -c 1 ${ip_w3}"`" ; echo -e ${aux} ; W3_w3="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
aux="`docker container exec workst-131 sh -c "echo -e -n '\n\n[workst-131] ' && ping -c 1 ${ip_W1}"`" ; echo -e ${aux} ; W3_W1="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-131 sh -c "echo -e -n '\n\n[workst-131] ' && ping -c 1 ${ip_W2}"`" ; echo -e ${aux} ; W3_W2="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${failed} ; else echo -n ${passed} ; fi`"
aux="`docker container exec workst-131 sh -c "echo -e -n '\n\n[workst-131] ' && ping -c 1 ${ip_W3}"`" ; echo -e ${aux} ; W3_W3="`if [ $(echo $aux | grep ' 0% packet loss' | wc -l) == '1' ] ; then echo -n ${passed} ; else echo -n ${failed} ; fi`"
echo -e -n "\n\n\nICMP Pings conformity with the expected among hosts:" && \
echo -e -n "\n               OK => valid"
echo -e "\n             FAIL => not valid" && \
echo "|          |firwll-0|switch-0|switch-1|workst-011|workst-021|workst-031|workst-111|workst-121|workst-131|" && \
echo "|----------|--------|--------|--------|----------|----------|----------|----------|----------|----------|" && \
echo "|  firwll-0|${fw_fw}|${fw_s0}|${fw_s1}|-${fw_w1}-|-${fw_w2}-|-${fw_w3}-|-${fw_W1}-|-${fw_W2}-|-${fw_W3}-|" && \
echo "|  switch-0|${s0_fw}|${s0_s0}|${s0_s1}|-${s0_w1}-|-${s0_w2}-|-${s0_w3}-|-${s0_W1}-|-${s0_W2}-|-${s0_W3}-|" && \
echo "|  switch-1|${s1_fw}|${s1_s0}|${s1_s1}|-${s1_w1}-|-${s1_w2}-|-${s1_w3}-|-${s1_W1}-|-${s1_W2}-|-${s1_W3}-|" && \
echo "|workst-011|${w1_fw}|${w1_s0}|${w1_s1}|-${w1_w1}-|-${w1_w2}-|-${w1_w3}-|-${w1_W1}-|-${w1_W2}-|-${w1_W3}-|" && \
echo "|workst-021|${w2_fw}|${w2_s0}|${w2_s1}|-${w2_w1}-|-${w2_w2}-|-${w2_w3}-|-${w2_W1}-|-${w2_W2}-|-${w2_W3}-|" && \
echo "|workst-031|${w3_fw}|${w3_s0}|${w3_s1}|-${w3_w1}-|-${w3_w2}-|-${w3_w3}-|-${w3_W1}-|-${w3_W2}-|-${w3_W3}-|" && \
echo "|workst-111|${W1_fw}|${W1_s0}|${W1_s1}|-${W1_w1}-|-${W1_w2}-|-${W1_w3}-|-${W1_W1}-|-${W1_W2}-|-${W1_W3}-|" && \
echo "|workst-121|${W2_fw}|${W2_s0}|${W2_s1}|-${W2_w1}-|-${W2_w2}-|-${W2_w3}-|-${W2_W1}-|-${W2_W2}-|-${W2_W3}-|" && \
echo "|workst-131|${W3_fw}|${W3_s0}|${W3_s1}|-${W3_w1}-|-${W3_w2}-|-${W3_w3}-|-${W3_W1}-|-${W3_W2}-|-${W3_W3}-|" && \
echo -e '\n\n' #&& \
#echo "------------------------------------------------" && \
#echo "------------------TRACE ROUTES------------------" && \
#echo "------------------------------------------------" && \
#echo -e '\n---[VLAN 11] checking route between 011 and 111---'
#docker container exec workst-011 sh -c 'echo -e -n "\n\n[workst-011] " && traceroute -I -m 7 -n 172.20.11.3'
#docker container exec workst-111 sh -c 'echo -e -n "\n\n[workst-111] " && traceroute -I -m 7 -n 172.20.1.3'
#echo -e '\n---[VLAN 21] checking route between 021 and 121---'
#docker container exec workst-021 sh -c 'echo -e -n "\n\n[workst-021] " && traceroute -I -m 7 -n 172.20.12.3'
#docker container exec workst-121 sh -c 'echo -e -n "\n\n[workst-121] " && traceroute -I -m 7 -n 172.20.2.3'
#echo -e '\n---[VLAN 31] checking route between 031 and 131---'
#docker container exec workst-031 sh -c 'echo -e -n "\n\n[workst-031] " && traceroute -I -m 7 -n 172.20.13.3'
#docker container exec workst-131 sh -c 'echo -e -n "\n\n[workst-131] " && traceroute -I -m 7 -n 172.20.3.3'
#echo -e '\n---[VLAN 11 <--x--> VLAN 21] checking blockage between 011 and 021---'
#docker container exec workst-011 sh -c 'echo -e -n "\n\n[workst-011] " && traceroute -I -m 7 -n 172.20.2.3'
#docker container exec workst-011 sh -c 'echo -e -n "\n\n[workst-011] " && traceroute -I -m 7 -n 172.20.12.3'
#docker container exec workst-111 sh -c 'echo -e -n "\n\n[workst-111] " && traceroute -I -m 7 -n 172.20.12.3'
#docker container exec workst-111 sh -c 'echo -e -n "\n\n[workst-111] " && traceroute -I -m 7 -n 172.20.2.3'
#docker container exec workst-021 sh -c 'echo -e -n "\n\n[workst-021] " && traceroute -I -m 7 -n 172.20.1.3'
#docker container exec workst-021 sh -c 'echo -e -n "\n\n[workst-021] " && traceroute -I -m 7 -n 172.20.11.3'
#docker container exec workst-121 sh -c 'echo -e -n "\n\n[workst-121] " && traceroute -I -m 7 -n 172.20.11.3'
#docker container exec workst-121 sh -c 'echo -e -n "\n\n[workst-121] " && traceroute -I -m 7 -n 172.20.1.3'
#echo -e '\n---[VLAN 21 <--x--> VLAN 31] checking blockage between 021 and 031---'
#docker container exec workst-021 sh -c 'echo -e -n "\n\n[workst-021] " && traceroute -I -m 7 -n 172.20.3.3'
#docker container exec workst-021 sh -c 'echo -e -n "\n\n[workst-021] " && traceroute -I -m 7 -n 172.20.13.3'
#docker container exec workst-121 sh -c 'echo -e -n "\n\n[workst-121] " && traceroute -I -m 7 -n 172.20.13.3'
#docker container exec workst-121 sh -c 'echo -e -n "\n\n[workst-121] " && traceroute -I -m 7 -n 172.20.3.3'
#docker container exec workst-031 sh -c 'echo -e -n "\n\n[workst-031] " && traceroute -I -m 7 -n 172.20.2.3'
#docker container exec workst-031 sh -c 'echo -e -n "\n\n[workst-031] " && traceroute -I -m 7 -n 172.20.12.3'
#docker container exec workst-131 sh -c 'echo -e -n "\n\n[workst-131] " && traceroute -I -m 7 -n 172.20.12.3'
#docker container exec workst-131 sh -c 'echo -e -n "\n\n[workst-131] " && traceroute -I -m 7 -n 172.20.2.3'
#echo -e '\n---[VLAN 31 <--x--> VLAN 11] checking blockage between 031 and 011---'
#docker container exec workst-031 sh -c 'echo -e -n "\n\n[workst-031] " && traceroute -I -m 7 -n 172.20.1.3'
#docker container exec workst-031 sh -c 'echo -e -n "\n\n[workst-031] " && traceroute -I -m 7 -n 172.20.11.3'
#docker container exec workst-131 sh -c 'echo -e -n "\n\n[workst-131] " && traceroute -I -m 7 -n 172.20.11.3'
#docker container exec workst-131 sh -c 'echo -e -n "\n\n[workst-131] " && traceroute -I -m 7 -n 172.20.1.3'
#docker container exec workst-011 sh -c 'echo -e -n "\n\n[workst-011] " && traceroute -I -m 7 -n 172.20.3.3'
#docker container exec workst-011 sh -c 'echo -e -n "\n\n[workst-011] " && traceroute -I -m 7 -n 172.20.13.3'
#docker container exec workst-111 sh -c 'echo -e -n "\n\n[workst-111] " && traceroute -I -m 7 -n 172.20.13.3'
#docker container exec workst-111 sh -c 'echo -e -n "\n\n[workst-111] " && traceroute -I -m 7 -n 172.20.3.3'
scen4Logs=$( find . -name "logs" | grep "scenario-4" )
docker container cp firwll-0:/eth0.firwll-0.log "${scen4Logs}/"
docker container cp firwll-0:/eth1.firwll-0.log "${scen4Logs}/"
docker container cp firwll-0:/eth2.firwll-0.log "${scen4Logs}/"
docker container cp switch-0:/lo.switch-0.log "${scen4Logs}/"
docker container cp switch-0:/br0.switch-0.log "${scen4Logs}/"
docker container cp switch-0:/vth0.switch-0.log "${scen4Logs}/"
docker container cp switch-0:/vth1.switch-0.log "${scen4Logs}/"
docker container cp switch-0:/vth2.switch-0.log "${scen4Logs}/"
docker container cp switch-0:/vth3.switch-0.log "${scen4Logs}/"
docker container cp switch-0:/lo0.switch-0.log "${scen4Logs}/"
docker container cp switch-0:/eth0.switch-0.log "${scen4Logs}/"
docker container cp switch-0:/vth0.x.switch-0.log "${scen4Logs}/"
docker container cp switch-0:/vth0.11.switch-0.log "${scen4Logs}/"
docker container cp switch-0:/vth0.21.switch-0.log "${scen4Logs}/"
docker container cp switch-0:/vth0.31.switch-0.log "${scen4Logs}/"
docker container cp switch-0:/lo1.switch-0.log "${scen4Logs}/"
docker container cp switch-0:/eth1.switch-0.log "${scen4Logs}/"
docker container cp switch-0:/vth1.11.switch-0.log "${scen4Logs}/"
docker container cp switch-0:/lo2.switch-0.log "${scen4Logs}/"
docker container cp switch-0:/eth2.switch-0.log "${scen4Logs}/"
docker container cp switch-0:/vth2.21.switch-0.log "${scen4Logs}/"
docker container cp switch-0:/lo3.switch-0.log "${scen4Logs}/"
docker container cp switch-0:/eth3.switch-0.log "${scen4Logs}/"
docker container cp switch-0:/vth3.31.switch-0.log "${scen4Logs}/"
docker container cp switch-1:/lo.switch-1.log "${scen4Logs}/"
docker container cp switch-1:/br1.switch-1.log "${scen4Logs}/"
docker container cp switch-1:/vth0.switch-1.log "${scen4Logs}/"
docker container cp switch-1:/vth1.switch-1.log "${scen4Logs}/"
docker container cp switch-1:/vth2.switch-1.log "${scen4Logs}/"
docker container cp switch-1:/vth3.switch-1.log "${scen4Logs}/"
docker container cp switch-1:/lo0.switch-1.log "${scen4Logs}/"
docker container cp switch-1:/eth0.switch-1.log "${scen4Logs}/"
docker container cp switch-1:/vth0.x.switch-1.log "${scen4Logs}/"
docker container cp switch-1:/vth0.11.switch-1.log "${scen4Logs}/"
docker container cp switch-1:/vth0.21.switch-1.log "${scen4Logs}/"
docker container cp switch-1:/vth0.31.switch-1.log "${scen4Logs}/"
docker container cp switch-1:/lo1.switch-1.log "${scen4Logs}/"
docker container cp switch-1:/eth1.switch-1.log "${scen4Logs}/"
docker container cp switch-1:/vth1.11.switch-1.log "${scen4Logs}/"
docker container cp switch-1:/lo2.switch-1.log "${scen4Logs}/"
docker container cp switch-1:/eth2.switch-1.log "${scen4Logs}/"
docker container cp switch-1:/vth2.21.switch-1.log "${scen4Logs}/"
docker container cp switch-1:/lo3.switch-1.log "${scen4Logs}/"
docker container cp switch-1:/eth3.switch-1.log "${scen4Logs}/"
docker container cp switch-1:/vth3.31.switch-1.log "${scen4Logs}/"
