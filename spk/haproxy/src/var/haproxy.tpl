# Simple configuration for an HTTP proxy listening on port 80 on all
# interfaces and forwarding requests to a single backend "servers" with a
# single server "server1" listening on 127.0.0.1:8000
global
	chroot /usr/local/haproxy/chroot
	daemon
	maxconn 256

defaults
	retries 3
	option redispatch
	timeout tunnel 1h

frontend http_in
	bind *:@HTTP_PORT@
	log 127.0.0.1 user debug
	option httplog
	mode http
	redirect prefix https://@DSM_NAME@.@DDNS@ if { hdr_dom(host) -i @DSM_NAME@.@DDNS@ }
	#backend_http#

listen https_in 
	bind :@HTTPS_PORT@
	mode tcp
	option tcplog
	log 127.0.0.1 user debug
	tcp-request inspect-delay 8s
	tcp-request content accept if WAIT_END
	acl is_ssl req_ssl_ver 2:3.1
	use_backend ssh if !is_ssl
	tcp-request content accept if is_ssl
	tcp-request content accept if { req_ssl_hello_type 1 }
	use_backend https_@DSM_NAME@ if { req_ssl_sni @DSM_NAME@.@DDNS@ }
	#backend_https#

backend ssh
	@SSH_ENABLED@
	mode tcp
	server ssh :@SSH_PORT@
	timeout connect 5s
	timeout server 2h	

backend http_@DSM_NAME@
	@DSM_ENABLED@
	mode http
	option forwardfor
	timeout server 30s
	timeout connect 4s
	server http_@DSM_NAME@ 127.0.0.1:@DSM_HTTP_PORT@ check inter 30000 downinter 1000

backend https_@DSM_NAME@
	@DSM_ENABLED@
	timeout server 30s
	timeout connect 4s
	option ssl-hello-chk
	server https_@DSM_NAME@ 127.0.0.1:@DSM_HTTPS_PORT@ check inter 30000 downinter 1000

#backend#


