#!/usr/bin/perl
use File::Copy;
use File::stat;
use URI::Escape;
use Time::HiRes qw(usleep);
use Cwd 'realpath';

#Synoshare error codes
my $ERR_NO_SUCH_SHARE = '0x1400';
my $ERR_SHARE_EXISTS = '0x1300';

my $tekkitPath = '/var/packages/tekkitlite/target';
my $downloadLoc = '/webman/3rdparty/tekkitlite/server.log.tar.gz';

if ( read(STDIN, $FormData, $ENV{'CONTENT_LENGTH'}) == 0 ) {
	$FormData = $ENV{'QUERY_STRING'}
}
%args = map {split(/=/, $_)} split(/&/, $FormData);

print "Content-type: application/json\n\n";

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

########################
#####   GET LOG    #####
########################
if (exists $args{'lineNo'}) {

	my $lineNo = 0;
	my $startNo = $args{'lineNo'};
	my $lastChangeTime = $args{'lastLogTime'};

	#LIMIT this by 100 lines or something to stop network spam! (and lag!!)
	my $limit = 100;

	if (open(IN,"$tekkitPath/server.log")) {
		my $ctime = stat(IN)->ctime;
		print('{"ret":"ok","log":"');
		my $startLoopTime = time();
		#while($ctime == $lastChangeTime) {
		while(1) {
			#Wait until there is something to return
			usleep(500);	 #microseconds
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

} 
########################
#####   SEND TEXT  #####
########################
elsif (exists $args{'text'}) {
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
########################
##### DOWNLOAD LOG #####
########################
elsif ($args{'download'}) {
	system("tar zc -f server.log.tar.gz -C $tekkitPath server.log");
	move("$tekkitPath/server.log.tar.gz", "$tekkitPath/app/server.log.tar.gz");
	print('{"ret":"ok","location":"'.$downloadLoc.'"}');
} 
########################
#####  CLEAR LOG   #####
########################
elsif ($args{'clearlog'}) {
	$now = localtime;
	if (open(OUT,">$tekkitPath/server.log")) {
		print OUT "==Log cleared at: $now==\n"; #Print something to stop the console freaking out
	}
	close(OUT);
	print('{"ret":"ok","text":"Log cleared."}');
} 
########################
##### MOUNT FOLDER #####
########################
elsif ($args{'mountfolder'}) {
	print('{"ret":"ok","text":"');
	
	#Does the tekkitlite share already exist ?
	my @shareExists = split(/synoerr=/, `synoshare --get TekkitLite`);
	if (exists $shareExists[1]) {
		$shareExists = substr($shareExists[1], 1); #Remove the '['
		$shareExists = substr($shareExists, 0, -2); #Remove the ']'
	} else {
		$shareExists = '0';
	}
	
	if ( $shareExists ne $ERR_NO_SUCH_SHARE) {
		#If yes, delete it, leaving the data
		if (uri_escape(`synoshare --del false TekkitLite`) == ''){ #If successful, then no output is received
			print "TekkikLite share removed OK";		
		}
	} else {
		#If no, create it!
		my $realPath = realpath($tekkitPath);
		my $exec = 'synoshare --add TekkitLite "" '.$realPath.' "" "@administrators" "guest" 1 0';
		if (uri_escape(`$exec`) == '') {
			print "TekkitLite share added OK ";
		}
	}
	print('"}');
} else {
	print('{"ret":"error","error":"Im not sure what to do here...","fd":"'.$FormData.'"}');
}
