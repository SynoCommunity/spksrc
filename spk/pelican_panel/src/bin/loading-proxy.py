#!/usr/bin/env python3
"""
Pelican Panel Loading Proxy
Serves a loading page while the Panel initializes, then proxies to the Panel.
Provides real-time status via API by monitoring Docker logs.
"""

import http.server
import socketserver
import urllib.request
import urllib.error
import subprocess
import sys
import os
import threading
import time
import signal
import json
import re

# Configuration
LISTEN_PORT = 8080
PANEL_INTERNAL_PORT = 8090
PANEL_CHECK_INTERVAL = 2  # Check every 2 seconds for faster updates
LOADING_HTML_PATH = "/var/packages/pelican_panel/target/share/loading.html"
INSTRUCTIONS_HTML_PATH = "/var/packages/pelican_panel/target/app/instructions.html"
CONTAINER_NAME = "pelican_panel-panel-1"
VAR_DIR = "/var/packages/pelican_panel/var"
WINGS_CONFIG_PATH = f"{VAR_DIR}/data/wings/config.yml"
WINGS_PID_FILE = f"{VAR_DIR}/wings.pid"
INSTALL_COMPLETE_FLAG = f"{VAR_DIR}/install_complete"
DATA_ROOT = f"{VAR_DIR}/data"  # Host path for Docker bind mounts

# Total migrations in Pelican Panel (222 tables based on actual install)
# This is updated dynamically if we discover more migrations
TOTAL_MIGRATIONS = 222

# Global state
state = {
    "panel_ready": False,
    "status": "starting",
    "message": "Démarrage du service...",
    "detail": "Initialisation en cours",
    "progress": 0,
    "migrations_done": 0,
    "migrations_total": TOTAL_MIGRATIONS,
    "current_migration": None,
    "start_time": time.time(),
    "estimated_remaining_seconds": None,
    "health_check_count": 0,  # Number of successful health checks needed
}
shutdown_flag = False
state_lock = threading.Lock()

# Track all migrations we've seen (persists across log reads)
seen_migrations = set()
migration_start_time = None
dynamic_total = TOTAL_MIGRATIONS  # Will be adjusted if we see more migrations


def get_docker_logs(tail=500):
    """Get Docker logs. Use larger tail to capture all migrations."""
    try:
        result = subprocess.run(
            ["docker", "logs", "--tail", str(tail), CONTAINER_NAME],
            capture_output=True,
            text=True,
            timeout=10
        )
        return result.stdout + result.stderr
    except Exception as e:
        print(f"[proxy] Error getting logs: {e}")
        return ""


def parse_migrations(logs):
    """Parse all migrations from logs and track them.

    Pelican/Laravel outputs migrations in this format:
      2016_01_23_195641_add_allocations_table ........................... 1 s DONE
      2016_01_23_195851_add_api_keys ............................... 308.07ms DONE
    """
    global seen_migrations, migration_start_time, dynamic_total

    # Find all completed migrations (lines ending with "DONE")
    # Pattern: timestamp_name followed by dots and timing, ending with DONE
    completed_migrations = re.findall(
        r'(\d{4}_\d{2}_\d{2}_\d+_[\w]+)\s+\.+\s+[\d.]+\s*(?:ms|s)\s+DONE',
        logs
    )

    # Add to our persistent set
    for m in completed_migrations:
        if m not in seen_migrations:
            seen_migrations.add(m)
            # Start timer on first migration
            if migration_start_time is None:
                migration_start_time = time.time()

    # Dynamically adjust total if we've seen more migrations than expected
    completed = len(seen_migrations)
    if completed > dynamic_total - 10:
        # We're close to or past the limit, increase estimate
        dynamic_total = completed + 20

    # Find migration currently in progress (line without DONE yet)
    # Look for lines that start with a migration pattern but don't have DONE
    lines = logs.split('\n')
    current = None

    for line in reversed(lines):
        line = line.strip()
        # Skip empty lines and completed migrations
        if not line or 'DONE' in line:
            continue
        # Check if it looks like a migration in progress
        match = re.match(r'(\d{4}_\d{2}_\d{2}_\d+_[\w]+)', line)
        if match:
            migration_name = match.group(1)
            if migration_name not in seen_migrations:
                # Extract just the name part after the timestamp
                name_match = re.match(r'\d{4}_\d{2}_\d{2}_\d+_(.*)', migration_name)
                if name_match:
                    current = name_match.group(1).replace('_', ' ').title()
                break

    # If no in-progress migration, show the last completed one
    if current is None and completed_migrations:
        last = completed_migrations[-1]
        name_match = re.match(r'\d{4}_\d{2}_\d{2}_\d+_(.*)', last)
        if name_match:
            current = name_match.group(1).replace('_', ' ').title()

    return completed, dynamic_total, current


def detect_phase(logs):
    """Detect current startup phase from logs.

    Log patterns from Pelican:
    - "Generating key" -> key generation
    - "Migrating Database" / "Running migrations" -> migrations starting
    - "DONE" lines -> migrations in progress
    - "Optimizing Filament" -> filament optimization
    - "entered RUNNING state" -> services started
    """
    logs_lower = logs.lower()

    # Check for completion indicators (in order of priority)
    # Supervisord shows services as RUNNING when fully started
    if "entered running state" in logs_lower:
        running_count = logs_lower.count("entered running state")
        if running_count >= 2:  # Both php-fpm and caddy running
            return "ready", "Services démarrés", 99

    # Filament optimization comes after migrations
    if "optimizing filament" in logs_lower:
        return "optimization", "Optimisation de Filament...", 92

    # Caching
    if "caching filament" in logs_lower:
        return "optimization", "Mise en cache Filament...", 94

    # Check for migrations (look for DONE pattern or "Running migrations")
    if "running migrations" in logs_lower or re.search(r'\d{4}_\d{2}_\d{2}_\d+_\w+.*DONE', logs):
        return "migrations", None, None  # Progress calculated from migration count

    if "nothing to migrate" in logs_lower:
        return "migrations_done", "Tables à jour", 85

    # Preparing database
    if "preparing database" in logs_lower or "creating migration table" in logs_lower:
        return "migrations", "Préparation de la base...", 8

    # Migrating database header
    if "migrating database" in logs_lower:
        return "migrations", "Démarrage des migrations...", 10

    # Key generation
    if "generating key" in logs_lower or "generated app key" in logs_lower:
        return "startup", "Génération de la clé...", 5

    # Very early startup
    if "external vars" in logs_lower:
        return "startup", "Initialisation...", 2

    return "startup", "Démarrage du conteneur...", 3


def check_panel_ready():
    """
    Check if panel is truly ready by verifying HTTP response on internal port.
    Uses multiple methods to ensure reliable detection.
    """
    try:
        # Method 1: Simple socket connection + HTTP request using subprocess
        # This is more reliable than urllib which can have issues with empty responses
        result = subprocess.run(
            ["curl", "-s", "-o", "/dev/null", "-w", "%{http_code}",
             "--connect-timeout", "3", "--max-time", "5",
             f"http://127.0.0.1:{PANEL_INTERNAL_PORT}/"],
            capture_output=True,
            text=True,
            timeout=10
        )
        http_code = result.stdout.strip()
        if http_code in ("200", "301", "302", "303", "307", "308"):
            print(f"[proxy] Panel ready check: HTTP {http_code}")
            return True

        # Method 2: Check health endpoint
        result = subprocess.run(
            ["curl", "-s", "-o", "/dev/null", "-w", "%{http_code}",
             "--connect-timeout", "3", "--max-time", "5",
             f"http://127.0.0.1:{PANEL_INTERNAL_PORT}/api/health"],
            capture_output=True,
            text=True,
            timeout=10
        )
        http_code = result.stdout.strip()
        if http_code == "200":
            print(f"[proxy] Panel health check: HTTP {http_code}")
            return True

        return False

    except Exception as e:
        print(f"[proxy] Health check error: {e}")
        return False


def monitor_status():
    """Monitor Docker container status and update state."""
    global state, shutdown_flag, seen_migrations, migration_start_time

    consecutive_ready = 0  # Need multiple checks to confirm ready
    last_progress = 0

    while not shutdown_flag:
        try:
            # Check if container is running
            result = subprocess.run(
                ["docker", "ps", "--filter", f"name={CONTAINER_NAME}", "--format", "{{.Status}}"],
                capture_output=True,
                text=True,
                timeout=5
            )
            container_status = result.stdout.strip()

            with state_lock:
                if not container_status:
                    state["status"] = "waiting"
                    state["message"] = "En attente du conteneur..."
                    state["detail"] = "Le conteneur Docker n'est pas encore démarré"
                    state["progress"] = 1
                    state["current_migration"] = None
                    consecutive_ready = 0
                else:
                    # Get logs with large tail to capture all migrations
                    logs = get_docker_logs(tail=1000)

                    # Parse migrations
                    completed, total, current_name = parse_migrations(logs)

                    # Detect phase
                    phase, phase_message, phase_progress = detect_phase(logs)

                    # Update state based on phase
                    if phase == "migrations" or (completed > 0 and phase not in ("optimization", "ready")):
                        # Calculate progress based on migrations
                        # Migrations are 10% to 85% of total progress
                        if completed > 0:
                            migration_pct = min(completed / total, 1.0)
                            progress = 10 + int(migration_pct * 75)
                        else:
                            progress = 10

                        state["progress"] = max(progress, last_progress)  # Never go backwards
                        state["message"] = "Création des tables..."
                        state["migrations_done"] = completed
                        state["migrations_total"] = total
                        state["current_migration"] = current_name

                        if current_name:
                            state["detail"] = f"Table {completed}/{total} - {current_name}"
                        else:
                            state["detail"] = f"Table {completed}/{total}"

                        # Estimate remaining time
                        if migration_start_time and completed > 0:
                            elapsed = time.time() - migration_start_time
                            rate = completed / elapsed
                            if rate > 0:
                                remaining = (total - completed) / rate
                                # Add buffer for optimization phase
                                remaining += 20
                                state["estimated_remaining_seconds"] = max(5, int(remaining))

                        consecutive_ready = 0

                    elif phase == "migrations_done":
                        state["progress"] = max(85, last_progress)
                        state["message"] = phase_message
                        state["detail"] = "Toutes les tables créées"
                        state["current_migration"] = None
                        consecutive_ready = 0

                    elif phase == "optimization":
                        state["progress"] = max(phase_progress or 90, last_progress)
                        state["message"] = phase_message
                        state["detail"] = "Préparation du panel..."
                        state["current_migration"] = None
                        state["estimated_remaining_seconds"] = 15
                        # Don't reset consecutive_ready here - panel might be ready!

                    elif phase == "ready":
                        state["progress"] = max(phase_progress or 98, last_progress)
                        state["message"] = phase_message
                        state["detail"] = "Vérification finale..."
                        state["current_migration"] = None
                        state["estimated_remaining_seconds"] = 5
                        # Don't reset consecutive_ready here - panel might be ready!

                    else:
                        # Startup phase
                        state["progress"] = max(phase_progress or 5, last_progress)
                        state["message"] = phase_message or "Démarrage..."
                        state["detail"] = "Initialisation du conteneur"
                        state["current_migration"] = None
                        consecutive_ready = 0

                    last_progress = state["progress"]

                    # Check if panel is actually ready (needs multiple confirmations)
                    if check_panel_ready():
                        consecutive_ready += 1
                        if consecutive_ready >= 3:  # 3 successful checks = truly ready
                            state["panel_ready"] = True
                            state["status"] = "ready"
                            state["message"] = "Panel prêt !"
                            state["detail"] = "Redirection..."
                            state["progress"] = 100
                            state["estimated_remaining_seconds"] = 0
                            state["current_migration"] = None
                    else:
                        consecutive_ready = 0
                        state["status"] = "initializing"

        except Exception as e:
            print(f"[proxy] Monitor error: {e}")
            with state_lock:
                state["detail"] = f"Erreur: {str(e)[:40]}"

        time.sleep(PANEL_CHECK_INTERVAL)


class ProxyHandler(http.server.BaseHTTPRequestHandler):
    """HTTP handler that serves loading page or proxies to Panel."""

    def log_message(self, format, *args):
        pass  # Suppress default logging

    def do_GET(self):
        self._handle_request('GET')

    def do_POST(self):
        self._handle_request('POST')

    def do_HEAD(self):
        self._handle_request('HEAD')

    def do_PUT(self):
        self._handle_request('PUT')

    def do_DELETE(self):
        self._handle_request('DELETE')

    def do_OPTIONS(self):
        self._handle_request('OPTIONS')

    def _handle_request(self, method):
        # API endpoint for loading status
        if self.path == "/api/loading-status":
            self._serve_status_api()
            return

        # Wings configuration page
        if self.path == "/wings-config" or self.path == "/wings-config/":
            self._serve_wings_config_page()
            return

        # Wings API endpoints
        if self.path == "/api/wings/status":
            self._serve_wings_status_api()
            return

        if self.path == "/api/wings/config":
            if method == 'OPTIONS':
                self._serve_cors_preflight()
            elif method == 'GET':
                self._serve_wings_config_api()
            elif method == 'POST':
                self._handle_wings_config_save()
            return

        with state_lock:
            panel_ready = state["panel_ready"]

        if panel_ready:
            self._redirect_to_panel()
        else:
            if method == 'HEAD':
                self._serve_head_response()
            else:
                self._serve_loading_page()

    def _redirect_to_panel(self):
        """Redirect to the Panel on internal port or show instructions."""
        try:
            # Get the host from the request
            host = self.headers.get('Host', '').split(':')[0]
            if not host:
                host = '127.0.0.1'

            path = self.path

            # Check if this is first-time setup (install not complete)
            # and user is accessing root
            if (path == '/' or path == '') and not os.path.exists(INSTALL_COMPLETE_FLAG):
                # Show instructions page before redirecting to installer
                self._serve_instructions_page()
                return

            # For subsequent accesses or other paths, redirect to panel
            if path == '/' or path == '':
                path = '/'  # Let Pelican handle routing

            # Redirect to the internal port
            redirect_url = f"http://{host}:{PANEL_INTERNAL_PORT}{path}"

            self.send_response(302)
            self.send_header('Location', redirect_url)
            self.send_header('Cache-Control', 'no-cache')
            self.end_headers()
        except Exception as e:
            print(f"[proxy] Redirect error: {e}")
            self._serve_loading_page()

    def _serve_instructions_page(self):
        """Serve the installation instructions page."""
        try:
            with open(INSTRUCTIONS_HTML_PATH, 'r', encoding='utf-8') as f:
                content = f.read()

            # Replace placeholder with actual internal port
            content = content.replace('{{INTERNAL_PORT}}', str(PANEL_INTERNAL_PORT))

            content_bytes = content.encode('utf-8')
            self.send_response(200)
            self.send_header('Content-Type', 'text/html; charset=utf-8')
            self.send_header('Content-Length', len(content_bytes))
            self.send_header('Cache-Control', 'no-cache')
            self.end_headers()
            self.wfile.write(content_bytes)

            # Mark that instructions were shown - create flag file
            # This ensures instructions are shown only once
            try:
                with open(INSTALL_COMPLETE_FLAG, 'w') as f:
                    f.write(str(int(time.time())))
                print(f"[proxy] Instructions shown, created flag: {INSTALL_COMPLETE_FLAG}")
            except Exception as e:
                print(f"[proxy] Could not create install flag: {e}")

        except FileNotFoundError:
            print(f"[proxy] Instructions file not found: {INSTRUCTIONS_HTML_PATH}")
            # Fallback: redirect directly to installer
            host = self.headers.get('Host', '').split(':')[0] or '127.0.0.1'
            redirect_url = f"http://{host}:{PANEL_INTERNAL_PORT}/installer"
            self.send_response(302)
            self.send_header('Location', redirect_url)
            self.send_header('Cache-Control', 'no-cache')
            self.end_headers()
        except Exception as e:
            print(f"[proxy] Error serving instructions: {e}")
            self._serve_loading_page()

    def _serve_status_api(self):
        """Serve current status as JSON."""
        with state_lock:
            status_data = dict(state)
            status_data["elapsed_seconds"] = int(time.time() - state["start_time"])

        content = json.dumps(status_data).encode('utf-8')
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', len(content))
        self.send_header('Cache-Control', 'no-cache')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        self.wfile.write(content)

    def _serve_wings_config_page(self):
        """Serve the Wings configuration HTML page."""
        try:
            content = get_wings_config_html()
            content_bytes = content.encode('utf-8')
            self.send_response(200)
            self.send_header('Content-Type', 'text/html; charset=utf-8')
            self.send_header('Content-Length', len(content_bytes))
            self.send_header('Cache-Control', 'no-cache')
            self.end_headers()
            self.wfile.write(content_bytes)
        except Exception as e:
            print(f"[proxy] Error serving wings config page: {e}")
            self.send_error(500, str(e))

    def _add_cors_headers(self):
        """Add CORS headers to allow cross-origin requests from DSM."""
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')

    def _serve_cors_preflight(self):
        """Handle CORS preflight OPTIONS request."""
        self.send_response(200)
        self._add_cors_headers()
        self.send_header('Content-Length', '0')
        self.end_headers()

    def _serve_wings_status_api(self):
        """Serve Wings status as JSON."""
        status = check_wings_status()
        status["success"] = True
        content = json.dumps(status).encode('utf-8')
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', len(content))
        self.send_header('Cache-Control', 'no-cache')
        self._add_cors_headers()
        self.end_headers()
        self.wfile.write(content)

    def _serve_wings_config_api(self):
        """Serve Wings configuration content as JSON."""
        config = get_wings_config()
        response = {"success": True, "config": config}
        content = json.dumps(response).encode('utf-8')
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', len(content))
        self.send_header('Cache-Control', 'no-cache')
        self._add_cors_headers()
        self.end_headers()
        self.wfile.write(content)

    def _handle_wings_config_save(self):
        """Handle POST request to save Wings configuration."""
        try:
            content_length = int(self.headers.get('Content-Length', 0))
            post_data = self.rfile.read(content_length)
            data = json.loads(post_data.decode('utf-8'))
            config_content = data.get('config', '')

            if not config_content.strip():
                response = {"success": False, "error": "Configuration vide"}
            else:
                success, message = save_wings_config(config_content)
                response = {"success": success, "message": message if success else None, "error": message if not success else None}

            content = json.dumps(response).encode('utf-8')
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Content-Length', len(content))
            self._add_cors_headers()
            self.end_headers()
            self.wfile.write(content)
        except Exception as e:
            print(f"[proxy] Error saving wings config: {e}")
            response = {"success": False, "error": str(e)}
            content = json.dumps(response).encode('utf-8')
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Content-Length', len(content))
            self._add_cors_headers()
            self.end_headers()
            self.wfile.write(content)

    def _serve_head_response(self):
        """Serve HEAD response for health checks."""
        self.send_response(503)
        self.send_header('Content-Type', 'text/html')
        self.send_header('Retry-After', '5')
        self.end_headers()

    def _serve_loading_page(self):
        """Serve the loading page."""
        try:
            content = None
            if os.path.exists(LOADING_HTML_PATH):
                try:
                    with open(LOADING_HTML_PATH, 'r', encoding='utf-8') as f:
                        content = f.read()
                except Exception as e:
                    print(f"[proxy] Error reading HTML: {e}")

            if not content:
                content = self._get_fallback_html()

            content_bytes = content.encode('utf-8')
            self.send_response(200)
            self.send_header('Content-Type', 'text/html; charset=utf-8')
            self.send_header('Content-Length', len(content_bytes))
            self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')
            self.end_headers()
            self.wfile.write(content_bytes)
        except BrokenPipeError:
            pass
        except Exception as e:
            print(f"[proxy] Error serving page: {e}")

    def _get_fallback_html(self):
        """Fallback loading page if template not found."""
        return '''<!DOCTYPE html>
<html><head><meta charset="utf-8"><title>Pelican Panel</title>
<style>
body{background:#1a1a2e;color:#fff;font-family:system-ui,sans-serif;
display:flex;justify-content:center;align-items:center;height:100vh;margin:0}
.c{text-align:center;max-width:500px;padding:40px}
.logo{font-size:2.5rem;font-weight:600;margin-bottom:40px;color:#4fc3f7}
.bar-bg{height:6px;background:rgba(255,255,255,0.1);border-radius:3px;margin-bottom:20px}
.bar{height:100%;background:#4fc3f7;border-radius:3px;width:0%;transition:width 0.3s}
.msg{font-size:1.1rem;margin:15px 0}
.detail{color:rgba(255,255,255,0.6);font-size:0.9rem}
.migration{color:#4fc3f7;font-size:0.85rem;margin-top:10px;font-family:monospace}
</style></head>
<body><div class="c">
<div class="logo">PELICAN</div>
<div class="bar-bg"><div class="bar" id="bar"></div></div>
<div class="msg" id="msg">Chargement...</div>
<div class="detail" id="detail"></div>
<div class="migration" id="migration"></div>
</div>
<script>
async function update(){
try{
const r=await fetch('/api/loading-status');
const d=await r.json();
document.getElementById('bar').style.width=d.progress+'%';
document.getElementById('msg').textContent=d.message||'Chargement...';
document.getElementById('detail').textContent=d.detail||'';
document.getElementById('migration').textContent=d.current_migration?'→ '+d.current_migration:'';
if(d.panel_ready){location.reload();}
}catch(e){}}
setInterval(update,1500);update();
</script></body></html>'''

    def _proxy_to_panel(self, method):
        """Proxy request to the Panel."""
        try:
            target_url = f"http://127.0.0.1:{PANEL_INTERNAL_PORT}{self.path}"

            content_length = self.headers.get('Content-Length')
            body = None
            if content_length:
                body = self.rfile.read(int(content_length))

            req = urllib.request.Request(target_url, data=body, method=method)

            for header, value in self.headers.items():
                if header.lower() not in ('host', 'content-length'):
                    req.add_header(header, value)

            with urllib.request.urlopen(req, timeout=30) as response:
                self.send_response(response.status)
                for header, value in response.getheaders():
                    if header.lower() not in ('transfer-encoding', 'connection'):
                        self.send_header(header, value)
                self.end_headers()
                self.wfile.write(response.read())

        except urllib.error.HTTPError as e:
            self.send_response(e.code)
            for header, value in e.headers.items():
                if header.lower() not in ('transfer-encoding', 'connection'):
                    self.send_header(header, value)
            self.end_headers()
            self.wfile.write(e.read())
        except Exception:
            with state_lock:
                state["panel_ready"] = False
            self._serve_loading_page()


class ThreadedTCPServer(socketserver.ThreadingMixIn, socketserver.TCPServer):
    allow_reuse_address = True
    daemon_threads = True


def signal_handler(signum, frame):
    global shutdown_flag
    shutdown_flag = True
    sys.exit(0)


def check_wings_status():
    """Check if Wings container is running."""
    running = False
    configured = os.path.exists(WINGS_CONFIG_PATH)

    try:
        # Check if Wings container is running
        result = subprocess.run(
            ["docker", "inspect", "-f", "{{.State.Running}}", "pelican_panel-wings-1"],
            capture_output=True,
            text=True,
            timeout=5
        )
        running = result.stdout.strip().lower() == "true"
    except Exception:
        pass

    return {"running": running, "configured": configured}


def get_wings_config():
    """Get Wings configuration content."""
    if os.path.exists(WINGS_CONFIG_PATH):
        try:
            with open(WINGS_CONFIG_PATH, 'r') as f:
                return f.read()
        except Exception:
            pass
    return ""


def save_wings_config(config_content):
    """Save Wings configuration and restart the package.

    Applies automatic fixes for Docker-in-Docker setup on Synology:
    1. Fixes API port: Panel generates 8445 (external), but container needs 8080 (internal)
    2. Fixes system paths: Uses host paths instead of container paths for bind mounts
    3. Disables mount_passwd: The passwd_file path doesn't exist on host
    4. Fixes tmp_directory: Must be host path for install scripts
    """
    try:
        # Create directory if needed
        os.makedirs(os.path.dirname(WINGS_CONFIG_PATH), exist_ok=True)

        # === FIX 1: API Port ===
        # The Panel generates config with external port (8445), but Wings inside
        # the container must listen on internal port (8080) because Docker maps 8445:8080
        config_content = re.sub(
            r'(\n\s*port:\s*)8445(\s*\n)',
            r'\g<1>8080\2',
            config_content
        )

        # === FIX 2: System Paths for Docker-in-Docker ===
        # Wings runs in a container but creates game server containers via mounted Docker socket.
        # Those containers need HOST paths, not container paths.
        # Replace /var/lib/pelican/* with actual Synology host paths.
        path_mappings = [
            (r'/var/lib/pelican/volumes', f'{DATA_ROOT}/servers'),
            (r'/var/lib/pelican/backups', f'{DATA_ROOT}/backups'),
            (r'/var/lib/pelican/archives', f'{DATA_ROOT}/archives'),
            (r'/var/log/pelican', f'{DATA_ROOT}/wings-logs'),
        ]
        for old_path, new_path in path_mappings:
            config_content = config_content.replace(old_path, new_path)

        # Also fix root_directory if present
        config_content = re.sub(
            r'(\s*root_directory:\s*)/var/lib/pelican\s*\n',
            f'\\g<1>{DATA_ROOT}\n',
            config_content
        )

        # === FIX 3: Disable mount_passwd ===
        # The passwd_file path /etc/pelican/passwd is inside the Wings container,
        # but Docker tries to mount it from the HOST where it doesn't exist.
        # Disabling mount_passwd avoids this issue.
        config_content = re.sub(
            r'(\s*mount_passwd:\s*)true',
            r'\g<1>false',
            config_content
        )

        # === FIX 4: tmp_directory ===
        # The tmp_directory is used for install scripts. It must be a host path
        # so Docker can mount it when creating install containers.
        config_content = re.sub(
            r'(\s*tmp_directory:\s*)/tmp/pelican\s*\n',
            f'\\g<1>{DATA_ROOT}/tmp\n',
            config_content
        )

        # Create tmp directory
        os.makedirs(f'{DATA_ROOT}/tmp', exist_ok=True)
        os.chmod(f'{DATA_ROOT}/tmp', 0o777)

        # Auto-append Docker network config if not present
        # This prevents "Pool overlaps" errors with default Docker network settings
        # Uses 172.31.x.x to avoid conflict with pelican_network (172.30.x.x)
        if 'docker:' not in config_content:
            docker_config = """
docker:
  network:
    interface: 172.31.0.1
    dns:
      - 1.1.1.1
      - 1.0.0.1
    name: pelican0
    ispn: false
    driver: bridge
    network_mode: pelican0
    is_internal: false
    enable_icc: true
    network_mtu: 1500
    interfaces:
      v4:
        subnet: 172.31.0.0/16
        gateway: 172.31.0.1
"""
            config_content = config_content.rstrip() + "\n" + docker_config

        # Save config
        with open(WINGS_CONFIG_PATH, 'w') as f:
            f.write(config_content)
        os.chmod(WINGS_CONFIG_PATH, 0o640)

        # Restart Wings container
        subprocess.Popen(
            ["docker", "compose", "-f", "/var/packages/pelican_panel/target/share/docker/compose.yaml",
             "--env-file", "/var/packages/pelican_panel/var/panel.env",
             "restart", "wings"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )

        return True, "Configuration saved"
    except Exception as e:
        return False, str(e)


def get_wings_config_html():
    """Return the Wings configuration HTML page."""
    return '''<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Configuration Wings - Pelican</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #0a1628 0%, #1a2744 100%);
            min-height: 100vh;
            color: #fff;
            padding: 20px;
        }
        .container { max-width: 800px; margin: 0 auto; }
        h1 { font-size: 1.5rem; margin-bottom: 20px; text-align: center; color: #4fc3f7; }
        .card {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            border: 1px solid rgba(79, 195, 247, 0.2);
        }
        .card h2 {
            font-size: 1rem;
            margin-bottom: 15px;
            color: #4fc3f7;
        }
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
        }
        .status-running { background: rgba(76, 175, 80, 0.2); color: #81c784; }
        .status-stopped { background: rgba(244, 67, 54, 0.2); color: #e57373; }
        .instructions {
            background: rgba(79, 195, 247, 0.1);
            border-left: 3px solid #4fc3f7;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 0 8px 8px 0;
            font-size: 0.9rem;
        }
        .instructions ol { margin-left: 20px; line-height: 1.8; }
        .instructions code {
            background: rgba(0, 0, 0, 0.3);
            padding: 2px 6px;
            border-radius: 4px;
        }
        textarea {
            width: 100%;
            height: 350px;
            background: #0d1117;
            border: 1px solid #30363d;
            border-radius: 8px;
            color: #c9d1d9;
            font-family: 'Courier New', monospace;
            font-size: 12px;
            padding: 15px;
            resize: vertical;
        }
        textarea:focus {
            outline: none;
            border-color: #4fc3f7;
        }
        .button-row {
            display: flex;
            gap: 10px;
            margin-top: 15px;
            justify-content: flex-end;
        }
        button {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-primary {
            background: linear-gradient(135deg, #4fc3f7 0%, #29b6f6 100%);
            color: #000;
        }
        .btn-primary:hover { transform: translateY(-2px); }
        .btn-secondary {
            background: rgba(255, 255, 255, 0.1);
            color: #fff;
        }
        .alert {
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 15px;
            display: none;
        }
        .alert-success {
            background: rgba(76, 175, 80, 0.2);
            border: 1px solid rgba(76, 175, 80, 0.3);
            color: #81c784;
        }
        .alert-error {
            background: rgba(244, 67, 54, 0.2);
            border: 1px solid rgba(244, 67, 54, 0.3);
            color: #e57373;
        }
        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #4fc3f7;
            text-decoration: none;
        }
        .back-link:hover { text-decoration: underline; }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }
        .info-item {
            background: rgba(0, 0, 0, 0.2);
            padding: 12px;
            border-radius: 8px;
        }
        .info-label {
            display: block;
            font-size: 0.8rem;
            color: #a0a0a0;
            margin-bottom: 4px;
        }
        .info-value {
            display: block;
            font-size: 1.1rem;
            color: #4fc3f7;
            font-family: monospace;
            font-weight: 600;
        }
        .warning-note {
            background: rgba(251, 191, 36, 0.1);
            border: 1px solid rgba(251, 191, 36, 0.3);
            border-radius: 8px;
            padding: 12px;
            margin-top: 15px;
            font-size: 0.9rem;
            color: #fbbf24;
        }
        .warning-note code {
            background: rgba(0, 0, 0, 0.3);
            padding: 2px 6px;
            border-radius: 4px;
            color: #fff;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="/" class="back-link">&larr; Retour au Panel</a>
        <h1>Configuration Wings - Pelican</h1>

        <div class="card">
            <h2>Status Wings <span id="wingsStatus" class="status-badge status-stopped">Chargement...</span></h2>
        </div>

        <div class="card">
            <h2>Instructions</h2>
            <div class="instructions">
                <ol>
                    <li>Dans le <strong>Panel Pelican</strong>, allez dans <code>Admin</code> &rarr; <code>Nodes</code> &rarr; <code>Create New</code></li>
                    <li>Configurez le Node avec les informations ci-dessous</li>
                    <li>Cliquez sur l'onglet <code>Configuration</code> puis <code>Generate Token</code></li>
                    <li><strong>Copiez tout le YAML</strong> et collez-le ci-dessous</li>
                </ol>
            </div>
        </div>

        <div class="card">
            <h2>Informations pour la creation du Node</h2>
            <div class="info-grid">
                <div class="info-item">
                    <span class="info-label">FQDN / IP du NAS</span>
                    <span class="info-value" id="nasHost">-</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Port Daemon (Wings API)</span>
                    <span class="info-value">8445</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Port SFTP</span>
                    <span class="info-value">2022</span>
                </div>
                <div class="info-item">
                    <span class="info-label">URL du Panel (pour config Node)</span>
                    <span class="info-value" id="panelUrl">-</span>
                </div>
            </div>
            <div class="warning-note">
                <strong>Important :</strong> Dans la configuration du Node, utilisez le port <code>8090</code> pour l'URL du Panel (pas 8080).
            </div>
            <div class="success-note" style="background: rgba(76, 175, 80, 0.1); border: 1px solid rgba(76, 175, 80, 0.3); border-radius: 8px; padding: 12px; margin-top: 15px; font-size: 0.9rem; color: #81c784;">
                <strong>Corrections automatiques :</strong> Lors de l'enregistrement, le port API et les chemins systeme sont automatiquement corriges pour fonctionner avec Docker sur Synology.
            </div>
        </div>

        <div id="alertSuccess" class="alert alert-success"></div>
        <div id="alertError" class="alert alert-error"></div>

        <div class="card">
            <h2>Configuration YAML</h2>
            <textarea id="configEditor" placeholder="Collez la configuration YAML generee par le Panel..."></textarea>
            <div class="button-row">
                <button class="btn-secondary" onclick="loadConfig()">Recharger</button>
                <button class="btn-primary" onclick="saveConfig()">Enregistrer &amp; Redemarrer</button>
            </div>
        </div>
    </div>

    <script>
        // Detect if running in HTTPS context (DSM built-in mode)
        // If HTTPS, use CGI proxy served by DSM. If HTTP, call loading proxy directly.
        const isHttps = window.location.protocol === 'https:';
        const CGI_BASE = '/webman/3rdparty/pelican_panel/api.cgi';
        const API_BASE = 'http://' + window.location.hostname + ':8080/api/wings';

        async function apiCall(action, method, body) {
            if (isHttps) {
                // Use CGI proxy for HTTPS (DSM built-in mode)
                const url = CGI_BASE + '?action=' + action;
                const options = { method: method || 'GET' };
                if (body) {
                    options.headers = { 'Content-Type': 'application/json' };
                    options.body = JSON.stringify(body);
                }
                return fetch(url, options);
            } else {
                // Direct call for HTTP
                const endpoint = action === 'status' ? '/status' : '/config';
                const url = API_BASE + endpoint;
                const options = { method: method || 'GET' };
                if (body) {
                    options.headers = { 'Content-Type': 'application/json' };
                    options.body = JSON.stringify(body);
                }
                return fetch(url, options);
            }
        }

        async function loadConfig() {
            hideAlerts();
            try {
                const response = await apiCall('get-config', 'GET');
                const data = await response.json();
                if (data.success) {
                    document.getElementById('configEditor').value = data.config || '';
                } else {
                    showError(data.error || 'Erreur de chargement');
                }
            } catch (e) {
                showError('Erreur: ' + e.message);
            }
            checkStatus();
        }

        async function saveConfig() {
            const config = document.getElementById('configEditor').value.trim();
            if (!config) {
                showError('La configuration ne peut pas etre vide');
                return;
            }
            hideAlerts();
            try {
                const response = await apiCall('save-config', 'POST', { config: config });
                const data = await response.json();
                if (data.success) {
                    showSuccess('Configuration enregistree ! Wings redemarre...');
                    setTimeout(checkStatus, 3000);
                } else {
                    showError(data.error || 'Erreur de sauvegarde');
                }
            } catch (e) {
                showError('Erreur: ' + e.message);
            }
        }

        async function checkStatus() {
            try {
                const response = await apiCall('status', 'GET');
                const data = await response.json();
                const badge = document.getElementById('wingsStatus');
                if (data.running) {
                    badge.className = 'status-badge status-running';
                    badge.textContent = 'En cours';
                } else {
                    badge.className = 'status-badge status-stopped';
                    badge.textContent = data.configured ? 'Arrete' : 'Non configure';
                }
            } catch (e) {
                document.getElementById('wingsStatus').textContent = 'Erreur';
            }
        }

        function showSuccess(msg) {
            const el = document.getElementById('alertSuccess');
            el.textContent = msg;
            el.style.display = 'block';
        }

        function showError(msg) {
            const el = document.getElementById('alertError');
            el.textContent = msg;
            el.style.display = 'block';
        }

        function hideAlerts() {
            document.getElementById('alertSuccess').style.display = 'none';
            document.getElementById('alertError').style.display = 'none';
        }

        // Populate dynamic info on page load
        function populateInfo() {
            document.getElementById('nasHost').textContent = window.location.hostname;
            document.getElementById('panelUrl').textContent = 'http://' + window.location.hostname + ':8090';
        }

        document.addEventListener('DOMContentLoaded', function() {
            populateInfo();
            loadConfig();
        });
        setInterval(checkStatus, 15000);
    </script>
</body>
</html>'''


def main():
    global LISTEN_PORT, PANEL_INTERNAL_PORT, LOADING_HTML_PATH

    if len(sys.argv) >= 2:
        LISTEN_PORT = int(sys.argv[1])
    if len(sys.argv) >= 3:
        PANEL_INTERNAL_PORT = int(sys.argv[2])
    if len(sys.argv) >= 4:
        LOADING_HTML_PATH = sys.argv[3]

    signal.signal(signal.SIGTERM, signal_handler)
    signal.signal(signal.SIGINT, signal_handler)

    print(f"[proxy] Pelican Loading Proxy")
    print(f"[proxy]   Port: {LISTEN_PORT} -> {PANEL_INTERNAL_PORT}")
    print(f"[proxy]   HTML: {LOADING_HTML_PATH} (exists: {os.path.exists(LOADING_HTML_PATH)})")

    # Start monitor thread
    monitor = threading.Thread(target=monitor_status, daemon=True)
    monitor.start()

    print(f"[proxy] Server starting...")

    with ThreadedTCPServer(("0.0.0.0", LISTEN_PORT), ProxyHandler) as server:
        try:
            server.serve_forever()
        except KeyboardInterrupt:
            pass


if __name__ == "__main__":
    main()
