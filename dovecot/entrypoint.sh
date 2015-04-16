#!/bin/bash

cat /etc/postfix/master-additional.cf >> /etc/postfix/master.cf

mkdir /etc/postfix/tmp; awk < /etc/postfix/virtual '{ print $2 }' > /etc/postfix/tmp/virtual-receivers
sed -r 's,(.+)@(.+),\2/\1/,' /etc/postfix/tmp/virtual-receivers > /etc/postfix/tmp/virtual-receiver-folders
paste /etc/postfix/tmp/virtual-receivers /etc/postfix/tmp/virtual-receiver-folders > /etc/postfix/virtual-mailbox-maps

postmap /etc/postfix/virtual
postmap /etc/postfix/virtual-mailbox-maps

chown -R vmail:vmail /srv/vmail; service rsyslog start; service postfix start; dovecot -F
