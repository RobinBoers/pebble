<?php

function list_pages() {
  global $SRC_DIR, $SRC_FORMAT;
  chdir($SRC_DIR);
 
  $to_slug = fn($filename) => basename($filename, $SRC_FORMAT);
  return array_map($to_slug, glob("*" . $SRC_FORMAT));
}

function get_page($slug) {
  $content = file_get_contents(content_path($slug));
  $parts = preg_split('/[\n]*[-]{3}[\n]/', $content, 3);

  $frontmatter = json_decode($parts[1]);
  $content = $parts[2];

  return [$frontmatter, $content];
}

function save_page($slug, $title, $content) { 
  $frontmatter = get_page($slug)[0];
  if(!$frontmatter) $frontmatter = (object) [];

  $frontmatter->title = $title;

  $content = "---\n" . $content;
  $content = json_encode($frontmatter) . "\n" . $content;
  $content = "---\n" . $content;

  file_put_contents(content_path($slug), $content);
}

function publish_page($slug, $title, $content) {
  $parser = new Parsedown();
  $rendered = render_template($parser, $title, $slug, $content);

  file_put_contents(public_path($slug), $rendered);
}

function render_template($parser, $title, $slug, $content) {
  $content = $parser->text($content);
  $url = public_url($slug);

  ob_start();
  include "template.php";
  return ob_get_clean();
}

function delete_page($slug) {
  unlink(content_path($slug));
}
