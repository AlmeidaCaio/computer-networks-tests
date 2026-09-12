#!/bin/sh
#
# Code Snippet for SNMP Agent (Net-SNMP) installation inside the Alpine Container
#    NOTE: test with net-snmp-tools, e.g. "snmpwalk -v 3 -l authPriv -u user_snmp -a SHA-256 -A auth-password -x AES-256 -X priv-password -t 5 hostname 1.3.6.1.2.1"
#
# References:
#    - https://wiki.alpinelinux.org/wiki/Obtaining_user_information_via_SNMP#Configure_net-snmp
#    - https://linux.die.net/man/5/snmpd.conf
#
#
# Parameters:
# $1 = Expects global parameter from .env named SNMPV3_MAIL
# $2 = Expects global parameter from .env named SNMPV3_AUTHTYPE
# $3 = Expects global parameter from .env named SNMPV3_AUTHPASS
# $4 = Expects global parameter from .env named SNMPV3_PRIVTYPE
# $5 = Expects global parameter from .env named SNMPV3_PRIVPASS
# $6 = Expects global parameter from .env named SNMPV3_USER
#
myMail=$1
snmpAuthAlg=$2
snmpAuthKey=\"$3\"
snmpPrivAlg=$4
snmpPrivKey=\"$5\"
snmpUser=$6
! [ $( apk list -I | grep -E '^openrc-.+\s\{openrc\}' | wc -l ) -gt 0 ] && { apk add openrc ; }
! [ $( apk list -I | grep -E '^net-snmp-.+\s\{net-snmp\}' | wc -l ) -gt 0 ] && { apk add net-snmp ; }
rc-service snmpd zap \
    && sed -E -i 's/^(agentAddress\s+udp:127\.0\.0\.1:161)/#\1/g' /etc/snmp/snmpd.conf \
    && sed -E -i 's/^#(agentAddress\s+udp:161,udp6:\[::1\]:161)/\1/g' /etc/snmp/snmpd.conf \
    && sed -E -i "s/^#\\s*createUser\\s+authPrivUser\\s+\\b.*$/createUser ${snmpUser} ${snmpAuthAlg} ${snmpAuthKey} ${snmpPrivAlg} ${snmpPrivKey}/g" /etc/snmp/snmpd.conf \
    && sed -E -i 's/^\s*#\s*system\s*\+\s*hrSystem\s+groups\s+only.*$/view   systemonly  included   .1.3.6.1.2.1.14/g' /etc/snmp/snmpd.conf \
    && sed -E -i 's/^\s*(rocommunity\s+public\s+default\s+-V\s+systemonly)/#\1/g' /etc/snmp/snmpd.conf \
    && sed -E -i "s/^\s*rouser\s+authOnlyUser\s*$/rouser ${snmpUser} priv -V systemonly/g" /etc/snmp/snmpd.conf \
    && sed -E -i 's/^sysLocation\s+(\b.*)$/sysLocation  "local PC"/g' /etc/snmp/snmpd.conf \
    && sed -E -i "s/^sysContact\\s+(\\b.*)$/sysContact  Me <${myMail}>/g" /etc/snmp/snmpd.conf \
    && sed -E -i 's/^sysServices\s+(\b.*)$/sysServices  15/g' /etc/snmp/snmpd.conf \
    && sed -E -i 's/^\s*(trapsink\s+localhost\s+public)$/#\1/g' /etc/snmp/snmpd.conf \
    && sed -E -i "s/^\s*iquerySecName\\s+internalUser/iquerySecName ${snmpUser}/g" /etc/snmp/snmpd.conf \
    && sed -E -i "s/^\s*rouser\\s+internalUser/rouser ${snmpUser}/g" /etc/snmp/snmpd.conf \
    && rc-service --verbose snmpd start 
! [ -d /run/openrc ] && { mkdir /run/openrc && touch /run/openrc/softlevel ; } \
    && rc-status --all \
    && rc-service --verbose snmpd restart
