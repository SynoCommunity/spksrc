#!/usr/bin/perl

use strict;

my $randString=generateRandomString(45);

# build conf file from parameters
open(IN,"/usr/local/gateone/var/conf/gateone.tpl");
open(OUT,">/usr/local/gateone/var/conf/gateone.conf");
while (<IN>) {
	s/==:COOKIE_SECRET:==/$randString/g;
	print OUT $_;
}
close(IN);
close(OUT);

sub generateRandomString
{
	my $length_of_randomstring=shift;

	my @chars=('a'..'z','A'..'Z','0'..'9');
	my $random_string;
	foreach (1..$length_of_randomstring) 
	{
		$random_string.=$chars[rand @chars];
	}
	return $random_string;
}

