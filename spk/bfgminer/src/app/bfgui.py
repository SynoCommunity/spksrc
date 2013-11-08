#!/usr/local/bin/python
# Copyright(c) 2012, 2013 Jonathan Poland

import os
import json
import socket
import time
import subprocess
from bottle import route, view, run, template, request, redirect, static_file
import bottle

bottle.TEMPLATE_PATH.insert(0, '/usr/local/bfgminer/app/views/') 

class Process(object):
    def __init__(self, args, shell=False, env=None):
        handle = subprocess.Popen(args, stdin=open(os.devnull, 'r'), stdout=subprocess.PIPE, 
                                  stderr=subprocess.PIPE, close_fds=True, shell=shell, env=env)
        self.stdout, self.stderr = handle.communicate()
        self.retval = handle.wait()

def require_auth(fn):
    def check_auth(**kwargs):   
        environment = {k: v for k,v in request.environ.iteritems() if isinstance(v, basestring)}
        authcgi = Process(['/usr/syno/synoman/webman/modules/authenticate.cgi'], env=environment)
        if authcgi.stdout:
            return fn(**kwargs)
        else:
            return "Not authorized"
    return check_auth

def status():
    retval = None
    pids = [pid for pid in os.listdir('/proc') if pid.isdigit()]
    for pid in pids:
        try:
            cmdline = open(os.path.join('/proc', pid, 'cmdline'), 'rb').read()
            if 'bfgminer' in cmdline:
                retval = 'Mining'
            elif 'bfgui' in cmdline and retval is None:
                retval = 'Idle'
        except IOError:
            pass
    return retval or 'Not running'

@route('/static/<filepath:path>')                   
def static(filepath):                                                                       
    return static_file(filepath, root='/usr/local/bfgminer/app/static/') 

@route('/')
@require_auth
@view('index')
def index():
    return {'request':request, 'alert':None, 'status':status()}
     
@route('/log')
@route('/log/<numlines:int>')
@require_auth
@view('log')
def log(numlines = 100):
    logdata = open(os.path.join(spglib.PKGDIR, 'spg.log')).readlines()[-numlines:]
    return {'request':request, 'status':status(), 'logdata':logdata, 'numlines':numlines}     

@route('/about')
@require_auth
@view('about')
def about():
    return {'request':request, 'status':status()}

@route('/', method='post')
@require_auth
@view('index')
def start():
    cmds = [x for x in request.POST.getall('todo')] + ['commentsync']
    jsoncmds = json.dumps(cmds)
    try:
        sock = socket.socket(socket.AF_UNIX, socket.SOCK_DGRAM)
        sock.sendto(jsoncmds, '/tmp/spg.socket')
    except Exception, e:
        alert = 'Error starting run: {0}'.format(e)
    else:
        alert = 'Run started'
        time.sleep(2) # Wait long enough for subprocess to be started by spg.py
    return {'request':request, 'alert':alert, 'status':status()}

run(host='0.0.0.0', port=1072)

