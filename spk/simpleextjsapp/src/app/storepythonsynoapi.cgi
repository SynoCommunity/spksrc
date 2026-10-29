#!/usr/bin/python

import os, sys
import subprocess

print("Content-type: application/json\n")

f = os.popen('/usr/syno/synoman/webman/modules/authenticate.cgi','r')
user = f.read()


# check user is authenticated
if len(user)>0:
    # API returning json data : list of installed packages
    print ('{"result": [', end='')
    first=True
    packages = subprocess.check_output(["/usr/syno/bin/synopkg list"], shell=True)
    list = packages.decode()
    details = list.split("\n")

    no = 1
    for lines in range(len(details)):
        items = details[lines].split(":")
        newline = 0
        for n in range(len(items)):
            field0 = '{ "identifier": '+str(no)
            if (newline == 0):
                field1 = ', "pkg_name": "'+items[n]+'"'
            elif (newline == 1):
                field2 = ', "pkg_desc": "'+items[n]+'" }' 
                if (lines != len(details)-2):
                    print (field0 + field1 + field2 + ',')
                else:
                    print (field0 + field1 + field2)
            newline = newline + 1
        no=no+1

    print ('],', end='')
    print ('"success": true,', end='')
    print ('"total": ', len(details), end='')
    print ('}')

# reject in case of no authentication
else:
    print ("Security : no user authenticated")
