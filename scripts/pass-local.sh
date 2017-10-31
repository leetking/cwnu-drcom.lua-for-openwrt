#!/bin/sh

# A part of Drcom4CWNU
# GPL v2
# (C) leetking <li_Tking@163.com>

INFACE=br-lan
LOCAL_PORT="1080"

PROXY_SERVER="192.168.1.1"
PROXY_PORT="2333"
METHOD="rc4-md5"
PASSWD="password"

SS_PID=/tmp/ss-redir.pid

start_ss_as_daemon() {
    #while :; do
    #    # wait for that ss-redir crashs
    #    echo "runing ss-redir ..."
    #    ss-redir -s $PROXY_SERVER -p $PROXY_PORT -l $LOCAL_PORT -m $METHOD -k "$PASSWD" -b 0.0.0.0
    #    echo "ss-redir restart."

    #    sleep 1
    #done &  # put while into background

    ss-redir -s $PROXY_SERVER -p $PROXY_PORT -l $LOCAL_PORT -m $METHOD -k "$PASSWD" -b 0.0.0.0 \
        -f $SS_PID &
}

start() {
    start_ss_as_daemon

    iptables -t nat -N PROXY
    iptables -t nat -A PROXY -d $PROXY_SERVER -j RETURN
    iptables -t nat -A PROXY -d 192.168.0.0/16 -j RETURN
    iptables -t nat -A PROXY -d 10.0.0.0/8 -j RETURN
    iptables -t nat -A PROXY -d 127.0.0.0/8 -j RETURN

    #local http_ports="80 8080 8081 8008 8090 3128"
    #for port in $http_ports; do
    #    iptables -t nat -A PROXY -p tcp --dport $port -j REDIRECT --to-ports $LOCAL_PORT
    #done

    iptables -t nat -A PROXY -p tcp --dport 443 -j  RETURN
    iptables -t nat -A PROXY -p tcp -j  REDIRECT --to-ports $LOCAL_PORT

    iptables -t nat -I PREROUTING -i $INFACE -j PROXY
}

restart() {
    kill `cat $SS_PID`
    sleep 1
}
stop() {
    kill `cat $SS_PID`
    iptables -t nat -F PROXY
    iptables -t nat -D PREROUTING 1
    iptables -t nat -X PROXY
}
status() {
    ps | grep "ss-redir" | grep -v grep
    iptables -t nat -S PROXY -v
}

help() {
    echo "pass-local.sh [start|restart|stop|status]"
}

case "$1" in
    start)   start ;;
    stop)    stop  ;;
    restart) restart ;;
    status)  status ;;
    *)       help ;;
esac
