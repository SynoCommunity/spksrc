#!/usr/bin/python

import os, sys

print("Content-type: application/json\n")

f = os.popen('/usr/syno/synoman/webman/modules/authenticate.cgi','r')
user = f.read()

# check user is authenticated
if len(user)>0:
    # fake API return json data
    print('{ \
    "result": [{ \
        "identifier": 1, \
        "title": "Elle", \
        "description": "Mode magazine" \
    }, { \
        "identifier": 2, \
        "title": "Wired", \
        "description": "Geek magazine" \
    }, { \
        "identifier": 3, \
        "title": "Hack.io", \
        "description": "Hacking magazine" \
    }], \
    "success": true, \
    "total": 3 \
}')
# reject in case of no authentication
else:
    print ("Security : no user authenticated")
