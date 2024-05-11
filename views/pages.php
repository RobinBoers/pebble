<!DOCTYPE html>
<html lang="en">
  <head>
    <?php include "components/metadata.php" ?>
    <title>Pages</title>
  </head>
  <body>
    <?php include "components/header.php" ?>
    <main>
      <header class="bar">
        <h2>Pages</h2>

        <a href="<?= pebble_url("/new") ?>" class="button">New Page</a>
      </header>

      <?php $at_least_one_page = false ?>

      <ul class="pages-list">
        <?php foreach(list_pages() as $slug) {
            $at_least_one_page = true;          
            ?>
              <li>
                <a href="<?= pebble_url("/edit") ?>?page=<?=$slug ?>">
                  <?= get_page($slug)[0]->title ?>
                </a>
              </li>
            <?php            
        } ?>
      </ul>

      <?php if(!$at_least_one_page) {
        ?>
          <p class="placeholder-text">No pages yet.</p>
        <?php
      } ?>
    </main>
  </body>
</html>
