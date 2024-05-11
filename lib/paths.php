<?php
// TODO(robin): validate paths here, to prevent path traversal attacks.

function content_path($slug) {
  global $SRC_DIR, $SRC_FORMAT;
  return $SRC_DIR . "/" . $slug . $SRC_FORMAT;
}

function public_path($slug) {
  global $DIST_DIR, $DIST_FORMAT;
  return $DIST_DIR . "/" . $slug . $DIST_FORMAT;
}

function public_url($slug) {
  global $SITE_ROOT, $DIST_FORMAT;
  return $SITE_ROOT . "/" . $slug . $DIST_FORMAT;
}

function pebble_path($path) {
  global $BASE;
  return $BASE . "/views" . $path . ".php";
}

function pebble_url($path) {
  global $SITE_ROOT;
  return $SITE_ROOT . "/pebble" . $path;
}

// Slightly related to paths?
// Maybe move this elsewhere...
function remove_prefix($str, $prefix) {
  return 0 === strpos($str, $prefix) ? substr($str, strlen($prefix)).'' : $str;
}
