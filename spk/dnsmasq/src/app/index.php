<html>
<head>
  <style type="text/css" media="all">
  #header ul {
    list-style: none;
    padding: 0;
    margin: 0;
  }
  #header li {
    display: inline;
    border: 1px solid;
    border-bottom-width: 0;
    margin: 0 0.5em 0 0;
  }
																		
  #header li a {
    padding: 0 1em;
  }

  #header #selected {
    padding-bottom: 1px;
  }
																																			
  #content {
    border: 1px solid;
  }
  </style>
																																			
 <script type="text/javascript">
   function activateTab(pageId) {
     var tabCtrl = document.getElementById('tabCtrl');
     var pageToActivate = document.getElementById(pageId);
     for (var i = 0; i < tabCtrl.childNodes.length; i++) {
       var node = tabCtrl.childNodes[i];
       if (node.nodeType == 1) { /* Element */
         node.style.display = (node == pageToActivate) ? 'block' : 'none';
       }
     }
   }
 </script>
</head>
 <body>
 <?php
$user=exec('/var/packages/dnsmasq/target/app/authenticate "'. $_SERVER['HTTP_COOKIE'] . '" "'.$_SERVER['REMOTE_ADDR'].'"');
if ( $user !== "admin" ) {
  echo "Please login as admin first, before using this webpage";
  exit;
}
 

$url = 'http://domain.com/backend/editor.php';
$file = '/var/packages/dnsmasq/target/etc/dnsmasq.conf';
$tmpfile = '/var/packages/dnsmasq/target/etc/dnsmasq.conf.tmp';
$output = array();
$savestate = "disabled";

// check if form has been submitted
if (isset($_POST['check']) | isset($_POST['save']) )
{
  // save the text contents
  file_put_contents($tmpfile, $_POST['text']);
  $return_var = 0;
  exec('/var/packages/dnsmasq/target/sbin/dnsmasq --test --conf-file=/var/packages/dnsmasq/target/etc/dnsmasq.conf.tmp 2>&1', $output, $return_var);
  if ( $return_var == 0 ) {
    $savestate=""; 
    if ( isset($_POST['save']) ) 
    {
      file_put_contents($file, $_POST['text']);
    } 
  }
  $content = $_POST['text'];
} else {
  $content = file_get_contents($file);
}
if (isset($_POST['stop']) )
{
  exec('/var/packages/dnsmasq/scripts/start-stop-status stop');
}
if (isset($_POST['start']) )
{
  exec('/var/packages/dnsmasq/scripts/start-stop-status start');
}
?>
<div><pre>
<?php echo exec ('/var/packages/dnsmasq/scripts/start-stop-status status'); ?>
</pre></div>


<div id="header">
<ul>
 <li>
  <a href="javascript:activateTab('page1')">Config</a>
</li>
<li>
  <a href="javascript:activateTab('page2')">Leases</a>
</li>
<li>
  <a href="javascript:activateTab('page3')">Log</a>
</li>
</div>
<div id="tabCtrl">
<div id="page1" style="display: block;">
<form action="" method="post">
<?php
  if (!empty($output)) {
?><div>
  <textarea style="width: 80%; height: 10%;"  name="text"><?php echo implode("\n", $output); ?></textarea>
  </div>
  <?php
  }
  ?>
  <div>
  <textarea  style="width: 80%; height: 50%;"  name="text"><?php echo htmlspecialchars($content) ?></textarea>
  </div>
  <input name="check" type="submit" value="Check" />
  <input name="save" type="submit" value="Save" <?php echo $savestate; ?> />
  <input name="reload" type="submit" value="Reload" />
  <input name="start" type="submit" value="Start" />
  <input name="stop" type="submit" value="Stop" />
</form>
</div>
<div id="page2" style="display: none;">
<div>                                                                                                                                             
  <textarea style="width: 80%; height: 60%;"  name="text"><?php echo file_get_contents('/var/packages/dnsmasq/target/lease/dnsmasq.lease'); ?></textarea>
</div> 
<form action="" method="post">
  <input name="reload" type="submit" value="Reload" />
</form>
</div>
<div id="page3" style="display: none;">
<div>                                                                                                                                             
  <textarea style="width: 80%; height: 70%;"  name="text"><?php echo file_get_contents('/var/packages/dnsmasq/target/log/dnsmasq.log'); ?></textarea>
</div>
<form action="" method="post">
  <input name="reload" type="submit" value="Reload" />
</form>
</div>
</div>
</div>
</body>
	            
            
