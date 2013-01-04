#!/bin/sh

REMOTE_NAME=$1
IRCOMMAND=$2
REPEAT=1

if [ $# -eq 3 ]; then
    REPEAT=$3
fi

X=0
while [ $X -lt $REPEAT ]; do
    /var/packages/lirc/target/bin/irsend SEND_ONCE $REMOTE_NAME $IRCOMMAND
    X=$((X+1))
    sleep 0.3
done

