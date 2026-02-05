import os

HAPROXY_CFG = os.environ.get('HAPROXY_CFG', '/var/packages/haproxy/var/haproxy.cfg')

def is_frontend_exist(frontend_name, frontend_ip, frontend_port):
    try:
        with open(HAPROXY_CFG, 'r') as haproxy_cfg:
            frontend_found = False
            for line in haproxy_cfg:
                if line.strip().startswith('frontend'):
                    _, existing_frontend_name = line.strip().split(' ', 1)
                    if existing_frontend_name.strip() == frontend_name:
                        frontend_found = True
                    else:
                        frontend_found = False
                elif frontend_found and line.strip().startswith('bind'):
                    _, bind_info = line.strip().split(' ', 1)
                    existing_ip, existing_port = bind_info.split(':', 1)
                    if existing_ip.strip() == frontend_ip and existing_port.strip() == frontend_port:
                        return True
        return False
    except FileNotFoundError:
        return False

def is_backend_exist(backend_name):
    try:
        with open(HAPROXY_CFG, 'r') as haproxy_cfg:
            for line in haproxy_cfg:
                line = line.strip()
                if line.startswith('backend') and not line.startswith('#'):
                    parts = line.split()
                    if len(parts) >= 2 and parts[1] == backend_name:
                        return True
        return False
    except FileNotFoundError:
        return False

def update_haproxy_config(frontend_name, frontend_ip, frontend_port, lb_method, protocol, backend_name, backend_servers, health_check, health_check_tcp, health_check_link, sticky_session, add_header, header_name, header_value, sticky_session_type, is_acl, acl_name, acl_action, acl_backend_name, use_ssl, ssl_cert_path, https_redirect, is_dos, ban_duration, limit_requests, forward_for, is_forbidden_path, forbidden_name, allowed_ip, forbidden_path, sql_injection_check, is_xss, is_remote_upload, add_path_based, redirect_domain_name, root_redirect, redirect_to, is_webshells):

    if is_backend_exist(backend_name):
        return f"Backend {backend_name} already exists. Cannot add duplicate."

    with open(HAPROXY_CFG, 'a') as haproxy_cfg:
        haproxy_cfg.write(f"\nfrontend {frontend_name}\n")
        if is_frontend_exist(frontend_name, frontend_ip, frontend_port):
            return "Frontend or Port already exists. Cannot add duplicate."
        haproxy_cfg.write(f"    bind {frontend_ip}:{frontend_port}")
        if use_ssl:
            haproxy_cfg.write(f" ssl crt {ssl_cert_path}\n")
            if https_redirect:
                haproxy_cfg.write(f" redirect scheme https code 301 if !{{ ssl_fc }}")
        haproxy_cfg.write("\n")
        if forward_for:
            haproxy_cfg.write(f"    option forwardfor\n")
        haproxy_cfg.write(f"    mode {protocol}\n")
        haproxy_cfg.write(f"    balance {lb_method}\n")
        if is_dos:
            haproxy_cfg.write(f"    stick-table type ip size 1m expire {ban_duration} store http_req_rate(1m)\n")
            haproxy_cfg.write(f"    http-request track-sc0 src\n")
            haproxy_cfg.write(f"    acl abuse sc_http_req_rate(0) gt {limit_requests}\n")
            haproxy_cfg.write(f"    http-request silent-drop if abuse\n")
        if sql_injection_check:
            haproxy_cfg.write(f"    acl is_sql_injection urlp_reg -i (union|select|insert|update|delete|drop|@@|1=1|`1)\n")
            haproxy_cfg.write(f"    acl is_long_uri path_len gt 400\n")
            haproxy_cfg.write(f"    acl semicolon_path path_reg -i ^.*;.*\n")
            haproxy_cfg.write(f"    acl is_sql_injection2 urlp_reg -i (;|substring|extract|union\\s+all|order\\s+by)\\s+(\\d+|--\\+)\n")
            haproxy_cfg.write(f"    http-request deny if is_sql_injection or is_long_uri or semicolon_path or is_sql_injection2\n")
        if is_xss:
            haproxy_cfg.write(f"    acl is_xss_attack urlp_reg -i (<|>|script|alert|onerror|onload|javascript)\n")
            haproxy_cfg.write(f"    acl is_xss_attack_2 urlp_reg -i (<\\s*script\\s*|javascript:|<\\s*img\\s*src\\s*=|<\\s*a\\s*href\\s*=|<\\s*iframe\\s*src\\s*=|\\bon\\w+\\s*=|<\\s*input\\s*[^>]*\\s*value\\s*=|<\\s*form\\s*action\\s*=|<\\s*svg\\s*on\\w+\\s*=)\n")
            haproxy_cfg.write(f"    acl is_xss_attack_hdr hdr_reg(Cookie|Referer|User-Agent) -i (<|>|script|alert|onerror|onload|javascript)\n")
            haproxy_cfg.write('     acl is_xss_cookie hdr_beg(Cookie) -i "<script" "javascript:" "on" "alert(" "iframe" "onload" "onerror" "onclick" "onmouseover"\n')
            haproxy_cfg.write(f"    http-request deny if is_xss_attack or is_xss_attack_hdr or is_xss_attack_2 or is_xss_cookie\n")
        if is_remote_upload:
            haproxy_cfg.write(f"    acl is_put_request method PUT\n")
            haproxy_cfg.write(f"    http-request deny if is_put_request\n")
        if is_acl:
            haproxy_cfg.write(f"    acl {acl_name} {acl_action}\n")
            haproxy_cfg.write(f"    use_backend {acl_backend_name} if {acl_name}\n")

        if is_forbidden_path:
            haproxy_cfg.write(f"    acl {forbidden_name} src {allowed_ip}\n")
            haproxy_cfg.write(f"    http-request deny if !{forbidden_name} {{ path_beg {forbidden_path} }}\n")

        if add_path_based:
            haproxy_cfg.write(f"    acl is_test_com hdr(host) -i {redirect_domain_name}\n")
            haproxy_cfg.write(f"    acl is_root path {root_redirect}\n")
            haproxy_cfg.write(f"    http-request redirect location {redirect_to} if is_test_com or is_root\n")

        if is_webshells:
            haproxy_cfg.write(f"    option http-buffer-request\n")
            haproxy_cfg.write(f"    acl is_webshell urlp_reg(payload,eval|system|passthru|shell_exec|exec|popen|proc_open|pcntl_exec)\n")
            haproxy_cfg.write(f"    acl is_potential_webshell urlp_reg(payload,php|jsp|asp|aspx)\n")
            haproxy_cfg.write(f"    acl blocked_webshell path_reg -i /(cmd|shell|backdoor|webshell|phpspy|c99|kacak|b374k|log4j|log4shell|wsos|madspot|malicious|evil).*\\.php.*\n")
            haproxy_cfg.write(f"    acl is_suspicious_post hdr(Content-Type) -i application/x-www-form-urlencoded multipart/form-data\n")
            haproxy_cfg.write(f"    http-request deny if blocked_webshell or is_webshell or is_potential_webshell or is_suspicious_post \n")

        haproxy_cfg.write(f"    default_backend {backend_name}\n")

    with open(HAPROXY_CFG, 'a') as haproxy_cfg:
        haproxy_cfg.write(f"\nbackend {backend_name}\n")

        if sticky_session and sticky_session_type == 'cookie':
            haproxy_cfg.write("    cookie SERVERID insert indirect nocache\n")
        if sticky_session and sticky_session_type == 'stick-table':
            haproxy_cfg.write("    stick-table type ip size 200k expire 5m\n")
            haproxy_cfg.write("    stick on src\n")
        if add_header:
            haproxy_cfg.write(f'   http-request set-header {header_name} "{header_value}"\n')
        if protocol == 'http':
            if health_check:
                haproxy_cfg.write(f"    option httpchk GET {health_check_link}\n")
                haproxy_cfg.write(f"    http-check disable-on-404\n")
                haproxy_cfg.write(f"    http-check expect string OK\n")
        if protocol == 'tcp':
            if health_check_tcp:
                haproxy_cfg.write(f"    option tcp-check\n")
                haproxy_cfg.write("    tcp-check send PING\\r\\n\n")
                haproxy_cfg.write("    tcp-check send QUIT\\r\\n\n")
        # Process all backend servers
        for i, backend_server in enumerate(backend_servers, 1):
            if len(backend_server) >= 3:  # Ensure we have name, ip and port
                backend_server_name = backend_server[0] or f"server{i}"
                backend_server_ip = backend_server[1]
                backend_server_port = backend_server[2]
                backend_server_maxconn = backend_server[3] if len(backend_server) > 3 else None

                line = f"    server {backend_server_name} {backend_server_ip}:{backend_server_port} check"
                if sticky_session and sticky_session_type == 'cookie':
                    line += f" cookie {backend_server_name}"
                if backend_server_maxconn:
                    line += f" maxconn {backend_server_maxconn}"
                haproxy_cfg.write(line + "\n")

    return "Frontend and Backend added successfully."

def count_frontends_and_backends():
    frontend_count = 0
    backend_count = 0
    acl_count = 0
    layer7_count = 0
    layer4_count = 0

    try:
        with open(HAPROXY_CFG, 'r') as haproxy_cfg:
            lines = haproxy_cfg.readlines()

            for line in lines:
                line = line.strip()

                if line.startswith('frontend '):
                    frontend_count += 1
                if line.startswith('acl '):
                    acl_count += 1
                if line.startswith('mode http'):
                    layer7_count += 1
                if line.startswith('mode tcp'):
                    layer4_count += 1
                elif line.startswith('backend '):
                    backend_count += 1
    except FileNotFoundError:
        pass

    return frontend_count, backend_count, acl_count, layer7_count, layer4_count
