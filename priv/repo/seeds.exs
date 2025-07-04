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

site0 =
  Pebble.Repo.insert!(%Pebble.Site{
    hostname: "geheimesite.nl"
  })

site1 =
  Pebble.Repo.insert!(%Pebble.Site{
    hostname: "obliviously.eu"
  })

site2 =
  Pebble.Repo.insert!(%Pebble.Site{
    hostname: "dupunkto.org"
  })

schemas = [
  %{
    label: "Tweet",
    listing: :inline,
    sites: [site1],
    definition: """
    [content]
    type = "textarea"
    label = "What's on your mind?"
    required = true
    visibility = "main"

    [thread]
    type = "text"
    label = "Thread"

    [visibility]
    type = "select"
    default = "draft"
    options = ["draft", "hidden", "rss", "public"]
    """
  },
  %{
    label: "Article",
    listing: :table,
    sites: [site0, site2],
    definition: """
    [title]
    type = "text"
    required = true
    visibility = "column"

    [content]
    type = "textarea"
    label = "Prose"
    visibility = "none"

    [index]
    type = "boolean"
    label = "Visible to search engines?"
    default = false
    visibility = "none"

    [visibility]
    type = "select"
    default = "draft"
    options = ["draft", "hidden", "rss", "public"]
    """
  }
]

for params <- schemas do
  {sites, params} = Map.pop(params, :sites, [])

  %Pebble.Schema{sites: sites}
  |> Pebble.Schema.changeset(params)
  |> Pebble.Repo.insert!()
end

templates = [
  %{
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
      %{route: "/e", site_id: site0.id, layout_id: nil},
      %{route: "/e", site_id: site1.id, layout_id: nil}
    ]
  },
  %{
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
      %{route: "/robino", site_id: site1.id, layout_id: nil}
    ]
  },
  %{
    label: "Jongeren lezen niet meer -- so what?",
    type: :plain,
    visibility: :draft,
    content: """
    Onlangs schreef iemand in NRC dat de taalvaardigheid van de jongere generaties achteruit holt doordat er minder gelezen wordt. Maar waarom zouden we daar tegenwoordig nog om malen? De jongeren van tegenwoordig hebben wel wat beters te doen dan met hun neus in de papieren gedoken te zitten. Wereldproblemen als uitstervende pandabeertjes, de verkeerde versie van een regenboogvlag en het kolonialisme in een theepot worden niet opgelost door te lezen. Ze worden opgelost door activisme. De jongste generatie weet dat die problemen juist opgelost worden door níet te lezen. Lezen is namelijk een van de grootste vijanden van modern activisme.

    Lezen kan je gevoelens kwetsen, je de nuance van een probleem laten inzien, vraagtekens zetten bij de meningen waar je je het hardst aan vastklampt. Comfortabeler en impactvoller is het, om te denken wat je altijd al hebt gedacht, en om je mening zo hard mogelijk te schreeuwen naar iedereen die in je buurt is. Want lezen kan je ook nog eens doen beseffen, dat je heel veel helemaal niet weet en dat je veel deugdelijkheid kan leren van boekenpersonages en auteurs. En nederigheid is de enige deugd die de jongere generatie als de pest moet mijden, als zij zich à la Tim Hofman ‘de tyfus willen deugen’.

    De sociale media worden er ook niet mee geholpen als jongeren veel lezen. De tijd die jongeren zouden verdoen aan het doorbladeren van stapels papier, zetten ze nu efficiënt in door rond te struinen op sociale media. Ze bevorderen er hun zelfvertrouwen, hun kritische zelfblik en Chinese gezichtsherkenningssoftware mee, door een oneindige hoeveelheid selfies te maken; ze amuseren zichzelf door licht verteerbare nieuwtjes op te zuigen; en als klap op de vuurpijl vechten zij voor rechtvaardigheid.

    Er is geen beter oefenterrein voor de rechtvaardigheidsstrijd dan de stormbaan van de sociale media. Het is goed om anderen keihard en genadeloos te veroordelen en om hen te doen struikelen over argeloos uitgesproken woorden. Op deze manier dragen jongeren een omvangrijk steentje bij aan het Twitterdebat. In een Twitterdebat heeft niemand immers behoefte aan rationele, weloverwogen, genuanceerde deelnemers. Er is niets dat zo vermakelijk is als een Twitterinferno. En hoe minder mensen lezen, hoe meer geneigd ze zijn om vurigheid de plek van informatie in te laten nemen.

    Behalve de potentiële problemen die een lezende jonge generatie met zich meebrengt, hebben we ook nog te kampen met de actualiteit. We hebben te weinig bouwvakkers, en, zoals iedereen die weleens een krant openslaat kan weten, in het algemeen flinke arbeidstekorten. Tegelijkertijd begint de hoeveelheid academici, en dan vooral (de hemel beware ons) de hoeveelheid vrouwelijke academici, dramatisch toe te nemen. Dit probleem is begonnen bij de jongeren. Als ze minder lezen, zullen ze vanzelf de universiteiten gaan verlaten en komen er meer jeugdige handen vrij voor fysieke arbeid.

    Dus: hoe minder jongeren lezen, hoe meer problemen er verholpen worden. Vergeet daarom het kleine meisje dat in de Tweede Wereldoorlog de boekrecensies van de buren als enige leesvoer had en ze opslurpte als honing voor haar ziel. Vergeet de boekenwijsheid die de ouderen van nu vroeger op hebben gedaan. In het boek Fahrenheit 451 is het de bevolking verboden om boeken te lezen en wordt men volgestopt met betaalbare vormen van amusement. Met de ontlezing werken we daarnaar toe. Want dit is de toekomst. Dit is pas echte progressie.
    """,
    linked_sites: [
      %{route: "/lezen", site_id: site1.id, layout_id: nil}
    ]
  }
]

for params <- templates do
  %Pebble.Template{}
  |> Pebble.Template.changeset(params)
  |> Pebble.Repo.insert!()
end
