#!/usr/bin/perl

use strict;
use File::Copy;

my $l;
my %params;
my @services;
my @services_idx;

my $use_backend_http=q{	use_backend http_@SERVICE_NAME@ if { hdr_dom(host) -i @SERVICE_NAME@.@DDNS@ }};
my $use_backend_https=q{	use_backend https_@SERVICE_NAME@ if { req_ssl_sni @SERVICE_NAME@.@DDNS@ }};
my $backend=q{
backend http_@SERVICE_NAME@
	@SERVICE_HTTP_ENABLED@
	mode http
	option forwardfor
	server http_@SERVICE_NAME@ 127.0.0.1:@SERVICE_HTTP_PORT@ check inter 1800000 downinter 10000

backend https_@SERVICE_NAME@
	@SERVICE_HTTPS_ENABLED@
	mode tcp
	timeout server 1h
	option ssl-hello-chk
	server https_@SERVICE_NAME@ 127.0.0.1:@SERVICE_HTTPS_PORT@ check inter 1800000 downinter 10000
};
my $redirect=q{	redirect prefix https://@SERVICE_NAME@.@DDNS@ if { hdr_dom(host) -i @SERVICE_NAME@.@DDNS@ }};

# read ini file
my $i = 0;
my $nolig=0;
open(IN,"haproxy.ini");
while($l=<IN>) 
{
	$nolig++;

	chomp $l;
	if ($l !~ /^(HTTP_PORT=[0-9]+|HTTPS_PORT=[0-9]+|DDNS=([^|]*)\|(.*)|SSH_(PORT=[0-9]+|ENABLED=(enabled|disabled))|(SERVICE[0-9]+)_(NAME=[a-z0-9_]+|ENABLED=(enabled|disabled)|HTTP_PORT=(redirect|[0-9]+|([^|]*)\|(.*))|HTTPS_PORT=([0-9]+|([^|]*)\|(.*))))?$/) 
	{
		print "Ligne $nolig invalide : $l\n";
	}

	if ($l =~ /([^=]+)=([^|]*)\|(.*)/) 
	{
		my $value=getValue($2,$3);
		if ($1 =~ /SERVICE([0-9]+)_([A-Z_]+)/)
		{
			my $idx = $1;			
			$services[$idx]{$2}=$value;
			if ( $2 =~ /(HTTPS?)_PORT/ ) 
			{
				if ( $value == 65535 ) 
				{
					$services[$idx]{$1."_ENABLED"}="disabled";
				} else 
				{
					$services[$idx]{$1."_ENABLED"}="enabled";
				}
			}
		} else
		{
			if ($1 eq "DDNS" && $value == 65535) 
			{
				$value = "localdomain";
			}
			$params{$1}=$value;
		}
	} else	
	{
		if ($l =~ /([^=]+)=(.*)/) 
		{
			my $value=$2;
			my $idx;

			if ($1 =~ /SERVICE([0-9]+)_([A-Z_]+)/)
			{
				$idx = $1;				
				$services[$idx]{$2}=$value;
				if ($2 eq "NAME") 
				{
					$services_idx[$i] = $idx;
					$i++;
				} elsif ($2 eq "HTTP_PORT" && $value eq "redirect") 
				{
					$services[$idx]{"HTTP_PORT"}="65535";
					$services[$idx]{"HTTPS_REDIRECT"}=1;
					$services[$idx]{"HTTP_ENABLED"}="disabled";
				} elsif ( $2 eq "HTTPS_PORT" )
				{
					if ( $value == 65535 ) 
					{
						$services[$idx]{"HTTPS_ENABLED"}="disabled";
					} else 
					{
						$services[$idx]{"HTTPS_ENABLED"}="enabled";
					}
				}
			} else 
			{
				$params{$1}=$value;
			}
		}
	}
}
close(IN);

# build conf file from parameters
open(IN,"haproxy.tpl");
open(OUT,">haproxy.conf");
while($l=<IN>) {
	if ($l =~ /#backend_http#/) {
		for $i (0 .. $#services_idx) {
			my $ligne = $use_backend_http;
			my $idx = $services_idx[$i];
			if ($services[$idx]{"HTTP_PORT"} ne "redirect") {
				$ligne =~ s/\@SERVICE_([^@]+)@/$services[$idx]{$1}/g;
				$ligne =~ s/@([^@]+)@/$params{$1}/g;
				print OUT $ligne."\n";
			}
		}
	} elsif ($l =~ /#redirect#/) {
		for $i (0 .. $#services_idx) {
			my $ligne = $redirect;
			my $idx = $services_idx[$i];
			if ($services[$idx]{"HTTPS_REDIRECT"} == 1) {
				$ligne =~ s/\@SERVICE_([^@]+)@/$services[$idx]{$1}/g;
				$ligne =~ s/@([^@]+)@/$params{$1}/g;
				print OUT $ligne."\n";
			}
		}
	} elsif ($l =~ /#backend_https#/) {
		for $i (0 .. $#services_idx) {
			my $ligne = $use_backend_https;
			my $idx = $services_idx[$i];
			$ligne =~ s/\@SERVICE_([^@]+)@/$services[$idx]{$1}/g;
			$ligne =~ s/@([^@]+)@/$params{$1}/g;
			print OUT $ligne."\n";
		}
	} elsif ($l =~ /#backends#/) {
		for $i (0 .. $#services_idx) {
			my $ligne = $backend;
			my $idx = $services_idx[$i];
			$ligne =~ s/\@SERVICE_([^@]+)@/$services[$idx]{$1}/g;
			$ligne =~ s/@([^@]+)@/$params{$1}/g;
			print OUT $ligne."\n";
		}
	} else {
		$l =~ s/@([^@]+)@/$params{$1}/g;
		print OUT $l;
	}
}
close(IN);
close(OUT);

sub getValue
{
	my $file = $_[0];
	my $regexp = $_[1];
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

