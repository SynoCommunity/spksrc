#!/usr/bin/perl
use File::Copy;
use File::stat;
use URI::Escape;

print "Content-type: application/json\n\n";

read(STDIN, $FormData, $ENV{'CONTENT_LENGTH'});
%args = map {split(/=/, $_)} split(/&/, $FormData);

if (open (IN,"/usr/syno/synoman/webman/modules/authenticate.cgi|")) {
	$user=<IN>;
	chop($user);
	close(IN);
}


# if not admin or no user at all...no authentication...so, bye-bye

if ($user ne 'admin') {
	print('{"ret":"error","error":"Not logged in!"}');
	die;
}

if (exists $args{'lineNo'}) {

	my $lineNo = 0;
	my $startNo = $args{'lineNo'};
	my $lastChangeTime = $args{'lastLogTime'};

	#LIMIT this by 100 lines or something to stop network spam! (and lag!!)
	my $limit = 100;

	if (open(IN,"/var/packages/tekkitlite/target/server.log")) {
		my $ctime = stat(IN)->ctime;
		print('{"ret":"ok","log":"');
		my $startLoopTime = time();
		#while($ctime == $lastChangeTime) {
		while(1) {
			#Wait until there is something to return
			sleep 1;	
			if (time() >= $startLoopTime + 55 || stat(IN)->ctime > $lastChangeTime) {
				last;
			}
		}
		while (<IN>) {
			if ($lineNo >= $startNo) {
				print(uri_escape($_));
			}
			$lineNo += 1;
			if (($lineNo - $startNo) >= $limit) {
				$lastChangeTime = 0;
				last; #Finish the loop and return what we have so far
			} else {
				$lastChangeTime = $ctime;
			}
		}
		close(IN);
		print('","lineNo":"'.$lineNo.'","lastLogTime":"'.$lastChangeTime.'"}');
	} else {
		print('{"ret":"error","error":"Unable to read log file"}');
	}

} else {
	$value = uri_unescape($args{'text'});
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
		print('{"ret":"error","error":"Unable to write to log file"}');
	}
}
