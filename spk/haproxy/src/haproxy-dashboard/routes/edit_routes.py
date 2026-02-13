from flask import Blueprint, render_template, request
import os
import subprocess
from auth.auth_middleware import requires_auth
import signal

edit_bp = Blueprint('edit', __name__)

@edit_bp.route('/edit', methods=['GET', 'POST'])
@requires_auth
def edit_haproxy_config():
    haproxy_cfg = os.environ.get('HAPROXY_CFG', '/var/packages/haproxy/var/haproxy.cfg')
    haproxy_bin = os.environ.get('HAPROXY_BIN', '/var/packages/haproxy/target/sbin/haproxy')
    synopkg_name = os.environ.get('SYNOPKG_PKGNAME', 'haproxy')

    if request.method == 'POST':
        edited_config = request.form['haproxy_config']
        # Save the edited config to the haproxy.cfg file
        with open(haproxy_cfg, 'w') as f:
            f.write(edited_config)

        check_output = ""

        if 'save_check' in request.form:
            # Run haproxy -c -V -f to check the configuration
            check_result = subprocess.run([haproxy_bin, '-c', '-V', '-f', haproxy_cfg], capture_output=True, text=True)
            check_output = check_result.stdout

            # Check if there was an error, and if so, append it to the output
            if check_result.returncode != 0:
                error_message = check_result.stderr
                check_output += f"\n\nError occurred:\n{error_message}"

        elif 'save_reload' in request.form:
            # Run haproxy -c -V -f to check the configuration
            check_result = subprocess.run([haproxy_bin, '-c', '-V', '-f', haproxy_cfg], capture_output=True, text=True)
            check_output = check_result.stdout

            # Check if there was an error, and if so, append it to the output
            if check_result.returncode != 0:
                error_message = check_result.stderr
                check_output += f"\n\nError occurred:\n{error_message}"
            else:
                # Graceful reload: start new HAProxy process and signal old one to finish
                # Read current PID file
                pid_file = os.environ.get('HAPROXY_PID', f'/var/packages/{synopkg_name}/var/haproxy.pid')
                old_pid = None
                if os.path.exists(pid_file):
                    try:
                        with open(pid_file, 'r') as f:
                            old_pid = f.read().strip()
                    except Exception:
                        pass

                # Use HAProxy's graceful reload (-sf option)
                reload_cmd = [haproxy_bin, '-f', haproxy_cfg, '-p', pid_file, '-D']
                if old_pid:
                    reload_cmd.extend(['-sf', old_pid])

                reload_result = subprocess.run(reload_cmd, capture_output=True, text=True)
                if reload_result.returncode == 0:
                    check_output += "\n\nHAProxy reloaded successfully (graceful reload)"
                else:
                    check_output += f"\n\nHAProxy Reload Output:\n{reload_result.stdout}"
                    if reload_result.stderr:
                        check_output += f"\nReload Stderr:\n{reload_result.stderr}"

        return render_template('edit.html', config_content=edited_config, check_output=check_output)

    # GET request - Read the current contents of haproxy.cfg
    try:
        with open(haproxy_cfg, 'r') as f:
            config_content = f.read()
    except FileNotFoundError:
        config_content = "# HAProxy configuration file not found\n# Please create the configuration file first"

    return render_template('edit.html', config_content=config_content)
