#!/bin/sh

# A part of Drcom4CWNU.
# check and update program to keep up to date.
# GPL v2
# (C) leetking <li_Tking@163.com>

PATH=$PATH:/overlay/Drcom4CWNU

# check peroid, second.
PERIOD=1800

while :; do
    date
    update.sh
    sleep $PERIOD
done > /tmp/update-daemon.sh &
