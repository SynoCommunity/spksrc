#!/usr/bin/perl

print "Content-type: text/html\n\n";

$user =  `/usr/syno/synoman/webman/modules/authenticate.cgi`;

if ($user eq "")
{
  print "Security : user not authenticated\n";
}
else
{
  print "Security : user authenticated $user\n";
}


