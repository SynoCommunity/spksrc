#!/usr/bin/perl
use File::Copy;

print "Content-type: text/html\n\n";

# Are we authenticated yet ?

if (open (IN,"/usr/syno/synoman/webman/modules/authenticate.cgi|")) {
	$user=<IN>;
	chop($user);
	close(IN);
}


# if not admin or no user at all...no authentication...so, bye-bye

if ($user ne 'admin') {
	print "<HTML><HEAD><TITLE>Login Required</TITLE></HEAD><BODY>Please login as admin first, before using this webpage</BODY></HTML>\n";
	die;
}

open(IN,"/usr/local/tinyproxy/tinyproxy.conf");
while($l=<IN>) {
	if ($l =~ /^(Port|Listen)\s+(.*)/)
	{
		$key=$1;
		$value=$2;
		if ($tmpljs{'tinyproxy'}) {
			$tmpljs{'tinyproxy'}.=",";
		}
		$tmpljs{'tinyproxy'}.="[\'$key\',\'$value\']";
	}
}
close(IN);
$tmpljs{'tinyproxy'}="[".$tmpljs{'tinyproxy'}."]";

# get javascript
$js="";
if (open(IN,"script.js")) {
	while (<IN>) {
		s/==:([^:]+):==/$tmpljs{$1}/g;
		$js.=$_;
	}
	close(IN);
}


$tmplhtml{'javascript'}=$js;

# print html page
if (open(IN,"page.html")) {
	while (<IN>) {
		s/==:([^:]+):==/$tmplhtml{$1}/g;
		print $_;
	}
	close(IN);
}

