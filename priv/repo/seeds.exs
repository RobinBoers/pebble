# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pebble.Repo.insert!(%Pebble.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Pebble.Repo.insert!(%Pebble.Site{
  id: 1,
  hostname: "geheimesite.nl"
})

Pebble.Repo.insert!(%Pebble.Site{
  id: 2,
  hostname: "obliviously.eu"
})

Pebble.Repo.insert!(%Pebble.Site{
  id: 3,
  hostname: "dupunkto.org"
})

params = %{
  label: "E",
  type: :plain,
  visibility: :draft,
  content: """
  Ergens, ver weg, werkt Bert. Bert werkt met netwerken. Bert zet steeds gekke tekens, trekt stekkers, test, en... erge stress!

  "'k Meen: werk met kernregels!" zegt Evert.
  "Vergeet het!" zegt Bert, "Lekker rebels, 'k leef slechts met de E!"

  Evert leest Bert z'n werk. Eerst: 'grep', 'sed', 'perl'.
  "Help! De hel zelf leest sneller!"
  "Welnee," zegt Bert, "deze regels representeren perfect het net!"

  Een week verder. Server gek.
  Evert belt Bert. Bert rent. Server lekt.
  Evert zet de zet: "Verzet werk!"
  Bert keert, beseft het: "Echt, te veel pret met slechts de E..."
  """,
  linked_sites: [
    %{route: "/e", site_id: 1, layout_id: nil},
    %{route: "/e", site_id: 2, layout_id: nil}
  ]
}

%Pebble.Template{}
|> Pebble.Template.changeset(params)
|> Pebble.Repo.insert!()
