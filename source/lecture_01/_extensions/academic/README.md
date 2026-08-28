# Academic Slides — Typst format for Quarto

A widescreen (13.333in × 7.5in) slide template that renders through **Typst**
instead of Beamer or revealjs. Body text is set in Noto Sans; slide titles,
section headings, the section table of contents, and header/footer text are
set in IBM Plex Mono. Both fonts are bundled in this extension, so rendering
works offline with no system font install required.

## Install

Copy the `_extensions/academic/` folder into your Quarto project (it should
sit next to your `.qmd` files, at `your-project/_extensions/academic/`).
Nothing else to install — Quarto's built-in Typst compiler is used.

## Use

In your document's YAML, set:

```yaml
format: academic-typst
```

Then render as usual:

```
quarto render your-slides.qmd
```

See `example.qmd` at the project root for a full working example.

## HTML version (for a course website / GitHub Pages)

`academic-revealjs.scss` (project root, alongside `example.qmd`) is a
matching revealjs theme — same fonts, colors, and title/section/slide
treatment, but as an HTML deck instead of a PDF. List both formats in a
document's YAML to render each with one `quarto render`:

```yaml
format:
  academic-typst: default
  revealjs:
    theme: [default, academic-revealjs.scss]
    width: 1280
    height: 720
    menu: true
    slide-number: true
    progress: true
```

The revealjs version gets a built-in, clickable outline via `menu: true`
rather than the Typst deck's section-divider pages. Use the Typst PDF as the
handout and the revealjs HTML for the web.

## How slides are structured

This template follows Quarto's normal slide convention — the same one used
by `revealjs` and `beamer` — so existing slide `.qmd` files mostly just work
after changing the `format:`:

- A level-1 heading (`# Section`) starts a new **section**. It produces a
  divider slide with a large section number, the section title, and a list
  of every section with the current one highlighted.
- A level-2 heading (`## Slide title`) starts a new **content slide**.
- Every slide after the title slide shows a running header listing all
  sections (current one bolded) and a page number in the footer.
- Bullet lists, numbered lists, tables, code blocks, inline code, images,
  and links are all styled to match.

Supported title-slide metadata: `title`, `subtitle`, `author`, `institute`,
`email`, `date` — all standard Quarto/Pandoc fields. `email` prints under
`institute` on the title slide.

## Notes and limitations

- This is a **flowing document with forced page breaks**, not a true slide
  engine — there is no build/incremental-reveal support, and speaker notes
  are not rendered. If a slide's content is too long for one page, Typst
  will flow the overflow onto a plain continuation page rather than
  shrinking it, so keep individual slides concise (as you would for Beamer
  or PowerPoint).
- Widescreen size, fonts, colors, spacing, and the divider-slide layout are
  all defined as plain values near the top of `typst-template.typ` —
  open that file and edit the `#let` block at the top to retune the
  palette or type scale.
- To change the accent color, edit the `accent` / `accent-soft` values in
  `typst-template.typ` (defined in OKLCH so hue, lightness, and chroma are
  independent).
- `date` prints exactly as typed, with no reformatting — write it as e.g.
  `August 25, 2026` (full month name, no leading zero on the day, four-digit
  year) to match the template's intended style.
