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

  Templates can then be loaded and rendered as such:

      Jinja.load_template("hello", "hewwo {{ name }}") # => :ok
      Jinja.render_template("hello", %{name: "Robin"}) # => {:ok, "hewwo Robin"}

  """
  use GenServer

  @doc false
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Renders a template string with given assigns.
  
      iex> Jinja.render_string("<h1>hewwo {{ name }}</h1>", %{"name" => "world"})
      {:ok, "<h1>hewwo world</h1>"}

  """
  def render_string(template, assigns \\ %{}) do
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
  def load_template(name, source) do
    GenServer.call(__MODULE__, {:load_template, name, source})
  end
  
  @doc """
  Renders a previously loaded template with given assigns.
  
      iex> Jinja.render_template("post", %{title: "hewwo world"})
      {:ok, "<html><body>hewwo world</body></html>"}

  """
  def render_template(name, assigns \\ %{}) do
    GenServer.call(__MODULE__, {:render_template, name, assigns})
  end

  def init(_opts) do
    state =
      initialise("""
      from jinja2 import Environment, DictLoader, select_autoescape
      
      templates = {}
      loader = DictLoader(templates)
      
      env = Environment(
        loader=loader,
        autoescape=select_autoescape(['html', 'htm', 'xml'])
      )
      """)
    
    {:ok, state}
  end

  def handle_call({:render_string, template, assigns}, _from, state) do
    globals =
      state
      |> assign(:source, template)
      |> assign(:assigns, assigns)

    rendered =
      execute(globals, """
      env.from_string(source).render(assigns)
      """)
      
    {:reply, {:ok, rendered}, state}
  rescue
    error -> {:reply, {:error, error}, state}
  end

  def handle_call({:load_template, name, source}, _from, state) do
    globals =
      state
      |> assign(:name, name)
      |> assign(:source, source)

    execute(globals, """
    templates[name] = source
    env.loader = DictLoader(templates)
    True
    """)
      
    {:reply, :ok, state}
  rescue
    error -> {:reply, {:error, error}, state}
  end

  def handle_call({:render_template, name, assigns}, _from, state) do
    globals =
      state
      |> assign(:name, name)
      |> assign(:assigns, assigns)

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

  defp assign(globals, name, value) do
    Map.put(globals, to_string(name), encode(value))
  end
end