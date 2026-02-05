from functools import wraps
from flask import request, Response
import os
import re

def get_credentials():
    """Get auth credentials from haproxy.cfg stats auth line.
    Falls back to environment variables if not found."""
    haproxy_cfg = os.environ.get('HAPROXY_CFG', '/var/packages/haproxy/var/haproxy.cfg')
    username = 'admin'
    password = 'admin'
    
    try:
        with open(haproxy_cfg, 'r') as f:
            for line in f:
                match = re.match(r'^\s*stats\s+auth\s+(\S+):(\S+)', line)
                if match:
                    username = match.group(1)
                    password = match.group(2)
                    break
    except (FileNotFoundError, IOError):
        pass
    
    return username, password

def check_auth(username, password):
    expected_user, expected_pass = get_credentials()
    return username == expected_user and password == expected_pass

def authenticate():
    return Response(
        'Could not verify your access level for that URL.\n'
        'You have to login with proper credentials', 401,
        {'WWW-Authenticate': 'Basic realm="Login Required"'})

def requires_auth(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        auth = request.authorization
        if not auth or not check_auth(auth.username, auth.password):
            return authenticate()
        return f(*args, **kwargs)
    return decorated

def setup_auth(app):
    # Placeholder for future auth setup if needed
    pass
