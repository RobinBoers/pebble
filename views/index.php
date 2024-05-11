<!DOCTYPE html>
<html lang="en">
  <head>
    <?php include "components/metadata.php" ?>
    <title>Pebble</title>
  </head>
  <body>
    <?php include "components/header.php" ?>
    <main>
      <header class="bar">
        <h2>Your home on the Web.</h2>
      </header>

      <p>Welcome to pebble, a simple but powerful tool to publish words on the Web.<br><br></p>

      <h3>Quick actions</h3>

      <ul>
        <li><a href="<?= pebble_url("/pages") ?>">Pages</a></li>
      </ul>
    </main>
  </body>
</html>
