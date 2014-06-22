#!/usr/bin/perl

my (@parts,$part,$buffer,$value,$name,%param,@raw_data);

read(STDIN,$buffer,$ENV{"CONTENT_LENGTH"});

# Are we authenticated yet ?
if (open (IN,"/usr/syno/synoman/webman/login.cgi|")) {
        while(<IN>) {
                if (/SynoToken/) { ($token)=/SynoToken" *: *"([^"]+)"/; }
        }
        close(IN);
}
$TMPENV=$ENV{QUERY_STRING};
$ENV{QUERY_STRING}="SynoToken=$token";

if (open (IN,"/usr/syno/synoman/webman/modules/authenticate.cgi|")) {
    $user=<IN>;
    chop($user);
    close(IN);
}
$ENV{QUERY_STRING}=$TMPENV;

# if not admin or no user at all...no authentication...so, bye-bye

if ($user ne 'admin') {
    print "<HTML><HEAD><TITLE>Login Required</TITLE></HEAD><BODY><div class='div-container'>
    <div class='SYNO-panel'><div class='sub' id='run' style='display:block;'><br><br>
    <div style='text-align:center'><img src='../gui_images/zabbix_logo.png' alt='zabbix'>
    <p style='font-size:20px'>Please login as admin first, before using this webpage</p></div></div></div>
    </div></BODY></HTML>\n";
    die;
}

print "Content-type: application/json; charset=UTF-8\n\n";

use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

sub get_file {
    my $filename = shift;
        if (open(DAT, 'tail -n 100 '. $filename .'  2>&1|')) {
        @raw_data = <DAT>;
        close(DAT);        
        foreach my $line (@raw_data) {
        print $line."<br>";
        } 
    }
}

if ($ENV{'REQUEST_METHOD'} eq "POST") {
    
     @parts = split(/\&/,$buffer);
     #print "\r\nnach usercheck" .$buffer;
     foreach $part (@parts) 
        {   
        ($name,$value) = split(/=/,$part);
        $value =~ tr/+/ /;
        $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
        # prevent include of server side includes
        $value =~ s/<!--(.|\n)*-->//g;
        $param{$name} = $value;
        if ($param{'action'} eq "server.log" )
            {  
            get_file('/usr/local/zabbixagent/var/zabbix_server.log');
            exit;
        }
        if ($param{'action'} eq "proxy.log" )
            {  
            get_file('/usr/local/zabbixagent/var/zabbix_proxy.log');
            exit;
        }
        if ($param{'action'} eq "agentd.log" )
            {  
            get_file('/usr/local/zabbixagent/var/zabbix_agentd.log');
            exit;
        }
    }
}
