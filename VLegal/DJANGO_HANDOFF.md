# Lajsek Legal — přepis statického webu do Django

Zdroj: statický HTML/CSS prototyp v `VLegal/` (14 stránek, sdílený `style.css`,
jeden `menu.js`). Cíl: Django projekt se stejným vzhledem a strukturou.
Textový/obrazový obsah zkopíruje uživatel ručně ze zdrojových `.html` souborů —
tento dokument popisuje **strukturu, jmenné konvence a chování**, ne obsah.

## 1. Přehled stránek → navrhované Django routy

| Soubor (zdroj)             | URL name           | Cesta                  | Titulek (`<title>`)                    |
|-----------------------------|--------------------|-------------------------|------------------------------------------|
| index.html                  | `home`             | `/`                      | Lajsek Legal \| Advokacie a mediace       |
| o-nas.html                  | `about`            | `/o-nas/`                | O nás \| Lajsek Legal                     |
| spoluprace.html              | `cooperation`      | `/jak-probiha-spoluprace/` | Jak probíhá spolupráce \| Lajsek Legal  |
| odmena.html                  | `fees`             | `/odmena/`                | Odměna \| Lajsek Legal                    |
| reference.html               | `references`       | `/reference/`             | Reference \| Lajsek Legal                 |
| blog.html                    | `blog_list`        | `/blog/`                  | Blog \| Lajsek Legal                      |
| kontakt.html                 | `contact`          | `/kontakt/`               | Kontakt \| Lajsek Legal                   |
| legal.html                   | `privacy`          | `/osobni-udaje/`          | Osobní údaje \| Lajsek Legal              |
| spory-a-mediace.html         | `service_disputes` | `/sluzby/spory-a-mediace/` | Soudní spory a mediace \| Lajsek Legal  |
| nemovitosti.html             | `service_realestate` | `/sluzby/nemovitosti/`  | Nemovitosti \| Lajsek Legal                |
| smlouvy.html                 | `service_contracts` | `/sluzby/smlouvy/`       | Smlouvy \| Lajsek Legal                    |
| dusevni-vlastnictvi.html     | `service_ip`       | `/sluzby/dusevni-vlastnictvi/` | Duševní vlastnictví \| Lajsek Legal  |
| gdpr.html                    | `service_gdpr`     | `/sluzby/gdpr/`           | Osobní údaje a GDPR \| Lajsek Legal        |
| mediace.html                 | `service_mediation` | `/sluzby/mediace/`       | Mediace \| Lajsek Legal                    |

Doporučená struktura Django apps:
- `core` – home, o-nas, spoluprace, odmena, reference, kontakt, legal (statické/skoro-statické stránky)
- `services` – 6 stránek právních služeb (mohly by být i jeden `Service` model + `slug` routa `/sluzby/<slug>/` misto 6 pevných šablon — viz sekce 5)
- `blog` – výpis článků + detail (aktuálně jen 3 statické karty bez detailu, viz sekce 6)

## 2. Sdílený layout (base.html)

Každá stránka má identickou kostru:

```
<!doctype html>
<html lang="cs">
  <head>
    charset utf-8, viewport, <title>, <link rel="icon" href="ikon.ico">,
    <link rel="stylesheet" href="style.css">
    (jen index.html navíc: <meta name="description" content="...">)
  </head>
  <body>
    <header class="header">…</header>
    <main>
      <section class="page-title">…</section>
      … obsah specifický pro stránku …
    </main>
    <footer class="footer">…</footer>
    <script src="menu.js" defer></script>  (chybí jen na legal.html)
  </body>
</html>
```

To se v Django přepíše jako `base.html` s bloky `{% block title %}`,
`{% block content %}`, případně `{% block extra_head %}`.

### 2.1 Header (identický na všech stránkách kromě aktivního odkazu a legal.html)

```html
<header class="header">
  <div class="wrap">
    <a class="brand" href="{% url 'home' %}">
      <strong>LAJSEK LEGAL</strong><span>Advokacie a mediace</span>
    </a>
    <nav class="nav" id="site-nav">
      <a href="...">Domů</a>
      <a href="...">O nás</a>
      <a href="...">Jak probíhá spolupráce</a>
      <a href="...">Odměna</a>
      <a href="...">Reference</a>
      <a href="...">Blog</a>
      <a href="...">Kontakt</a>
      <!-- aktivní stránka: aria-current="page" na daném <a> -->
    </nav>
    <div class="header-cta">
      <a class="phone-pill" href="tel:+420723506568">
        <svg ...telefonní ikona.../>
        <span>+420 723 506 568</span>
      </a>
      <a class="button" href="{% url 'contact' %}">Kontaktujte nás</a>
      <button class="nav-toggle" aria-expanded="false" aria-controls="site-nav"
              aria-label="Otevřít menu">
        <span></span><span></span><span></span>
      </button>
    </div>
  </div>
</header>
```

Poznámka: `legal.html` (Osobní údaje) NEMÁ `<nav>` ani hamburger tlačítko —
jen brand + phone-pill + "Kontaktujte nás" tlačítko. Je to záměrně
odlehčená stránka bez primární navigace.

Chování hamburger menu (`menu.js`, mobil <980px):
- klik na `.nav-toggle` toggluje `.is-open` na `#site-nav` + `aria-expanded`
- klik na libovolný `<a>` v nav zavře menu
- klik mimo nav i toggle zavře menu
- `Escape` zavře menu
- `resize` nad 980px zavře menu (desktop layout je vždy plně viditelný)
- při otevření na mobilu se zamkne scroll `document.body.style.overflow = "hidden"`

### 2.2 Footer (100% identický na všech 14 stránkách)

```html
<footer class="footer">
  <div class="wrap footer-grid">
    <div class="footer-col">
      <h3>Kontakt</h3>
      <p>Nejefektivnější způsob, jak nás kontaktovat, je e-mailem, nebo nám můžete zavolat.</p>
      <ul class="footer-list">
        <li><span>E-mail</span><a href="mailto:vlajsek@lajseklegal.cz">vlajsek@lajseklegal.cz</a></li>
        <li><span>Telefon</span><a href="tel:+420723506568">+420 723 506 568</a></li>
      </ul>
    </div>
    <div class="footer-col">
      <h3>Najdete nás</h3>
      <p>Chrudimská 1418/2<br>130 00 Praha 3</p>
      <p>Pondělí – pátek: 9:00–18:00</p>
    </div>
    <div class="footer-col">
      <h3>Datová schránka</h3>
      <p>5yzxazh</p>
    </div>
  </div>
  <div class="wrap footer-bottom">
    <div>
      <strong>LAJSEK LEGAL</strong>
      <p>Moderní kancelář, moderní prostředky</p>
    </div>
    <nav class="footer-nav">
      <a href="{% url 'home' %}">Domů</a>
      <a href="{% url 'privacy' %}">Osobní údaje</a>
    </nav>
  </div>
</footer>
```

→ ideální kandidát na `templates/partials/footer.html` include, žádná
stránková variace.

## 3. Statické soubory (→ Django `static/`)

| Soubor | Účel | Poznámka |
|---|---|---|
| `style.css` | jediný stylesheet celého webu | `--ink`, `--ink-soft`, `--ivory`, `--paper`, `--wine`, `--wine-dark`, `--line`, `--max-width:1200px`, `--reading-width:710px` custom properties v `:root` |
| `menu.js` | hamburger menu (viz 2.1) | vanilla JS, žádné závislosti |
| `ikon.ico` | favicon, linkovaný jako `<link rel="icon">` na všech stránkách | |
| `obrazek1.jpg` | portrét Vladimíra Lajska (hero na homepage, bio na o-nas.html) | používá se 2×, `object-position: 20% center` jen na homepage hero |
| `obrazek2.jpg` | kancelář (about-preview na homepage, i jako obrázek na kontakt.html) | používá se 2× |
| `obrazek3.jpg` | needed by (uploaded, but aktuálně nikde nepoužit — referencí sekce teď používá text quotes místo obrázku) | ověřit, zda ho chce klient jinam přidat |
| Google Font | `Jakarta` (Plus Jakarta Sans) přes `@font-face` na `/fonts/plus-jakarta-sans-latin-ext.woff2` — **cesta je absolutní `/fonts/...`, v Django přepsat na `{% static %}`** | fallback: Arial, sans-serif |
| `Georgia, "Times New Roman", serif` | druhé písmo (`--serif`), používané na nadpisy — systémový font, nic ke stažení | |

Google Maps embed na kontakt.html je `<iframe>` bez API klíče:
`https://www.google.com/maps?q=Chrudimsk%C3%A1%201418%2F2%2C%20130%2000%20Praha%203&output=embed`

## 4. Klíčové CSS komponenty/třídy (glosář pro šablony)

Layout/primitivy: `.wrap` (kontejner, max-width 1200px), `.section`, `.content`,
`.page-title` (nadpis stránky pod headerem), `.reading` (omezená šířka 710px
pro dlouhý text), `.hero` / `.hero-copy` (jen homepage).

Opakující se komponenty a kde se používají:
- `.service` / `.services` — grid 6 právních oblastí na homepage (číslo + odkaz)
- `.about-preview` — homepage sekce "O nás" (text + obrázek, 2 sloupce od 640px)
- `.quotes` / `blockquote` — reference.html, 2×2 grid citací s ikonou uvozovky,
  avatar (iniciály), jméno, role
- `.steps` / `.step` — spoluprace.html, 4 očíslované kroky spolupráce
- `.fee-list` — odmena.html (a shodná struktura na 6 stránkách služeb pod
  nadpisem "Co pro Vás zajistíme")
- `.pub-list` — o-nas.html, seznam publikací (border-top/bottom řádky)
- `.contact-grid` / `.contact-card` / `.info-list` / `.info-icon` / `.map-embed`
  — kontakt.html, karta s kontaktními údaji + Google Maps iframe vedle sebe
- `.form-card` / `.contact-form` / `.form-row` — kontakt.html formulář
  (aktuálně `action="mailto:..."` — **v Django nahradit skutečným POST
  view/formulářem**, pole: jméno, e-mail, telefon, předmět, zpráva)
- `.posts` / `.post` — blog.html a homepage výpis (datum + nadpis, zatím bez
  detailu článku ani textu)
- `.disclaimer` — box s upozorněním na advokátní mlčenlivost (homepage i
  reference.html)
- `.footer-grid` / `.footer-col` / `.footer-list` / `.footer-bottom` /
  `.footer-nav` — viz sekce 2.2
- `.header-cta` / `.phone-pill` / `.nav-toggle` / `.button` / `.text-link` —
  viz sekce 2.1

Breakpointy: `640px` (tablet), `980px` (desktop — nad touto šířkou se nav
zobrazuje inline místo hamburgeru a `.phone-pill` se stává viditelnou).

## 5. Návrh datového modelu (volitelně, pokud nemá zůstat čistě statické)

Pokud klient bude chtít obsah služeb/blogu editovat přes Django admin místo
pevných šablon:

```python
class Service(models.Model):
    slug = models.SlugField(unique=True)       # "spory-a-mediace", "nemovitosti", ...
    order = models.PositiveIntegerField()       # 1–6, pořadí v homepage gridu
    title = models.CharField(max_length=100)     # "Soudní spory a mediace"
    lead = models.TextField()                    # úvodní věta na stránce služby
    intro = models.TextField(blank=True)         # text pod "Co pro Vás zajistíme"

class ServiceFeature(models.Model):
    service = models.ForeignKey(Service, related_name="features", on_delete=models.CASCADE)
    heading = models.CharField(max_length=120)   # "Příprava a podání žaloby"
    body = models.TextField()

class BlogPost(models.Model):
    slug = models.SlugField(unique=True)
    title = models.CharField(max_length=200)
    published_at = models.DateField()
    body = models.TextField()                     # aktuálně na webu chybí, jen nadpis+datum

class Testimonial(models.Model):
    quote = models.TextField()
    name = models.CharField(max_length=80)        # "Martin", "Pavel", "Eva", "Kryštof"
    role = models.CharField(max_length=150)        # "Zakladatel a ředitel technologické společnosti"
```

Pokud má zůstat jednoduché (doporučeno pro první verzi) — 6 služeb i blog
klidně jako pevné Django template soubory/views bez modelů, DB jen pro
kontaktní formulář (uložení poptávek) případně później.

## 6. Známé mezery / rozhodnutí pro klienta

- **Kontaktní formulář** na kontakt.html je čistě klientský `mailto:` submit
  (žádný backend) — v Django nahradit skutečným `forms.Form` + POST view,
  který pošle e-mail nebo uloží zprávu do DB.
- **Blog** má jen 3 statické karty (datum + nadpis), žádný text článku ani
  detail stránka — potřeba rozhodnout, jestli blog bude mít `BlogPost` model
  s `detail.html`, nebo zůstane jen výpis.
- **obrazek3.jpg** není v aktuální verzi webu nikde vyrenderován (dřív byl na
  reference.html, nahrazen textovými citacemi) — zeptat se klienta, jestli ho
  chce použít jinde, nebo ho vynechat.
- Publikace na o-nas.html jsou čistý text (citace), bez odkazů — pokud klient
  pošle skutečné URL, přidat `<a href>` na každou položku `.pub-list`.
- Telefon/e-mail/adresa (`vlajsek@lajseklegal.cz`, `+420 723 506 568`,
  `Chrudimská 1418/2, 130 00 Praha 3`, datová schránka `5yzxazh`) se opakují
  na cca 10 místech (header, footer, kontakt) — v Django je vytáhnout do
  `settings.py` nebo context processoru, ať se nekopírují ručně.

## 7. Jak postupovat v novém repu

1. Založit Django projekt, `base.html` podle sekce 2, `static/style.css` a
   `static/menu.js` zkopírovat 1:1 (jen opravit `/fonts/...` na `{% static %}`).
2. Vytvořit `core` app s views pro home/o-nas/spoluprace/odmena/reference/kontakt/legal.
3. Vytvořit `services` app (6 pevných šablon, nebo `Service` model dle sekce 5).
4. Zkopírovat textový obsah z jednotlivých `.html` souborů do odpovídajících
   Django šablon/`.txt`/DB záznamů — obsah beze změny, jen HTML tagy
   nahradit template syntaxí kde je potřeba (`{% url %}`, `{% for %}` u
   opakujících se bloků jako `.service`, `.quotes`, `.pub-list`).
5. Kontaktní formulář přepojit na skutečný Django `forms.Form` + view misto
   `mailto:`.
