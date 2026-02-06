import os
import requests
import csv

HAPROXY_STATS_PORT = os.environ.get('HAPROXY_STATS_PORT', '8280')
HAPROXY_CFG = os.environ.get('HAPROXY_CFG', '/var/packages/haproxy/var/haproxy.cfg')

def get_stats_credentials():
    """Parse stats auth credentials from haproxy.cfg"""
    try:
        with open(HAPROXY_CFG, 'r') as f:
            for line in f:
                line = line.strip()
                if line.startswith('stats auth '):
                    # Format: stats auth user:password
                    auth_part = line[11:].strip()
                    if ':' in auth_part:
                        user, passwd = auth_part.split(':', 1)
                        return user, passwd
    except Exception:
        pass
    return 'admin', 'admin'

def fetch_haproxy_stats():
    stats_url = f'http://127.0.0.1:{HAPROXY_STATS_PORT}/;csv'
    try:
        user, passwd = get_stats_credentials()
        response = requests.get(stats_url, auth=(user, passwd), timeout=5)
        response.raise_for_status()
        return response.text
    except requests.exceptions.RequestException as e:
        return f"Error: {str(e)}"

def parse_haproxy_stats(stats_data):
    data = []
    try:
        reader = csv.DictReader(stats_data.strip().split('\n'))
        for row in reader:
            frontend_name = row.get('# pxname', 'N/A')
            server_name = row.get('svname', 'N/A')
            _4xx_errors = row.get('hrsp_4xx', 'N/A')
            _5xx_errors = row.get('hrsp_5xx', 'N/A')
            bytes_in = row.get('bin', '0')
            bytes_out = row.get('bout', '0')
            conn_tot = row.get('conn_tot', 'N/A')

            bytes_in_mb = round(int(bytes_in) / (1024 * 1024), 2) if bytes_in.isdigit() else 'N/A'
            bytes_out_mb = round(int(bytes_out) / (1024 * 1024), 2) if bytes_out.isdigit() else 'N/A'

            data.append({
                'frontend_name': frontend_name,
                'server_name': server_name,
                '4xx_errors': _4xx_errors,
                '5xx_errors': _5xx_errors,
                'bytes_in_mb': bytes_in_mb,
                'bytes_out_mb': bytes_out_mb,
                'conn_tot': conn_tot
            })
    except Exception:
        pass
    return data
