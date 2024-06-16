<!DOCTYPE html>
<html>

<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="icon" type="image/png" href="./images/demowebservice-16.png" sizes="16x16" />
<link rel="icon" type="image/png" href="./images/demowebservice-32.png" sizes="32x32" />

<!-- page tabs are based on https://www.w3schools.com/howto/howto_js_full_page_tabs.asp -->
<style>
  * {box-sizing: border-box}

  /* Set height of body and the document to 100% */
  body, html {
    height: 100%;
    margin: 0;
    font-family: Arial;
  }

  /* Style tab links */
  .tablink {
<?php 
if (version_compare(PHP_VERSION, '8.0', '<=')) {
    print "background-color: #44A;";
} else {
    print "background-color: #66F;";
}
?>
    color: black;
    float: left;
    border: none;
    outline: none;
    cursor: pointer;
    padding: 14px 16px;
    font-size: 18px;
    width: 33.33%;
  }

  .tablink:hover {
<?php 
if (version_compare(PHP_VERSION, '8.0', '<=')) {
    print "background-color: #66F;";
} else {
    print "background-color: #44A;";
}
?>
  }

  /* Style the tab content (and add height:100% for full page content) */
  /* PHP >= 8: phpInfo adapts the color scheme, so we must define scheme dependent colors */
  /*           but for PHP 7 use light mode only */
  @media (prefers-color-scheme: light) {
    .tabcontent {
      color: black;
      background-color: white;
      display: none;
      padding: 80px 20px;
      height: 100%;
    }
  }
  @media (prefers-color-scheme: dark) {
    .tabcontent {
<?php 
if (version_compare(PHP_VERSION, '8.0', '<=')) {
      print "color: black;";
      print "background-color: white;";
} else {
      print "color: white;";
      print "background-color: #333;";
}
?>
      display: none;
      padding: 80px 20px;
      height: 100%;
    }
  }
  
</style>
</head>

<title>Demo Web Service</title>

<body>
<button class="tablink" onclick="openPage('about', this)" id="defaultOpen">About</button>
<button class="tablink" onclick="openPage('phpinfo', this)" >PHP info</button>
<button class="tablink" onclick="openPage('share', this)">Shared Folder</button>

<div id="about" class="tabcontent">

  <h3>Demo Web Service</h3>
  <p>This is a demo web service package for synology DSM.</p>
  <p>It demonstrates how to build a package to integrate with web server and PHP.</p>
  <p>It also shows how to configure and use a shared folder.</p>

  <p>The source code is located in the SynoCommunity respository under <a target="_blank" href="https://github.com/SynoCommunity/spksrc/tree/master/spk/demowebservice">demowebservice</a>.</p>

  <h4>List of server variables:</h4>
  <p><small><pre><?php foreach($_SERVER as $key_name => $key_value) { print $key_name . " = " . $key_value . "<br>"; } ?></pre></small></p>
  
<?php 
if (version_compare(PHP_VERSION, '8.0', '<=')) {
  print "<hr><em><p align='center'>on PHP less than 8.x <tt>phpinfo()</tt> does not support dark mode and we use light mode for all pages.</p></em><hr>";
}
?>  
  
</div>

<div id="phpinfo" class="tabcontent">
<?php phpinfo(); ?>
</div>

<div id="share" class="tabcontent">
  <h3>Shared Folder</h3>
  <p>Name of the shared folder is <b><span>@@shared_folder_name@@</span></b>.</p>
  <p>Full path of the shared folder is <b><span>@@shared_folder_fullname@@</span></b>.</p>
  
  <p>The following list of files and folders shows that the package has access to this folder.</p>

  <h4>Content of the shared folder:</h4>
<?php
  $path = "@@shared_folder_fullname@@";

  $open_basedir = ini_get('open_basedir');
  $open_basedirs = explode(":",$open_basedir);
  if (!empty($open_basedir) && !in_array($path,$open_basedirs))
  {
    echo "<b><p style='color: red;'>ERROR: open_basedir restriction in effect. Path (".$path.") is not within the allowed path(s).</p></b>";
    echo "<p> open_basedir=".ini_get('open_basedir')."</p>";
    echo "<p>You have to add <b><span>".$path."</span></b> to the php <b><span>open_basedir</span></b> to list the folder content.</p>";
  }
  else
  {
    if (file_exists($path)) {
      try {
        print_folder($path);
      }
      catch (Exception $e) {
        echo "<b><p style='color: red;'>ERROR: ".$e->getMessage()."</p></b>";
      }
    }
    else {
      echo "<b><p style='color: red;'>The folder '".$path."' does not exist.</p></b>";
    }
  }

  function add_list_element($dom, $parent, $fileinfo)
  {
    $info = $fileinfo->getFilename();
    if ( !$fileinfo->isDir() ) {
      $info .= " size=[".$fileinfo->getSize()." bytes]";
    }
    $info .= " access=[";
    if ($fileinfo->isReadable())   { $info .= "r"; } else { $info .= "-"; }
    if ($fileinfo->isWritable())   { $info .= "w"; } else { $info .= "-"; }
    if ($fileinfo->isExecutable()) { $info .= "x"; } else { $info .= "-"; }
    $info .= "]";
    $info .= " owner=[".$fileinfo->getOwner().":".$fileinfo->getGroup()."]" ;

    $li = $dom->createElement('li', $info);
    $parent->appendChild($li);
  }

  // print directory tree based on the accepted answer in:
  // https://stackoverflow.com/questions/10779546/recursiveiteratoriterator-and-recursivedirectoryiterator-to-nested-html-lists
  function print_folder($path)
  {
    $directoryIteratorFlags = FilesystemIterator::KEY_AS_PATHNAME|FilesystemIterator::CURRENT_AS_FILEINFO|FilesystemIterator::SKIP_DOTS;
    $objects = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($path, $directoryIteratorFlags), RecursiveIteratorIterator::SELF_FIRST);
    $dom = new DomDocument("1.0");
    $list = $dom->createElement("ul");
    $dom->appendChild($list);
    $node = $list;
    $depth = 0;
    foreach ($objects as $name => $object) {
      if ($objects->getDepth() == $depth) {
        // the depth hasn't changed so just add another li
        add_list_element($dom,$node,$object);
      }
      elseif ($objects->getDepth() > $depth) {
        // the depth increased, the last li is a non-empty folder 
        $li = $node->lastChild;
        $ul = $dom->createElement('ul');
        $li->appendChild($ul);
        add_list_element($dom,$ul,$object);
        $node = $ul;
      }
      else {
        // the depth decreased, going up $difference directories
        $difference = $depth - $objects->getDepth();
        for ($i = 0; $i < $difference; $difference--) {
            $node = $node->parentNode->parentNode;
        }
        add_list_element($dom,$node,$object);
      }
      $depth = $objects->getDepth();
    }
    echo $dom->saveHtml();
  }
?>
</div>


<script>
  function openPage(pageName,activeTabLink) {
    var i, tabcontent, tablinks;
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
      tabcontent[i].style.display = "none";
    }
    tablinks = document.getElementsByClassName("tablink");
    for (i = 0; i < tablinks.length; i++) {
      tablinks[i].style.color = 'white';
      tablinks[i].style.backgroundColor = "";
    }
    document.getElementById(pageName).style.display = "block";
<?php
if (version_compare(PHP_VERSION, '8.0', '<=')) {
    print "activeTabLink.style.color = 'black';";
    print "activeTabLink.style.backgroundColor = 'white';";
} else {
    print "activeTabLink.style.color = 'white';";
    print "activeTabLink.style.backgroundColor = '#333';";
}
?>
  }

  // select the element with id="defaultOpen"
  document.getElementById("defaultOpen").click();
</script>

</body>

</html>
