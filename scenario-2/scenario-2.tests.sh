#!/bin/sh
#
# TODO: Colocar testes de validação - camada 4

# Tests for HTTP ACCEPT
externalIP1="`ping -c 1 -4 jsonplaceholder.typicode.com \
    | grep -E '([0-9]{1,3}\.){3}[0-9]{1,3}' \
    | head -n 1 \
    | sed -E 's/.*[^0-9]+([0-9]{1,3}[.][0-9]{1,3}[.][0-9]{1,3}[.][0-9]{1,3}).*/\1/'`"
httpTestPID=$( docker container exec firwll-1 bash -c "{ tcpdump -i eth0 -n &> test-http.accept.firwll-1.log & } && echo \$!" )
echo "[firwll-1] TCP dump PId (accept): ${httpTestPID}"
curl -X 'GET' "https://jsonplaceholder.typicode.com/todos/1"


docker container exec workst-2 bash -c "{ nc -v -l -p 80 &> test-http.accept.workst-2.log & } < <( echo -e '\n\n' )"
docker container exec workst-1 bash -c "curl -v -s -k -X 'HEAD' -H 'Content-Type: text/plain' 'http://172.16.2.3:80' &> test-http.accept.workst-1.log" 
docker container exec firwll-1 bash -c "kill ${httpTestPID} < <( echo '' )"
echo '' && echo "[workst-1] test-http.accept.workst-1.log:" && docker container exec workst-1 cat test-http.accept.workst-1.log
echo '' && echo "[workst-2] test-http.accept.workst-2.log:" && docker container exec workst-2 cat test-http.accept.workst-2.log
echo '' && echo "[firwll-1] test-http.accept.firwll-1.log:" && docker container exec firwll-1 cat test-http.accept.firwll-1.log

# Tests for HTTP REJECT - TODO: Must block connection
httpTestPID=$( docker container exec firwll-1 bash -c "{ tcpdump -i eth0 -n &> test-http.reject.firwll-1.log & } && echo \$!" )
echo "[firwll-1] TCP dump PId (reject): ${httpTestPID}"
docker container exec workst-1 bash -c "{ nc -v -l -p 80 &> test-http.reject.workst-1.log & } < <( echo -e '\n\n' )"
docker container exec workst-2 bash -c "curl -v -s -k -X 'HEAD' -H 'Content-Type: text/plain' 'http://172.16.1.3:80' &> test-http.reject.workst-2.log" 
docker container exec firwll-1 bash -c "kill ${httpTestPID} < <( echo '' )"
echo '' && echo "[workst-2] test-http.reject.workst-2.log:" && docker container exec workst-2 cat test-http.reject.workst-2.log
echo '' && echo "[workst-1] test-http.reject.workst-1.log:" && docker container exec workst-1 cat test-http.reject.workst-1.log
echo '' && echo "[firwll-1] test-http.reject.firwll-1.log:" && docker container exec firwll-1 cat test-http.reject.firwll-1.log
