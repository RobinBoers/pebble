<?php

$slug = $_GET["page"];

if(isset($slug)) {
  delete_page($slug);
  header("Location: " . pebble_url("/pages"));
} else {
  error_json(401, "No page with slug '" . $slug . "' exists.");
}
