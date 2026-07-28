#!/bin/bash

echo -e "Content-type: application/json\n\n"

USER=$(/usr/syno/synoman/webman/modules/authenticate.cgi)

if [ "${USER}" = "" ]; then
  echo -e "Security : user not authenticated\n"
else
  echo -e '{"result": ['
  RATES="`curl -sS  "https://api.freecurrencyapi.com/v1/latest?apikey=TqJmBqGId4ua1XmnUbOaB5Osfu5CwML8eVAD1Mul&currencies=EUR%2CUSD%2CCAD" | jq '.data | to_entries[] '`"
  echo -e $RATES | sed -En 's/}/},/gp' | sed 's/,$//'
  echo -e '], "success": true, "total":3 }'
fi

