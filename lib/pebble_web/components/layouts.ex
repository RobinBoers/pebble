defmodule PebbleWeb.Layouts do
  @moduledoc false
  use PebbleWeb, :html

  import PebbleWeb.Navigation, only:
    [tab_class: 2, child_class: 2]

  embed_templates "layouts/*"
end
