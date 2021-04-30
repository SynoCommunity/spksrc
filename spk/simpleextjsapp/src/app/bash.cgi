#!/bin/bash

echo -e "Content-type: text/html\n\n"

USER=$(/usr/syno/synoman/webman/modules/authenticate.cgi)

if [ "${USER}" = "" ]; then
  echo -e "User not authenticated\n"
else
  echo -e "User authenticated : ${USER}\n"
fi
