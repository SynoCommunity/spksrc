#!/usr/bin/python

import os, sys
import sqlite3

print("Content-type: application/json\n")

f = os.popen('/usr/syno/synoman/webman/modules/authenticate.cgi','r')
user = f.read()

con = sqlite3.connect('/var/packages/simpleextjsapp/home/api.db')
cur = con.cursor();

# check user is authenticated
if len(user)>0:
    # API returning json data
    print ('{"result": [', end='')
    first=True
    for id, title, desc in con.execute('SELECT identifier, title, description FROM magazines ORDER BY identifier').fetchall():
        if (first!=True):
            print(', ',end='')
        print('{ "identifier": %s, "title": "%s", "description": "%s" }' % (id, title, desc), end='')
        first=False
    print ('],', end='')
    print ('"success": true,', end='')
    print ('"total": 3', end='')
    print ('}')

# reject in case of no authentication
else:
    print ("Security : no user authenticated")

con.close()

