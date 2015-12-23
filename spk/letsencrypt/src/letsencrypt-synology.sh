#!/bin/sh
# RUN COMMAND: ./letsencrypt-synology_TEST.sh
# DATE: 22/12/2015

# Notes:
# Redirect to HTTPS while ignoring .well-known/acme-challenge for redirects
#RewriteCond %{SERVER_PORT} 80
#RewriteCond %{REQUEST_URI} !^/\.well-known/acme-challenge/?
#RewriteRule ^(.*)$ https://%{SERVER_NAME}/$1 [R=301,L]
# - - - - - - - - - - - - - - - - - - -
# User Defined Varables
lea_cmd="/usr/local/letsencrypt/env/bin/letsencrypt"
lea_opt="certonly -t  --expand --agree-tos --rsa-key-size 4096 --webroot  "

# Dynamic Varables
external_host_ip=$(/bin/get_key_value /etc/synoinfo.conf external_host_ip)

httpd_vhost_conf_user_file="/etc/httpd/sites-enabled-user/httpd-vhost.conf-user"
httpd_ssl_vhost_conf_user_file="/etc/httpd/sites-enabled-user/httpd-ssl-vhost.conf-user"
httpd_ssl_vhost_conf_user_domains="$(grep "ServerName" "$httpd_ssl_vhost_conf_user_file" | sed -e 's/^[[:space:]]*//' | cut -d ' ' -f 2)"  # Get domains in httpd-ssl-vhost.conf-user
httpd_ssl_vhost_conf_user_domains="$external_host_ip www.$external_host_ip $httpd_ssl_vhost_conf_user_domains"
httpd_ssl_vhost_conf_user_domains=$(echo $httpd_ssl_vhost_conf_user_domains|tr -d '\n')  # Remove Carriage Returns
letsencrypt_user_domains="-d $external_host_ip -d $external_host_ip"

# Test if vhost are accessible from outside
for host in $httpd_ssl_vhost_conf_user_domains
do
echo "Testing $host"
nslookup $host
# Host found in dns
if [ $? -eq 0 ]
then
    #Add it to the list of host
    letsencrypt_user_domains="$letsencrypt_user_domains -d $host"
fi
done

letsencrypt_certs_directory="/volume1/letsencrypt/certs/$external_host_ip"
#letsencrypt_user_domains=$(grep "ServerName" "$httpd_ssl_vhost_conf_user_file" | sed -e 's/^[[:space:]]*//' | cut -d ' ' -f 2 | sed -e 's/^/ -d /' | tr -d '\n') # Add -d in front of each host and Remove Carriage Returns
lea_opt=$(echo $lea_opt --email admin@$external_host_ip --webroot-path /var/services/web $letsencrypt_user_domains --config-dir $letsencrypt_certs_directory --work-dir $letsencrypt_certs_directory --logs-dir $letsencrypt_certs_directory)


# Download and Setup LetsEncrypt Client
# cd /volume1/active_system/letsencrypt
# #wget https://github.com/letsencrypt/letsencrypt/archive/v0.1.1.zip
# git clone https://github.com/letsencrypt/letsencrypt
# cd letsencrypt

# Setup "well-known" challenge redirects for HTTPS Web Services
echo "ALL Domains: $external_host_ip $httpd_ssl_vhost_conf_user_domains"
echo "NAS Domain: $external_host_ip"
echo "Web Service Domains: $httpd_ssl_vhost_conf_user_domains"

# Check if Redirect for /.well-known/acme-challenge is in httpd-ssl-vhost.conf-user, if not, then add it.
if grep -q "Alias /.well-known/acme-challenge" "$httpd_ssl_vhost_conf_user_file"; then
    echo "Redirect found, no need to edit: $httpd_ssl_vhost_conf_user_file"
else
    echo "Redirect NOT found in: $httpd_ssl_vhost_conf_user_file"
    echo "Writing Redirect for /.well-known/acme-challenge in: $httpd_ssl_vhost_conf_user_file"

    # Adding Redirect for /.well-known/acme-challenge is in httpd-ssl-vhost.conf-user for each domain found.
#     sed -i -e "/\ServerName*/a Redirect 301 /.well-known/acme-challenge http://$external_host_ip/.well-known/acme-challenge" /etc/httpd/sites-enabled-user/httpd-ssl-vhost.conf-user
    sed -i -e "/\ServerName*/a Alias /.well-known/acme-challenge /var/services/web/.well-known/acme-challenge" /etc/httpd/sites-enabled-user/httpd-ssl-vhost.conf-user
    sed -i -e "/\ServerName*/a ProxyPass /.well-known/acme-challenge ! " /etc/httpd/sites-enabled-user/httpd-ssl-vhost.conf-user
    cat /etc/httpd/sites-enabled-user/httpd-ssl-vhost.conf-user
    modified=1
fi

# Check if Redirect for /.well-known/acme-challenge is in httpd-vhost.conf-user, if not, then add it.
if grep -q "Alias /.well-known/acme-challenge" "$httpd_vhost_conf_user_file"; then
    echo "Redirect found, no need to edit: $httpd_vhost_conf_user_file"
else
    echo "Redirect NOT found in: $httpd_vhost_conf_user_file"
    echo "Writing Redirect for /.well-known/acme-challenge in: $httpd_vhost_conf_user_file"

    # Adding Redirect for /.well-known/acme-challenge is in httpd-vhost.conf-user for each domain found.
#     sed -i -e "/\ServerName*/a Redirect 301 /.well-known/acme-challenge http://$external_host_ip/.well-known/acme-challenge" /etc/httpd/sites-enabled-user/httpd-vhost.conf-user
    sed -i -e "/\ServerName*/a Alias /.well-known/acme-challenge /var/services/web/.well-known/acme-challenge" /etc/httpd/sites-enabled-user/httpd-vhost.conf-user
    sed -i -e "/\ServerName*/a ProxyPass /.well-known/acme-challenge ! " /etc/httpd/sites-enabled-user/httpd-vhost.conf-user
    cat /etc/httpd/sites-enabled-user/httpd-vhost.conf-user
    modified=1
fi

# configuration files have been modified so we need to restart the webserver for user
if [ -n "$modified" ]
/sbin/initctl stop httpd-user
/sbin/initctl start httpd-user
fi


# System httpd
#cat /etc/init/httpd-sys.conf
#cat /etc/httpd/conf/httpd.conf-sys

# we create the destination directory if it not exist
mkdir -p "$letsencrypt_certs_directory"

$lea_cmd $lea_opt

# Run Docker Contained LetsEncrypt
#echo "[ Running LetsEncrypt Docker Container ]"
# http://blog.pavelsklenar.com/how-to-install-and-use-docker-on-synology/
# docker pull dockette/letsencrypt  # pull / update docker image
# docker
# docker
# docker

#echo "PLEASE CONFIGURE & RUN YOUR DOCKER CONTAINER [MANUALLY] NOW"
#read -p "Press [ENTER] key to continue script..."



# Certicate Backup/Copy Fuction
file_backup_copy() {
    echo "~ - - - - - - - - - - - - - - - - - - - ~"

    # Create Backup
    echo "Creating Backup: $2.bak"
    cp "$2" "$2.bak"

    # Output Destination
    echo "Current File: $2"
    cat "$2"

    # Copy Source to Dest
    echo "Coping Source to Destination: ($1) -> ($2)"
    cp "$1" "$2"

    # Output Destination / As is Overwriten by Source
    echo "Current File: $2"
    cat "$2"

    echo "-----------------------------------------"
}

# SSL Systen
sslcrtdir="/usr/syno/etc/ssl/ssl.crt"
sslcsrdir="/usr/syno/etc/ssl/ssl.csr"
sslkeydir="/usr/syno/etc/ssl/ssl.key"
sslcadir="/usr/syno/etc/ssl/ssl.intercrt"

# Server Key
echo "[ Copying LetsEncrypt Server Key ]"
file_backup_copy "$letsencrypt_certs_directory/live/$external_host_ip/privkey.pem" "$sslkeydir/server.key"

# Server Cert
#openssl x509 -inform PEM -in /usr/syno/etc/ssl/ssl.crt/server.crt  -text
echo "[ Copying LetsEncrypt Server Cert ]"
file_backup_copy "$letsencrypt_certs_directory/live/$external_host_ip//cert.pem" "$sslcrtdir/server.crt"

# CA Cert (CHAIN)
echo "[ Copying LetsEncrypt CA Cert ]"
file_backup_copy "$letsencrypt_certs_directory/live/$external_host_ip//chain.pem" "$sslcadir/server-ca.crt"


# Set Permisions
chmod 755 $sslcrtdir
chmod 755 $sslcsrdir
chmod 700 $sslkeydir
chmod 777 $sslcadir
chmod 400 $sslcrtdir/*
chmod 400 $sslcsrdir/*
chmod 400 $sslkeydir/*
chmod 777 $sslcadir/*

# Restart Web Services
# DEBUG: ls /etc/init/
# DEBUG: cat /var/log/upstart/httpd-user.log
/sbin/initctl stop httpd-user
/sbin/initctl start httpd-user

/sbin/initctl stop httpd-sys
/sbin/initctl start httpd-sys

/sbin/initctl stop webdav-httpd-ssl
/sbin/initctl start webdav-httpd-ssl
