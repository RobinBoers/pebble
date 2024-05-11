<?php

$slug = $_POST["slug"];
$title = $_POST["title"];
$content = $_POST["content"];

if(!isset($slug)) json_error(401, "Slug is required");
if(!isset($title)) json_error(401, "Title is required");
if(!isset($content)) json_error(401, "Content is required");

save_page($slug, $title, $content);
header("Location: " . pebble_url("/pages"));
