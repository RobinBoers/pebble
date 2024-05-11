<?php include __DIR__ . "/config.php" ?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="generator" content="pebble">

  <title><?= $title ?> — <?= $SITE_TITLE ?></title>

  <meta name="author" content="<?= $SITE_AUTHOR ?>">
  <meta name="canonical" content="<?= $url ?>">

  <link rel="stylesheet" href="/main.css" type="text/css">
</head>
<body>
  <main class="h-entry">
    <h1 class="p-title"><?= $title ?></h1>

    <div class="p-summary e-content">
      <?= $content ?>
    </div>
  </main>
</body>
</html>
