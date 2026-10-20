# @milktop/imba-ui

Imba components built on [Zag](https://zagjs.com) state machines. Zag handles
state, keyboard navigation, focus, ARIA, positioning and dismissal; this
package adds Imba markup and an optional theme.

**Playground:** https://imba-ui.pages.dev, with every component, its props and
code, and some composed screens (blocks).

| Component | Tag | Notes |
| --- | --- | --- |
| Button | `<ui-button>` | A real `<button>`: variants (`field` looks like an input, for pickers), sizes, Iconify icons, icon-only (square, or `round`), loading, a `count` badge or `dot` |
| Copy button | `<ui-copy-button>` | Copies a value, shows a tick; fits an input's suffix slot |
| Avatar | `<ui-avatar>` | Image with initials (or icon) fallback, sizes, circle or square, colours (or one picked from the name), a `status` dot |
| Badge | `<ui-badge>` | Status labels: neutral, accent, success, warning, danger, outline; `removable` tags that emit `remove` |
| Kbd | `<ui-kbd>` | A key, or a shortcut of several (`keys`) |
| Divider | `<ui-divider>` | A line across or up, with an optional label; solid, dashed or dotted |
| Prose | `<ui-prose>` | Rich text (an `html` string or children) styled like the editor's content |
| Highlight | `<ui-highlight>` | Text with the parts matching a `query` marked; named tints or any colour (`$ui-highlight`) |
| Format | `<ui-format-number>`, `<ui-format-bytes>`, `<ui-format-relative>` | Numbers (currency, percent, compact), sizes and relative times in the app's locale; also `formatNumber`, `formatBytes`, `formatRelative` |
| Rolling number | `<ui-rolling-number>` | A number whose digits roll to a new value; Intl `format`; still for reduced motion |
| Card | `<ui-card>` | Surface with heading, description, actions and footer slots; `flush` for edge-to-edge content |
| Data list | `<ui-data-list>` (+ `<ui-data-item>`) | Labels and values as a `<dl>`: beside or above, plain/divided/card, grid columns, info tooltips |
| Stat | `<ui-stat>`, `<ui-stats>` | Headline numbers with unit, coloured change, help and icon; numbers formatted (`format`) or rolling (`animate`); grids that are plain, cards or one divided card |
| Charts | `<ui-area-chart>`, `<ui-bar-chart>`, `<ui-donut-chart>`, `<ui-sparkline>` | SVG drawn by Imba with d3 for the maths: one or more series, stacked or not, tooltips, legends, theme colours (`$ui-chart-1…5`); donuts and pies with a total in the middle |
| Timeline | `<ui-timeline>` (+ `<ui-timeline-item>`) | Events down a line with icon or dot markers, colours, times; line or cards |
| Table | `<ui-table>` | Rows by `columns`: sortable headings, row selection with select-all and Shift-click ranges, custom cell tags, formats, loading/empty states, sticky header, sizes sm/md/lg, `flush` inside cards; or write the `<table>` yourself with parts (`ui-table-header`, `-cell`, `-row`, `-select`, `-select-all`: real cells with props); state in `TableSelection` and `TableSort` (which follows the URL by default, for server-side sorting, with headings as links through your router's `linkTag`; or `local: yes`) |
| Pagination | `<ui-pagination>` | Previous/next, page numbers with ellipses and first/last once pages are hidden, optional "Showing 11–20 of 95 items" summary (`noun` renames them); binds `page` |
| Alert | `<ui-alert>` | In-page message: info, success, warning, danger; actions, dismissible |
| Banner | `<ui-banner>` | Slim announcement strip: accent, soft, neutral, success, warning, danger; icon, actions, dismissible, edge to edge |
| Skeleton | `<ui-skeleton>` | Loading placeholders: blocks, circles, text lines |
| Spinner | `<ui-spinner>` | Small loading indicator with an accessible label |
| Empty state | `<ui-empty-state>` | Icon, heading, description and actions for empty views |
| Progress | `<ui-progress>` | Bar or circle, determinate or indeterminate, formatted value |
| Tree view | `<ui-tree-view>` | Nested items that open and close: keyboard navigation, single or multiple selection, checkboxes that tick a branch's children; bind the selection, `expanded` and `checked` |
| Sortable list | `<ui-sortable-list>` | Rows put in order by dragging a grip (or the whole row), or with the keyboard (Space, arrows, Space; Escape cancels), announced to screen readers; `itemTag` for row content; card or plain; bindable |
| Collapsible | `<ui-collapsible>` | A section that opens with a height animation; heading or own trigger |
| Date picker | `<ui-date-picker>` | Single or range, min/max, unavailable dates, day/month/year views; ↑/↓ in the input step a day (⇧ a week), starting from today; separators typed for you; a typed date it can't take stays, marked invalid with the reason (`invalidchange`); `inline` calendar, unframed for a card or popover |
| Date range filter | `<ui-date-range-filter>` | A button opening preset ranges (last 30 days, last quarter…) beside a range calendar; binds `[from, to]`; pick presets by key or add your own |
| Event calendar | `<ui-event-calendar>` | Events by the hour over a day, a few days or a week, optionally a column per resource (in the views you choose, `resourceViews`): select to book, drag or keyboard to move and resize, all-day strip with folding, availability shading and refusals, pinned placing, right-click menus, extra rows, sticky headers in a fixed height; `eventTag`/`resourceTag` for custom content; bindable date, view and pinned |
| Native select | `<ui-native-select>` | The browser's own `<select>` styled like the inputs: groups, a placeholder, the items' own values, field wiring |
| Swatch picker | `<ui-swatch-picker>` | A colour from swatches (Tailwind's by name, or your own), arrow keys like radios; inline or in a popover field |
| Select | `<ui-select>` | One component for every pick: a button, or with `searchable` an input that filters; async `load` for server search; `oncreate` to add items; `multiple` with ticks or `tags`, `hideSelected`, `deselectable`, `clearable`; `itemTag` for custom options, `valueTag` for the chosen item in the box and `startTag` before it (a colour's dot, an avatar); Enter picks a run, Backspace removes the last pick; hidden `<select>` for plain forms; `size='sm'` |
| Input | `<ui-input>` | Text input with icon, prefix/suffix text or slots, `round` for a pill, `size='sm'`; slot a textarea to replace it |
| Time input | `<ui-time-input>` | A time of day as 'HH:mm' (or null), with `step` in minutes, `min`/`max`; the browser's own picker |
| Number input | `<ui-number-input>` | +/- buttons, arrow/Shift stepping, clamping, locale formatting (`formatOptions`); emits a number |
| Password input | `<ui-password-input>` | Show/hide button; `ui-field type='password'` renders one |
| Pin input | `<ui-pin-input>` | One box per character for codes; emits `complete` when filled |
| Slider | `<ui-slider>` | Single or range (array value), marks, formatted value |
| Tags input | `<ui-tags-input>` | Free-form tags: add with Enter or comma, edit, remove |
| File upload | `<ui-file-upload>` | Dropzone and file list with previews and rejections |
| Attachments | `<ui-attachments>` | Files on a page or form, as tiles (`columns` per row) or a list: image thumbnails with a large preview, file icons, download, remove, an add tile and drag and drop, limits (`accept`, `maxFiles`, `maxFileSize`); takes Files too; bindable; `label` and field wiring, read only when `disabled`; a grid/list switch (`switchable`, remembered with `persist`); posts with plain forms (`name`, `keptName`) |
| Editor | `<ui-editor>` | Rich text on TipTap: HTML value (bindable), configurable toolbar (marks, headings, lists, quote, link popover, undo), placeholder, character limit, images via `uploadImage` (a URL, or attributes incl. `data-*` kept on the `<img>`) |
| Textarea | `<ui-textarea>` | Grows with its content from `rows` to `maxRows` |
| Editable | `<ui-editable>` | Text you click to edit in place: Enter or leaving saves, Escape cancels; ✓/✕ and pencil buttons; emits `change` once saved |
| Checkbox | `<ui-checkbox>` | Checked, unchecked or indeterminate; binds `checked`; `labelHidden` for a label only assistive tech hears |
| Checkbox group | `<ui-checkbox-group>` | Checkboxes for a list of items, bound to an array; optional select-all; Shift-click fills a range; `cards` (icon, description) or `chips` |
| Radio group | `<ui-radio-group>` | One of a list of options, with optional descriptions; `cards` (with an icon) |
| Switch | `<ui-switch>` | On/off toggle; binds `checked` |
| Segmented | `<ui-segmented>` | Pill of options with a sliding indicator; arrow keys move the selection; icons, `iconOnly` (with tooltips) |
| Theme toggle | `<ui-theme-toggle>` | Light, dark and system as icons with tooltips, a menu or a single toggle button (also just on phones), driving `colorScheme` (saved, follows the OS) |
| Appearance | `<ui-appearance>` | One button opening light and dark, the accent colour and the sidebar style, driving `colorScheme` and `appearance` (saved); the choices on offer are yours, and a dev mode tries every one |
| Tooltip | `<ui-tooltip>` | Hover/focus hint on any element, with arrow and placement |
| Popover | `<ui-popover>` | Floating panel from a trigger, with heading, close button, optional arrow; sized by its content up to 18rem, or exactly with `$ui-popover-width`; `flush` for content that sizes itself; binds `open` |
| Hover card | `<ui-hover-card>` | Rich preview while hovering or focusing a trigger; stays open over the card |
| Dialog | `<ui-dialog>` | Modal rendered at the end of `<body>`: focus trap, scroll lock, heading, footer slot; binds `open`; `exitcomplete` once it has animated out |
| Confirm | `confirm(options)` | Await a yes or no from anywhere: danger, type-to-confirm, async `onConfirm` (the button spins; errors show in the dialog), queued calls |
| Sheet | `<ui-sheet>` | Panel sliding in from any edge (`side`), sized sm/md/lg; a modal dialog underneath, with scrolling body and pinned footer |
| Action bar | `<ui-action-bar>` | Floating toolbar at the bottom while something is selected: count, actions, close; not modal |
| Menu | `<ui-menu>` | Dropdown of actions with icons, shortcuts, a label, groups, separators and nested submenus, links and checkbox/radio items (ticked after the label; `indicator='start'` puts the mark before it), from `items` or child tags (`ui-menu-item`, `ui-menu-group`, `ui-menu-separator`, `ui-submenu`, `ui-menu-checkbox`, `ui-menu-radio-group`); emits `select` and `change` |
| Context menu | `<ui-context-menu>` | ui-menu opened by right-click or long-press on its area, at the pointer |
| Toast | `<ui-toaster>` + `toaster` | Notifications stacked in a corner: success/error/warning/info/loading, actions, pause on hover |
| Tabs | `<ui-tabs>` + `<ui-tab>` | Panels with a tab list built from their labels; line or pills |
| Accordion | `<ui-accordion>` + `<ui-accordion-item>` | Expandable sections, single or multiple open |
| Field | `<ui-field>` | Label, hint and error around any control, wired up with aria attributes |
| Fields | `<ui-fields>` | 12-column grid of fields that stacks when narrower than `stackBelow`; with `legend` or `disabled` a real `<fieldset>` |
| Breadcrumbs | `<ui-breadcrumbs>` (+ `<ui-breadcrumb>`) | Trail from `items` or markup; icons, custom separator; middle crumbs fold into a … popover past `max` or when they don't fit |
| Command menu | `<ui-command>` | ⌘K search box over commands: groups, icons, shortcuts, keywords, links (`href`), async `load` (server results listed after the commands, which filter as you type), accents ignored; emits `select`. `<ui-command-trigger>` is a search box that opens it, showing its shortcut |
| App shell | `<ui-app-shell>` + `<ui-sidebar>`, `<ui-nav-section>`, `<ui-nav-item>`, `<ui-nav-group>`, `<ui-sidebar-user>`, `<ui-topbar>`, `<ui-page>` | App layout: sidebar that collapses to an icon rail (⌘B, persisted) and becomes a drawer on phones, sticky top bar, page header |

## Install

The package ships Imba source, so the consuming app compiles it. That works with
the Vite plugin from `@milktop/inertia-imba`. Install a tagged version from
GitHub (see the [releases](https://github.com/milktop/imba-ui/tags)):

```sh
npm install github:milktop/imba-ui#v0.24.1
# or, while developing locally
npm install file:../../imba/ui
```

To upgrade, install the newer tag. Until 1.0, a minor version (0.2) may
change props or markup; patch versions (0.1.1) only fix things.

Keep Vite's dependency optimiser away from the `.imba` source:

```js
// vite.config.js
export default defineConfig({
  optimizeDeps: { exclude: ['@milktop/imba-ui'] },
})
```

## Use

Import each component you use (or everything at once, with
`import '@milktop/imba-ui'`), once, e.g. in the app's entry:

```imba
import '@milktop/imba-ui/date-picker'
import '@milktop/imba-ui/select'

<ui-date-picker label='Lesson date' bind=lesson.date>
<ui-select label='Subject' items=subjects labelKey='name' valueKey='id' searchable bind=subjectId>
```

Values work three ways, all two-way:

- `bind=model.field` (Imba binds custom tags through `data`, which aliases `value`)
- `bind:value=model.field`
- `value=x @change=(x = e.detail)`

Values are plain: ISO dates from the date picker, and the items' own values
(numeric ids stay numbers) from select. Changing the value from
outside updates the component without emitting `change`, as with native inputs;
only user changes emit it. Number input and slider also emit `input` (the value
in `e.detail`) on every change before it's committed: each step, keystroke or
drag, where `change` waits for blur, Enter or the end of the drag. With async `load`, an outside value only shows a
label once its item is among the loaded results.

## Forms

`ui-fields` lays fields out on a 12-column grid; each `ui-field` spans `span`
columns (default 12) and every field goes full width when the grid is narrower
than `stackBelow` (480px by default; it measures the grid, not the viewport, so
it works in dialogs and sidebars too). Lower it (`<ui-fields stackBelow=320>`)
for a form in a popover that should keep its columns, or set 0 to never stack.
Give such a form (or its popover) a width: a grid sized by its own content
narrows once stacked, so it stays stacked.

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
name (see Icons, under Theming). For anything else before or after the input, use the slots:

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
		<ui-sidebar-user slot='footer' name='Ada Lovelace' description='ada@example.com' @select=account(e.detail)>
			<ui-menu-item value='profile' icon='lucide:user'> "Profile"
			<ui-menu-item value='logout' icon='lucide:log-out'> "Log out"
	<ui-topbar>
		"Search…"
	<ui-page heading='Students' description='12 active'>
		<ui-button slot='actions'> "Add student"
		…
```

- The sidebar collapses to an icon rail with its button or ⌘/Ctrl+B. In the
  rail, a click anywhere along its right edge expands it again (`edge=true`
  keeps that strip when expanded too, `edge=false` drops it). Labels
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
  It's a ui-menu with the user as its trigger: its content takes ui-menu's
  child tags (submenus, checkbox and radio items too), or give it `items`.
- `ui-sidebar accordion` keeps one nav group open at a time, and
  `ui-nav-section collapsible` adds a collapse/expand-all button to a section.
- On wide screens an `inset` shell fills the viewport and only the page
  scrolls, so the frame round it stays put; `scroll='page'` does the same
  without `inset` (the default, 'window', scrolls the whole window). Phones
  scroll the window either way. The page then takes focus, so Space and the
  arrow keys scroll it straight away, prints in full, and is marked
  `scroll-region` for Inertia's scroll resets. Listen for scrolling on the
  shell's `scroller` (the page, or the document's scrolling element).
- `ui-page` takes `width` ('narrow', 'default', 'wide' or 'full'), `align`
  ('center' or 'start') and
  `breadcrumbs` and `actions` slots.
- Size the sidebar with `$ui-sidebar-width` and `$ui-sidebar-rail-width`,
  and its items with `$ui-sidebar-item-height`, `-item-padding`,
  `-item-radius` and `-item-text`.
- Style the current page's item (and hovers) with `$ui-sidebar-active`,
  `$ui-sidebar-active-text` and friends (the `-inset-` ones in an `inset`
  layout); see Theming. Set them on `:root` for the whole app, or on
  `ui-sidebar` from your own component's CSS for just that sidebar; either
  way, no `@important` or `>>>` needed:

  ```imba
  css ui-sidebar
  	$ui-sidebar-item-height:2.5rem
  	$ui-sidebar-item-text:$ui-text
  	$ui-sidebar-active:$ui-accent-soft
  ```
- `inset` layers it: a grey sidebar, a white frame (the top bar and a gap
  round the page), the page as a rounded grey panel, and white cards on it.
- The main area sits on `$ui-canvas`, so cards and tables on `$ui-surface`
  stand out; the inset layout's sidebar uses `$ui-sidebar-bg` (a lighter shade
  of the canvas) and its frame `$ui-frame`. In dark mode the frame is darkest
  and cards lightest. Override any of them, or set `$ui-canvas` to
  `$ui-surface` for an all-white app.

## Command menu

`ui-command` is a ⌘K menu: a search box over a list of commands, filtered as
you type (every word must appear in the label, description, group or
`keywords`).

```imba
<ui-command items=commands @select=run(e.detail)>
	<ui-command-trigger slot='trigger'>

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
- `ui-command-trigger` is a search box for the `trigger` slot: a `field`
  button with a search icon, "Search…" (or your own text) and the menu's
  shortcut, hidden on small screens. It takes `icon`, `variant`, `size` and
  `shortcut` (null for none). It's a real `<button is='ui-command-trigger'>`,
  so style it by class rather than by tag name.

## Locale and words

Dates, numbers and every word a component shows or reads out (placeholders,
empty states, screen-reader labels, Zag's own) follow one app-wide setting.
English and French are built in; until it's set, the browser's locale is used.

```imba
import { uiLocale } from '@milktop/imba-ui/locale'

uiLocale.set('fr-FR')
# Change a few words, keeping the rest
uiLocale.set('en-GB', { table: { empty: 'No pupils yet' }, select: { placeholder: 'Choose…' } })
```

For another language, pass the whole list (start from `en`, exported from the
same module). Text given to a component (`placeholder`, `emptyText`, `label`)
wins over the list, and a component's own `locale` prop over the app's.
`formatNumber`, `formatBytes` and `formatRelative` (and their tags) use the
same locale.

## Theming

Styled components read `$ui-*` tokens, set in `src/theme.imba`. They're
ordinary CSS custom properties (`$ui-accent` is `--ui-accent`), so you can set
them from Imba CSS or plain CSS, for the whole app or for part of it. The
playground's **Theming** page shows each way to restyle (the whole app, part
of a page, one component, its parts, every instance, your own look) and builds
an override snippet from a colour you pick; **Tokens** lists every token with
what it styles and its light and dark values.

| Tokens | What they style |
| --- | --- |
| `$ui-text`, `$ui-muted` | Text, and secondary text (hints, labels) |
| `$ui-surface`, `$ui-border`, `$ui-hover` | Cards and popups; their borders; hovered rows and items |
| `$ui-field-bg`, `$ui-field-border`, `$ui-field-border-hover` | Form controls (inputs, selects, checkboxes, the editor): fill, border, border on hover. Light, they follow `$ui-surface` and `$ui-border`; dark, a darker fill and a stronger border |
| `$ui-field-autofill-bg` | Text inputs the browser autofilled: a faint accent tint in place of the browser's own colour. Set it to `$ui-field-bg` for no tint |
| `$ui-canvas`, `$ui-sidebar-bg`, `$ui-frame` | The app shell: the page behind cards, the sidebar, the frame round an inset layout |
| `$ui-accent-50` … `$ui-accent-950`, `$ui-accent-500-text` | The accent as a scale, which the accent and ring tokens are steps of (light: 600, 100, 800, 500; dark: 500, 900, 200, 400), and the text on its 500. Set the scale to recolour them all, in both modes |
| `$ui-accent`, `$ui-accent-text` | Primary buttons, selections, checked controls; text on them |
| `$ui-accent-soft`, `$ui-accent-soft-text` | Soft buttons, accent badges, highlighted items |
| `$ui-ring`, `$ui-ring-soft` | Focus rings and outlines |
| `$ui-selection`, `$ui-highlight` | Selected text; ui-highlight's marks (both a tint of the accent) |
| `$ui-danger`, `$ui-success`, `$ui-warning` | Errors and destructive actions; positive changes; cautions (alerts tint themselves from these and `$ui-accent`) |
| `$ui-chart-1` … `$ui-chart-5` | Chart series, in order (the first follows the accent) |
| `$ui-skeleton` | Loading placeholders |
| `$ui-radius` | Corner rounding (cards and popups add a little to it) |
| `$ui-font` | The components' font (`inherit` by default, so they use the app's) |
| `$ui-control-height`, `-sm`, `-lg` | Buttons and inputs share these, so they line up in a row |
| `$ui-icon-stroke` | Line weight of stroke icons such as Lucide's (`2`, in their 24-unit grid; try `1.5` or `2.5`) |
| `$ui-shadow`, `$ui-card-shadow` | Popups; cards at rest |
| `$ui-sidebar-width`, `$ui-sidebar-rail-width` | ui-app-shell's sidebar, open and collapsed |
| `$ui-sidebar-surface`, `-heading`, `-icon`, `-hover-text` | The sidebar's background (outside the inset layout), section headings, its own icon buttons, and hovered text |
| `$ui-sidebar-text`, `-muted`, `-border`, `-divider` | The sidebar's other text (the logo, ui-sidebar-user) and its muted text, its edge and nested groups' rule, and the line above its footer: for a coloured sidebar |
| `$ui-sidebar-item-height`, `-item-padding`, `-item-radius`, `-item-text` | Sidebar items and group toggles: size, shape and resting text colour |
| `$ui-sidebar-hover`, `$ui-sidebar-active`, `-active-text`, `-active-icon`, `-active-weight`, `-active-shadow` | Sidebar items: hovered, and the current page (its icon follows its text unless set) |
| `$ui-sidebar-inset-hover`, `-inset-active`, `-inset-active-shadow` | The same in an `inset` layout (white items on the grey sidebar) |

### Dark mode

Dark values apply under `html.dark` (or `[data-theme=dark]`). Put a
`<ui-theme-toggle>` anywhere to let people choose, or set it from code:

```imba
import { colorScheme } from '@milktop/imba-ui/color-scheme'

colorScheme.value = 'dark'        # 'light', 'dark' or 'system' (the default)
colorScheme.dark                  # whether dark is showing now
colorScheme.listen do(scheme, dark) console.log(scheme, dark)
```

Read it in `render` like any other state: every change re-renders the page,
including the OS switching and other tabs. `listen` is for code that doesn't
render.

It toggles `dark` and `color-scheme` on `<html>`, follows the OS setting in
`system`, and saves the choice in localStorage under `ui-color-scheme` (set
`colorScheme.storageKey` first to change it). Your bundle loads after the
first paint, so to avoid a flash of light on dark pages, apply the saved choice
in the `<head>`:

```html
<script>
  try {
    var s = localStorage.getItem('ui-color-scheme') || 'system'
    var d = s === 'dark' || (s === 'system' && matchMedia('(prefers-color-scheme: dark)').matches)
    document.documentElement.classList.toggle('dark', d)
    document.documentElement.style.colorScheme = d ? 'dark' : 'light'
  } catch (e) {}
</script>
```

### Accent and sidebar style

`appearance` holds the accent colour and the sidebar style, saved like
`colorScheme`. `<ui-appearance>` lets people choose them, with light and dark,
behind one button:

```imba
<ui-appearance accents=['teal', 'blue', 'violet'] sidebars=['neutral', 'tint', 'dark']>
```

`accents` and `sidebars` are what users may choose (every one if left out), the
default first: a saved choice outside them moves to it. While building the app,
add `dev`: it offers every accent and sidebar style, any colour, a reset, and
the props to paste for the current choice, and its switch previews what users
get. Take it off before shipping.

The accents are Tailwind's scales (`slate`, `blue`, `indigo`, `violet`, `teal`,
`emerald`, `rose`), each 600 taking white text; a custom hex colour gets its
scale worked out in the browser. The sidebar styles are light-mode only:

| Style | The sidebar | The current page |
| --- | --- | --- |
| `default` | As the theme has it | As the theme has it |
| `neutral` | Grey | A darker grey, its icon in the accent |
| `soft` | Grey | The accent's soft tint |
| `tint` | The accent's lightest tint | A deeper tint, its text in the accent |
| `accent` | The accent (600), white text | A translucent white, a stronger hover |
| `dark` | The accent's 900, white text | A translucent white, a stronger hover |
| `deep` | The accent's 950, white text | A translucent white, a stronger hover |

Set them from code too, for example from a user's saved preference:

```imba
import { appearance } from '@milktop/imba-ui/appearance'

appearance.defaults = { accent: 'teal', sidebar: 'neutral' }   # before anything is saved, and for reset
appearance.update accent: 'violet', sidebar: 'dark'
appearance.load(user.appearance)                # apply a saved one
appearance.onchange = do(value) save(value)     # { accent, custom, sidebar }
```

It sets the `$ui-accent-50` … `-950` scale on `<html>` and the style as
`data-ui-sidebar-style`, and saves both under `ui-appearance` (set
`appearance.storageKey` first to change it), scale included, so the `<head>`
can paint them before your bundle loads, next to the dark mode script:

```html
<script>
  try {
    var a = JSON.parse(localStorage.getItem('ui-appearance') || '{}'), r = document.documentElement
    if (a.sidebar && a.sidebar !== 'default') r.dataset.uiSidebarStyle = a.sidebar
    var steps = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950]
    if (a.scale) steps.forEach(function (s, i) { r.style.setProperty('--ui-accent-' + s, a.scale[i]) })
    if (a.scaleText) r.style.setProperty('--ui-accent-500-text', a.scaleText)
  } catch (e) {}
</script>
```

### Brand the app

Set tokens in your app's root CSS. An accent comes with four companions:
a soft tint, text for on the tint, and the focus ring. `color-mix` can derive
them from one colour:

```imba
global css
	@root
		$ui-accent:#e11d48
		$ui-accent-soft:color-mix(in srgb, $ui-accent 15%, white)
		$ui-accent-soft-text:color-mix(in srgb, $ui-accent 70%, black)
		$ui-ring:$ui-accent
		$ui-ring-soft:color-mix(in srgb, $ui-accent 25%, transparent)
		$ui-radius:10px
		$ui-font:'Inter Variable', system-ui, sans-serif
	html.dark, [data-theme=dark]
		$ui-accent-soft:color-mix(in srgb, $ui-accent 30%, black)
		$ui-accent-soft-text:color-mix(in srgb, $ui-accent 35%, white)
```

**Set dark values too.** Dark mode applies under `html.dark` or
`[data-theme=dark]`, and the library's own dark values there are more specific
than `@root`. So a colour you only set in `@root` is replaced by the library's in
dark mode. Override it in both places, as above. Radius, font and sizes aren't
redefined for dark mode, so `@root` alone is enough for them. Your `html.dark`
rules match the library's exactly, so the later one wins: import the
components before your own styles.

Or map the tokens onto a design system you already have:

```imba
global css @root
	$ui-accent:$brand $ui-surface:$card $ui-border:$line $ui-font:$body-font
```

### Theme part of a page

Set tokens on any element and they apply to everything inside it, which is
useful for a differently branded section or a denser admin panel:

```imba
css .billing $ui-accent:#059669 $ui-accent-soft:#d1fae5 $ui-accent-soft-text:#065f46
css .dense $ui-control-height:2rem $ui-radius:4px
```

One catch: a token derived with `color-mix` at `@root` is resolved there.
Redefine the derived ones alongside the accent wherever you scope it, as above.

### Beyond tokens

- One instance: put a `css` block inside it and reach its parts with `>>>`.
  It applies to that element only, and Imba ranks it alongside the
  library's own styles, so no `@important`:

  ```imba
  <ui-date-picker>
  	css >>> .prev, >>> .next c:pink6 bg:pink1 rd:full
  		@hover bg:pink2
  ```

  Every part has a class (each component's Props panel in the playground
  lists them) and Zag's parts have `data-part` and state attributes too.
  Styles on a part also beat its library states (hover, active), so restate
  the ones you care about. Some components expose their own variables
  (ui-button's `$ui-button-count-bg`); each component page's Styling panel
  lists the tokens, variables and parts it uses.
- A different look altogether: subclass the headless tag (next section).

### Icons

Components show [Iconify](https://iconify.design) icons through the
`iconify-icon` element, which comes with the package. Pass any Iconify name
(`icon='lucide:calendar'`). Icons load on demand from the Iconify API, so a
strict Content Security Policy needs to allow `https://api.iconify.design`.
Offline apps can register icon sets locally (see `iconify-icon`'s docs).
`$ui-icon-stroke` sets the weight of stroke icons (Lucide's are drawn at `2`),
for the whole app or one part of it: `css .toolbar $ui-icon-stroke:2.5`.

## Headless use and custom styles

Every component is two tags:

- `ui-<name>-base` (`@milktop/imba-ui/<name>/base`): behaviour and markup, no styles
- `ui-<name>` (`@milktop/imba-ui/<name>`): the base plus the default theme

The base tags stay unstyled even when the styled library is loaded, so both
can share a page. Base tags that contain other components render their base
tags (ui-avatar-base's tooltip is ui-tooltip-base) and name each one in a field
(`tooltipTag`, `popoverTag`, `menuTag`, …): set one in a subclass to use a
styled tag or your own there. The playground's Headless page shows them side by
side.

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

Parts rendered by child tags (a menu's items, a radio group's radios) need
`>>>` to be reached from the subclass's CSS:

```imba
import '@milktop/imba-ui/menu/base'

tag ink-menu < ui-menu-base
	css
		>>> [data-part=content] p:1 bg:$ui-text c:$ui-surface
		>>> .item px:2 py:1
			&[data-highlighted] bg:$ui-surface c:$ui-text
```

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
- **Swap collections after the transition.** Changing a searchable select's collection
  inside `onInputValueChange` runs Zag's watchers from the wrong state. Defer
  the change to a microtask, as a framework re-render would.
- **One tag over two machines.** `ui-select` renders `ui-list-select` (Zag's
  select) or `ui-search-select` (Zag's combobox) and passes its props on; the
  inner one's `change` bubbles through, after updating the outer value (and
  with it a `bind=`). Keep the props of the three in step.
- **Use `globalThis.queueMicrotask`.** Inside a tag or class, Imba compiles
  a bare `queueMicrotask` to `self.queueMicrotask`.
- **Stop native `change` events.** Inner inputs' native `change` events bubble
  to the host and clash with the component's own `change`, so use `@change.stop`.
- **Popup z-index goes on the positioner.** Zag sets `z-index: var(--z-index)`
  on it inline and copies the content's z-index into `--z-index`, but not
  reliably, and an unset variable leaves the positioner at `auto`. Set both
  in CSS: `.positioner zi:50 --z-index:50`.
- **Prop names.** Avoid native attribute names such as `dir`, `hidden` and `title` as prop names.

## Develop

The playground also has **Blocks** in `playground/blocks/`, each with its
source a click away, to copy as a starting point:

- **Sections**: page headings, card panels, stacked lists, form layouts,
  feeds and banners, a few variants each
- **Pages**: a dashboard, profile, detail page (main and aside), table page,
  settings, sign in and empty
  states, composed from them

```sh
npm install
npm run dev   # playground
```

## Deploy the playground

`npm run build` writes a static, client-side site to `playground/dist`, which
any static host can serve. It's on **Cloudflare Pages** at
https://imba-ui.pages.dev:

1. **Workers & Pages → Create**, then the Pages option ("Looking to deploy
   Pages? Get started") → **Import an existing Git repository**, and pick
   this one.
2. Framework preset None; build command `npm run build`; build output
   directory `playground/dist`. `.nvmrc` sets Node 22.
3. Deploy. Every push to `main` redeploys; other branches get preview URLs.
   For a custom subdomain, use **Custom domains** in the project and add the
   CNAME it asks for at your DNS host (`ui  CNAME  imba-ui.pages.dev`).

Pages needs no config file: with no top-level `404.html` it serves
`index.html` for unknown paths, which the playground's router needs. The site
is public but kept out of search results: a `noindex` meta tag in
`index.html`, and an `X-Robots-Tag` header on every file from
`playground/public/_headers`. To make it private instead, turn on
**Cloudflare Access** for the project, and add a login method under Zero
Trust → Settings → Authentication (One-time PIN needs no setup); free for up
to 50 users.

Elsewhere (e.g. Netlify), add an SPA fallback: a `playground/public/_redirects`
file containing `/* /index.html 200`.
