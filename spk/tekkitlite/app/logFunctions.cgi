#!/usr/bin/perl
use File::Copy;
use URI::Escape;

print "Content-type: application/json\n\n";

read(STDIN, $FormData, $ENV{'CONTENT_LENGTH'});
($name, $value) = split(/=/, $FormData);

if (open (IN,"/usr/syno/synoman/webman/modules/authenticate.cgi|")) {
	$user=<IN>;
	chop($user);
	close(IN);
}


# if not admin or no user at all...no authentication...so, bye-bye

if ($user ne 'admin') {
	print('{"ret":"error","error":"Not logged in!"');
	die;
}

if ($name eq 'lineNo') {

	#LIMIT this by 1000 characters or something to stop network spam! (and lag!!)
	my $limit = 1000;
	my $lineNo = 0;
	my $startNo = $value;
	if (open(IN,"/var/packages/TekkitLite/target/server.log")) {
		print('{"ret":"ok","log":"');
		while (<IN>) {
			if ($lineNo < $limit & $lineNo >= $startNo) {
				print(uri_escape($_));
			}
			$lineNo += 1;
		}
		close(IN);
		print('","lineNo":"'.$lineNo.'"}');
	} else {
		print('{"ret":"error","error":"Unable to read log file"');
	}

} else {
	$value = uri_unescape($value);
	@chars = map substr( $value, $_, 1), 0 .. length($value) -1;
	#Remove any extra slashes at the front
	if ($chars[0] eq '/') {
		$value = substr($value, 1, length($value) -1);
	}
	
	if (open(OUT,">>/tmp/stdin.tekkitlite")) {
		print OUT $value."\n";
		close(OUT);
		print('{"ret":"ok","text":"'.$value.'"}');
	} else {
		print('{"ret":"error","error":"Unable to write to log file"');
	}
}
