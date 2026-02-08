#! /usr/bin/perl  -w
#
# Explain to the user that the URL is blocked and by which rule set
#
# Original by PÂl Baltzersen 1999 (pal.baltzersen@ost.eltele.no)
# French texts thanks to Fabrice Prigent (fabrice.prigent@univ-tlse1.fr)
# Dutch texts thanks to Anneke Sicherer-Roetman (sicherer@sichemsoft.nl)
# German texts thanks to Buergernetz Pfaffenhofen (http://www.bn-paf.de/filter/)
# Spanish texts thanks to Samuel Garc√≠a.
# Russian texts thanks to Vladimir Ipatov.
# Rewrite by Christine Kronberg, 2008, to enable an easier integration of
# other languages.
#

# By accepting this notice, you agree to be bound by the following
# agreements:
# 
# This software product, squidGuard, is copyrighted (C) 1998-2008
# by Christine Kronberg, Shalla Secure Services. All rights reserved.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License (version 2) as
# published by the Free Software Foundation.  It is distributed in the
# hope that it will be useful, but WITHOUT ANY WARRANTY; without even
# the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
# PURPOSE.  See the GNU General Public License (GPL) for more details.
# 
# You should have received a copy of the GNU General Public License
# (GPL) along with this program.

use strict;
use Socket;
#
# GLOBAL VALUES:
#
my ($clientaddr,$clientname,$clientuser,$clientgroup,$targetgroup,$url);
my (@supported,$image,$redirect,$autoinaddr,$proxy,$proxymaster);
my $lang="en"; 
my (%msgconf,%title,%logo,%msg,%tab,%word);
my ($protocol,$address,$port,$path,$refererhost,$referer);
my %Babel = ();
my $rechts="";
my $links="";
my $dummy="";
sub getpreferedlang(@);
sub parsequery($);
sub status($);
sub redirect($);
sub content($);
sub expires($);
sub msg($$);
sub gethostnames($);
sub spliturl($);
sub showhtml($);
sub showimage($$$);
sub showinaddr($$$$$);

#
# CONFIGURABLE OPTIONS:
#
# (Currently: "en", "fr", "de", "es", "nl", "no", "ru")
@supported   = (
		"en (English), ",
		"fr (Fran&#231;ais), ",
		"de (Deutsch), ",
		"es (Espa&#241;ol), ",
		"nl (Nederlands), ",
		"no (Norsk), ",
		"ru (Russian)."
	       );
#
# Modifiy the values below to reflect you environment
# The image you define with "$image" and redirect will be displayed if the unappropriate
# url is of the type: gif, jpg, jpeg, png, mp3, mpg, mpeg, avi or mov.
#
$image       = "blocked.gif";					# RELATIVE TO DOCUMENT_ROOT
$redirect    = "http://admin.your-domain/images/blocked.gif";		# "" TO AVOID REDIRECTION
$proxy       = "proxy.your-domain";					# Your proxy server
$proxymaster = "operator\@your-domain";					# The email of your proxy adminstrator
$autoinaddr  = 2;			# 0|1|2;
					# 0 TO NOT REDIRECT
					# 1 TO AUTORESOLVE & REDIRECT IF UNIQUE
					# 2 TO AUTORESOLVE & REDIRECT TO FIRST NAME

# You may wish to enter your company link and logo to be displayed on the page
my $company = "SynoCommunity";
my $companylogo = "synocommunity.png";

my $squidguard = "http://www.squidguard.org";
my $squidguardlogo = "http://www.squidguard.org/Logos/squidGuard.gif";

########################################################################################
#
# SUBROUTINES:
#

#
# RETURN THE FIRST SUPPORTED LANGUAGE OF THE BROWSERS PREFERRED OR THE
# DEFAULT:
#
sub getpreferedlang(@) {
  my @supported = @_;
  my @languages = split(/\s*,\s*/,$ENV{"HTTP_ACCEPT_LANGUAGE"}) if(defined($ENV{"HTTP_ACCEPT_LANGUAGE"}));
  my $lang;
  my $supp;
  push(@languages,$supported[0]);
  for $lang (@languages) {
    $lang =~ s/\s.*//;
    $lang = substr($lang,0,2);
    for $supp (@supported) {
      $supp =~ s/\s.*//;
      return($lang) if ($lang eq $supp);
    }
  }
}

#
# PARSE THE QUERY_STRING FOR KNOWN KEYS:
#
sub parsequery($) {
  my $query       = shift;
  my $clientaddr  = "$Babel{Unknown}";
  my $clientname  = "$Babel{Unknown}";
  my $clientuser  = "$Babel{Unknown}";
  my $clientgroup = "$Babel{Unknown}";
  my $targetgroup = "$Babel{Unknown}";
  my $url         = "$Babel{Unknown}";
  if (defined($query)) {
    while ($query =~ /^\&?([^\&=]+)=\"([^\"]*)\"(.*)/ || $query =~ /^\&?([^\&=]+)=([^\&=]*)(.*)/) {
      my $key = $1;
      my $value = $2;
      $value = "$Babel{Unknown}" unless(defined($value) && $value && $value ne "unknown");
      $query = $3;
      if ($key =~ /^(clientaddr|clientname|clientuser|clientgroup|targetgroup|url)$/) {
	eval "\$$key = \$value";
      }
      if ($query =~ /^url=(.*)/) {
	$url = $1;
	last;
      }
    }
  }
  return($clientaddr,$clientname,$clientuser,$clientgroup,$targetgroup,$url);
}

#
# PRINT HTTP STATUS HEADER:
#
sub status($) {
  my $status = shift;
  print "Status: $status\n";
}

#
# PRINT HTTP LOCATION HEADER:
#
sub redirect($) {
  my $location = shift;
  print "Location: $location\n";
}

#
# PRINT HTTP CONTENT-TYPE HEARER:
#
sub content($) {
  my $contenttype = shift;
  print "Content-Type: $contenttype\n";
}

#
# PRINT HTTP LAST-MODIFIED AND EXPIRES HEARER:
#
sub expires($) {
  my $ttl = shift;
  my $time = time;
  my @day = ("Sun","Mon","Tue","Wed","Thu","Fri","Sat");
  my @month = ("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
  my ($sec,$min,$hour,$mday,$mon,$year,$wday) = gmtime($time);
  printf "Last-Modified: %s, %d %s %d", $day[$wday],$mday,$month[$mon],$year+1900;
  printf " %02d:%02d:%02d GMT\n", $hour,$min,$sec;
  ($sec,$min,$hour,$mday,$mon,$year,$wday) = gmtime($time+$ttl);
  printf "Expires: %s, %d %s %d", $day[$wday],$mday,$month[$mon],$year+1900;
  printf " %02d:%02d:%02d GMT\n", $hour,$min,$sec;
}

#
# REVERSE LOOKUP AND RETURN NAMES:
#
sub gethostnames($) {
  my $address = shift;
  my ($name,$aliases) = gethostbyaddr(inet_aton($address), AF_INET);
  my @names;
  if (defined($name)) {
    push(@names,$name);
    if (defined($aliases) && $aliases) {
      for(split(/\s+/,$aliases)) {
	next unless(/\./);
	push(@names,$_);
      }
    }
  }
  return(@names);
}

#
# SPLIT AN URL INTO PROTOCOL, ADDRESS, PORT AND PATH:
#
sub spliturl($) {
  my $url      = shift;
  my $protocol = "";
  my $address  = "";
  my $port     = "";
  my $path     = "";
  $url =~ /^([^\/:]+):\/\/([^\/:]+)(:\d*)?(.*)/;
  $protocol = $1 if(defined($1));
  $address  = $2 if(defined($2));
  $port     = $3 if(defined($3));
  $path     = $4 if(defined($4));
  return($protocol,$address,$port,$path);
}

#
# SEND OUT AN IMAGE:
#
sub showimage($$$) {
  my ($type,$file,$redirect) = @_;
  content("image/$type");
  expires(300);
  redirect($redirect) if($redirect);
  print "\n";
  open(GIF, "$ENV{\"DOCUMENT_ROOT\"}$file");
  print <GIF>;
  close(GIF)
}

#
# SHOW THE INADDR ALERNATIVES WITH OPTIONAL ATOREDIRECT:
#
sub showinaddr($$$$$) {
  my ($targetgroup,$protocol,$address,$port,$path) = @_;
  my $msgid = $targetgroup;
  my @names = gethostnames($address);
  if($autoinaddr == 2 && @names || $autoinaddr && @names==1) {
    status("301 Moved Permanently");
    redirect("$protocol://$names[0]$port$path");
  } elsif (@names>1) {
    status("300 Multiple Choices");
  } elsif (@names) {
    status("301 Moved Permanently");
  } else {
    status("404 Not Found");
  }
  if (@names) {
    print "Content-type: text/html\n\n";
    print "<!DOCTYPE html PUBLIC \"-//W3C//DTD  HTML 4.0 Transitional//EN\" \"http://www.w3.org/TR/REC-html40/loose.dtd\">\n";
    print "<html><head>\n";
    print "<title>$Babel{Title}</title>\n";
    print "</head>\n";
    print "<body bgcolor=#E6E6FA> \n";
    expires(0);
    $msgid = "in-addr" unless(defined($msgconf{$msgid}));
    if (defined($msgconf{$msgid})) {
      print "  <!-- showinaddr(\"$msgid\") -->\n";
      for (@{$msgconf{$msgid}}) {
	my @config = split(/:/);
	my $type = shift(@config);
	if ($type eq "msg") {
	  msg($config[0],$config[1]);
	} elsif ($type eq "tab") {
	  table(shift(@config),shift(@config),@config);
	} elsif ($type eq "alternatives") {
	  print "  <TABLE BORDER=0 ALIGN=CENTER>\n";
	  for (@names) {
	    print "   <TR>\n    <TH ALIGN=LEFT>\n     <FONT SIZE=+1>";
	    href("$protocol://$_$port$path");
	    print "\n     </FONT>\n    </TH>\n   </TR>\n";
	  }
	  print "  </TABLE>\n\n";
	  if (defined($ENV{"HTTP_REFERER"}) && $ENV{"HTTP_REFERER"} =~ /:\/\/([^\/:]+)/) {
	    $refererhost = $1;
	    $referer = $ENV{"HTTP_REFERER"};
	    msg("H4","referermaster");
	  }
	}
      }
    } 
  }
  return;
}


########################################################################################
#
#                                   MAIN   PROGRAM
#
# To change the messages in the blocked page please refer to the corresponding babel file.
#
$lang = getpreferedlang(@supported);

open (BABEL, "babel.$lang") || warn "Unable to open language file:   $!\n";
flock (BABEL, 2);
   while (<BABEL>) {
      chomp $_ ;
      ($links, $rechts) =  split (/=/, $_);
       $Babel{$links} = $rechts;
    }
flock (BABEL, 8);
close (BABEL);

($clientaddr,$clientname,$clientuser,$clientgroup,$targetgroup,$url) = parsequery($ENV{"QUERY_STRING"});
($protocol,$address,$port,$path) = spliturl($url);

if ($url =~ /\.(gif|jpg|jpeg|png|mp3|mpg|mpeg|avi|mov)$/i) {
  status("403 Forbidden");
  showimage("gif",$image,$redirect);
  exit 0;
}
if ($targetgroup eq "in-addr") {
   showinaddr($targetgroup,$protocol,$address,$port,$path);
}

status("403 Forbidden");
expires(0);
print "Content-type: text/html\n\n";
print "<!DOCTYPE html PUBLIC \"-//W3C//DTD  HTML 4.0 Transitional//EN\" \"http://www.w3.org/TR/REC-html40/loose.dtd\">\n";
print "<html><head>\n";
print "<title>$Babel{Title}</title>\n";
print "</head>\n";
print "<body bgcolor=#E6E6FA> \n";

print "\n";
print "<a href=$company>\n";
print "<img align=left border=0 alt=\"\" src=$companylogo></a>\n";
print "<a href=$squidguard>\n";
print "<img align=right border=0 alt=\"\" src=$squidguardlogo></a><br><br>\n";
print "<center>\n";
print "<table border=0 width=80%>\n";
print "<tr><td align=center>\n";

print "<h2>$Babel{Msg}</h2>\n";
print "<br><br>\n";

print "<b>$Babel{Tabcaption}</b><br><br>\n";

print "<table border=4>\n";
print "<tr>\n";
print "<td>$Babel{TabIP}</td><td>&nbsp;$clientaddr</td>\n";
print "</tr>\n";

print "<tr>\n";
print "<td>$Babel{Tabclientname}</td><td>&nbsp;$clientname</td>\n";
print "</tr>\n";

print "<tr>\n";
print "<td>$Babel{Tabclientuser}</td><td>&nbsp;$clientuser</td>\n";
print "</tr>\n";

print "<tr>\n";
print "<td>$Babel{Tabclientgroup}</td><td>&nbsp;$clientgroup</td>\n";
print "</tr>\n";

print "<tr>\n";
print "<td>$Babel{Taburl}</td><td>&nbsp;$url</td>\n";
print "</tr>\n";

print "<tr>\n";
print "<td>$Babel{Tabtargetgroup}</td><td>&nbsp;$targetgroup</td>\n";
print "</tr>\n";
print "</table>\n";
print "<br><br>\n";

print "</td></tr>\n";
print "<tr><td>\n";
if ($targetgroup eq "in-addr") {
   print "$Babel{msginaddr}<br><br>\n";
   print "$Babel{msgnoalternatives} <U>",$address,"</U>.<br>\n";
   print "$Babel{msgwebmaster}\n";
}
print "<br><br>\n";
print "$Babel{msgrefresh}\n";

print "</td></tr></table>\n";

# bottom of page
print "</center>\n";
print "<br><br>\n";
print "<hr>\n";
print "<font size=-1>\n";
print "$Babel{msgdeflang} ",@supported, "\n";
print "</font>\n";
print "</body></html>\n";



exit 0 ;
