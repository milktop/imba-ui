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
- `playground/`: Vite demo app (`npm run dev`); add a section for every component

New components follow the same pattern: add both files, an entry in
`package.json` `exports` (`./<name>` and `./<name>/base`), an import in
`src/index.imba`, a playground section and a row in the readme table.

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
- **Inner `<input>`/`<select>` elements get `@change.stop`,** so their native events
  don't reach the host's `change` listeners.
- **Popups:** put `zi` on `.content`; Zag copies it onto the positioner.
- **Prop names:** don't use native attribute names (`dir`, `hidden`, `title`).
  Read-only DOM properties (`prefix`) throw as a `prop`; use a get/set accessor.
- **Imba CSS shorthands:** `size:` and `pi:` don't exist; use `w`/`h` and `place-items`.
- **Values are controlled and bindable.** Read and write the value through `data`
  (it aliases `value`; `bind=` replaces it with the model). Call
  `machine.syncValue data, do …setValue(…)` in render, and on Zag's
  `onValueChange` set `data` and `emit('change', data) if machine.track(data)`.
- **Fields:** components look up their `ui-field` with `closestField` in render
  (refreshing when its `stateKey` changes), pass `invalid` and lazy `ids` for the
  label, skip their own label when the field has one, and spread
  `#field.describe(props)` onto their focusable control. They also pass
  `disabled: disabled or #locked`, where `#locked` is an enclosing
  `fieldset:disabled`, since Zag doesn't track it.
- **Emitted values:** `change` emits plain values (ISO dates, the items' original
  values), never Zag's internal strings.

## Testing

Run the playground and drive it in the browser. When the browser pane is in the
background, rAF is throttled, so screenshots and parent re-renders can lag. Check
state through the DOM or `el.machine.service` before assuming a bug.

Build check: `npx vite build playground`.
