locale = "en_US"
pam_service = "login"
session_logging = True
session_dir = "/usr/local/gateone/var/sessions"
cookie_secret = "==:COOKIE_SECRET:=="
address = "0.0.0.0"
port = 8022
log_file_num_backups = 3
logging = "info"
dtach = False
certificate = "/usr/syno/etc/ssl/ssl.crt/server.crt"
keyfile = "/usr/syno/etc/ssl/ssl.key/server.key"
log_to_stderr = False
log_file_max_size = 1048576
session_timeout = "5d"
command="/bin/login"
embedded = True
debug = True
auth = None
log_file_prefix = "/usr/local/gateone/var/gateone.log"
origins="*"

