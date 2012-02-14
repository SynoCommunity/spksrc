#!/usr/bin/perl -w

use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);

# Const
my $SYAUTH = "/usr/syno/synoman/webman/modules/authenticate.cgi|";

# CGI
my $q = CGI->new;

# Controller
if (&isAuthed()) {
	print $q->redirect("mumble://".$ENV{SERVER_NAME}."/?version=1.2.3");
} else {
	print $q->header;
	print $q->start_html("uMurmur - Authentication required");
	print $q->h4("Please connect to DSM to continue...");
	print $q->end_html;
}





#################
# Subs are here #
#################
#
# Check for user's authentication
sub isAuthed {
	my $user;
	if (open(IN,$SYAUTH)) {
		$user=<IN>;
		chop($user);
		close(IN);
	}
	if (!$user) {
		return 0;
	}
	return 1;
}
