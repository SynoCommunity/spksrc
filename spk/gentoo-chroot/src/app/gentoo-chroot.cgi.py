#!/usr/local/gentoo-chroot/env/bin/python
from application.auth import requires_auth
from application.direct import Base, Overview
from flask import Flask, request, Response
from pyextdirect.api import create_api
from pyextdirect.router import Router
from wsgiref.handlers import CGIHandler
import json


app = Flask('gentoo-chroot')


@app.route('/direct/router', methods=['POST'])
@requires_auth(groups=['administrators'])
def route():
    router = Router(Base)
    return Response(router.route(request.json or dict((k, v[0] if len(v) == 1 else v) for k, v in request.form.to_dict(False).iteritems())), mimetype='application/json')


@app.route('/direct/poller', methods=['GET'])
@requires_auth(groups=['administrators'])
def poll():
    overview = Overview()
    event = {'type': 'event', 'name': 'status', 'data': {
             'installed': 'installed' if overview.is_installed() else 'installing',
             'running_services': overview.running_services()}}
    return Response(json.dumps(event), mimetype='application/json')


@app.route('/direct/api')
@requires_auth(groups=['administrators'])
def api():
    return create_api(Base)


if __name__ == '__main__':
    CGIHandler().run(app)
