#!/bin/sh /etc/rc.common

# post `uname' and `pwd' from /etc/config/drcomrc to `/overlay/Drcom4CWNU/drcomrc'
# GPL v2
# (C) leetking <li_Tking@163.com>
# locate at /overlay/Drcom4CWNU/wr2drcomrc.sh

CONFIG_NAME=drcomrc
SECTION_NAME=setting
DRCOMRC=/overlay/Drcom4CWNU/config.lua

parse_conf() {
    local uname
    local paswd
    local net_
    local ser
    config_get uname $1 username
    config_get paswd $1 password
    config_get net_  $1 net
    config_get ispc_ $1 ispc
    echo "usr: $uname"
    echo "pwd: $paswd"
    echo "net: $net_"
    echo "pc?: $ispc_"
    if [ -e ${DRCOMRC} ]; then
        sed -i "/usr/s/\"[^\"]*\"/\"${uname}\"/"    ${DRCOMRC}
        sed -i "/pwd/s/\"[^\"]*\"/\"${paswd}\"/"    ${DRCOMRC}
        sed -i "/net/s/\"[^\"]*\"/\"${net_}\"/"     ${DRCOMRC}
        sed -i "/ispc/s/\"[^\"]*\"/\"${ispc_}\"/"   ${DRCOMRC}
    fi
}

start() {
    config_load $CONFIG_NAME
    config_foreach parse_conf $SECTION_NAME
}
