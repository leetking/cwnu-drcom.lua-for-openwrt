#!/bin/sh /etc/rc.common

# wrap of `/overlay/Drcom4CWNU/drcom' for `/etc/init.d/drcom.sh',
# write for openwrt to implement auto-login
# GPL v2
# (C) leetking <li_Tking@163.com>
# locate at /etc/init.d/drcom.sh

Drcom4CWNU_PATH=/overlay/Drcom4CWNU

START=98

start() {
    cd ${Drcom4CWNU_PATH}
    ./drcom
}
restart() {
    cd ${Drcom4CWNU_PATH}
    ./drcom
}
stop() {
    drcom
}
status() {
    drcom
}
