defmodule Jinja do
  @moduledoc """
  Jinja is a fast, expressive, extensible templating engine written in Python.

  This library provides a public API for working with Jinja templates in Elixir.
  This is not a port of Jinja, but rather a wrapper that runs using `Pythonx`.

  ## Usage

  Add `Jinja` to your application supervision tree:

      children = [
        Jinja,
        ...
      ]

  ## Loaders

  The default loader is `:dict`. This allows you to register templates at runtime,
  for the lifetime of your application. Templates can be loaded and rendered as such:

      Jinja.load_template("hello", "hewwo {{ name }}") # => :ok
      Jinja.render_template("hello", %{name: "Robin"}) # => {:ok, "hewwo Robin"}

  The `:path` loader allows you to specify a directory on disk to load templates
  from. When configured, the `load_template/2` function will be unavailable.

      children = [
        {Jinjq,
          loader: :path,
          from: Application.app_dir(:your_app, ~w(lib your_app_web templates))
        }
      ]

      # Loads template from lib/your_app_web/templates/hello.html
      Jinja.render_template("hello.html", %{name: "Robin"}) # => {:ok, "hewwo Robin"}

      # `load_template/2` is unavailable for loader: :path
      Jinja.load_template("bye", "...") # => {:error, "loading templates at runtime is only supported for loader: :dict"}

  """
  use GenServer
  
  defstruct [:loader, :globals]

  import Structo

  @doc false
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Renders a template string with given assigns.
  
      iex> Jinja.render_string("<h1>hewwo {{ name }}</h1>", %{"name" => "world"})
      {:ok, "<h1>hewwo world</h1>"}

  """
  @spec render_string(String.t(), map()) :: {:ok, String.t()} | {:error, term()}
  def render_string(template, assigns \\ %{}) when is_binary(template) and is_map(assigns) do
    GenServer.call(__MODULE__, {:render_string, template, assigns})
  end

  @doc """
  Loads a template with the given name and source.
  
      iex> Jinja.load_template("page", \"""
      <html><body>{% block body %}{% endblock %}</body></html>
      \""")
      :ok

      iex> Jinja.load_template("post", \"""
      {% extends "page" %}
      {% block body %}
        {{ title }}
      {% endblock %}
      \""")
      :ok

  """
  @spec load_template(String.t(), String.t()) :: :ok | {:error, term()}
  def load_template(name, source) when is_binary(name) and is_binary(source) do
    GenServer.call(__MODULE__, {:load_template, name, source})
  end
  
  @doc """
  Renders a previously loaded template with given assigns.
  
      iex> Jinja.render_template("post", %{title: "hewwo world"})
      {:ok, "<html><body>hewwo world</body></html>"}

  """
  @spec load_template(String.t(), map()) :: {:ok, String.t()} | {:error, term()}
  def render_template(name, assigns \\ %{}) when is_binary(name) and is_map(assigns) do
    GenServer.call(__MODULE__, {:render_template, name, assigns})
  end

  @doc false
  def init(opts) do
    {loader, globals} = init_state(opts)
    {:ok, ~m{:__MODULE__, loader, globals}}
  end

  defp init_state(opts) do
    case Keyword.get(opts, :loader, :dict) do
      :dict -> {:dict, init_dict_loader()}
      :path -> {:path, init_path_loader(opts)}
    end
  end

  defp init_dict_loader do
    initialise("""
    from jinja2 import Environment, DictLoader, select_autoescape
    
    templates = {}
    loader = DictLoader(templates)
    
    env = Environment(
      loader=loader,
      autoescape=select_autoescape(['html', 'htm', 'xml'])
    )
    """)
  end

  defp init_path_loader(opts) do
    search_path = Keyword.get(opts, :from)
      || raise "when using loader: :path, please provide the search path via the :from option"

    initialise("""
    from jinja2 import Environment, FileSystemLoader, select_autoescape
    
    env = Environment(
      loader=FileSystemLoader('#{search_path}'),
      autoescape=select_autoescape(['html', 'htm', 'xml'])
    )
    """)
  end

  def handle_call({:render_string, template, assigns}, _from, state) do
    globals =
      state.globals
      |> put_glob(:source, template)
      |> put_glob(:assigns, assigns)

    rendered =
      execute(globals, """
      env.from_string(source).render(assigns)
      """)
      
    {:reply, {:ok, rendered}, state}
  rescue
    error -> {:reply, {:error, error}, state}
  end

  def handle_call({:load_template, name, source}, _from, %{loader: :dict} = state) do
    globals =
      state.globals
      |> put_glob(:name, name)
      |> put_glob(:source, source)

    execute(globals, """
    templates[name] = source
    env.loader = DictLoader(templates)
    True
    """)
      
    {:reply, :ok, state}
  rescue
    error -> {:reply, {:error, error}, state}
  end

  def handle_call({:load_template, _name, _source}, _from, %{loader: :path} = state) do
    {:reply, {:error, "loading templates at runtime is only supported for loader: :dict"}, state}
  end

  def handle_call({:render_template, name, assigns}, _from, state) do
    globals =
      state.globals
      |> put_glob(:name, name)
      |> put_glob(:assigns, assigns)

    rendered = execute(globals, "env.get_template(name).render(assigns)")

    {:reply, {:ok, rendered}, state}
  rescue
    error -> {:reply, {:error, error}, state}
  end

  defp initialise(source) do
    source
    |> Pythonx.eval(%{})
    |> then(fn {_, g} -> g end)
  end

  defp execute(globals, source) do
    source
    |> Pythonx.eval(globals)
    |> then(fn {r, _} -> r end)
    |> Pythonx.decode()
  end

  defp encode(obj) when is_binary(obj), do: Pythonx.NIF.unicode_from_string(obj)
  defp encode(obj) when is_map(obj), do: encode(Enum.map(obj, fn {k, v} -> {k, encode(v)} end))
  defp encode(obj), do: Pythonx.encode!(obj)

  defp put_glob(globals, name, value) do
    Map.put(globals, to_string(name), encode(value))
  end
end