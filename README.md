# danielhavlicek.cz — osobní portfolio

Statický web pro freelance vývojáře Daniela Havlíčka. Nasazuje se na **Cloudflare Pages** přímým nahráním souborů — žádný build step, žádný backend.

---

## Struktura souborů

```
/
├── index.html          ← Hlavní portfolio stránka
├── style.css           ← Styly pro portfolio
├── script.js           ← CZ/EN přepínač jazyka + animace + mobilní menu
│
├── demo/
│   └── index.html      ← Ukázková stránka pro prospekty (self-contained)
│
└── README.md
```

---

## Jak přidat novou ukázku pro klienta

Stránka `/demo/index.html` je **self-contained** — veškerý CSS a JS je inline, žádné externí závislosti kromě Google Fonts.

**Postup:**
1. Zkopíruj celou složku `demo/` do nové složky:
   ```
   demo/    →   klientjmeno/
   ```
2. Uprav `klientjmeno/index.html` — nahraď placeholder texty konkrétním obsahem klienta.
3. Nahraj složku na Cloudflare Pages.
4. Výsledná URL: `danielhavlicek.cz/klientjmeno/`

Demo banner v horní části stránky vždy odkazuje zpět na `danielhavlicek.cz` — absolutní URL, funguje bez ohledu na umístění složky.

---

## Přepínač jazyka (CZ/EN)

Překlady jsou v souboru `script.js` v objektu `i18n`. Každý přeložitelný element má atribut `data-i18n="klic"`. Při přepnutí jazyka se vyplní `innerHTML` daného elementu hodnotou z objektu `i18n`.

Zvolený jazyk se ukládá do `localStorage` — uživatel ho uvidí i po načtení stránky znovu.

**Přidání překladu:** přidej nový klíč do obou sekcí (`cs` i `en`) v `script.js` a na příslušný HTML element přidej atribut `data-i18n="tvuj.klic"`.

---

## Nasazení na Cloudflare Pages

1. V dashboardu Cloudflare Pages vytvoř nový projekt.
2. Propoj GitHub repozitář (nebo nahraj soubory ručně).
3. **Build settings:** žádný build command, output directory = `/` (root).
4. Nastav custom domain `danielhavlicek.cz`.

---

## Kontakt & přístupy

- E-mail: daniel.havlicek1@seznam.cz
- Telefon: +420 777 454 591
- GitHub: https://github.com/Danas2008
