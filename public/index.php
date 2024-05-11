<?php

chdir(__DIR__ . '/..');
require 'vendor/autoload.php';

require 'lib/config.php';
require 'lib/paths.php';
require 'lib/pages.php';
require 'lib/errors.php';

$path = remove_prefix($_SERVER["PATH_INFO"], "/pebble");

if(in_array($path, ["", "/", "/home"])) {
  include pebble_path("/index");
} else {
  include pebble_path($path);
}
