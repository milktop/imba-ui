# @milktop/imba-ui

Imba components built on [Zag](https://zagjs.com) state machines. Zag handles
state, keyboard navigation, focus, ARIA, positioning and dismissal; this
package adds Imba markup and an optional theme.

| Component | Tag | Notes |
| --- | --- | --- |
| Button | `<ui-button>` | A real `<button>`: variants, sizes, Iconify icons, icon-only (square, or `round`), loading |
| Copy button | `<ui-copy-button>` | Copies a value, shows a tick; fits an input's suffix slot |
| Avatar | `<ui-avatar>` | Image with initials (or icon) fallback, sizes, circle or square |
| Badge | `<ui-badge>` | Status labels: neutral, accent, success, warning, danger, outline |
| Card | `<ui-card>` | Surface with heading, description, actions and footer slots |
| Table | `<ui-table>` | Rows by `columns`: sortable headings, row selection with select-all, custom cell tags, formats, loading/empty states, sticky header; or style a `<table>` written inside |
| Pagination | `<ui-pagination>` | Previous/next and page numbers with ellipses, optional "11–20 of 95" summary; binds `page` |
| Alert | `<ui-alert>` | In-page message: info, success, warning, danger; actions, dismissible |
| Skeleton | `<ui-skeleton>` | Loading placeholders: blocks, circles, text lines |
| Spinner | `<ui-spinner>` | Small loading indicator with an accessible label |
| Empty state | `<ui-empty-state>` | Icon, heading, description and actions for empty views |
| Progress | `<ui-progress>` | Bar or circle, determinate or indeterminate, formatted value |
| Collapsible | `<ui-collapsible>` | A section that opens with a height animation; heading or own trigger |
| Date picker | `<ui-date-picker>` | Single or range, min/max, unavailable dates, day/month/year views; ↑/↓ in the input step a day (⇧ a week), starting from today |
| Select | `<ui-select>` | Single or multiple, typeahead, optional hidden `<select>` for plain forms |
| Combobox | `<ui-combobox>` | Filtering, multiple selection with tags, async `load` for server search |
| Input | `<ui-input>` | Text input with icon, prefix/suffix text or slots; slot a textarea to replace it |
| Number input | `<ui-number-input>` | +/- buttons, arrow/Shift stepping, clamping, locale formatting (`formatOptions`); emits a number |
| Password input | `<ui-password-input>` | Show/hide button; `ui-field type='password'` renders one |
| Pin input | `<ui-pin-input>` | One box per character for codes; emits `complete` when filled |
| Slider | `<ui-slider>` | Single or range (array value), marks, formatted value |
| Tags input | `<ui-tags-input>` | Free-form tags: add with Enter or comma, edit, remove |
| File upload | `<ui-file-upload>` | Dropzone and file list with previews and rejections |
| Textarea | `<ui-textarea>` | Grows with its content from `rows` to `maxRows` |
| Checkbox | `<ui-checkbox>` | Checked, unchecked or indeterminate; binds `checked`; `labelHidden` for a label only assistive tech hears |
| Checkbox group | `<ui-checkbox-group>` | Checkboxes for a list of items, bound to an array; optional select-all |
| Radio group | `<ui-radio-group>` | One of a list of options, with optional descriptions |
| Switch | `<ui-switch>` | On/off toggle; binds `checked` |
| Segmented | `<ui-segmented>` | Pill of options with a sliding indicator; arrow keys move the selection |
| Tooltip | `<ui-tooltip>` | Hover/focus hint on any element, with arrow and placement |
| Popover | `<ui-popover>` | Floating panel from a trigger, with heading, close button, optional arrow; binds `open` |
| Hover card | `<ui-hover-card>` | Rich preview while hovering or focusing a trigger; stays open over the card |
| Dialog | `<ui-dialog>` | Modal rendered at the end of `<body>`: focus trap, scroll lock, heading, footer slot; binds `open` |
| Sheet | `<ui-sheet>` | Panel sliding in from any edge (`side`), sized sm/md/lg; a modal dialog underneath, with scrolling body and pinned footer |
| Menu | `<ui-menu>` | Dropdown of actions with icons, shortcuts, a label, groups and separators; emits `select` |
| Context menu | `<ui-context-menu>` | ui-menu opened by right-click or long-press on its area, at the pointer |
| Toast | `<ui-toaster>` + `toaster` | Notifications stacked in a corner: success/error/warning/info/loading, actions, pause on hover |
| Tabs | `<ui-tabs>` + `<ui-tab>` | Panels with a tab list built from their labels; line or pills |
| Accordion | `<ui-accordion>` + `<ui-accordion-item>` | Expandable sections, single or multiple open |
| Field | `<ui-field>` | Label, hint and error around any control, wired up with aria attributes |
| Fields | `<ui-fields>` | 12-column grid of fields that stacks when narrow; with `legend` or `disabled` a real `<fieldset>` |
| Breadcrumbs | `<ui-breadcrumbs>` (+ `<ui-breadcrumb>`) | Trail from `items` or markup; icons, custom separator; middle crumbs fold into a … popover past `max` or when they don't fit |
| Command menu | `<ui-command>` | ⌘K search box over commands: groups, icons, shortcuts, keywords, links (`href`), async `load`; emits `select` |
| App shell | `<ui-app-shell>` + `<ui-sidebar>`, `<ui-nav-section>`, `<ui-nav-item>`, `<ui-nav-group>`, `<ui-sidebar-user>`, `<ui-topbar>`, `<ui-page>` | App layout: sidebar that collapses to an icon rail (⌘B, persisted) and becomes a drawer on phones, sticky top bar, page header |

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

## App layout

`ui-app-shell` lays out a sidebar, a top bar and the page:

```imba
<ui-app-shell persist='sidebar'>
	<ui-sidebar>
		<a slot='logo' href='/'> "Tutor"
		<span slot='logo-collapsed'> "T"
		<ui-nav-section heading='Menu'>
			<ui-nav-item icon='lucide:house' href='/' active=isHome> "Dashboard"
			<ui-nav-item icon='lucide:users' href='/students' badge=3> "Students"
			<ui-nav-group icon='lucide:settings' label='Settings'>
				<ui-nav-item href='/settings/billing'> "Billing"
		<ui-sidebar-user slot='footer' name='Ada Lovelace' description='ada@example.com'
			items=[{ label: 'Profile', value: 'profile' }, { label: 'Log out', value: 'logout' }]
			@select=account(e.detail)>
	<ui-topbar>
		"Search…"
	<ui-page heading='Students' description='12 active'>
		<ui-button slot='actions'> "Add student"
		…
```

- The sidebar collapses to an icon rail with its button, ⌘/Ctrl+B, or a
  click anywhere along its right edge (`edge=false` turns that off). Labels
  then show as tooltips and groups open as a flyout. Bind the state with
  `bind=` (or `bind:collapsed=`), and remember it with `persist` (a
  localStorage key).
- Below `breakpoint` (768px) the sidebar is a drawer, opened by the top bar's
  menu button and closed by Escape, the backdrop or following a link.
- Nav items render `<a href>`, which Imba's router picks up. For Inertia,
  subclass `ui-nav-item` and set `linkTag = 'inertia-link'`.
- Instead of markup, give the sidebar `items`: `[{ heading, items: [{ label,
  icon, href, active, badge, items }] }]`.
- `ui-sidebar-user` shows the signed-in user in the footer and opens a menu
  of account actions upwards (to the right in the rail), emitting `select`.
- `ui-page` takes `width` ('narrow', 'default', 'wide' or 'full') and
  `breadcrumbs` and `actions` slots.
- Size the sidebar with `$ui-sidebar-width` and `$ui-sidebar-rail-width`.

## Command menu

`ui-command` is a ⌘K menu: a search box over a list of commands, filtered as
you type (every word must appear in the label, description, group or
`keywords`).

```imba
<ui-command items=commands @select=run(e.detail)>
	<button slot='trigger'> "Search"

commands = [
	{ label: 'Students', href: '/students', icon: 'lucide:users', group: 'Pages' }
	{ label: 'New lesson', value: 'new-lesson', shortcut: 'N', group: 'Actions' }
]
```

- ⌘K (Ctrl+K elsewhere) opens it; set `hotkey` to another key, or `null`
  for none. `hotkeyText` reads it out for a trigger ('⌘K' or 'Ctrl K').
- Items with `href` go there when picked: a link is clicked, so Imba's router
  handles it. For Inertia pass `navigate=(do(href) router.visit(href))`.
- `select` gets the item's `value` (or the item when it has none).
- `load` takes an async function(query) for server search; earlier results
  stay while it runs.
- Bind the open state with `bind=`; the `trigger` slot is optional.

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
