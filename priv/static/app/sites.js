function switch_site(site) {
  // TODO(robin): this strips any query params and fragments from
  // the URL. If we ever have a use-case where we need to retain 
  // those, this needs to be updated. For now, this works just fine.

  const [_, old, path] = window.location.pathname.split("/", 3);
  window.location.pathname = `/${site}/${path ?? ""}`;
}
