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


my $DDNS=getValue("/etc/ddns.conf","[ ]*hostname[ ]*=[ ]*([a-zA-Z0-9\-_.]+).*");

open(IN,"/usr/local/gateone/app/config.tpl");
open(OUT,">/usr/local/gateone/app/config");
while (<IN>) {
	s/==:DDNS:==/$DDNS/g;
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

sub getValue
{
	my $file = $_[0];
	my $regexp = $_[1];
	my $l;
	if (open (FIC,$file)) {
		while($l=<FIC>)
		{
			if ($l =~ $regexp)
			{
				close(FIC);
				return $1;
			}
		}
		close(FIC);
	} else {
		return 65535;
	}
	return 65535;
}
