defmodule Jinja do
  @moduledoc """
  Jinja is a fast, expressive, extensible templating engine written in Python.

  This module provides a public API for working with Jinja templates in Elixir.
  This is not a port of Jinja, but rather a wrapper that runs using `Pythonx`.

  ## Usage

  Add `Jinja` to your application supervision tree:

      children = [
        Jinja,
        ...
      ]

  """
  use GenServer

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
  def render_string(template, assigns \\ %{}) do
    GenServer.call(__MODULE__, {:render_string, template, assigns})
  end
  
  @doc """
  Renders a template file with given assigns.
  
      iex> Jinja.render_file("welcome.html", %{"user" => "Alice"})
      {:ok, "<h1>Welcome, Alice.</h1>"}

  """
  def render_file(filename, assigns \\ %{}) do
    GenServer.call(__MODULE__, {:render_file, filename, assigns})
  end

  def init(opts) do
    search_path = Keyword.get(opts, :path, search_path())
    autoescape = Keyword.get(opts, :autoescape, true)
    
    globals =
      initialise("""
      from jinja2 import Environment, FileSystemLoader, select_autoescape
      
      env = Environment(
        loader=FileSystemLoader('#{search_path}'),
        autoescape=select_autoescape(['html', 'htm', 'xml']) if "#{autoescape}" == "true" else False
      )
      """)
    
    {:ok, ~m{globals, search_path}}
  end

  def handle_call({:render_string, template, assigns}, _from, state) do
    globals =
      state.globals
      |> assign(:source, template)
      |> assign(:assigns, assigns)

    rendered =
      execute(globals, """
      template = env.from_string(source)
      template.render(assigns)
      """)
      
    {:reply, {:ok, rendered}, state}
  rescue
    error -> {:reply, {:error, error}, state}
  end

  def handle_call({:render_file, filename, assigns}, _from, state) do
    globals =
      state.globals
      |> assign(:filename, filename)
      |> assign(:assigns, assigns)

    rendered =
      execute(globals, """
      template = env.get_template(filename)
      template.render(assigns)
      """)
    
    {:reply, {:ok, rendered}, state}
  rescue
    error -> {:reply, {:error, error}, state}
  end

  defp search_path do
    Path.join(:code.priv_dir(:pebble), "templates")
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