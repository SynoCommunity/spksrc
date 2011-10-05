#!/usr/bin/perl -w
#
# Another Perl random password generator
# Usage: passgen.pl [number of passwords] [Length]
##################################################
use strict;

# Get number of passwords to generate and password length from cli arguments
my ($num_pass,$length) = @ARGV;

# default values
$num_pass = 1 if ( $num_pass eq "" );
$length = 8 if ( $length eq "" );

for (1..$num_pass)
{
    my $password = generate();
    print "$password\n";
}

sub generate
{
    my $rand;
    my ($SIZE,$DEVRANDOM) = ($length,"/dev/urandom");
    my @var = ('a'..'z','A'..'Z','0'..'9'); # 62 characters

    open RND, "< $DEVRANDOM";
    read (RND, $rand, $SIZE+1);
    my @rand  = split //, $rand;

    my $passwd="";

    for my $i (1..$SIZE)
    {
                my $tmp = $var[ord($rand[$i])%62];
                        $passwd="$passwd$tmp";
    }
    return $passwd;
}