#!/usr/bin/perl
use Cwd;
use CGI;

$cgi=new CGI;

# set to "1" to get a /tmp/tinyproxy.txt file
$debug=1;

#open up debugfile
if ($debug) {
	if (!(open(DEBUG,">/tmp/tinyproxy.txt"))) {
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

$tinyproxy_address=$cgi->param('proxyaddress');
$tinyproxy_port=$cgi->param('proxyport');

&sdbg("tinyproxy_address:$tinyproxy_address");
&sdbg("tinyproxy_port:$tinyproxy_port");

		
# Mise à jour du fichier tinyproxy.conf
if (!(open(IN,"/usr/local/tinyproxy/tinyproxy.conf.tpl"))) {
	$res='{ success:false, "msg":"Impossible d\'ouvrir le fichier /usr/local/tinyproxy/tinyproxy.conf.tpl en lecture"}';
} else {
	if (!(open(OUT,">/usr/local/tinyproxy/tinyproxy.conf"))) {
		$res='{ success:false, "msg":"Impossible d\'ouvrir le fichier /usr/local/tinyproxy/tinyproxy.conf en ecriture"}';
		close(IN);
	} else {
		$tmpl{'PORT'} = "Port $tinyproxy_port";
		$tmpl{'LISTEN'} = "Listen $tinyproxy_address";
		while (<IN>) {
			s/==:([^:]+):==/$tmpl{$1}/g;
			print OUT $_;
		}
		close(IN);
		close(OUT);
	}
}

print $res ."\n\n";

&sdbg("sending result:$res");

if ($debug) {
	close(DEBUG);
}

exit 0;
