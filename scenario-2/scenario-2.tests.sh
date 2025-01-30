#!/bin/sh
#
# About it:
# * Four set of tests to validate firewall rules:
#    1. Test to validate flow of https requests from VLAN 10 to exterior
#    2. Test to validate blockage of https requests from VLAN 20 to exterior
#    3. Test to validate flow of smtps requests from VLAN 20 to exterior
#    4. Test to validate blockage of smtps requests from VLAN 10 to exterior
#
# Parameters:
# $1 = E-mail address of the sender ("From:")
# $2 = E-mail address of the recipient ("To:")
# $3 = SMTP Relay login + password (format "account:password")
#
mySender=$SMTP_MAIL_RECEIVER
myReceiver=$SMTP_MAIL_SENDER
myRelayPass=$SMTP_RELAY_CREDENTIALS
#
echo "-----------------------------------------------" && \
echo "------------TESTS FOR HTTPS : ACCEPT------------" && \
echo "-----------------------------------------------"
testPID=$( docker container exec firwll-1 bash -c "{ tcpdump -i eth0 -n &> test-https.accept.firwll-1.log & } && echo \$!" )
echo "[firwll-1] TCP dump HTTPS PId (accept): ${testPID}"
echo -e '\n\n[firwll-1] traceroute to google.com:' \
    && docker container exec firwll-1 traceroute -I -l -v -i eth0 google.com 
echo -e '\n\n[firwll-1] nslookup of api.restful-api.dev:' \
    && docker container exec firwll-1 nslookup api.restful-api.dev 
echo -e '\n\n[workst-1] ping to jsonplaceholder.typicode.com:' \
    && docker container exec workst-1 ping -c 1 api.restful-api.dev
echo -e '\n\n[workst-1] https request to api.restful-api.dev/objects:' \
    && sleep 2 && docker container exec workst-1 curl -k -m 4 -X 'GET' 'https://api.restful-api.dev/objects' 
docker container exec firwll-1 bash -c "kill ${testPID} < <( echo '' )"
echo -e "\n\n[firwll-1] test-https.reject.firwll-1.log:" \
    && docker container exec firwll-1 cat test-https.accept.firwll-1.log
echo -e "\n\n"
#
echo "-----------------------------------------------" && \
echo "------------TESTS FOR HTTPS : REJECT------------" && \
echo "-----------------------------------------------"
testPID=$( docker container exec firwll-1 bash -c "{ tcpdump -i eth0 -n &> test-https.reject.firwll-1.log & } && echo \$!" )
echo "[firwll-1] TCP dump HTTPS PId (reject): ${testPID}"
echo -e '\n\n[workst-2] ping to api.restful-api.dev:' \
    && docker container exec workst-2 ping -c 1 api.restful-api.dev
echo -e '\n\n[workst-2] https request to api.restful-api.dev/objects:' \
    && sleep 2 && docker container exec workst-2 curl -k -m 4 -X 'GET' 'https://api.restful-api.dev/objects' 
docker container exec firwll-1 bash -c "kill ${testPID} < <( echo '' )"
echo -e "\n\n[firwll-1] test-https.reject.firwll-1.log:" \
    && docker container exec firwll-1 cat test-https.reject.firwll-1.log
echo -e "\n\n"
#
echo "-----------------------------------------------" && \
echo "-----------TESTS FOR SMTPS : ACCEPT-------------" && \
echo "-----------------------------------------------"
testPID=$( docker container exec firwll-1 bash -c "{ tcpdump -i eth0 -n &> test-smtps.accept.firwll-1.log & } && echo \$!" )
echo "[firwll-1] TCP dump SMTPS PId (accept): ${testPID}"
echo -e '\n\n[firwll-1] traceroute to gmail.com:' \
    && docker container exec firwll-1 traceroute -I -l -v -i eth0 gmail.com 
echo -e '\n\n[workst-2] ping to gmail.com:' \
    && sleep 1 && docker container exec workst-2 ping -c 1 gmail.com
echo -e '\n\n[workst-2] smtps request to gmail.com relay:' \
    && sleep 2 && docker container exec workst-2 curl -v --ssl-reqd --url 'smtp://smtp.gmail.com:587' --mail-from $mySender --mail-rcpt $myReceiver --user $myRelayPass -H 'Subject: Test Mail Send' -H "From: $mySender" -H "To: $myReceiver" -F '=(;type=multipart/alternative' -F '= Hi, I do work Thanks for testing!;type=text/plain' -F '=)' 
docker container exec firwll-1 bash -c "kill ${testPID} < <( echo '' )"
echo -e "\n\n[firwll-1] test-smtps.accept.firwll-1.log:" \
    && docker container exec firwll-1 cat test-smtps.accept.firwll-1.log
echo -e "\n\n"
#
# TODO: Tests for SMTPS DROP
echo "-----------------------------------------------" && \
echo "-----------TESTS FOR SMTPS : DROP-------------" && \
echo "-----------------------------------------------"
echo -e "\n\n"
