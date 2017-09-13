#!/bin/sh

go_as_daemon() {
    # sleep 30 minutes to wait ntpd work successfully.
    sleep 1800

    # reboot at 04:00 PM
    local at=4

    while :; do
        now=`date +'%H'`
        if [ "$at" = "$now" ]; then
            echo "reboot at `date`"
            reboot
        fi
        sleep 2
    done > /tmp/autoreboot.log &
}

Usage() {
    echo "Usage: autoreboot.sh {start|help}"
    echo "       autoreboot at 04:00 PM, ervery day."
}

case "$1" in
    start) go_as_daemon ;;
    *) Usage ;;
esac

