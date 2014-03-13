#***********************************************************************#
#  check_appprivilege.pl                                                #
#  Description: Script zur Abfrage der Berechtigung des aktiven         #
#               Benutzers zur Benutzung der aufgerufenden Applikation.  #
#               Damit wird die Steuerung der Berechtigungen             #
#               auch für 3rdparty Apps über Systemsteuerung -           #
#               Anwendungsberechtigungen möglich.                       #
#               Nun mit Abfrage vom SynoToken (DSM 4.x/DSM 5.x)         #
#  Author:      QTip from the german Synology support forum             #
#  Copyright:   2012-2014 by QTip                                       #
#  License:     GNU GPLv3 (see LICENSE)                                 #
#  -------------------------------------------------------------------  #
#  Version:     0.6 - 25/01/2014                                        #
#  for more information check the changelog                             #
#***********************************************************************#

sub check_privilege {
     my $appname = shift;
     my $token = '';
     use CGI;
     use CGI::Carp qw(fatalsToBrowser);

     # hole SynoToken...
     $token = `/usr/syno/synoman/webman/login.cgi`;
     $token =~ /\"SynoToken\"\s*?:\s*?\"(.*)\"/i;
     $synotoken = $1;
     $ENV{'QUERY_STRING'} = 'SynoToken='.$synotoken;
     $ENV{'X-SYNO-TOKEN'} = $synotoken;

     # und prüfe ob Benutzer angemeldet ist...
     $synouser = `/usr/syno/synoman/webman/modules/authenticate.cgi`;
     $synouser =~ s/^\s+|\s+$//g;

     # wenn leerer String zurückgegeben wird (nicht angemeldet), dann verlasse die Applikation mit exit
     exit if ($synouser eq '');

     my ($start,$found);
     if (open (IN, "/usr/syno/synoman/webman/initdata.cgi|")) {
          while (<IN>) {
               chomp;
               if ($_ =~ /AppPrivilege/i) {$start = 1; next;} # wenn der Abschnitt "AppPrivilege" gefunden wurde, dann flag setzen und zur nächsten Zeile
               if ($_ =~ /Session/i) {$start = 2; next;} # wenn der Abschnitt "Session" gefunden wurde, dann flag auf 2 setzen und zur nächsten Zeile
               if ($start == 1 && $_ =~ /$appname/) {
                    # wenn Applikation gefunden wurde, dann hat der Benutzer die Berechtigung und wir springen aus der Schleife
                    $found = 1;
                    $start = 0;
               } elsif ($start == 2 && $_ =~ /\"is_admin\"\s*?:\s*?true,/) {
                    # ist der aktuelle User in der Administratoren-Gruppe, merken und weiter
                    $is_admin = 1;
                    last;
               }
               if ($start && $_ =~ /}/) {$start = 0; next;} # Ende des Abschnitts erkannt
          }
          close (IN);
          # wenn Applikation nicht gefunden wurde, dann Umleitung zum DSM
          unless ($found || $synouser eq "admin") {
               print "Status: 302 Found\n";
               print "Location: /\n";
               print "URI: </>\n";
               print "Content-type: text/html\n\n";
               exit;
          }
     }
     return ($synotoken,$synouser,$is_admin);
}
1;
