<?php
  $slug = $_GET["page"];
  if(!isset($slug)) header("Location: " . pebble_url("/pages"));

  $data = get_page($slug);
?>

<!DOCTYPE html>
<html lang="en">
  <head>
    <?php include "components/metadata.php" ?>
    <title>Editting '<?= $data[0]->title ?>'</title>
  </head>
  <body>
    <?php include "components/header.php" ?>
    <main>
      <?php include "components/editor.php" ?>
    </main>
  </body>
</html>
