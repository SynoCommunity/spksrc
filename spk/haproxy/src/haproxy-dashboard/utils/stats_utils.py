import os
import requests
import csv

HAPROXY_STATS_PORT = os.environ.get('HAPROXY_STATS_PORT', '8280')
HAPROXY_STATS_URL = f'http://127.0.0.1:{HAPROXY_STATS_PORT}/;csv'

def fetch_haproxy_stats():
    try:
        response = requests.get(HAPROXY_STATS_URL)
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
