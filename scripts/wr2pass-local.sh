#!/bin/sh /etc/rc.common

# transfer infermation from /etc/config/drcomrc to command `/usr/bin/pass-local.sh'
# GPL v2
# (C) leetking <li_Tking@163.com>
# locate at /overlay/Drcom4CWNU/wr2pass-local.sh

CONFIG_NAME=drcomrc
SECTION_NAME=setting
PASS_LOCAL=/usr/bin/pass-local.sh

parse_conf() {
    local _proxy
    local _proxy_port
    local _method
    local _proxy_pwd
    config_get _proxy      $1 proxy
    config_get _proxy_port $1 proxy_port
    config_get _method     $1 method
    config_get _proxy_pwd  $1 proxy_pwd
    echo "proxy:      $_proxy"
    echo "proxy_port: $_proxy_port"
    echo "method:     $_method"
    echo "proxy_pwd:  $_proxy_pwd"
    if [ -e ${PASS_LOCAL} ]; then
        sed -i "/^PROXY_SERVER/s/\"[^\"]*\"/\"${_proxy}\"/"    ${PASS_LOCAL}
        sed -i "/^PROXY_PORT/s/\"[^\"]*\"/\"${_proxy_port}\"/" ${PASS_LOCAL}
        sed -i "/^METHOD/s/\"[^\"]*\"/\"${_method}\"/"         ${PASS_LOCAL}
        sed -i "/^PASSWD/s/\"[^\"]*\"/\"${_proxy_pwd}\"/"      ${PASS_LOCAL}
    fi
}

start() {
    config_load $CONFIG_NAME
    config_foreach parse_conf $SECTION_NAME
}

