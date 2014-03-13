#!/usr/bin/perl

#check if the user has permission to access this page
#Thanks to QTip from the german Synology forum
require "check_appprivilege.pl";
my ($synotoken, $synouser, $is_admin) = check_privilege('com.synocommunity.packages.zabbixcontrol');

use strict;
use CGI;
use warnings;
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);

print "Content-type: text/html\n\n";

my $server=new CGI;
my $proxy=new CGI;
my $agent=new CGI;
if($server->param('input1')){
	open FH, ">/usr/local/zabbix/etc/zabbix_server.conf" or die $!;
	print FH $server->param('SYNOsettings1');
	close FH;
	system("/usr/local/zabbix/sbin/z_server_start_stop.sh stop");
	system("/usr/local/zabbix/sbin/z_server_start_stop.sh start");
	print "<meta HTTP-EQUIV='REFRESH' content='0; url=index.cgi'>";
}elsif($proxy->param('input2')){
	open FH, ">/usr/local/zabbix/etc/zabbix_proxy.conf" or die $!;
	print FH $proxy->param('SYNOsettings2');
	close FH;
	system("/usr/local/zabbix/sbin/z_proxy_start_stop.sh stop");
	system("/usr/local/zabbix/sbin/z_proxy_start_stop.sh start");
	print "<meta HTTP-EQUIV='REFRESH' content='0; url=index.cgi'>";
}elsif($agent->param('input3')){
	open FH, ">/usr/local/zabbix/etc/zabbix_agentd.conf" or die $!;
	print FH $agent->param('SYNOsettings3');
	close FH;
	system("/usr/local/zabbix/sbin/z_agent_start_stop.sh stop");
	system("/usr/local/zabbix/sbin/z_agent_start_stop.sh start");
	print "<meta HTTP-EQUIV='REFRESH' content='0; url=index.cgi'>";
}

print <<"EOF";

<!DOCTYPE html>


<html>
<head>
<link rel="stylesheet" type="text/css" href="gui.css" /> 
</head>

<body>

<div class="div-container">

	<div class="SYNO-list">
		<div id="run-selected" class="x-list-selected">
			<div style=
			"width:220px;height:50px;" class="SYNO-list-column" 
			onclick="document.getElementById('settings-selected').className='';
			document.getElementById('run-selected').className='x-list-selected';
			document.getElementById('run').style.display='block';
			document.getElementById('settings').style.display='none';">
				<div class="SYNO-list-run">Zabbix Services</div>
			</div>
		</div>
		
		<div id="settings-selected">
			<div style=
			"width:220px;height:50px;" class="SYNO-list-column" 
			onclick="document.getElementById('settings-selected').className='x-list-selected';
			document.getElementById('run-selected').className='';
			document.getElementById('run').style.display='none';
			document.getElementById('settings').style.display='block';">
				<div class="SYNO-list-settings">Zabbix Settings</div>
			</div>
		</div>
		<br>
		<br>
		<div style="text-align:center;font-size:12px;font-weight: bold;color:#294766;margin-left:10px;margin-right:15px;">
EOF
		if (-e "/usr/local/zabbix/var/zabbix_server.pid") {
		print "Zabbix Server<br>";
		print "<img src=gui_images/on.png>"
		}else{
		print "Zabbix Server<br>";
		print "<img src=gui_images/off.png>"
		} 
print <<"EOF1";	
		</div>	
		<br>
		<div style="text-align:center;font-size:12px;font-weight: bold;color:#294766;margin-left:10px;margin-right:15px;">
EOF1
		if (-e "/usr/local/zabbix/var/zabbix_proxy.pid") {
		print "Zabbix Proxy<br>";
		print "<img src=gui_images/on.png height=42></img>"
		}else{
		print "Zabbix Proxy<br>";
		print "<img src=gui_images/off.png>"
		} 
print <<"EOF2";	
		</div>	
		<br>
		<div style="text-align:center;font-size:12px;font-weight: bold;color:#294766;margin-left:10px;margin-right:15px;">
EOF2
		if (-e "/usr/local/zabbix/var/zabbix_agentd.pid") {
		print "Zabbix Agent<br>";
		print "<img src=gui_images/on.png>"
		}else{
		print "Zabbix Agent<br>";
		print "<img src=gui_images/off.png>"
		} 
print <<"EOF3";	
		</div>	
	
	
	</div>
	
	<div class="SYNO-panel">
		<div class="sub" id="run" style="display:block;">
		<img src="gui_images/zabbix_logo.png" alt="zabbix">
		<br>		
			<fieldset>
			<legend>Zabbix Server</legend>
			<div class="SYNO-button">
				<div id="run-button-state0" class="" align="center">
					<div class="SYNO-button-left">&nbsp;</div><div onclick=
					"location.href=('scripts/server_run.cgi');
					" onmousedown="document.getElementById('run-button-state0').className='mousedown';
					" onmouseover="document.getElementById('run-button-state0').className='mouseover';
					" onmouseout="document.getElementById('run-button-state0').className='';
					" class="SYNO-button-center SYNO-button-text">&nbsp;Start Zabbix Server&nbsp;
					</div><div class="SYNO-button-right">&nbsp;</div>
				</div>
				<div id="run-button-state1" class="" align="center">	
					<div class="SYNO-button-left">&nbsp;</div><div onclick=
					"location.href=('scripts/server_stop.cgi');
					" onmousedown="document.getElementById('run-button-state1').className='mousedown';
					" onmouseover="document.getElementById('run-button-state1').className='mouseover';
					" onmouseout="document.getElementById('run-button-state1').className='';
					" class="SYNO-button-center SYNO-button-text">&nbsp;Stop Zabbix Server&nbsp;
					</div><div class="SYNO-button-right">&nbsp;</div>	
				</div>
			</div>
			<br>
			<div style="text-align:center;font-size:12px;margin-left:10px;margin-right:15px;">Zabbix Server Log
			<textarea name="" rows="10" style="width:100%" disabled>
EOF3
			open( my $zabbixserverlog, "/usr/local/zabbix/var/zabbix_server.log");
			while ( <$zabbixserverlog> ) {
		  	chomp;
	  	 	print "$_\n";
			}
			close ($zabbixserverlog);
print <<"EOF4";		
			</textarea>
			</div>
			</fieldset>
		<br>
			<fieldset>
			<legend>Zabbix Proxy</legend>
			<div class="SYNO-button">
				<div id="run-button-state2" class="" align="center">
					<div class="SYNO-button-left">&nbsp;</div><div onclick=
					"location.href=('scripts/proxy_run.cgi');
					" onmousedown="document.getElementById('run-button-state2').className='mousedown';
					" onmouseover="document.getElementById('run-button-state2').className='mouseover';
					" onmouseout="document.getElementById('run-button-state2').className='';
					" class="SYNO-button-center SYNO-button-text">&nbsp;Start Zabbix Proxy&nbsp;
					</div><div class="SYNO-button-right">&nbsp;</div>
				</div>
				<div id="run-button-state3" class="" align="center">				
					<div class="SYNO-button-left">&nbsp;</div><div onclick=
					"location.href=('scripts/proxy_stop.cgi');
					" onmousedown="document.getElementById('run-button-state3').className='mousedown';
					" onmouseover="document.getElementById('run-button-state3').className='mouseover';
					" onmouseout="document.getElementById('run-button-state3').className='';
					" class="SYNO-button-center SYNO-button-text">&nbsp;Stop Zabbix Proxy&nbsp;
					</div><div class="SYNO-button-right">&nbsp;</div>					
				</div>
			</div>
			<br>
			<div style="text-align:center;font-size:12px;margin-left:10px;margin-right:15px;">Zabbix Proxy Log
			<textarea name="" rows="10" style="width:100%" disabled>
EOF4
			open( my $zabbixproxylog, "/usr/local/zabbix/var/zabbix_proxy.log");
			while ( <$zabbixproxylog> ) {
		  	chomp;
	  	 	print "$_\n";
			}
			close ($zabbixproxylog);
print <<"EOF5";		
			</textarea>
			</div>
			</fieldset>
		<br>
			<fieldset>
			<legend>Zabbix Agent</legend>
			<div class="SYNO-button">
				<div id="run-button-state4" class="" align="center">
					<div class="SYNO-button-left">&nbsp;</div><div onclick=
					"location.href=('scripts/agent_run.cgi');
					" onmousedown="document.getElementById('run-button-state4').className='mousedown';
					" onmouseover="document.getElementById('run-button-state4').className='mouseover';
					" onmouseout="document.getElementById('run-button-state4').className='';
					" class="SYNO-button-center SYNO-button-text">&nbsp;Start Zabbix Agent&nbsp;
					</div><div class="SYNO-button-right">&nbsp;</div>
				</div>
				<div id="run-button-state5" class="" align="center">	
					<div class="SYNO-button-left">&nbsp;</div><div onclick=
					"location.href=('scripts/agent_stop.cgi');
					" onmousedown="document.getElementById('run-button-state5').className='mousedown';
					" onmouseover="document.getElementById('run-button-state5').className='mouseover';
					" onmouseout="document.getElementById('run-button-state5').className='';
					" class="SYNO-button-center SYNO-button-text">&nbsp;Stop Zabbix Agent&nbsp;
					</div><div class="SYNO-button-right">&nbsp;</div>	
				</div>
			</div>
			<br>
			<div style="text-align:center;font-size:12px;margin-left:10px;margin-right:15px;">Zabbix Agent Log
			<textarea name="" rows="10" style="width:100%" disabled>
EOF5
			open( my $zabbixagentdlog, "/usr/local/zabbix/var/zabbix_agentd.log");
			while ( <$zabbixagentdlog> ) {
		  	chomp;
	  	 	print "$_\n";
			}
			close ($zabbixagentdlog);
print <<"EOF6";		
			</textarea>
			</div>
			</fieldset>
		</div>
	
		
		<div class="sub" id="settings" style="display:none;">
			<fieldset>
			<legend>Zabbix Server Config</legend>
			<form method="GET" action="" id="libform1">
			<p style="font-size:14px;margin-left:10px;margin-right:15px;">
			<textarea name="SYNOsettings1" rows="20" style="width:100%">
EOF6
			open (server, "/usr/local/zabbix/etc/zabbix_server.conf");
			while (<server>){
		  	chomp;
	  	 	print "$_\n";
			}
			close (server);
print <<"EOF7";			
			</textarea>
			<input type="hidden" name="input1" value="1">
			<div class="SYNO-button">
				<div id="lib-button-state1" class="">
					<div class="SYNO-button-left">&nbsp;</div><div onclick=
					"document.getElementById('libform1').submit();
					" onmousedown="document.getElementById('lib-button-state1').className='mousedown';
					" onmouseover="document.getElementById('lib-button-state1').className='mouseover';
					" onmouseout="document.getElementById('lib-button-state1').className='';
					" class="SYNO-button-center SYNO-button-text">&nbsp;Save Config & Restart Service&nbsp;
					</div><div class="SYNO-button-right">&nbsp;</div>
				</div>
			</div>
			</p>
			</form>
			<p style="font-size:12px;margin-left:10px;margin-right:15px;">
			<b>Info:</b><br>
			You can find more info on configuration file <a href="https://www.zabbix.com/documentation/2.2/manual/appendix/config/zabbix_server" target="_blank">Here</a> 
			</p>
			</fieldset>
		<br>
			<fieldset>
			<legend>Zabbix Proxy Config</legend>
			<form method="GET" action="" id="libform2">
			<p style="font-size:14px;margin-left:10px;margin-right:15px;">
			<textarea name="SYNOsettings2" rows="20" style="width:100%">
EOF7
			open (proxy, "/usr/local/zabbix/etc/zabbix_proxy.conf");
			while (<proxy>){
		  	chomp;
	  	 	print "$_\n";
			}
			close (proxy);
print <<"EOF8";			
			</textarea>
			<input type="hidden" name="input2" value="1">
			<div class="SYNO-button">
				<div id="lib-button-state2" class="">
					<div class="SYNO-button-left">&nbsp;</div><div onclick=
					"document.getElementById('libform2').submit();
					" onmousedown="document.getElementById('lib-button-state2').className='mousedown';
					" onmouseover="document.getElementById('lib-button-state2').className='mouseover';
					" onmouseout="document.getElementById('lib-button-state2').className='';
					" class="SYNO-button-center SYNO-button-text">&nbsp;Save Config & Restart Service&nbsp;
					</div><div class="SYNO-button-right">&nbsp;</div>
				</div>
			</div>
			</p>
			</form>
			<p style="font-size:12px;margin-left:10px;margin-right:15px;">
			<b>Info:</b><br>
			You can find more info on configuration file <a href="https://www.zabbix.com/documentation/2.2/manual/appendix/config/zabbix_proxy" target="_blank">Here</a>
			</p>
			</fieldset>
		<br>
			<fieldset>
			<legend>Zabbix Agent Config</legend>
			<form method="GET" action="" id="libform3">
			<p style="font-size:14px;margin-left:10px;margin-right:15px;">
			<textarea name="SYNOsettings3" rows="20" style="width:100%">
EOF8
			open (agent, "/usr/local/zabbix/etc/zabbix_agentd.conf");
			while (<agent>){
		  	chomp;
	  	 	print "$_\n";
			}
			close (agent);
print <<"EOF9";			
			</textarea>
			<input type="hidden" name="input3" value="1">
			<div class="SYNO-button">
				<div id="lib-button-state3" class="">
					<div class="SYNO-button-left">&nbsp;</div><div onclick=
					"document.getElementById('libform3').submit();
					" onmousedown="document.getElementById('lib-button-state3').className='mousedown';
					" onmouseover="document.getElementById('lib-button-state3').className='mouseover';
					" onmouseout="document.getElementById('lib-button-state3').className='';
					" class="SYNO-button-center SYNO-button-text">&nbsp;Save Config & Restart Service&nbsp;
					</div><div class="SYNO-button-right">&nbsp;</div>
				</div>
			</div>
			</p>
			</form>
			<p style="font-size:12px;margin-left:10px;margin-right:15px;">
			<b>Info:</b><br>
			You can find more info on configuration file <a href="https://www.zabbix.com/documentation/2.2/manual/appendix/config/zabbix_agentd" target="_blank">Here</a>
			</p>
			</fieldset>
		</div>
	</div>
</div>

</body>
</html>

EOF9
#