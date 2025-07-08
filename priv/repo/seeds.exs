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
    label: "Start",
    type: :md,
    visibility: :public,
    content: """
    <%= subtitle = "Hey, I'm Robin!!" %>

    <div class="container">
      <noscript class="header">
        <h1>{subtitle}</h1>
      </noscript>

      <script>
        const header = document.querySelector(".header");
        const heading = document.createElement("h1");

        header.parentNode.insertBefore(heading, header.nextSibling);

        function type(element, text) {
          if(text == "") return;
          heading.innerHTML += text.charAt(0);
          window.setTimeout(() => type(element, text.slice(1)), 20);
        }

        type(heading, "<%= subtitle %>");
      </script>

      I'm a teenage developer. I write pretty decent software.
    </div>

    <picture>
      <source srcset="{{ commitGraph.light_href }}" media="(prefers-color-scheme: light)"/>
      <source srcset="{{ commitGraph.dark_href }}" media="(prefers-color-scheme: dark)"/>

      <img eleventy:ignore src="{{ commitGraph.light_href }}" alt="" width="100%" style="margin: 1em auto">
    </picture>

    <div class="container">

      [contact](/contact)  ·  [website stability note](/stability)

    </div>
    """,
    linked_sites: [
      %{route: "/", site_id: site0.id, layout_id: nil}
    ]
  },
  %{
    label: "RSS",
    type: :plain,
    visibility: :draft,
    content: """
    Nearly every blog has a feature called <dfn>syndication</dfn>. This is a way to to easily subscribe to a site. It works like this: the site exposes a feed, which is a simple text file that contains the latest content in a form that a newsreader app can understand. Your newsreader then periodically checks the feed and shows updates of all sites that you follow in reverse-chronological order. 

    The technology to make this work is called <abbr title="Really Simple Syndication">RSS</abbr>, and thus these feeds are often called RSS feeds. There's also another very similar format called Atom. Virtually all newsreaders work equally with both.

    ## But why?

    Basically, RSS is like your Facebook feed, but instead of an algorithm deciding what to show you, you choose what to subscribe too yourself. That means it is fully in your control: no ads, no data mining. It's a bit like an email newsletter, but without giving your email to some American company for them to sell to spammers.

    ## Cool, how do I get started?

    To subscribe to an RSS feed, you use a newsreader app. There's [lots of choices](//en.wikipedia.org/wiki/Comparison_of_feed_aggregators) out there.

    RSS itself is free, but some apps provide additional features in a paid subscription. Most of these apps also allow you to sync your subscriptions between devices, but limit the amount of subscriptions you can have.

    - [Inoreader](//inoreader.com). Free up to 150 subscriptions.  
      Offers iOS, iPadOS, and Android apps, along with a Web app.

    - [NewsBlur](//newsblur.com). Free up to 64 subscriptions.  
      Offers iOS, iPadOS, and Android apps, along with a (very good!) Web app.

    - [NetNewsWire](//netnewswire.com). Offers iOS, iPadOS, and MacOS apps.
      The apps themselves are entirely free and don't put limits on the amount of feeds.
      However, if you use an online service like Inoreader or NewsBlur to sync
      your subscriptions , their limits still apply.

    - [The Old Reader](//theoldreader.com). Free up to 100 subscriptions.
      Offers iOS and Android apps, along with a Web app. Contains ads.

    ## But how do I use RSS?

    Most sites that offer an RSS will probably have a link saying "RSS/Atom" or an orage icon similar to this: <svg
      xmlns="http://www.w3.org/2000/svg"
      version="1.1"
      style="vertical-align: text-bottom; width: 1.2em; height: 1.2em"
      class="pr-1"
      viewBox="0 0 256 256"
    >
      <defs>
        <linearGradient x1="0.085" y1="0.085" x2="0.915" y2="0.915" id="RSSg">
          <stop offset="0.0" stop-color="#E3702D" />
          <stop offset="0.1071" stop-color="#EA7D31" />
          <stop offset="0.3503" stop-color="#F69537" />
          <stop offset="0.5" stop-color="#FB9E3A" />
          <stop offset="0.7016" stop-color="#EA7C31" />
          <stop offset="0.8866" stop-color="#DE642B" />
          <stop offset="1.0" stop-color="#D95B29" />
        </linearGradient>
      </defs>
      <rect
        width="256"
        height="256"
        rx="55"
        ry="55"
        x="0"
        y="0"
        fill="#CC5D15"
      />
      <rect
        width="246"
        height="246"
        rx="50"
        ry="50"
        x="5"
        y="5"
        fill="#F49C52"
      />
      <rect
        width="236"
        height="236"
        rx="47"
        ry="47"
        x="10"
        y="10"
        fill="url(#RSSg)"
      />
      <circle cx="68" cy="189" r="24" fill="#FFF" />
      <path
        d="M160 213h-34a82 82 0 0 0 -82 -82v-34a116 116 0 0 1 116 116z"
        fill="#FFF"
      />
      <path
        d="M184 213A140 140 0 0 0 44 73 V 38a175 175 0 0 1 175 175z"
        fill="#FFF"
      />
    </svg> somewhere on the page. If they do, you can subscribe to them.

    Subscribing is dead simple to do: you subscribe to someone by entering the URL to their blog, website, channel, profile, whatever into your RSS reader app.

    Then, the app will check the feed for updates every few hours, and show the posts in reverse-chronological order. Some apps also provide other filters for showing the content, but whatever you choose, it's always under your control.

    ## Where can I find feeds to subscribe to?

    The best way to discover blogs to follow is by simply browsing the web. Not with a search engine, but by following links from site to site. There's tons of interesting stuff out there. Often, blogs have a blogroll: a list of blogs that they like.

    Here are some starting points:

    - [ooh.directory](//ooh.directory)
    - [blogroll.org](//blogroll.org)

    In addition to most blogs, lots of other sites offer RSS feeds too. Forexample, every YouTube channel has an RSS feed (try it: simply enter the channel URL in your RSS reader!). And most news sites (like [NOS](//nos.nl/feeds)) offer RSS feeds too, as do [weather forecasts](//rss.buienradar.nl/radar.php). Additionally, RSS is often used for podcasts too.
    """,
    linked_sites: [
      %{route: "/rss", site_id: site0.id, layout_id: nil},
      %{route: "/rss", site_id: site1.id, layout_id: nil}
    ]
  },
  %{
    label: "Jongeren lezen niet meer--so what?",
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
      %{route: "/iconic", site_id: site1.id, layout_id: nil}
    ]
  }
]

for params <- templates do
  %Pebble.Template{}
  |> Pebble.Template.changeset(params)
  |> Pebble.Repo.insert!()
end
