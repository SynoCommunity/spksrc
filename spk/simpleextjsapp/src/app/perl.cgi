#!/usr/bin/perl

print "Content-type: text/html\n\n";

$user =  `/usr/syno/synoman/webman/modules/authenticate.cgi`;

if ($user eq "")
{
  print "User not authenticated\n";
}
else
{
  print "User authenticated : $user\n";
}


