# @milktop/imba-ui

Imba components built on [Zag](https://zagjs.com) state machines. Zag handles
state, keyboard navigation, focus, ARIA, positioning and dismissal; this
package adds Imba markup and an optional theme.

| Component | Tag | Notes |
| --- | --- | --- |
| Button | `<ui-button>` | A real `<button>`: variants, sizes, Iconify icons, icon-only, loading |
| Date picker | `<ui-date-picker>` | Single or range, min/max, unavailable dates, day/month/year views; ↑/↓ in the input step a day (⇧ a week), starting from today |
| Select | `<ui-select>` | Single or multiple, typeahead, optional hidden `<select>` for plain forms |
| Combobox | `<ui-combobox>` | Filtering, multiple selection with tags, async `load` for server search |
| Input | `<ui-input>` | Text input with icon, prefix/suffix text or slots; slot a textarea to replace it |
| Number input | `<ui-number-input>` | +/- buttons, arrow/Shift stepping, clamping, locale formatting (`formatOptions`); emits a number |
| Textarea | `<ui-textarea>` | Grows with its content from `rows` to `maxRows` |
| Checkbox | `<ui-checkbox>` | Checked, unchecked or indeterminate; binds `checked` |
| Checkbox group | `<ui-checkbox-group>` | Checkboxes for a list of items, bound to an array; optional select-all |
| Radio group | `<ui-radio-group>` | One of a list of options, with optional descriptions |
| Switch | `<ui-switch>` | On/off toggle; binds `checked` |
| Segmented | `<ui-segmented>` | Pill of options with a sliding indicator; arrow keys move the selection |
| Tooltip | `<ui-tooltip>` | Hover/focus hint on any element, with arrow and placement |
| Popover | `<ui-popover>` | Floating panel from a trigger, with heading, close button, optional arrow; binds `open` |
| Dialog | `<ui-dialog>` | Modal rendered at the end of `<body>`: focus trap, scroll lock, heading, footer slot; binds `open` |
| Menu | `<ui-menu>` | Dropdown of actions with icons, shortcuts, groups and separators; emits `select` |
| Toast | `<ui-toaster>` + `toaster` | Notifications stacked in a corner: success/error/warning/info/loading, actions, pause on hover |
| Tabs | `<ui-tabs>` + `<ui-tab>` | Panels with a tab list built from their labels; line or pills |
| Accordion | `<ui-accordion>` + `<ui-accordion-item>` | Expandable sections, single or multiple open |
| Field | `<ui-field>` | Label, hint and error around any control, wired up with aria attributes |
| Fields | `<ui-fields>` | 12-column grid of fields that stacks when narrow; with `legend` or `disabled` a real `<fieldset>` |

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

<ui-date-picker label='Lesson date' bind=lesson.date>
<ui-combobox label='Subject' items=subjects labelKey='name' valueKey='id' bind=subjectId>
```

Values work three ways, all two-way:

- `bind=model.field` (Imba binds custom tags through `data`, which aliases `value`)
- `bind:value=model.field`
- `value=x @change=(x = e.detail)`

Values are plain: ISO dates from the date picker, and the items' own values
(numeric ids stay numbers) from select and combobox. Changing the value from
outside updates the component without emitting `change`, as with native inputs;
only user changes emit it. With async `load`, an outside value only shows a
label once its item is among the loaded results.

## Forms

`ui-fields` lays fields out on a 12-column grid; each `ui-field` spans `span`
columns (default 12) and every field goes full width when the grid is narrower
than 480px (a container query, so it works in dialogs and sidebars too).

```imba
<ui-fields>
	<ui-field span=6 label='Email' type='email' icon='lucide:mail' required error=form.errors.email bind=form.email>
	<ui-field span=6 label='Subject' error=form.errors.subject>
		<ui-select items=subjects bind=form.subject>
```

Without children a field renders a `ui-input`, passing on `type`, `name`,
`placeholder`, `autocomplete`, `icon`, `prefix`, `suffix`, `min`, `max`, `step`,
`attrs`, `required`, `disabled` and its value (`bind=`, `bind:value=` or `value` + `@change`).
`type='number'` renders a `ui-number-input` (also passing `formatOptions` and
`steppers`, which hides the +/- buttons when false) and
`type='textarea'` a `ui-textarea` (with `rows` and `maxRows`). Children replace
the default with any other control.

`ui-input` takes the same props. `attrs` passes any other attributes to the
input, e.g. `attrs={ inputmode: 'decimal' }`. `icon` is an [Iconify](https://iconify.design)
name and needs `import 'iconify-icon'` in the app; the built-in components
don't use it. For anything else before or after the input, use the slots:

```imba
<ui-input type=(show ? 'text' : 'password') icon='lucide:key' bind=password>
	<button slot='suffix' @click=(show = !show)> <iconify-icon icon='lucide:eye'>
```

Use one `ui-fields` for a plain form, or several with a `legend` (and optional
`description`) to group them. With a legend or `disabled` it renders a real
`<fieldset>`: assistive tech announces the named group, and `disabled`
disables every control inside, components included.

```imba
<ui-fields legend='Student' description='Who the lessons are for' disabled=saving>
```

A field owns its control's label, hint and error; an error replaces the hint
while there is one. Plain inputs get an id, the
label's `for`, `aria-describedby` and `aria-invalid`. Components inside a field
skip their own `label`, use the field's, and turn `invalid` on (`data-invalid`)
while there is an error.

## Theming

Styled components read `$ui-*` tokens from `src/theme.imba`: colours (`$ui-accent`
for primary buttons and selections, `$ui-danger`, `$ui-ring`…), `$ui-radius`,
and `$ui-control-height` (with `-sm`/`-lg`), which buttons and inputs share so
they line up. Override them globally, e.g. to map onto an app's own tokens:

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
