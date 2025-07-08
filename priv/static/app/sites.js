function switch_site(site) {
  // TODO(robin): this strips any query params and fragments from
  // the URL. If we ever have a use-case where we need to retain 
  // those, this needs to be updated. For now, this works just fine.

  // .filter(Boolean) skips any empty segments.
  const segments = window.location.pathname.split("/").filter(Boolean);
  const [, ...rest] = segments;

  window.location.pathname = `/${site}/${rest.join("/")}`;
}
