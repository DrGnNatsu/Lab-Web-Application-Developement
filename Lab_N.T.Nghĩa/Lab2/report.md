# Lab report — Flexbox notes

## link git pages
https://drgnnatsu.github.io/
## start_boostrap.html
![boostrap.png](boostrap.png)


## Exercise 3 — Top-down architecture (how the layout is built)

1) Page shell (top-level)
- Create a wrapper `#container` and make it a column flex: `display: flex; flex-direction: column; height: 100vh;`.
- Purpose: make the page fill the viewport so we can divide it into header, content, and footer.

2) Header and Footer (level 1)
- Place `#header` and `#footer` as normal flex children. They keep their natural height and sit at top and bottom.

3) Content area (level 2)
- Make the middle area `.content` a flex item with `flex: 1`; this tells it to grow and fill all remaining vertical space between header and footer.
- Result: header and footer remain fixed-size, and `.content` stretches to occupy the leftover space.

4) Columns inside content (level 3)
- Inside `.content` set `display: flex; flex-direction: row;` so its direct children become horizontal columns.
- Use `flex` ratios to set widths, e.g. `#main { flex: 2 }` and sidebars `#sidebar-a, #sidebar-b { flex: 1 }` so the main column is twice as wide as each sidebar.
- `align-items: stretch` (default) makes those columns match the full height of `.content`.

## Exercise 4 — Top-down architecture (how the layout is built)

1) Page shell (top-level)
- No special outer wrapper: the document flow stacks `header`, `main`, and `footer` vertically.

2) Header (level 1)
- `header` is a row flex: `display:flex; flex-direction:row; align-items:stretch;`.
- Two parts inside header: `#logo` and `#title`. `#title` uses `flex:1` so it fills remaining horizontal space; `#logo` keeps its content size.
- Image: `width`/`height` set on the image and `object-fit:cover` make it fill its box while preserving aspect ratio.

3) Main area (level 2)
- `main` is a row flex container holding `article` and `aside`.
- Widths controlled by `flex` ratios: `article { flex: 6 }` and `aside { flex: 4 }`, so article is wider.
- `aside` uses `align-self: flex-start` so its background only covers its content height (it does not stretch to match `article`).

4) Footer (level 1)
- Simple block at the bottom with a top border; no flex sizing needed.
---
