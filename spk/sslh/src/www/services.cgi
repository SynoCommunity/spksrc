#!/usr/bin/perl
use Cwd;
use CGI;

$cgi=new CGI;

# set to "1" to get a /tmp/sslh.txt file
$debug=0;

#open up debugfile
if ($debug) {
	if (!(open(DEBUG,">/tmp/sslh.txt"))) {
		$debug=0;
	}
}

sub sdbg {
	if ($debug) {
		print DEBUG $_[0] ."\n";
	}
}


print "Content-type: text/html\n\n";


# Are we authenticated yet ?

if (open (IN,"/usr/syno/synoman/webman/modules/authenticate.cgi|")) {
	$user=<IN>;
	chop($user);
	close(IN);
}


# if not admin or no user at all...no authentication...so, bye-bye

if ($user ne 'admin') {
	print '{ success:false, "msg":"Veuillez vous connecter admin."}';
	die;
}

$res='{ success:true, "msg":"Mise à jour terminée avec succès !"}';

$sslh_address=$cgi->param('sslhaddress');
$sslh_port=$cgi->param('sslhport');
$ssh_address=$cgi->param('sshaddress');
$ssh_port=$cgi->param('sshport');
$ssl_address=$cgi->param('ssladdress');
$ssl_port=$cgi->param('sslport');
$vpn_address=$cgi->param('vpnaddress');
$vpn_port=$cgi->param('vpnport');

&sdbg("sslh_address:$sslh_address");
&sdbg("sslh_port:$sslh_port");
&sdbg("ssh_address:$ssh_address");
&sdbg("ssh_port:$ssh_port");
&sdbg("ssl_address:$ssl_address");
&sdbg("ssl_port:$ssl_port");
&sdbg("vpn_address:$vpn_address");
&sdbg("vpn_port:$vpn_port");

# Mise à jour du fichier sslh.ini
if (!(open(SSLH,">/usr/local/sslh/sslh.ini"))) {
	$res='{ success:false, "msg":"Impossible d\'ouvrir le fichier /usr/local/sslh/sslh.ini en écriture"}';
} else {
	print SSLH "listen=$sslh_address:$sslh_port\n";
	print SSLH "ssh=$ssh_address:$ssh_port\n";
	print SSLH "ssl=$ssl_address:$ssl_port\n";
	print SSLH "openvpn=$vpn_address:$vpn_port\n";
	close(SSLH);
}

print $res ."\n\n";

&sdbg("sending result:$res");

if ($debug) {
	close(DEBUG);
}

exit 0;
