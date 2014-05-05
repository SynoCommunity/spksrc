#!/usr/bin/perl

use File::Copy;

print "Content-type: text/html\n\n";


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



sub addCfgFile {
    ($fname,$name)=@_;
    $fname=~s/^\s*//g;
    $name=~s/^\s*//g;
    if ($tmpljs{'names'}) {
        $tmpljs{'names'}.=',';
    }
    $tmpljs{'names'}.="'" .$name ."'" ;
}

$gotown=0;
if (open(IN,"scripts/configfiles.txt")) {
    while(<IN>) {
        chop();
        if ((!(/^#/))&&(/,/)) {
            ($fname,$name)=/([^,]+),(.*)/;
            addCfgFile($fname,$name);
        }
    }
}

# get javascript
$js="";
if (open(IN,"script.js")) {
    while (<IN>) {
        s/==:([^:]+):==/$tmpljs{$1}/g;
        $js.=$_;
    }
    close(IN);
}


$tmplhtml{'javascript'}=$js;
$tmplhtml{'debug'}=$debug;

# print html page
if (open(IN,"page.html")) {
    while (<IN>) {
        s/==:([^:]+):==/$tmplhtml{$1}/g;
        print $_;
    }
    close(IN);
}
