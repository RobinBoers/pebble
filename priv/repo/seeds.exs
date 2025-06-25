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
  label: "A",
  type: :plain,
  visibility: :draft,
  content: """
  Jan, makkaar fan data, zat aan z’n taflank. Dagtaak: maakbaar CMS aframmala. SaaS? Ja! Maar laat: Jan had plan A. Plan A was raar. Kladraat, maar gaaf.

  "Maak kaal CMS," blaart Jan. "Laat maat Graag Hans, maar laat Bart."
  Hans, met baard, blaast: "Aah? SaaS? Naar Amazon? Bah!"
  Bart, daarentegen, blaast aan: "Graag, maar waar dan?"

  Jan gaat aan’t werk. Start: bash. Maak maar plan van aanraakbaar panel, graag krasbaar, maar gaaf. Alles dragbaar, schaalbaar, adaptable aan taal naar aard.

  "Wat taal?" vraagt Hans.
  "Java? Nah. Maar Bash? Hah! Maar wacht: daar ga ik naar Laravel."

  Bart lacht hard. "Laravel? SaaS? Data naar Canada?"

  Jan, kwaad, raast: "Bart, afgaan daar gaat aan, maar wacht: maakbaar! Aantrekkelijk! SaaS-aanpak!"
  Bart, dramatisch, gaat af. Hans, daarentegen, gaat aan’t kladblad.

  Daarna: databank. MariaDB? Ja! Maar data-arm. Waar data? SaaS-backup aan Kanaal-Braak?

  Jan blaast alarm. "Bart had data! Maar Bart had drama!"
  Hans gaat naar Bart. Bart slaapt. Jan slaat.

  Laat: data-zaak gaat af. Maar Jan had backup. Haha! Bart baalt. Jan lacht.
  """,
  linked_sites: [%{route: "/a", site_id: 1, layout_id: nil}]
}

%Pebble.Template{}
|> Pebble.Template.changeset(params)
|> Pebble.Repo.insert!()
