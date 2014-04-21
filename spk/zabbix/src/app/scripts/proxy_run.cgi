#!/usr/bin/perl

#check if the user has permission to access this page
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
	<div style='text-align:center'><img src='gui_images/zabbix_logo.png' alt='zabbix'>
	<p style='font-size:20px'>Please login as admin first, before using this webpage</p></div></div></div>
	</div></BODY></HTML>\n";
	die;
}

print "content-type: text/html \n\n";
print <<"EOF";
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="../gui.css" /> 
</head>
<body>
<div class="div-container">
	<div class="SYNO-panel">
		<div class="sub" id="run" style="display:block;">
		<br>
		<br>		
			<fieldset>
			<div style="text-align:center"><img src="../gui_images/zabbix_logo.png" alt="zabbix">
			<p style="font-size:12px">Your request is being processed</p>
			</div>
			</fieldset>
		</div>
	</div>
</div>
EOF
my $status = system("/usr/local/zabbix/sbin/z_proxy_start_stop.sh start");
print <<"EOF2";
</body>
</html>
EOF2
print "<meta HTTP-EQUIV='REFRESH' content='2; url=../index.cgi'>";