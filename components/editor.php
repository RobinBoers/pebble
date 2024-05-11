<form method="post">
  <header>
    <?php if(!isset($slug)) { ?>
      <input required placeholder="Slug" name="slug" type="text" pattern="[a-z0-9](-?[a-z0-9])*">
    <?php } ?>
    
    <div class="bar">
      <input required placeholder="Title" name="title" value="<?= $data[0]->title ?>">

      <p class="button-group">
        <?php if(isset($slug)) { ?>
          <input name="slug" value="<?= $slug ?>" type="hidden">
          <a href="<?= pebble_url("/delete") ?>?page=<?= $slug ?>" class="button">Delete</a>
        <?php } ?>

        <input formaction="<?= pebble_url("/save") ?>" name="save" type="submit" value="Save">
        <input formaction="<?= pebble_url("/publish") ?>" name="publish" type="submit" value="Publish">
      </p>
    </div>
  </header>

  <textarea 
    autofocus 
    required 
    placeholder="Write anything. Write everything." 
    name="content"><?= $data[1] ?></textarea>
</form>