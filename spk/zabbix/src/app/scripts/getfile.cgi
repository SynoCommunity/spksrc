#!/usr/bin/perl
print "Content-type: text/html\n\n";

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

if (open(IN,'configfiles.txt')) { 
    while(<IN>) {
        chop();
        if ((!(/^#/))&&(/,/)) { 
            ($script,$name)=/([^,]+),([^,]+)/;
            $script=~s/^\s*//;
            $name=~s/^\s*//;
            $do{$name}=$script;
        }
    }
    close(IN);
}

close(IN);
$_=$ENV{'QUERY_STRING'};
s/\%20/ /g;
($action)=/action=([^&]+)/;
if (open (IN,$do{$action})) {
    while(<IN>) {
        print;
    }
    close(IN);
} 
