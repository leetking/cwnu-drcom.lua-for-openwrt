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

start() {
    ss-redir -s $PROXY_SERVER -p $PROXY_PORT -l $LOCAL_PORT -m $METHOD -k "$PASSWD" -b 0.0.0.0 &

    iptables -t nat -N PROXY
    iptables -t nat -A PROXY -d $PROXY_SERVER -j RETURN
    iptables -t nat -A PROXY -d 192.168.0.0/16 -j RETURN
    iptables -t nat -A PROXY -d 10.0.0.0/8 -j RETURN
    iptables -t nat -A PROXY -d 127.0.0.0/8 -j RETURN

    iptables -t nat -A PROXY -p tcp --dport 443 -j  RETURN
    #iptables -t nat -A PROXY -p tcp --dport 80 -m string --to 512 --algo bm --icase --string ".jpg" -j RETURN
    #iptables -t nat -A PROXY -p tcp --dport 80 -m string --to 512 --algo bm --icase --string ".png" -j RETURN
    #iptables -t nat -A PROXY -p tcp --dport 80 -m string --to 512 --algo bm --icase --string ".webp" -j RETURN
    #iptables -t nat -A PROXY -p tcp --dport 80 -m string --to 512 --algo bm --icase --string ".gif" -j RETURN
    iptables -t nat -A PROXY -p tcp -j  REDIRECT --to-ports $LOCAL_PORT

    iptables -t nat -I PREROUTING -i $INFACE -j PROXY
}

restart() {
    :
}
stop() {
    :
}
status() {
    ps | grep "ss-redir"
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
