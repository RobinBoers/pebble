document.querySelectorAll("[data-autosave]").forEach(form => {
  form.addEventListener('input', () => {
    const data = new URLSearchParams(new FormData(form));
    fetch(form.action, { method: form.method, body: data, redirect: 'manual' })
      .then(response => {
        if (response.status === 204) return clearErrors(form);
        return response.text().then(html => putErrors(form, html));
      })
      .catch(error => {
        console.error('Autosave failed:', error);
      });
  })
});

function clearErrors(form) {
  form.querySelectorAll('.form-error').forEach(el => el.remove());
}

function putErrors(form, html) {
  const parser = new DOMParser();
  const doc = parser.parseFromString(html, 'text/html');
  const errors = doc.querySelectorAll('.form-error');

  clearErrors(form);

  for(const error of errors) {
    const fieldID = error.getAttribute('data-for') || error.closest('[data-for]')?.getAttribute('data-for');
    if (!fieldID) continue;
  
    const field = form.querySelector(`#${fieldID}`);
    if (!field) continue;
    
    field.parentNode.appendChild(error.cloneNode(true));
  }
}
