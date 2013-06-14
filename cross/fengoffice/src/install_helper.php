<?php
  @set_time_limit(0);
  require_once dirname(__FILE__) . '/include.php';
  require_once INSTALLER_PATH . '/installation/installation.php'; 

  parse_str($_SERVER['QUERY_STRING'], $_SESSION);
  $_SESSION[EXECUTED_STEPS_SESSION_VARIABLE][] = 3;
  $installer->executeStep(4)

?>
