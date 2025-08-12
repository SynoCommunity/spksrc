MUSEUM="${SYNOPKG_PKGDEST}/bin/museum"
CONFIG_FILE="${SYNOPKG_PKGVAR}/museum.yaml"
DATA_DIR="${SYNOPKG_PKGVAR}/data"
NGINX_CONFIG="${SYNOPKG_PKGVAR}/nginx.conf"

if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
    SYNOPKG_PKGHOME="${SYNOPKG_PKGVAR}"
fi

WORK_DIR="${SYNOPKG_PKGVAR}/work"

# Set group based on DSM version
if [ ${SYNOPKG_DSM_VERSION_MAJOR} -ge 7 ]; then
    GROUP="synocommunity"
else
    GROUP="sc-ente"
fi

if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
    ENV="HOME=${SYNOPKG_PKGHOME} LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib GIN_MODE=release"
else
    ENV="HOME=${SYNOPKG_PKGHOME} LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib GIN_MODE=release"
fi

SVC_CWD="${WORK_DIR}"
# Start both museum server and nginx web server
SERVICE_COMMAND="env ${ENV} ${MUSEUM} --config ${CONFIG_FILE}
nginx -c ${NGINX_CONFIG}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y
PID_FILE="${SYNOPKG_PKGVAR}/ente.pid"

generate_random_keys ()
{
    # Generate cryptographically secure keys matching Ente's requirements
    # - Encryption: 32 bytes (crypto_secretbox_KEYBYTES) -> base64 standard encoding
    # - Hash: 64 bytes (crypto_generichash_KEYBYTES_MAX) -> base64 standard encoding  
    # - JWT: 32 bytes (crypto_secretbox_KEYBYTES) -> base64 URL encoding for JWT spec
    ENCRYPTION_KEY=$(openssl rand -base64 32)
    HASH_KEY=$(openssl rand -base64 64)
    # Use base64url encoding for JWT (replace + with -, / with _, remove padding =)
    JWT_SECRET=$(openssl rand -base64 32 | tr '+/' '-_' | tr -d '=')
}

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Get NAS IP address for configuration
        IP=$(ip route get 1 2>/dev/null | awk '{print $(NF);exit}' || echo "localhost")
        
        # Create data directory
        mkdir -p "${DATA_DIR}"
        
        # Set up initial configuration if config file doesn't exist
        if [ ! -f "${CONFIG_FILE}" ]; then
            # Copy template configuration and update with detected IP for fresh installs only
            cp "${SYNOPKG_PKGDEST}/var/museum.yaml" "${CONFIG_FILE}"
            # Replace NAS IP placeholder with detected IP (fresh installs only)
            sed -i "s|ENTE_NAS_IP_PLACEHOLDER|${IP}|g" "${CONFIG_FILE}"
            
            # Generate fresh security keys for production use
            generate_random_keys
            
            # Replace placeholder keys with generated ones
            sed -i "s|ENTE_ENCRYPTION_KEY_PLACEHOLDER|${ENCRYPTION_KEY}|g" "${CONFIG_FILE}"
            sed -i "s|ENTE_HASH_KEY_PLACEHOLDER|${HASH_KEY}|g" "${CONFIG_FILE}"
            sed -i "s|ENTE_JWT_SECRET_PLACEHOLDER|${JWT_SECRET}|g" "${CONFIG_FILE}"
            
            chown ${EFF_USER}:${GROUP} "${CONFIG_FILE}" 2>/dev/null || true
            
            # Update help documentation with detected IP (fresh installs only)
            HELP_FILE="${SYNOPKG_PKGDEST}/app/help/enu/index.html"
            if [ -f "${HELP_FILE}" ]; then
                sed -i "s|host: localhost|host: ${IP}|g" "${HELP_FILE}"
                # Also update any other localhost references in help
                sed -i "s|http://localhost:|http://${IP}:|g" "${HELP_FILE}"
            fi
        fi
        
        # MinIO bucket must be created manually
        
        # Create symlinks so museum can find required directories from any working directory
        WORK_DIR="${SYNOPKG_PKGVAR}/work"
        mkdir -p "${WORK_DIR}"
        if [ ! -L "${WORK_DIR}/configurations" ]; then
            ln -sf "${SYNOPKG_PKGDEST}/share/server/configurations" "${WORK_DIR}/configurations"
        fi
        if [ ! -L "${WORK_DIR}/migrations" ]; then
            ln -sf "${SYNOPKG_PKGDEST}/share/server/migrations" "${WORK_DIR}/migrations"
        fi
        if [ ! -L "${WORK_DIR}/mail-templates" ]; then
            ln -sf "${SYNOPKG_PKGDEST}/share/server/mail-templates" "${WORK_DIR}/mail-templates"
        fi
        if [ ! -L "${WORK_DIR}/web-templates" ]; then
            ln -sf "${SYNOPKG_PKGDEST}/share/server/web-templates" "${WORK_DIR}/web-templates"
        fi
        if [ ! -L "${WORK_DIR}/museum.yaml" ]; then
            ln -sf "${CONFIG_FILE}" "${WORK_DIR}/museum.yaml"
        fi
        
        # Create credentials.yaml with Synology-specific database settings
        # Uses PostgreSQL peer authentication with database name = username
        if [ ! -f "${WORK_DIR}/credentials.yaml" ]; then
            
            cat > "${WORK_DIR}/credentials.yaml" << EOF
# Synology NAS configuration overrides for Ente
#
# This file overrides default settings from local.yaml and museum.yaml
# Config loading order: local.yaml -> credentials.yaml -> museum.yaml
# 
# This provides the correct Synology-specific configuration for database,
# HTTP port, logging, and web endpoints.
# Synology NAS database credentials (using Unix socket)
db:
  host: /run/postgresql
  port: 5432
  user: sc-ente
  name: sc-ente
  sslmode: disable

# HTTP configuration override
http:
  port: 8080

# Log file override
log-file: ${DATA_DIR}/museum.log

# Web app endpoints override
apps:
  public-albums: "http://${IP:-localhost}:8097"
EOF
            chown ${EFF_USER}:${GROUP} "${WORK_DIR}/credentials.yaml" 2>/dev/null || true
        fi
        
        # Create nginx configuration for web interface (regenerate on every install)
        # Remove old config to ensure we use the latest version
        rm -f "${NGINX_CONFIG}"
            # Create nginx working directories
            mkdir -p "${SYNOPKG_PKGVAR}/nginx/logs"
            mkdir -p "${SYNOPKG_PKGVAR}/nginx/client_body_temp"
            mkdir -p "${SYNOPKG_PKGVAR}/nginx/proxy_temp"
            mkdir -p "${SYNOPKG_PKGVAR}/nginx/fastcgi_temp"
            mkdir -p "${SYNOPKG_PKGVAR}/nginx/uwsgi_temp"
            mkdir -p "${SYNOPKG_PKGVAR}/nginx/scgi_temp"
            
            cat > "${NGINX_CONFIG}" << EOF
pid ${SYNOPKG_PKGVAR}/nginx/nginx.pid;
error_log ${SYNOPKG_PKGVAR}/nginx/logs/error.log;

events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    
    access_log ${SYNOPKG_PKGVAR}/nginx/logs/access.log;
    
    client_body_temp_path ${SYNOPKG_PKGVAR}/nginx/client_body_temp;
    proxy_temp_path       ${SYNOPKG_PKGVAR}/nginx/proxy_temp;
    fastcgi_temp_path     ${SYNOPKG_PKGVAR}/nginx/fastcgi_temp;
    uwsgi_temp_path       ${SYNOPKG_PKGVAR}/nginx/uwsgi_temp;
    scgi_temp_path        ${SYNOPKG_PKGVAR}/nginx/scgi_temp;
    
    sendfile        on;
    keepalive_timeout  65;
    
    server {
        listen 8097;
        server_name _;
        
        # Root directory for Ente web static files
        root /volume1/@appstore/ente/web;
        index index.html;
        
        # Serve static files
        location / {
            try_files \$uri \$uri/ /index.html;
            
            # Add CORS headers for API calls
            add_header 'Access-Control-Allow-Origin' '*' always;
            add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS' always;
            add_header 'Access-Control-Allow-Headers' 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range,Authorization,X-Auth-Token,X-Auth-Access-Token,X-Cast-Access-Token,X-Auth-Access-Token-JWT,X-Client-Package,X-Client-Version' always;
            add_header 'Access-Control-Expose-Headers' 'Content-Length,Content-Range,X-Request-Id' always;
        }
        
        # Proxy API calls to museum server
        location /api {
            proxy_pass http://127.0.0.1:8080;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
            
            # Handle CORS preflight requests
            if (\$request_method = 'OPTIONS') {
                add_header 'Access-Control-Allow-Origin' '*';
                add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS';
                add_header 'Access-Control-Allow-Headers' 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range,Authorization,X-Auth-Token,X-Auth-Access-Token,X-Cast-Access-Token,X-Auth-Access-Token-JWT,X-Client-Package,X-Client-Version';
                add_header 'Access-Control-Max-Age' 1728000;
                add_header 'Content-Type' 'text/plain; charset=utf-8';
                add_header 'Content-Length' 0;
                return 204;
            }
        }
        
        # Proxy health check endpoint
        location /ping {
            proxy_pass http://127.0.0.1:8080;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
        
        # Handle Next.js assets
        location /_next/ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
        
        # Handle images and static assets
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }
}
EOF
            chown ${EFF_USER}:${GROUP} "${NGINX_CONFIG}" 2>/dev/null || true
        
        # Set permissions (only needed for DSM < 7)
        if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
            chown -R ${EFF_USER}:${GROUP} "${SYNOPKG_PKGVAR}"
        fi
        chmod -R u+rw "${SYNOPKG_PKGVAR}"
    fi
}


service_restore ()
{
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        # Make a copy of the new config file before it gets overwritten by restore
        [ -f "${CONFIG_FILE}" ] && cp -f "${CONFIG_FILE}" "${TMP_DIR}/museum.yaml.new"
    fi
}

service_poststop ()
{
    # Clean up any remaining nginx processes
    if [ -f "${NGINX_CONFIG}" ]; then
        # Kill any nginx processes using our config file
        pkill -f "nginx -c ${NGINX_CONFIG}" 2>/dev/null || true
    fi
}