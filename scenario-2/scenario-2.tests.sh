#!/bin/sh
#
# Tests for HTTPS ACCEPT
echo "-----------------------------------------------" && \
echo "------------TESTS FOR HTTP : ACCEPT------------" && \
echo "-----------------------------------------------"
httpTestPID=$( docker container exec firwll-1 bash -c "{ tcpdump -i eth0 -n &> test-http.accept.firwll-1.log & } && echo \$!" )
echo "[firwll-1] TCP dump PId (accept): ${httpTestPID}"
echo -e '\n\n[firwll-1] traceroute to google.com:' \
    && docker container exec firwll-1 traceroute -I -l -v -i eth0 google.com 
echo -e '\n\n[firwll-1] nslookup of api.restful-api.dev:' \
    && docker container exec firwll-1 nslookup api.restful-api.dev 
echo -e '\n\n[workst-1] ping to jsonplaceholder.typicode.com:' \
    && docker container exec workst-1 ping -c 1 api.restful-api.dev
echo -e '\n\n[workst-1] http request to api.restful-api.dev/objects:' \
    && sleep 2 && docker container exec workst-1 curl -k -m 4 -X 'GET' 'https://api.restful-api.dev/objects' 
docker container exec firwll-1 bash -c "kill ${httpTestPID} < <( echo '' )"
echo -e "\n\n[firwll-1] test-http.reject.firwll-1.log:" \
    && docker container exec firwll-1 cat test-http.accept.firwll-1.log
echo -e "\n\n"
#
# Tests for HTTPS DROP - curl will give timeout
echo "-----------------------------------------------" && \
echo "------------TESTS FOR HTTP : REJECT------------" && \
echo "-----------------------------------------------"
httpTestPID=$( docker container exec firwll-1 bash -c "{ tcpdump -i eth0 -n &> test-http.drop.firwll-1.log & } && echo \$!" )
echo "[firwll-1] TCP dump PId (drop): ${httpTestPID}"
echo -e '\n\n[workst-2] ping to api.restful-api.dev:' \
    && docker container exec workst-2 ping -c 1 api.restful-api.dev
echo -e '\n\n[workst-2] http request to api.restful-api.dev/objects:' \
    && sleep 2 && docker container exec workst-2 curl -k -m 4 -X 'GET' 'https://api.restful-api.dev/objects' 
docker container exec firwll-1 bash -c "kill ${httpTestPID} < <( echo '' )"
echo -e "\n\n[firwll-1] test-http.drop.firwll-1.log:" \
    && docker container exec firwll-1 cat test-http.drop.firwll-1.log
echo -e "\n\n"
#
# TODO: Tests for SSH ACCEPT
echo "-----------------------------------------------" && \
echo "------------TESTS FOR SSH : ACCEPT-------------" && \
echo "-----------------------------------------------"
echo -e "\n\n"
#
# TODO: Tests for SSH DROP
echo "-----------------------------------------------" && \
echo "------------TESTS FOR SSH : REJECT-------------" && \
echo "-----------------------------------------------"
echo -e "\n\n"
