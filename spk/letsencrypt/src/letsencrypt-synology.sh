#!/bin/sh

# User Defined Variables
lea_cmd="/usr/local/letsencrypt/env/bin/letsencrypt"
lea_opt="certonly -t  --expand --agree-tos --rsa-key-size 4096 --webroot  "
# Here are the letsencrypt files are stored. Certs, logs, usw.
letsencrypt_certs_directory="/usr/local/letsencrypt/data"

show_certs=false

# Dynamic Varables  
httpd_vhost_conf_user_file="/etc/httpd/sites-enabled-user/httpd-vhost.conf-user"
httpd_ssl_vhost_conf_user_file="/etc/httpd/sites-enabled-user/httpd-ssl-vhost.conf-user"

# SSL Systen
sslcrtdir="/usr/syno/etc/ssl/ssl.crt"
sslcsrdir="/usr/syno/etc/ssl/ssl.csr"
sslkeydir="/usr/syno/etc/ssl/ssl.key"
sslcadir="/usr/syno/etc/ssl/ssl.intercrt"


task_start() {
  echo "[ $1 ]"
  #echo "~ - - - - - - - - - - - - - - - - - - - ~"
}

task_end() {
  echo -e "[ DONE ]\n"
}

# Get domains in httpd-ssl-vhost.conf-user
task_start "Searching for virtual hostnames in Webconfig"
echo "Files: $httpd_vhost_conf_user_file ; $httpd_ssl_vhost_conf_user_file"
httpd_ssl_vhost_conf_user_domains="$(grep "ServerName" "$httpd_ssl_vhost_conf_user_file" | sed -e 's/^[[:space:]]*//' | cut -d ' ' -f 2)"

# Remove Carriage Returns
httpd_ssl_vhost_conf_user_domains=$(echo $httpd_ssl_vhost_conf_user_domains|tr -d '\n')
if [ -n "$httpd_ssl_vhost_conf_user_domains" ]
then
  echo "Found virtual hostnames for: $httpd_ssl_vhost_conf_user_domains"
else
  echo "No virtual hostname found."
fi
task_end

# Check if the DS has a external hostname in "Externer Zugriff>Erweitert"
task_start "Search for DS external hostname"
external_host_ip=$(/bin/get_key_value /etc/synoinfo.conf external_host_ip)

if [ -n "$external_host_ip" ]
then
  echo "DS external hostname: $external_host_ip"
  # Add forced hostname and www subdomain to domainlist
  httpd_ssl_vhost_conf_user_domains="$external_host_ip www.$external_host_ip $httpd_ssl_vhost_conf_user_domains"
  letsencrypt_user_domains="-d $external_host_ip"
else
  echo "DS external hostname is NOT set!"
  echo "Define the hostname of you DS in: Systememsteuerung>Externer Zugriff>Erweitert>Hostname"
  exit
fi
task_end


# Test if vhost are accessible from outside for host in $httpd_ssl_vhost_conf_user_domains
task_start "Test if vhost are accessible from outside for host in $httpd_ssl_vhost_conf_user_domains"

for host in $httpd_ssl_vhost_conf_user_domains
do 
echo "Testing: $host"
  nslookup $host
  # Host found in dns
  if [ $? -eq 0 ]
  then
    echo 'Host found in DNS'    
    #Add it to the list of host
    letsencrypt_user_domains="$letsencrypt_user_domains -d $host"
  fi
done
task_end

# Exit if access test faild
if [ -z "$letsencrypt_user_domains" ]
then
  echo "DNS test faild. Check connectivity from internet."
  exit
fi
         

# todo: email maybe different then $external_host_ip. Ask the user on install.
lea_opt=$(echo $lea_opt --email admin@$external_host_ip --keep-until-expiring --webroot-path /var/services/web $letsencrypt_user_domains --config-dir $letsencrypt_certs_directory --work-dir $letsencrypt_certs_directory --logs-dir $letsencrypt_certs_directory)

# Setup "well-known" challenge redirects for HTTPS Web Services
task_start "Setup "well-known" challenge redirects for HTTPS Web Services"
echo "ALL Domains: $external_host_ip $httpd_ssl_vhost_conf_user_domains"
echo "NAS Domain: $external_host_ip"
echo "Web Service Domains: $httpd_ssl_vhost_conf_user_domains"

# Check if Redirect for /.well-known/acme-challenge is in httpd-ssl-vhost.conf-user, if not, then add it.
if grep -q "Alias /.well-known/acme-challenge" "$httpd_ssl_vhost_conf_user_file"; then
    echo "Redirect found, no need to edit: $httpd_ssl_vhost_conf_user_file"
else
    echo "Redirect NOT found in: $httpd_ssl_vhost_conf_user_file"
    echo "Writing Redirect for /.well-known/acme-challenge in: $httpd_ssl_vhost_conf_user_file"
    sed -i -e "/\ServerName*/a Alias /.well-known/acme-challenge /var/services/web/.well-known/acme-challenge" /etc/httpd/sites-enabled-user/httpd-ssl-vhost.conf-user
    sed -i -e "/\ServerName*/a ProxyPass /.well-known/acme-challenge ! " /etc/httpd/sites-enabled-user/httpd-ssl-vhost.conf-user
    cat /etc/httpd/sites-enabled-user/httpd-ssl-vhost.conf-user
    modified=1
fi
task_end

# Check if Redirect for /.well-known/acme-challenge is in httpd-vhost.conf-user, if not, then add it.
task_start "Check if Redirect for /.well-known/acme-challenge is in httpd-vhost.conf-user"
if grep -q "Alias /.well-known/acme-challenge" "$httpd_vhost_conf_user_file"; then
    echo "Redirect found, no need to edit: $httpd_vhost_conf_user_file"
    task_end
else
    echo "Redirect NOT found in: $httpd_vhost_conf_user_file"
    echo "Writing Redirect for /.well-known/acme-challenge in: $httpd_vhost_conf_user_file"

	# Adding Redirect for /.well-known/acme-challenge is in httpd-vhost.conf-user for each domain found.
	sed -i -e "/\ServerName*/a Alias /.well-known/acme-challenge /var/services/web/.well-known/acme-challenge" /etc/httpd/sites-enabled-user/httpd-vhost.conf-user
	sed -i -e "/\ServerName*/a ProxyPass /.well-known/acme-challenge ! " /etc/httpd/sites-enabled-user/httpd-vhost.conf-user
	
  echo "[ Result: ]"    
	cat /etc/httpd/sites-enabled-user/httpd-vhost.conf-user
  task_end
   	
	# Set flag for modified vhost-config
	modified=1
fi

# If configuration files have been modified so we need to restart the webserver for user
if [ -n "$modified" ]
then
	task_start "Configuration have benn modified. Webserver needs restart"
	/sbin/initctl stop httpd-user
	/sbin/initctl start httpd-user
fi

# we create the destination directory if it not exist
# todo: 
mkdir -p "$letsencrypt_certs_directory"

# Run letsencrypt client
task_start "Run letsencrypt client"
echo "$lea_cmd $lea_opt" 
$lea_cmd $lea_opt
task_end


# Certicate Backup/Copy Fuction
file_backup_copy() {
    # Create Backup
    echo "Creating Backup: $2.bak"
    cp "$2" "$2.bak"

    # Output Destination
    echo "Current File: $2"
    if [ "$show_certs" = "true" ] 
    then 
      cat "$2"
    fi

    # Copy Source to Dest
    echo "Coping Source to Destination: ($1) -> ($2)"
    cp "$1" "$2"

    # Output Destination / As is Overwriten by Source
    echo "Current File: $2"
    if [ "$show_certs" = "true" ] 
    then 
      cat "$2"
    fi
}

# Server Key
task_start "Copying LetsEncrypt Server Key"
file_backup_copy "$letsencrypt_certs_directory/live/$external_host_ip/privkey.pem" "$sslkeydir/server.key"
task_end

# Server Cert
#openssl x509 -inform PEM -in /usr/syno/etc/ssl/ssl.crt/server.crt  -text
task_start "Copying LetsEncrypt Server Cert"
file_backup_copy "$letsencrypt_certs_directory/live/$external_host_ip//cert.pem" "$sslcrtdir/server.crt"
task_end

# CA Cert (CHAIN)
task_start "Copying LetsEncrypt CA Cert"
file_backup_copy "$letsencrypt_certs_directory/live/$external_host_ip//chain.pem" "$sslcadir/server-ca.crt"
task_end

# Set Permisions
task_start "Changeing persissions"
chmod 755 $sslcrtdir
chmod 755 $sslcsrdir
chmod 700 $sslkeydir
chmod 777 $sslcadir
chmod 400 $sslcrtdir/*
chmod 400 $sslcsrdir/*
chmod 400 $sslkeydir/*
chmod 777 $sslcadir/*
task_end

task_start "Restart webservices"
/sbin/initctl stop httpd-user
/sbin/initctl start httpd-user

/sbin/initctl stop httpd-sys
/sbin/initctl start httpd-sys

/sbin/initctl stop webdav-httpd-ssl
/sbin/initctl start webdav-httpd-ssl
task_end 
 
