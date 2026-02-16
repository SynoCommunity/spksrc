from flask import Flask, render_template, render_template_string, send_from_directory
import os
import ssl
from routes.main_routes import main_bp
from routes.edit_routes import edit_bp
from utils.stats_utils import fetch_haproxy_stats, parse_haproxy_stats
from auth.auth_middleware import setup_auth
from log_parser import parse_log_file

app = Flask(__name__)

# Get configuration from environment variables
HAPROXY_DASHBOARD_DIR = os.environ.get('HAPROXY_DASHBOARD_DIR', '/var/packages/haproxy/var')
HAPROXY_CERT = os.environ.get('HAPROXY_CERT', os.path.join(HAPROXY_DASHBOARD_DIR, 'crt/default.pem'))
HAPROXY_LOG = os.environ.get('HAPROXY_LOG', os.path.join(HAPROXY_DASHBOARD_DIR, 'http-access.log'))
HAPROXY_STATS_PORT = os.environ.get('HAPROXY_STATS_PORT', '8280')
DASHBOARD_PORT = int(os.environ.get('DASHBOARD_PORT', '8281'))

# Register blueprints
app.register_blueprint(main_bp)
app.register_blueprint(edit_bp)

# Make stats port available to all templates
@app.context_processor
def inject_stats_port():
    return dict(stats_port=HAPROXY_STATS_PORT)

# Setup authentication (placeholder, not currently used)
setup_auth(app)

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
def display_haproxy_stats():
    haproxy_stats = fetch_haproxy_stats()
    if haproxy_stats.startswith('Error'):
        parsed_stats = []
        error_message = haproxy_stats
    else:
        parsed_stats = parse_haproxy_stats(haproxy_stats)
        error_message = None
    return render_template_string('''
        <!DOCTYPE html>
        <html>
        <head>
            <title>HAProxy Statistics</title>
            <link href="/static/css/bootstrap.min.css" rel="stylesheet">
            <link href="/static/css/all.min.css" rel="stylesheet">
        </head>
        <body>
        <style>
            header {
                background-color: #f2f2f2;
                padding: 20px;
                display: flex;
                padding-left: 100px;
                align-items: center;
            }
            .logo {
                width: 300px;
                height: auto;
            }
            .menu-link {
                text-decoration: none;
                padding: 10px 20px;
                color: #333;
                font-weight: bold;
            }
            .menu-link:hover {
                background-color: #3B444B;
                color: white;
                text-decoration: none;
            }
            .menu-link.active {
                background-color: #3B444B;
                color: white;
            }
            /* Dark mode styles */
            .dark-mode {
                background-color: #121B2E;
                color: white;
            }
            .dark-mode header {
                background-color: #25354e;
                color: white;
                box-shadow: 0 0 5px rgba(0, 0, 0, 0.3);
            }
            .dark-mode .menu-link {
                color: white;
            }
            .dark-mode .logo {
                color: #2bb9c7;
            }
            .dark-mode .menu-link:hover {
                color: #2bb9c7;
            }
            .dark-mode .menu-link.active {
                color: #2bb9c7;
                border-bottom: 2px solid #2bb9c7;
                background-color: transparent;
            }
            .dark-mode .table {
                color: white;
            }
            .dark-mode .table-striped tbody tr:nth-of-type(odd) {
                background-color: rgba(255, 255, 255, 0.05);
            }
            .dark-mode .table-bordered {
                border-color: #2bb9c7;
            }
            .dark-mode .table-bordered th,
            .dark-mode .table-bordered td {
                border-color: rgba(43, 185, 199, 0.3);
            }
            .dark-mode h1 {
                color: #2bb9c7;
            }
        </style>
        <header>
            <a href="/home" style="text-decoration: none;">
                <h3 style="font-size: 22px;" class="logo">
                    <i style="margin: 8px;" class="fas fa-globe"></i>HAProxy Dashboard
                </h3>
            </a>
            <a href="/home" class="menu-link">Home</a>
            <a href="/" class="menu-link">Add Frontend & Backend</a>
            <a href="/edit" class="menu-link">Edit HAProxy Config</a>
            <a href="/logs" class="menu-link">Security Events</a>
            <a href="/statistics" class="menu-link active">Statistics</a>
            <a href="http://{{ request.host.split(':')[0] }}:''' + HAPROXY_STATS_PORT + '''/" class="menu-link">HAProxy Stats</a>
            <div class="custom-control custom-switch ml-auto">
                <input type="checkbox" class="custom-control-input" id="darkModeSwitch">
                <label class="custom-control-label" for="darkModeSwitch">Dark Mode</label>
            </div>
        </header>
        <div class="container">
            <h1 class="my-4">HAProxy Statistics</h1>
            {% if error_message %}
            <div class="alert alert-warning" role="alert">
                {{ error_message }}
            </div>
            {% endif %}
            <div class="table-responsive">
                <table class="table table-bordered table-striped">
                    <thead>
                        <tr>
                            <th>Frontend Name</th>
                            <th>Server Name</th>
                            <th>4xx Errors</th>
                            <th>5xx Errors</th>
                            <th>Bytes In (MB)</th>
                            <th>Bytes Out (MB)</th>
                            <th>Total Connections</th>
                        </tr>
                    </thead>
                    <tbody>
                        {% for stat in stats %}
                        <tr>
                            <td>{{ stat.frontend_name }}</td>
                            <td>{{ stat.server_name }}</td>
                            <td>{{ stat['4xx_errors'] }}</td>
                            <td>{{ stat['5xx_errors'] }}</td>
                            <td>{{ stat.bytes_in_mb }}</td>
                            <td>{{ stat.bytes_out_mb }}</td>
                            <td>{{ stat.conn_tot }}</td>
                        </tr>
                        {% endfor %}
                    </tbody>
                </table>
            </div>
        </div>
        <script>
            function toggleDarkMode() {
                const body = document.body;
                body.classList.toggle('dark-mode');
                localStorage.setItem('darkMode', body.classList.contains('dark-mode'));
            }
            // Check localStorage for dark mode preference
            if (localStorage.getItem('darkMode') === 'true') {
                document.body.classList.add('dark-mode');
                document.getElementById('darkModeSwitch').checked = true;
            }
            document.getElementById('darkModeSwitch').addEventListener('change', toggleDarkMode);
        </script>
        </body>
        </html>
    ''', stats=parsed_stats, error_message=error_message)

# Logs Route
@app.route('/logs')
def display_logs():
    log_file_path = HAPROXY_LOG
    parsed_entries = parse_log_file(log_file_path)
    return render_template('logs.html', entries=parsed_entries)

if __name__ == '__main__':
    import logging
    log = logging.getLogger('werkzeug')
    log.setLevel(logging.ERROR)
    app.run(host='::', port=DASHBOARD_PORT, ssl_context=ssl_context, debug=False)
