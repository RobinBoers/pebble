defmodule Pebble.MixProject do
  use Mix.Project

  @documentation "https://hexdocs.pm/pebble"
  @git_repository "https://git.dupunkto.org/~axcelott/pebble"

  def project do
    [
      name: "pebble",
      app: :pebble,
      version: "0.1.0-rc1",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),

      # Docs
      source_url: @git_repository,
      homepage_url: @documentation,
      description: description(),
      package: package(),
      docs: docs()
    ]
  end

  def description, do: 
    "Pebble is the best CMS in the multiverse"

  defp package, do: [
    licenses: ["Unlicense"],
    links: %{"Sources" => @git_repository}
  ]

  def application, do: [
    mod: {Pebble.Application, []},
    extra_applications: [:logger, :runtime_tools]
  ]

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps, do: [
    {:phoenix, "~> 1.7.18"},
    {:phoenix_ecto, "~> 4.5"},
    {:ecto_sql, "~> 3.10"},
    {:postgrex, ">= 0.0.0"},
    {:phoenix_html, "~> 4.1"},
    {:phoenix_live_reload, "~> 1.2", only: :dev},
    {:phoenix_live_view, "~> 1.0.0"},
    {:floki, ">= 0.30.0", only: :test},
    {:ex_doc, "~> 0.38", only: :dev, runtime: false},
    {:telemetry_metrics, "~> 1.0"},
    {:telemetry_poller, "~> 1.0"},
    {:bandit, "~> 1.5"},
    {:decorator, "~> 1.3"},
    {:typed_ecto_schema, "~> 0.4.2"},
    {:typedstruct, "~> 0.5.3"},
    {:toml, "~> 0.7"},
    {:structo, "~> 0.1.4"}
  ]

  defp aliases, do: [
    setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
    "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
    "ecto.reset": ["ecto.drop", "ecto.setup"],
    test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
  ]

  defp docs, do: [
    main: "Pebble",
    api_reference: false,
    authors: ["Robijntje"],
    formatters: ["html"],
    groups_for_modules: [
      "Entities": [
        Pebble.Site,
        Pebble.Layout,
        Pebble.Asset,
        Pebble.Contact,
        Pebble.Context,
        Pebble.Fragment,
        ~r/Pebble.Menu/,
        Pebble.Schema,
        Pebble.Template,
        Pebble.Settings
      ],
      "Web Layer": [~r/PebbleWeb/],
      Ecto: [~r/Ecto./]
    ]
  ]
end
