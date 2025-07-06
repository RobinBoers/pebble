const stack = [];

function open_modal(selector) {
  const modal = document.querySelector(selector);
  stack.push(modal);
  modal.style.display = "block";
}

function close_modal() {
  const modal = stack.pop();
  if (modal) modal.style.display = "none";
}

function is_typing() {
  return (
    document.activeElement.tagName == "INPUT" ||
    document.activeElement.tagName == "TEXTAREA" ||
    document.activeElement.isContentEditable
  );
}

document.addEventListener("keydown", (e) => {
  if (e.key == "Escape" && !is_typing())
    close_modal();
});
