#!/bin/sh

# Sync ca certificates
/var/packages/mono/target/bin/cert-sync /etc/ssl/certs/ca-certificates.crt
