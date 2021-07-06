#!/bin/bash

echo -e "Content-type: application/json\n\n"

USER=$(/usr/syno/synoman/webman/modules/authenticate.cgi)

if [ "${USER}" = "" ]; then
  echo -e "Security : user not authenticated\n"
else
  echo -e '{"result": ['
  RATES="`curl -sS  https://api.ratesapi.io/api/latest| jq '.rates | to_entries[
] '`"
  echo -e $RATES | sed -En 's/}/},/gp' | sed 's/,$//'
  echo -e '], "success": true, "total":32 }'
fi

