<?php

/**
 * Minimal wrapper to run Roundcube database schema updates without
 * initializing the full application (avoids session table chicken-and-egg).
 *
 * Usage: php db_update.php \
 *            --install-path=<roundcube-root> \
 *            --dir=<sql-migrations-dir> \
 *            --package=<name> \
 *            [--version=<ver>]
 *
 * The ROUNDCUBE_CONFIG_DIR environment variable can be set to point
 * to the directory containing config.inc.php (e.g. the web root's config/).
 */

$opts = getopt('', ['install-path:', 'dir:', 'package:', 'version::']);

if (empty($opts['install-path']) || empty($opts['dir']) || empty($opts['package'])) {
    fwrite(STDERR, "Usage: --install-path=<dir> --dir=<dir> --package=<name> [--version=<ver>]\n");
    exit(1);
}

define('INSTALL_PATH', rtrim($opts['install-path'], '/') . '/');

require_once INSTALL_PATH . 'program/include/iniset.php';

$config  = new rcube_config();
$db      = rcube_db::factory($config->get('db_dsnw'));
$debug   = (bool) $config->get('sql_debug');

$db->set_debug($debug);
$db->db_connect('w');

if (!$db->is_connected()) {
    fwrite(STDERR, "Failed to connect to database\n");
    exit(1);
}

rcmail_utils::$db = $db;
$result = rcmail_utils::db_update(
    $opts['dir'],
    $opts['package'],
    $opts['version'] ?? null,
    ['errors' => true]
);

exit($result ? 0 : 1);
