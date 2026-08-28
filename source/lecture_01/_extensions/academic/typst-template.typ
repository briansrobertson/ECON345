// ============================================================
// Academic Slides — Typst template for Quarto
// Widescreen (13.333in x 7.5in) presentation built as a flowing
// Typst document: level-1 headings open a section-divider slide,
// level-2 headings open a normal content slide. No external
// slide package is used, so this stays plain, readable Typst.
// ============================================================

// ---- Design tokens -------------------------------------------------
#let body-font = "Roboto"
#let mono-font = "IBM Plex Mono"

// Colors given as sRGB hex (source values are OKLCH, converted for
// maximum compatibility). To retune, pick new OKLCH values and convert.
#let ink = rgb("#1e1a16")         // oklch(22% 0.01 60) -- near-black, warm
#let ink-muted = rgb("#72665e")   // oklch(52% 0.02 60)
#let ink-faint = rgb("#b2a9a2")   // oklch(74% 0.014 60)
#let rule-color = rgb("#ddd6d1")  // oklch(88% 0.01 60)
#let accent = rgb("#413e96")      // oklch(42% 0.14 280) -- indigo
#let accent-soft = rgb("#e3e6ff") // oklch(93% 0.035 280)
#let link-color = rgb("#006185")  // oklch(46% 0.1 230) -- steel blue
#let code-bg = rgb("#f7f4f2")     // oklch(97% 0.004 60)

#let slide-w = 13.333in
#let slide-h = 7.5in

// ---- Section-tracking helpers --------------------------------------
// All top-level (level-1) headings in the document, in order.
#let all-sections() = query(heading.where(level: 1))

// The most recent level-1 heading at or before a given location.
#let current-section-at(loc) = {
  let matches = query(heading.where(level: 1).before(loc))
  if matches.len() > 0 { matches.last() } else { none }
}

// 1-based index of a level-1 heading (by its location) among all sections.
#let section-index-of(loc) = {
  let secs = all-sections()
  let idx = secs.position(s => s.location() == loc)
  if idx == none { 1 } else { idx + 1 }
}

// ---- Running header: section breadcrumb + rule ----------------------
#let nav-header() = context {
  let secs = all-sections()
  if secs.len() > 0 {
    let cur = current-section-at(here())
    block(width: 100%, height: 0.42in, above: 0pt, below: 0pt, clip: true)[
      #set text(font: mono-font, size: 10.5pt, tracking: 0.4pt)
      #for (i, s) in secs.enumerate() [
        #if i > 0 [#text(fill: ink-faint)[ · ]]
        #if cur != none and s.location() == cur.location() [
          #link(s.location())[#text(fill: accent, weight: "bold")[#upper(s.body)]]
        ] else [
          #link(s.location())[#text(fill: ink-faint, weight: "regular")[#upper(s.body)]]
        ]
      ]
      #v(7pt)
      #line(length: 100%, stroke: 0.6pt + rule-color)
    ]
  }
}

// ---- Running footer: page number only --------------------------------
#let page-footer() = context {
  set text(font: mono-font, size: 10pt, fill: ink-muted)
  align(right)[#counter(page).display("1")]
}

// ---- Main template function, invoked from typst-show.typ -------------
#let conf(
  title: none,
  subtitle: none,
  author: none,
  institute: none,
  email: none,
  date: none,
  lang: "en",
  region: "US",
  doc,
) = {
  set page(
    width: slide-w,
    height: slide-h,
    margin: (top: 0.9in, bottom: 0.5in, x: 0.7in),
    fill: white,
    numbering: none,
    header: none,
    footer: none,
  )
  set text(font: body-font, size: 19pt, fill: ink, lang: lang, region: region)
  set par(justify: false, leading: 0.62em)
  set heading(numbering: none)
  show heading: set text(font: mono-font)

  // Lists
  set list(marker: (move(dy: -0.25em, text(fill: accent)[▪]), text(fill: ink-muted)[–]))
  set enum(numbering: n => text(fill: accent, weight: "bold")[#n.])

  // Links: external URLs get the accent link color + underline; internal
  // links (TOC / header navigation to a heading) keep the caller's styling.
  show link: it => if type(it.dest) == str {
    text(fill: link-color)[#underline(it)]
  } else {
    it
  }

  // Figures & images
  set image(width: 100%, fit: "contain")
  set figure(gap: 0.7em)
  show figure.caption: set text(font: body-font, size: 14pt, fill: ink-muted, style: "italic")

  // Code
  show raw.where(block: true): it => block(
    width: 100%,
    fill: code-bg,
    inset: 12pt,
    radius: 3pt,
    above: 12pt,
    below: 12pt,
  )[#set text(font: mono-font, size: 15.5pt, fill: ink)
    #it]
  show raw.where(block: false): it => text(font: mono-font, size: 0.9em, fill: accent)[#it]

  // Tables
  set table(
    stroke: (x, y) => if y == 0 { (bottom: 1pt + ink) } else { (bottom: 0.4pt + rule-color) },
    fill: (x, y) => if y == 0 { accent-soft } else { white },
    inset: 8pt,
  )
  show table.cell: set text(size: 16pt)
  show table.cell.where(y: 0): set text(font: mono-font, size: 15pt, weight: "bold", fill: ink)

  // Level-3: in-slide subheading (no page break)
  show heading.where(level: 3): it => block(above: 14pt, below: 8pt)[
    #text(font: mono-font, size: 16pt, weight: "bold", fill: ink)[#it.body]
  ]

  // Level-2: slide title (starts a new content slide)
  show heading.where(level: 2): it => {
    pagebreak(weak: true)
    block(above: 0pt, below: 16pt)[
      #text(font: mono-font, size: 27pt, weight: "bold", fill: ink)[#it.body]
      #v(5pt)
      #line(length: 100%, stroke: 2pt + accent)
    ]
  }

  // Level-1: section divider slide (starts a new section)
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    context {
      let secs = all-sections()
      let idx = section-index-of(it.location())
      [
        #v(1fr)
        #grid(
          columns: (3in, 1fr),
          column-gutter: 0.4in,
          align(left + horizon)[
            #text(font: mono-font, size: 130pt, weight: "light", fill: ink-faint)[#numbering("01", idx)]
          ],
          align(left + horizon)[
            #text(font: mono-font, size: 34pt, weight: "bold", fill: ink)[#it.body]
            #v(20pt)
            #for (i, s) in secs.enumerate() {
              let is-current = s.location() == it.location()
              block(above: 5pt, below: 5pt)[
                #link(s.location())[#text(
                  font: mono-font,
                  size: 13pt,
                  fill: if is-current { accent } else { ink-faint },
                  weight: if is-current { "bold" } else { "regular" },
                )[#numbering("01", i + 1)  #s.body]]
              ]
            }
          ],
        )
        #v(1fr)
      ]
    }
  }

  // ---- Title slide (no header/footer) --------------------------------
  if title != none {
    v(1fr)
    text(font: mono-font, size: 46pt, weight: "bold", fill: ink)[#title]
    if subtitle != none {
      v(12pt)
      text(font: body-font, size: 21pt, fill: ink-muted)[#subtitle]
    }
    v(24pt)
    line(length: 100%, stroke: 2pt + accent)
    v(24pt)
    if author != none {
      block(below: 4pt)[#text(font: body-font, size: 16pt, fill: ink)[#author]]
    }
    if institute != none {
      block(below: 4pt)[#text(font: body-font, size: 13pt, fill: ink-muted)[#institute]]
    }
    if email != none {
      block(below: 10pt)[#text(font: body-font, size: 13pt, fill: ink-muted)[#email]]
    }
    if date != none {
      text(font: mono-font, size: 12pt, fill: ink-muted, tracking: 0.5pt)[#date]
    }
    v(1.4fr)
    pagebreak(weak: true)
  }

  // Header/footer switch on for every slide after the title.
  set page(header: nav-header(), footer: page-footer())

  doc
}
