#!/usr/bin/perl
use strict;
use Sys::Hostname;
                                                                                                                                                                                
my $port = qx(awk -F "=" '/^port/ { print \$2}' /usr/local/gateone/var/conf/gateone.conf |sed 's/ //g');
my $redirect = sprintf("%s://%s:%s","https", $ENV{'SERVER_NAME'}, $port);
if ( -e '/usr/local/haproxy/var/haproxy.conf' && -e '/usr/local/haproxy/var/haproxy.pid')
{
       my $ligne = qx(grep 'req_ssl_sni.*gateone' /usr/local/haproxy/var/haproxy.conf);
       if ($ligne =~ /req_ssl_sni +([a-zA-Z0-9-_:\/.]+)/)
       {
               $redirect = "https://$1/";
       }
}
                                                                                                                                                                                
printf "Location: %s\n\n", $redirect;
