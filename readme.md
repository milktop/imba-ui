# @milktop/imba-ui

Imba components built on [Zag](https://zagjs.com) state machines. Zag handles
state, keyboard navigation, focus, ARIA, positioning and dismissal; this
package adds Imba markup and an optional theme.

**Playground:** https://imba-ui.pages.dev, with every component, its props and
code, and some composed screens (blocks).

| Component | Tag | Notes |
| --- | --- | --- |
| Button | `<ui-button>` | A real `<button>`: variants, sizes, Iconify icons, icon-only (square, or `round`), loading, a `count` badge or `dot` |
| Copy button | `<ui-copy-button>` | Copies a value, shows a tick; fits an input's suffix slot |
| Avatar | `<ui-avatar>` | Image with initials (or icon) fallback, sizes, circle or square |
| Badge | `<ui-badge>` | Status labels: neutral, accent, success, warning, danger, outline |
| Card | `<ui-card>` | Surface with heading, description, actions and footer slots; `flush` for edge-to-edge content |
| Data list | `<ui-data-list>` (+ `<ui-data-item>`) | Labels and values as a `<dl>`: beside or above, plain/divided/card, grid columns, info tooltips |
| Stat | `<ui-stat>`, `<ui-stats>` | Headline numbers with unit, coloured change, help and icon; grids that are plain, cards or one divided card |
| Charts | `<ui-area-chart>`, `<ui-bar-chart>`, `<ui-sparkline>` | SVG drawn by Imba with d3 for the maths: one or more series, stacked or not, tooltips, legends, theme colours (`$ui-chart-1…5`) |
| Timeline | `<ui-timeline>` (+ `<ui-timeline-item>`) | Events down a line with icon or dot markers, colours, times; line or cards |
| Table | `<ui-table>` | Rows by `columns`: sortable headings, row selection with select-all and Shift-click ranges, custom cell tags, formats, loading/empty states, sticky header, sizes sm/md/lg, `flush` inside cards; or style a `<table>` written inside |
| Pagination | `<ui-pagination>` | Previous/next, page numbers with ellipses and first/last once pages are hidden, optional "Showing 11–20 of 95 items" summary (`noun` renames them); binds `page` |
| Alert | `<ui-alert>` | In-page message: info, success, warning, danger; actions, dismissible |
| Banner | `<ui-banner>` | Slim announcement strip: accent, soft, neutral, success, warning, danger; icon, actions, dismissible, edge to edge |
| Skeleton | `<ui-skeleton>` | Loading placeholders: blocks, circles, text lines |
| Spinner | `<ui-spinner>` | Small loading indicator with an accessible label |
| Empty state | `<ui-empty-state>` | Icon, heading, description and actions for empty views |
| Progress | `<ui-progress>` | Bar or circle, determinate or indeterminate, formatted value |
| Collapsible | `<ui-collapsible>` | A section that opens with a height animation; heading or own trigger |
| Date picker | `<ui-date-picker>` | Single or range, min/max, unavailable dates, day/month/year views; ↑/↓ in the input step a day (⇧ a week), starting from today |
| Select | `<ui-select>` | Single or multiple, typeahead, optional hidden `<select>` for plain forms; `size='sm'` |
| Combobox | `<ui-combobox>` | Filtering, multiple selection with tags, async `load` for server search |
| Input | `<ui-input>` | Text input with icon, prefix/suffix text or slots, `round` for a pill, `size='sm'`; slot a textarea to replace it |
| Number input | `<ui-number-input>` | +/- buttons, arrow/Shift stepping, clamping, locale formatting (`formatOptions`); emits a number |
| Password input | `<ui-password-input>` | Show/hide button; `ui-field type='password'` renders one |
| Pin input | `<ui-pin-input>` | One box per character for codes; emits `complete` when filled |
| Slider | `<ui-slider>` | Single or range (array value), marks, formatted value |
| Tags input | `<ui-tags-input>` | Free-form tags: add with Enter or comma, edit, remove |
| File upload | `<ui-file-upload>` | Dropzone and file list with previews and rejections |
| Attachments | `<ui-attachments>` | Files on a page or form, as tiles (`columns` per row) or a list: image thumbnails with a large preview, file icons, download, remove, an add tile and drag and drop, limits (`accept`, `maxFiles`, `maxFileSize`); takes Files too; bindable |
| Editor | `<ui-editor>` | Rich text on TipTap: HTML value (bindable), configurable toolbar (marks, headings, lists, quote, link popover, undo), placeholder, character limit, images via `uploadImage` (a URL, or attributes incl. `data-*` kept on the `<img>`) |
| Textarea | `<ui-textarea>` | Grows with its content from `rows` to `maxRows` |
| Checkbox | `<ui-checkbox>` | Checked, unchecked or indeterminate; binds `checked`; `labelHidden` for a label only assistive tech hears |
| Checkbox group | `<ui-checkbox-group>` | Checkboxes for a list of items, bound to an array; optional select-all; Shift-click fills a range |
| Radio group | `<ui-radio-group>` | One of a list of options, with optional descriptions |
| Switch | `<ui-switch>` | On/off toggle; binds `checked` |
| Segmented | `<ui-segmented>` | Pill of options with a sliding indicator; arrow keys move the selection; icons, `iconOnly` (with tooltips) |
| Theme toggle | `<ui-theme-toggle>` | Light, dark and system as icons with tooltips, driving `colorScheme` (saved, follows the OS) |
| Tooltip | `<ui-tooltip>` | Hover/focus hint on any element, with arrow and placement |
| Popover | `<ui-popover>` | Floating panel from a trigger, with heading, close button, optional arrow; binds `open` |
| Hover card | `<ui-hover-card>` | Rich preview while hovering or focusing a trigger; stays open over the card |
| Dialog | `<ui-dialog>` | Modal rendered at the end of `<body>`: focus trap, scroll lock, heading, footer slot; binds `open` |
| Sheet | `<ui-sheet>` | Panel sliding in from any edge (`side`), sized sm/md/lg; a modal dialog underneath, with scrolling body and pinned footer |
| Action bar | `<ui-action-bar>` | Floating toolbar at the bottom while something is selected: count, actions, close; not modal |
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
the Vite plugin from `@milktop/inertia-imba`. Install a tagged version from
GitHub (see the [releases](https://github.com/milktop/imba-ui/tags)):

```sh
npm install github:milktop/imba-ui#v0.3.2
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
		<ui-sidebar-user slot='footer' name='Ada Lovelace' description='ada@example.com'
			items=[{ label: 'Profile', value: 'profile' }, { label: 'Log out', value: 'logout' }]
			@select=account(e.detail)>
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
- `ui-sidebar accordion` keeps one nav group open at a time, and
  `ui-nav-section collapsible` adds a collapse/expand-all button to a section.
- `ui-page` takes `width` ('narrow', 'default', 'wide' or 'full'), `align`
  ('center' or 'start') and
  `breadcrumbs` and `actions` slots.
- Size the sidebar with `$ui-sidebar-width` and `$ui-sidebar-rail-width`.
- `inset` layers it: a grey sidebar, a white frame (the top bar and a gap
  round the page), the page as a rounded grey panel, and white cards on it.
  The sidebar's hover and active colours come from `--ui-sidebar-hover`,
  `--ui-sidebar-active` (and `--ui-sidebar-active-shadow`).
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

Styled components read `$ui-*` tokens, set in `src/theme.imba`. They're
ordinary CSS custom properties (`$ui-accent` is `--ui-accent`), so you can set
them from Imba CSS or plain CSS, for the whole app or for part of it. The
playground's **Theming** page lists every token with its light and dark
default, and builds an override snippet from a colour you pick.

| Tokens | What they style |
| --- | --- |
| `$ui-text`, `$ui-muted` | Text, and secondary text (hints, labels) |
| `$ui-surface`, `$ui-border`, `$ui-hover` | Cards, inputs and popups; their borders; hovered rows and items |
| `$ui-canvas`, `$ui-sidebar-bg`, `$ui-frame` | The app shell: the page behind cards, the sidebar, the frame round an inset layout |
| `$ui-accent`, `$ui-accent-text` | Primary buttons, selections, checked controls; text on them |
| `$ui-accent-soft`, `$ui-accent-soft-text` | Soft buttons, accent badges, highlighted items |
| `$ui-ring`, `$ui-ring-soft` | Focus rings and outlines |
| `$ui-danger`, `$ui-success` | Errors and destructive actions; positive changes |
| `$ui-chart-1` … `$ui-chart-5` | Chart series, in order (the first follows the accent) |
| `$ui-skeleton` | Loading placeholders |
| `$ui-radius` | Corner rounding (cards and popups add a little to it) |
| `$ui-font` | The components' font (`inherit` by default, so they use the app's) |
| `$ui-control-height`, `-sm`, `-lg` | Buttons and inputs share these, so they line up in a row |
| `$ui-shadow`, `$ui-card-shadow` | Popups; cards at rest |
| `$ui-sidebar-width`, `$ui-sidebar-rail-width` | ui-app-shell's sidebar, open and collapsed |

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

- One component's look: style its parts from your CSS. Parts have classes
  (`.badge`, `.control`, `.item`) and Zag's `data-part` and state attributes,
  e.g. `ui-button .badge`. Some components expose their own variables
  (ui-button's `--ui-button-count-bg`).
- A different look altogether: subclass the headless tag (next section).

### Icons

Components show [Iconify](https://iconify.design) icons through the
`iconify-icon` element, which comes with the package. Pass any Iconify name
(`icon='lucide:calendar'`). Icons load on demand from the Iconify API, so a
strict Content Security Policy needs to allow `https://api.iconify.design`.
Offline apps can register icon sets locally (see `iconify-icon`'s docs).

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
