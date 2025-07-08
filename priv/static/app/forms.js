document.querySelectorAll("[data-autosave]").forEach(form => {
  console.log(form);
  form.addEventListener('input', () => {
    const data = new URLSearchParams(new FormData(form));
    fetch(form.action, { method: form.method, body: data });
  })
});
