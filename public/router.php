<?php

chdir(__DIR__);

if (preg_match('/^\/(pebble)\//', $_SERVER["REQUEST_URI"])) {
  include 'index.php';
} else {
  // Serve the requested resource as-is.
  return false;
}
