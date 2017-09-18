#!/bin/sh

# A part of Drcom4CWNU.
# check and update program to keep up to date.
# GPL v2
# (C) leetking <li_Tking@163.com>

PATH=$PATH:/overlay/Drcom4CWNU

APP=Drcom4CWNU

URL=http://119.23.218.41/pkgs/$APP
ver=""
ver1=""

CFG=/etc/config/drcomrc

check() {
    ver1=`opkg list $APP | awk '{print $3}'`
    wget -q $URL/version.txt -O /tmp/$APP.ver
    ver=`head -1 /tmp/$APP.ver | grep -o '[0-9]\.[0-9]\.[0-9]\.[0-9][a-z-]\+' 2> /dev/null`
    rm -f /tmp/$APP.ver
    if [ "" == "$ver" ]; then
        echo "Download file \`version.txt' fail."
        return 1
    fi
    if [ "x$ver1" != "x$ver" ]; then
        return 0
    else
        return 1
    fi
}

update() {
    echo "wget -q $URL/$APP-$ver.ipk -O $APP-$ver.ipk"
    wget -q $URL/$APP-$ver.ipk -O /tmp/$APP-$ver.ipk

    # backup file
    cp $CFG /tmp/drcomrc-$$
    # install new pkg
    opkg install /tmp/$APP-$ver.ipk
    rm -r $CFG
    cp /tmp/drcomrc-$$ $CFG
    # recovery config file
    wr2drcomrc.sh       start
    wr2wireless.sh      start
    wr2pass-local.sh    start
    # clear
    rm -f /tmp/drcomrc-$$
    rm -f /tmp/$APP-$ver.ipk
}

# GO!!
if check; then
    echo "Update $APP ($ver1 -> $ver) ..."
    update
    opkg list $APP
    echo "Update done."
    echo ""
else
    echo "$APP is up of date."
    echo ""
fi
