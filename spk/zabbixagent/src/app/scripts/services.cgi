#!/usr/bin/perl


use CGI;
use warnings;


print "content-type: text/html \n\n";


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

my $serverstart = new CGI;
my $serverrestart = new CGI;
my $serverstop = new CGI;
my $proxystart = new CGI;
my $proxyrestart = new CGI;
my $proxystop = new CGI;
my $agentstart = new CGI;
my $agentrestart = new CGI;
my $agentstop = new CGI;

print <<"EOF";
<!DOCTYPE html>
<html>
<head>
</head>
<body>
<div>
    <div>
        <div>
            <br>
            <br>        
            <fieldset>
                <div style="text-align:center"><br><img src="gui_images/zabbix_logo.png" alt="zabbix">
                    <p style="font-size:12px"><br>Your request is being processed</p><br>
                </div>
            </fieldset>
        </div>
    </div>
</div>
EOF
if($serverstart->param('startserver')){
    system("/usr/local/zabbixagent/sbin/z_server_start_stop.sh start");
}
if($serverrestart->param('restartserver')){
    system("/usr/local/zabbixagent/sbin/z_server_start_stop.sh restart");
}
if($serverstop->param('stopserver')){
    system("/usr/local/zabbixagent/sbin/z_server_start_stop.sh stop");
}
if($proxystart->param('startproxy')){
    system("/usr/local/zabbixagent/sbin/z_proxy_start_stop.sh start");
}
if($proxyrestart->param('restartproxy')){
    system("/usr/local/zabbixagent/sbin/z_proxy_start_stop.sh restart");
}
if($proxystop->param('stopproxy')){
    system("/usr/local/zabbixagent/sbin/z_proxy_start_stop.sh stop");
}
if($agentstart->param('startagent')){
    system("/usr/local/zabbixagent/sbin/z_agent_start_stop.sh start");
}
if($agentrestart->param('restartagent')){
    system("/usr/local/zabbixagent/sbin/z_agent_start_stop.sh restart");
}
if($agentstop->param('stopagent')){
    system("/usr/local/zabbixagent/sbin/z_agent_start_stop.sh stop");
}
print <<"EOF2";
</body>
</html>
EOF2

