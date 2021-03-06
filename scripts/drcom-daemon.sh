#!/bin/sh /etc/rc.common

# Drcom4CWNU deamon process
# GPL v2
# (C) leetking <li_Tking@163.com>
# locate at /etc/init.d/drcom-daemon

PATH=$PATH:/etc/init.d/:/overlay/Drcom4CWNU

DRCOM_SH=/etc/init.d/drcom.sh

#record status
SLEEPTIME=60
RECONCNT=0

isconnect() {
    local url=baidu.com
    local ping_cnt=3

    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>"
    echo "Now detecting networking..."
    date
    local i=0
    while [ $i -lt ${ping_cnt} ]; do
        #ping -q -c 2 -W 3 ${url} > /dev/null 2> /dev/null
        ping -c 2 -W 3 ${url}
        s=$?
        echo "isconnect $i: ping -c 2 -W 3 ${url} | $s"
        if [ 0 == $s ]; then
            return 0
        fi
        i=`expr $i + 1`
    done
    return 1
}

tx_some_file() {
    local DOWNLOAD_CNT=10
    local i=0
    while [ $i -lt ${DOWNLOAD_CNT} ]; do
        #echo "wget -q http://www.baidu.com/ -O /dev/null"
        wget -q http://www.baidu.com/ -O /dev/null
        i=`expr $i + 1`
    done
    return 0
}

drcom_daemon() {
    if isconnect; then
        SLEEPTIME=60
        RECONCNT=0
        tx_some_file
        #sleep 7 mins
        sleep 420
    else
        RECONCNT=`expr ${RECONCNT} + 1`
        echo "${RECONCNT}-th restarting Drcom4CWNU ..."
        ${DRCOM_SH} start
        echo "sleep ${SLEEPTIME}s..."
        sleep ${SLEEPTIME}
        if [ ${RECONCNT} -gt 2 -a ${SLEEPTIME} -lt 86400 ]; then
            SLEEPTIME=`expr ${SLEEPTIME} + ${SLEEPTIME}`
        fi
    fi
}

go() {
    while true; do
        drcom_daemon
    done > /tmp/drcom-daemon.log &
}

# generate a random mac address
set_random_mac() {
    local mac=`random_mac`
    echo "mac is $mac"
    # if has wan_dev, modify macaddr at there.
    if uci get network.wan_dev.macaddr > /dev/null; then
        uci set network.wan_dev.macaddr="$mac"
    fi
    uci set network.wan.macaddr="$mac"
    uci commit network
    uci export network
    # Now, you can retire.
    #sed -i "/'wan'/,/^\s*$/{/.*macaddr.*/d}; /'wan'/a\ option macaddr '${mac}'" ${networkrc}
}

start() {
    # random mac
    set_random_mac > /tmp/random-mac.log
    network restart

    # Go!!
    go
}

