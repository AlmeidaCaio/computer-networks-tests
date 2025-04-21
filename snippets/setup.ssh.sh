#!/bin/sh
#
# Code Snippet for SSH Server (OpenSSH) installation inside the Alpine Container
#
# References:
#    - https://wiki.alpinelinux.org/wiki/Setting_up_a_SSH_server#Service_commands
#    - https://man.openbsd.org/sshd_config
#    - https://serverfault.com/questions/1015547/what-causes-ssh-error-kex-exchange-identification-connection-closed-by-remote
#
#
ENABLE_SSH_WIDEOPEN="1"
apk add openrc \
    openssh  \
&& [ $ENABLE_SSH_WIDEOPEN == "1" ] && {
    rc-service sshd zap \
    && sed -E -i 's/^(Include\s*\/etc\/ssh\/sshd_config\.d)/#\1/g' /etc/ssh/sshd_config \
    && sed -E -i 's/^#(Port\s*22)/\1/g' /etc/ssh/sshd_config \
    && sed -E -i 's/^#(AddressFamily\s*any)/\1/g' /etc/ssh/sshd_config \
    && sed -E -i 's/^#PermitRootLogin\s*prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config \
    && sed -E -i 's/^#(StrictModes\s*yes)/\1/g' /etc/ssh/sshd_config \
    && sed -E -i 's/^#MaxAuthTries\s*6/MaxAuthTries 3/g' /etc/ssh/sshd_config \
    && sed -E -i 's/^#MaxSessions\s*10/MaxSessions 1/g' /etc/ssh/sshd_config \
    && sed -E -i 's/^#(PasswordAuthentication\s*yes)/\1/g' /etc/ssh/sshd_config \
    && sed -E -i 's/^#PermitEmptyPasswords\s*no/PermitEmptyPasswords yes/g' /etc/ssh/sshd_config \
    && sed -E -i 's/^#?AllowTcpForwarding\s*no/AllowTcpForwarding yes/g' /etc/ssh/sshd_config \
    && sed -E -i 's/^#(UseDNS\s*no)/\1/g' /etc/ssh/sshd_config \
    && sh -c "echo -e '\nAllowUsers root' >> /etc/ssh/sshd_config" \
    && sh -c "echo ssh >> /etc/securetty" \
    && sh -c "passwd < <( echo -e -n '\n\n' )" \
    && rc-service sshd start
    ! [ -d /run/openrc ] && { mkdir /run/openrc && touch /run/openrc/softlevel ; } \
    && rc-status --all \
    && rc-service --verbose sshd restart
}
