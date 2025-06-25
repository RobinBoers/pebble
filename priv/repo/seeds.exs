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

params = %{
  label: "Robiño",
  type: :plain,
  visibility: :draft,
  content: """
  Er was eens un chico llamado Robiño. Hij woonde in een klein pueblo net buiten Almere, waar de koeien zeggen "moo" y de mensen zeggen "waar is mijn fiets?"

  Op een dag besloot Robiño: "Hoy ga ik mijn dromen volgen en word ik een tortilla-bakker."
  Zijn moeder zei: "Pero Robiño, je kan niet eens een ei breken zonder huilen!"
  Waarop Robiño zei: "Maar madre, huilen maakt de omelet extra salty."

  Hij begon zijn eigen zaakje: Tortillas y Bitterballen Robiño S.A.
  Iedereen in het dorp was confused. Een klant vroeg: "Heeft u ook kroketten?"
  En Robiño antwoordde trots: "No, maar ik heb tortilla met frikandel en een beetje olijf."

  Op de opening kwam zelfs de burgemeester. Die nam een hap, keek drie seconden omhoog en zei:
  "Dios mío... dit is... ongelofelijk verwarrend."
  En Robiño riep: "Gracias! Wil je er ook satésaus bij?"

  Sindsdien is Robiño bekend als de eerste tortilla-chef die permanent is verbannen uit Tex-Mex restaurants, maar wel een Michelin-ster kreeg van zijn eigen oma, handgeschreven met een Bic-pen op een servetje.
  """,
  linked_sites: [
    %{route: "/robino", site_id: 2, layout_id: nil}
  ]
}

%Pebble.Template{}
|> Pebble.Template.changeset(params)
|> Pebble.Repo.insert!()
