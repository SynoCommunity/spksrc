#!/usr/local/nzbconfig/env/bin/python
from application.auth import requires_auth
from application.direct import Base
from flask import Flask, request, Response
from pyextdirect.api import create_api
from pyextdirect.router import Router
from wsgiref.handlers import CGIHandler


app = Flask('nzbconfig')


@app.route('/direct/router', methods=['POST'])
@requires_auth(groups=['administrators'])
def route():
    router = Router(Base)
    return Response(router.route(request.json or dict((k, v[0] if len(v) == 1 else v) for k, v in request.form.to_dict(False).iteritems())), mimetype='application/json')


@app.route('/direct/api')
@requires_auth(groups=['administrators'])
def api():
    return create_api(Base)


if __name__ == '__main__':
    CGIHandler().run(app)
