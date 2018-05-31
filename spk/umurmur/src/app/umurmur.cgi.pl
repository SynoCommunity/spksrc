#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);

# CGI
my $q = CGI->new;

# Redirect
print $q->redirect("mumble://".$ENV{SERVER_NAME}."/?version=1.2.19");
