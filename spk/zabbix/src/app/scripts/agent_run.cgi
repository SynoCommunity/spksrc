#!/usr/bin/perl

#check if the user has permission to access this page
#Thanks to QTip from the german Synology forum
require "../check_appprivilege.pl";
my ($synotoken, $synouser, $is_admin) = check_privilege('com.synocommunity.packages.zabbixcontrol');

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
my $status = system("/usr/local/zabbix/sbin/z_agent_start_stop.sh start");
print <<"EOF2";
</body>
</html>
EOF2
print "<meta HTTP-EQUIV='REFRESH' content='2; url=../index.cgi'>";