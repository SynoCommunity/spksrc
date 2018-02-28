#!/bin/sh

LOG_FILE="/var/run/pam-debug.log"

usage () {
  echo "Usage:"
  echo "ykhelper debug-pam      - Tail the PAM Debug output"
  echo "ykhelper ident [OTP]    - Extract the public Identity from an Yubikey OTP"
}

case "$1" in
        debug-pam)
            if [ ! -e "$LOG_FILE" ]
            then
                touch /var/run/pam-debug.log
                chmod go+w /var/run/pam-debug.log
            fi

            echo "Starting debug output... (press STRG + C to exit)"
            tail -f -n30 /var/run/pam-debug.log
        ;;

        ident)
            if [ -z "$2" ]
            then
                read -p "Enter OTP: " s && echo "Your public Identity is: " ${s:0:12}
            else
                echo "Your public Identity is: "
                echo "$2" | cut -c1-12
            fi
        ;;

        *)
        usage
        exit 1
        ;;
esac