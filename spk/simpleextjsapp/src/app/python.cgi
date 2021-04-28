#!/usr/bin/python

import os, sys

print("Content-type: text/html\n")

f = os.popen('/usr/syno/synoman/webman/modules/authenticate.cgi','r')
user = f.read()

if len(user)>0:
    print("User authenticated : "+user)
else:
    print ("No user authenticated")

