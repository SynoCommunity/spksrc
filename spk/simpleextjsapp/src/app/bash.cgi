#!/bin/bash

echo -e "Content-type: text/html\n\n"

USER=$(/usr/syno/synoman/webman/modules/authenticate.cgi)

if [ "${USER}" = "" ]; then
  echo -e "Security : user not authenticated\n"
else
  echo -e "Security : user authenticated ${USER}\n"
fi
