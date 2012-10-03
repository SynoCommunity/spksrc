# Simple configuration for an HTTP proxy listening on port 80 on all
# interfaces and forwarding requests to a single backend "servers" with a
# single server "server1" listening on 127.0.0.1:8000
global
	chroot /usr/local/haproxy/chroot
	daemon
	maxconn 256

defaults
	retries 3
	timeout tunnel 1h
	timeout connect 5s
	timeout client 50s
	timeout server 50s

frontend http_in
	bind *:@HTTP_PORT@
	log 127.0.0.1 user info
	option httplog
	mode http
	#redirect#
	#backend_http#

listen https_in 
	bind *:@HTTPS_PORT@
	mode tcp
	option tcplog
	log 127.0.0.1 user info
	tcp-request inspect-delay 8s
	acl is_ssl req_ssl_ver 2:3.1
	use_backend ssh if !is_ssl
	tcp-request content accept if is_ssl
	tcp-request content accept if { req_ssl_hello_type 1 }
	#backend_https#

backend ssh
	@SSH_ENABLED@
	mode tcp
	server ssh :@SSH_PORT@
	timeout connect 5s
	timeout server 1h	

#backends#


