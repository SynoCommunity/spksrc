locale = "en_US"
pam_service = "login"
session_logging = True
session_dir = "/usr/local/gateone/var/sessions"
cookie_secret = "==:COOKIE_SECRET:=="
address = "0.0.0.0"
port = 8022
log_file_num_backups = 3
logging = "info"
dtach = True
certificate = "/usr/local/gateone/var/server.crt"
keyfile = "/usr/local/gateone/var/server.key"
log_to_stderr = False
log_file_max_size = 1048576
session_timeout = "5d"
command="/usr/local/gateone/gateone/plugins/ssh/scripts/ssh_connect.py -S '/usr/local/gateone/var/sessions/%SESSION%/%SHORT_SOCKET%' --sshfp -a '-oUserKnownHostsFile=%USERDIR%/%USER%/ssh/known_hosts' -c /usr/syno/bin/ssh"
embedded = True
debug = False
auth = None
log_file_prefix = "/usr/local/gateone/var/gateone.log"
origins="*"

