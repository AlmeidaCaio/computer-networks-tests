#!/bin/sh
#
# TODO: Colocar testes de validação - camada 4
externalIP1="`ping -c 1 -4 jsonplaceholder.typicode.com \
    | grep -E '([0-9]{1,3}\.){3}[0-9]{1,3}' \
    | head -n 1 \
    | sed -E 's/.*[^0-9]+([0-9]{1,3}[.][0-9]{1,3}[.][0-9]{1,3}[.][0-9]{1,3}).*/\1/'`"

# Tests for HTTP ACCEPT
httpTestPID=$( docker container exec firwll-1 bash -c "{ tcpdump -i eth0 -n &> test-http.accept.firwll-1.log & } && echo \$!" )
echo "[firwll-1] TCP dump PId (accept): ${httpTestPID}"
docker container exec firwll-1 traceroute -I -l -v -i eth0 google.com 
docker container exec workst-1 ping -c 1 jsonplaceholder.typicode.com
docker container exec workst-1 curl -X 'GET' "https://jsonplaceholder.typicode.com/todos/1"
docker container exec firwll-1 bash -c "kill ${httpTestPID} < <( echo '' )"
echo '' && echo "[firwll-1] test-http.reject.firwll-1.log:" && docker container exec firwll-1 cat test-http.accept.firwll-1.log

# TODO: Tests for HTTPS DROP

# TODO: Tests for SSH ACCEPT

# TODO: Tests for SSH DROP
