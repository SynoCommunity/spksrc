SPK_NAME = curl
SPK_VERS = 8.21.0
SPK_REV = 1

# package of curl with optional features

DEPENDS = cross/curl

# Configurations for building cURL with additional features

# Valid configurations
# some combinations are not allowed 
# - MultiSSL cannot be enabled with HTTP/3 and vice versa.

# 1) with MultiSSL (without HTTP/2, HTTP/3)
#export BUILD_CURL_WITH="mbedtls gnutls libssh2 libidn2 libpsl gsasl gss ldap zstd brotli websockets"
# Protocols: dict file ftp ftps gopher gophers http https imap imaps ipfs ipns ldap ldaps mqtt mqtts pop3 pop3s rtsp scp sftp smtp smtps telnet tftp ws wss
# Features: alt-svc AsynchDNS brotli gsasl GSS-API HSTS HTTPS-proxy IDN IPv6 Kerberos Largefile libz MultiSSL PSL SPNEGO SSL threadsafe TLS-SRP UnixSockets zstd

# 2) with HTTP/2 and HTTP/3
export BUILD_CURL_WITH="libssh2 libidn2 libpsl nghttp2 nghttp3 gsasl gss ldap zstd brotli websockets"
# Protocols: dict file ftp ftps gopher gophers http https imap imaps ipfs ipns ldap ldaps mqtt mqtts pop3 pop3s rtsp scp sftp smtp smtps telnet tftp ws wss
# Features: alt-svc AsynchDNS brotli gsasl GSS-API HSTS HTTP2 HTTP3 HTTPS-proxy IDN IPv6 Kerberos Largefile libz PSL SPNEGO SSL threadsafe TLS-SRP UnixSockets zstd

export CURL_INCLUDE_EXECUTABLE=1

MAINTAINER = SynoCommunity
DESCRIPTION = Command line tool and library for transferring data with URLs.
STARTABLE = no

HOMEPAGE = https://curl.haxx.se
LICENSE = https://curl.haxx.se/docs/copyright.html

SPK_COMMANDS = bin/curl

include ../../mk/spksrc.spk.mk
