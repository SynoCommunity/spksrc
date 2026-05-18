from flask import Blueprint, render_template, request
from auth.auth_middleware import requires_auth
from utils.haproxy_config import update_haproxy_config, is_frontend_exist, count_frontends_and_backends

main_bp = Blueprint('main', __name__)

@main_bp.route('/', methods=['GET', 'POST'])
@requires_auth
def index():
    if request.method == 'POST':
        frontend_name = request.form['frontend_name']
        frontend_ip = request.form['frontend_ip']
        frontend_port = request.form['frontend_port']
        lb_method = request.form['lb_method']
        protocol = request.form['protocol']
        backend_name = request.form['backend_name']
        add_header = 'add_header' in request.form if 'add_header' in request.form else ''
        header_name = request.form['header_name']
        header_value = request.form['header_value']
        
        # Get all backend servers data
        backend_server_names = request.form.getlist('backend_server_names[]')
        backend_server_ips = request.form.getlist('backend_server_ips[]')
        backend_server_ports = request.form.getlist('backend_server_ports[]')
        backend_server_maxconns = request.form.getlist('backend_server_maxconns[]')

        is_acl = 'add_acl' in request.form
        acl_name = request.form['acl'] if 'acl' in request.form else ''
        acl_action = request.form['acl_action'] if 'acl_action' in request.form else ''
        acl_backend_name = request.form['backend_name_acl'] if 'backend_name_acl' in request.form else ''
        use_ssl = 'ssl_checkbox' in request.form
        ssl_cert_path = request.form['ssl_cert_path']
        https_redirect = 'ssl_redirect_checkbox' in request.form
        is_dos = 'add_dos' in request.form if 'add_dos' in request.form else ''
        ban_duration = request.form["ban_duration"]
        limit_requests = request.form["limit_requests"]
        forward_for = 'forward_for_check' in request.form

        is_forbidden_path = 'add_acl_path' in request.form
        forbidden_name = request.form["forbidden_name"]
        allowed_ip = request.form["allowed_ip"]
        forbidden_path = request.form["forbidden_path"]

        sql_injection_check = 'sql_injection_check' in request.form if 'sql_injection_check' in request.form else ''
        is_xss = 'xss_check' in request.form if 'xss_check' in request.form else ''
        is_remote_upload = 'remote_uploads_check' in request.form if 'remote_uploads_check' in request.form else ''

        add_path_based = 'add_path_based' in request.form
        redirect_domain_name = request.form["redirect_domain_name"]
        root_redirect = request.form["root_redirect"]
        redirect_to = request.form["redirect_to"]
        is_webshells = 'webshells_check' in request.form if 'webshells_check' in request.form else ''

        # Combine backend server info into a list of tuples (name, ip, port, maxconns)
        backend_servers = []
        for i in range(len(backend_server_ips)):
            name = backend_server_names[i] if i < len(backend_server_names) else f"server{i+1}"
            ip = backend_server_ips[i] if i < len(backend_server_ips) else ''
            port = backend_server_ports[i] if i < len(backend_server_ports) else ''
            maxconn = backend_server_maxconns[i] if i < len(backend_server_maxconns) else None

            if ip and port:  # Only add if we have IP and port
                backend_servers.append((name, ip, port, maxconn))
        
        # Check if frontend or port already exists
        if is_frontend_exist(frontend_name, frontend_ip, frontend_port):
            return render_template('index.html', message="Frontend or Port already exists. Cannot add duplicate.")

        # Get health check related fields if the protocol is HTTP
        health_check = False
        health_check_link = ""
        if protocol == 'http':
            health_check = 'health_check' in request.form
            if health_check:
                health_check_link = request.form['health_check_link']

        health_check_tcp = False
        if protocol == 'tcp':
            health_check_tcp = 'health_check2' in request.form

        # Get sticky session related fields
        sticky_session = False
        sticky_session_type = ""
        if 'sticky_session' in request.form:
            sticky_session = True
            sticky_session_type = request.form['sticky_session_type']

        # Update the HAProxy config file
        message = update_haproxy_config(
            frontend_name, frontend_ip, frontend_port, lb_method, protocol, backend_name, 
            backend_servers, health_check, health_check_tcp, health_check_link, sticky_session,
            add_header, header_name, header_value, sticky_session_type, is_acl, acl_name,
            acl_action, acl_backend_name, use_ssl, ssl_cert_path, https_redirect, is_dos, 
            ban_duration, limit_requests, forward_for, is_forbidden_path, forbidden_name, 
            allowed_ip, forbidden_path, sql_injection_check, is_xss, is_remote_upload, 
            add_path_based, redirect_domain_name, root_redirect, redirect_to, is_webshells
        )
        return render_template('index.html', message=message)

    return render_template('index.html')

@main_bp.route('/home')
@requires_auth
def home():
    frontend_count, backend_count, acl_count, layer7_count, layer4_count = count_frontends_and_backends()
    return render_template('home.html', 
                         frontend_count=frontend_count, 
                         backend_count=backend_count, 
                         acl_count=acl_count,
                         layer7_count=layer7_count, 
                         layer4_count=layer4_count)
