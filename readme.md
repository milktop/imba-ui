# @milktop/imba-ui

Imba components built on [Zag](https://zagjs.com) state machines. Zag handles
state, keyboard navigation, focus, ARIA, positioning and dismissal; this
package adds Imba markup and an optional theme.

| Component | Tag | Notes |
| --- | --- | --- |
| Date picker | `<ui-date-picker>` | Single or range, min/max, unavailable dates, day/month/year views |
| Select | `<ui-select>` | Single or multiple, typeahead, optional hidden `<select>` for plain forms |
| Combobox | `<ui-combobox>` | Filtering, multiple selection with tags, async `load` for server search |

## Install

The package ships Imba source, so the consuming app compiles it. That works with
the Vite plugin from `@milktop/inertia-imba`.

```sh
npm install github:milktop/imba-ui
# or, while developing locally
npm install file:../../imba/ui
```

Keep Vite's dependency optimiser away from the `.imba` source:

```js
// vite.config.js
export default defineConfig({
  optimizeDeps: { exclude: ['@milktop/imba-ui'] },
})
```

## Use

```imba
import '@milktop/imba-ui/date-picker'
import '@milktop/imba-ui/combobox'

<ui-date-picker label='Lesson date' value=lesson.date @change=(lesson.date = e.detail)>
<ui-combobox label='Subject' items=subjects labelKey='name' valueKey='id' @change=(subjectId = e.detail)>
```

Each component emits `change` with plain values: ISO dates from the date picker,
and the items' own values (numeric ids stay numbers) from select and combobox.

## Theming

Styled components read `$ui-*` tokens from `src/theme.imba`. Override them
globally, e.g. to map onto an app's own tokens:

```imba
global css @root
	$ui-accent:$focus $ui-surface:$surface $ui-border:$border
```

Dark values apply under `html.dark` or `[data-theme=dark]`.

## Headless use and custom styles

Every component is two tags:

- `ui-<name>-base` (`@milktop/imba-ui/<name>/base`): behaviour and markup, no styles
- `ui-<name>` (`@milktop/imba-ui/<name>`): the base plus the default theme

Imba scopes a subclass's CSS to everything its instances render, including the
markup they inherit. So a custom look is a subclass with ordinary scoped CSS:

```imba
import '@milktop/imba-ui/date-picker/base'

tag lesson-date-picker < ui-date-picker-base
	css
		.cell rd:full
			&[data-selected] bg:$brand
```

Elements have a class per part (`.control`, `.content`, `.item`, `.cell`…)
plus Zag's `data-part` and state attributes (`data-selected`, `data-highlighted`,
`data-state=open`…).

## Writing a component

`src/zag.imba` is the whole adapter:

- `<div zag=api.getXProps!>` spreads Zag's props onto any element (the
  `zag` setter on `Element`). Zag's `class` is ignored because Imba owns it.
- `new Machine(self, machine, propsFn)` runs the service and re-renders the
  owning tag synchronously on every change.

Things learned the hard way:

- **Render synchronously.** Zag's effects expect the DOM to be current, e.g.
  when focusing a cell straight after opening. That's why `Machine` calls `render!`
  instead of relying on `imba.commit!`.
- **Props are read lazily.** Zag calls the props function repeatedly. Work out
  fixed values (like a parsed `defaultValue`) once, before it. When something it
  reads changes outside a Zag event (e.g. async results), call `machine.refresh!`.
- **Swap collections after the transition.** Changing a combobox collection
  inside `onInputValueChange` runs Zag's watchers from the wrong state. Defer
  the change to a microtask, as a framework re-render would.
- **Use `globalThis.queueMicrotask`.** Inside a tag or class, Imba compiles
  a bare `queueMicrotask` to `self.queueMicrotask`.
- **Stop native `change` events.** Inner inputs' native `change` events bubble
  to the host and clash with the component's own `change`, so use `@change.stop`.
- **Popup z-index goes on `.content`.** Zag copies the content's computed
  z-index onto the positioner.
- **Prop names.** Avoid native attribute names such as `dir`, `hidden` and `title` as prop names.

## Develop

```sh
npm install
npm run dev   # playground
```
