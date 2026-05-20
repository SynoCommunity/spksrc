from flask import Flask, render_template, send_from_directory
import os
import ssl
from routes.main_routes import main_bp
from routes.edit_routes import edit_bp
from utils.stats_utils import fetch_haproxy_stats, parse_haproxy_stats
from auth.auth_middleware import requires_auth
from log_parser import parse_log_file

app = Flask(__name__)

# Get configuration from environment variables
HAPROXY_DASHBOARD_DIR = os.environ.get('HAPROXY_DASHBOARD_DIR', '/var/packages/haproxy/var')
HAPROXY_CERT = os.environ.get('HAPROXY_CERT', os.path.join(HAPROXY_DASHBOARD_DIR, 'crt/default.pem'))
HAPROXY_LOG = os.environ.get('HAPROXY_LOG', os.path.join(HAPROXY_DASHBOARD_DIR, 'http-access.log'))
HAPROXY_STATS_PORT = os.environ.get('HAPROXY_STATS_PORT', '8280')
try:
    DASHBOARD_PORT = int(os.environ.get('DASHBOARD_PORT', '8281'))
except (ValueError, TypeError):
    DASHBOARD_PORT = 8281

# Register blueprints
app.register_blueprint(main_bp)
app.register_blueprint(edit_bp)

# Make stats port available to all templates
@app.context_processor
def inject_stats_port():
    return dict(stats_port=HAPROXY_STATS_PORT)



# SSL Configuration - use combined cert/key pem file
ssl_context = None
if os.path.exists(HAPROXY_CERT):
    ssl_context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    ssl_context.load_cert_chain(certfile=HAPROXY_CERT)

# Favicon route
@app.route('/favicon.ico')
def favicon():
    return send_from_directory(os.path.join(app.root_path, 'static'), 'favicon.ico', mimetype='image/x-icon')

# Statistics Route
@app.route('/statistics')
@requires_auth
def display_haproxy_stats():
    haproxy_stats = fetch_haproxy_stats()
    if haproxy_stats.startswith('Error'):
        parsed_stats = []
        error_message = haproxy_stats
    else:
        parsed_stats = parse_haproxy_stats(haproxy_stats)
        error_message = None
    return render_template('statistics.html', stats=parsed_stats, error_message=error_message)

# Logs Route
@app.route('/logs')
@requires_auth
def display_logs():
    log_file_path = HAPROXY_LOG
    parsed_entries = parse_log_file(log_file_path)
    return render_template('logs.html', entries=parsed_entries)

if __name__ == '__main__':
    import logging
    log = logging.getLogger('werkzeug')
    log.setLevel(logging.ERROR)
    app.run(host='::', port=DASHBOARD_PORT, ssl_context=ssl_context, debug=False)
