# @milktop/imba-ui

Imba 2 UI components built on Zag (`@zag-js/*`) state machines. The package ships
`.imba` source (no build step); consuming apps compile it with the Vite plugin
from `@milktop/inertia-imba`. Read `readme.md` first: it covers usage, theming
and the Zag/Imba lessons below in more detail.

## Layout

- `src/zag.imba`: the adapter. The `zag=` setter on `Element` spreads Zag props;
  `Machine` wraps `VanillaMachine` and re-renders its owner synchronously.
- `src/<name>/base.imba`: headless tag `ui-<name>-base`, with behaviour and markup only
- `src/<name>/index.imba`: styled tag `tag ui-<name> < ui-<name>-base`, a `css` block only
- `src/theme.imba`: `$ui-*` tokens (dark under `html.dark` / `[data-theme=dark]`)
- `src/items.imba`: item/collection helpers shared by select and combobox
- `playground/`: Vite demo app (`npm run dev`), routed with Imba's router: a shell in
  `main.imba`, one file per group in `pages/` (inputs, pickers, choices, forms),
  shared bits in `demo.imba`. Add a `demo-section` for every component. Its Code
  toggle shows the section's own markup from the page source (`?raw`); put
  readouts (`json-print`) and value-setting buttons in a `<div.out>` so they're
  left out of it

New components follow the same pattern: add both files, an entry in
`package.json` `exports` (`./<name>` and `./<name>/base`), an import in
`src/index.imba`, a section on the right playground page (or a new page in
`pages/`, `main.imba`'s `pages` list and its routes) and a row in the readme table.

## Rules

- **Markup lives in the base, styles in the subclass.** Give every element a class
  per part (`.control`, `.content`, `.item`) alongside its `zag=` props. Imba
  scopes subclass CSS to inherited markup, but not to elements rendered by child
  tags. Inline small pieces instead, or use `>>>`.
- **Machine props are read lazily.** Parse fixed values (e.g. `defaultValue`)
  before the props function. After changing something it reads outside a Zag
  event, call `machine.refresh!`.
- **Use `globalThis.queueMicrotask`.** Inside tags and classes, Imba compiles bare
  `queueMicrotask` to `self.queueMicrotask`. Check unfamiliar globals in the
  compiled output.
- **Template loops:** render tags, not bare expressions (a prebuilt element in a
  loop is dropped). Key items that own state with `<tag key=item.id>` so
  they keep their element as the list changes (`ui-toaster`).
- **Slot fallbacks must be one element.** Imba miscompiles a `<slot>` whose
  fallback is an `if`/`else`; wrap it (see `ui-field`).
- **Machines that spread props over defaults** (number-input) get `defined(...)`
  props, so unset ones don't wipe out the defaults.
- **Inner `<input>`/`<select>` elements get `@change.stop`,** so their native events
  don't reach the host's `change` listeners.
- **Popups:** put `zi` on `.content`; Zag copies it onto the positioner. Floating
  panels (tooltip, popover) use `strategy: 'fixed'` so overflow can't clip them.
- **Exit animations:** Zag hides closing popups at once; use `Presence` from
  `zag.imba` (`update(open)` in render, `keep(props)` on hidden parts, `done` on
  animationend) to keep them shown while they animate out.
- **Modals** render their backdrop and panel inside Imba's `<global>` teleport, at
  the end of <body>.
- **Slotted triggers** (tooltip, popover, dialog, menu) get Zag's trigger props spread straight
  onto the slotted element (`trigger.zag = …`), in both `render` and `rendered`:
  Machine re-renders without Imba's `rendered` hook.
- **No optional assignment:** `a..b = c` compiles to invalid `a?.b = c`; write
  `a.b = c if a`.
- **Method names:** don't reuse Imba's component methods (`commit`, `render`,
  `visit`, `setup`, `mount`); overriding `commit` silently breaks rendering.
- **Prop names:** don't use native attribute names (`dir`, `hidden`, `title`).
  `prop` compiles to a plain assignment, so on a native property (`disabled` on
  a button) it just sets the native one, and read-only ones (`prefix`) throw;
  use a get/set accessor. `tag x < button` makes the element a real <button>.
- **Imba CSS shorthands:** `size:` and `pi:` don't exist; use `w`/`h` and `place-items`.
  `x:`/`y:` emit unitless values (`x:4` is invalid); use `transform` with units.
  `inset:` also sets `position:absolute`, so write `pos:fixed` after it. There's
  no `!important` or `@supports`/reduced-motion; plain rules like those live in
  the style element `theme.imba` injects (it also keeps Zag's `[hidden]` parts
  hidden whatever display a component sets).
- **Values are controlled and bindable.** Read and write the value through `data`
  (it aliases `value`; `bind=` replaces it with the model). Call
  `machine.syncValue data, do …setValue(…)` in render, and on Zag's
  `onValueChange` set `data` and `emit('change', data) if machine.track(data)`.
- **Fields:** components look up their `ui-field` with `closestField` in render
  (`machine.watch "{#field..stateKey}|{#locked}"` refreshes when it changes), pass `invalid` and lazy `ids` for the
  label, skip their own label when the field has one (checkbox and switch keep
  theirs), and spread
  `#field.describe(props)` onto their focusable control. They also pass
  `disabled: disabled or #locked`, where `#locked` is an enclosing
  `fieldset:disabled`, since Zag doesn't track it.
- **Emitted values:** `change` emits plain values (ISO dates, the items' original
  values), never Zag's internal strings.

## Testing

Run the playground and drive it in the browser. When the browser pane is in the
background, rAF is throttled, so screenshots and parent re-renders can lag. Check
state through the DOM or `el.machine.service` before assuming a bug. Route
changes render through `imba.commit` too, so in a background pane call
`document.querySelector('main').parentElement.render()` after navigating.

Build check: `npx vite build playground`.
