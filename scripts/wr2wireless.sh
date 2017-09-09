#!/bin/sh /etc/rc.common

# post `wifissid' and `wifipwd' from /etc/config/drcomrc to `/etc/config/wireless'
# GPL v2
# (C) leetking <li_Tking@163.com>
# locate at /overlay/Drcom4CWNU/wr2wireless.sh

DRCOMRC=drcomrc
SECTION_NAME=setting
PATH=$PATH:/sbin/

parse_conf() {
    local wifissid
    local wifipwd
    config_get wifissid $1 wifissid
    config_get wifipwd $1 wifipwd
    echo "wifissid: '$wifissid'"
    echo "wifipwd : '$wifipwd'"
    local wificnt=`uci show wireless | grep -o "\[[0-9]\]" | uniq | wc -l`
    local i=0
    # suport 5G
    while [ $i -lt $wificnt ]; do
        uci set wireless.@wifi-iface[$i].ssid="${wifissid}"
        uci set wireless.@wifi-iface[$i].key="${wifipwd}"
        uci set wireless.@wifi-iface[$i].hidden="0"
        uci set wireless.@wifi-iface[$i].country="CN"
        uci set wireless.@wifi-iface[$i].encryption="psk2"
        echo "modify \`wireless@$i\' success!\n"
        i=`expr $i + 1`
    done
    uci commit wireless
    echo "commit \`wireless\' success!\n"
    uci export wireless
}

start() {
    config_load $DRCOMRC
    config_foreach parse_conf $SECTION_NAME
}
