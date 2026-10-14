# Changelog

Until 1.0, a minor version may change props or markup; patch versions only
fix things.

## 0.14.1 (2026-10-14)

- Calmer sidebar styles: `neutral` is grey with the current page's icon in
  the accent (new token `$ui-sidebar-active-icon`), and replaces
  `neutral-accent`, whose name still loads as `neutral`; on `accent`, `dark`
  and `deep` the current page is a stronger version of the hover in
  translucent white rather than a pill from the scale
- A faint line above the sidebar's footer (ui-sidebar-user), like the top
  bar's, from the new `$ui-sidebar-divider` (set it to `transparent` for
  none)

## 0.14.0 (2026-10-14)

To check when upgrading:

- On wide screens an `inset` `ui-app-shell` now scrolls only its page, not
  the window: the sidebar, top bar and the frame round the page stay put.
  Code listening for the window's scroll should listen on the shell's
  `scroller` instead

New:

- `ui-app-shell scroll='page'` scrolls only the page without `inset` too
  ('window', the default, scrolls the window); phones scroll the window
  either way
- A page that scrolls takes focus, so Space, Page Up/Down, Home, End and
  the arrows scroll it with nothing focused; it prints in full, and is
  marked `scroll-region` so Inertia resets and restores its scroll

## 0.13.0 (2026-10-14)

- `ui-appearance`: one button opening light and dark, the accent colour and
  the sidebar style. `accents` and `sidebars` list what users may choose (the
  first is the fallback for a saved choice outside them); `dev` offers every
  one, any colour, a reset and the props to paste for the current choice,
  with a switch to preview what users get
- `appearance` (`@milktop/imba-ui/appearance`): the accent and sidebar style,
  saved like `colorScheme`, with `defaults`, `update`, `load`, `onchange` for
  saving it per user, `restrict` and `storageKey`. Seven Tailwind accents or
  any hex colour; eight light-mode sidebar styles (`default`, `neutral`,
  `neutral-accent`, `soft`, `tint`, `accent`, `dark`, `deep`). The readme has
  the `<head>` script that paints it before the bundle loads
- The accent is a scale, `$ui-accent-50` … `-950` (with `$ui-accent-500-text`),
  and `$ui-accent`, `-soft`, `-soft-text`, `$ui-ring` and `-ring-soft` are
  steps of it, in light and dark: set the scale to recolour them all
- New sidebar tokens for coloured sidebars: `$ui-sidebar-text` (the logo,
  ui-sidebar-user), `-muted` and `-border`

To check when upgrading:

- The default colours are unchanged. Overriding `$ui-accent` and its
  companions still works; setting the scale instead now recolours dark mode
  too
- ui-sidebar-user's text, the sidebar's edge and nested groups' rule now
  read the new sidebar tokens (by default the same colours as before), and
  flyouts in the collapsed rail use the page's text colours, so a sidebar
  coloured through its tokens no longer gives them white text on white

## 0.12.2 (2026-10-13)

- The sidebar goes over the top bar while it's hovered or focused, so its
  tooltips and flyouts near the top (the collapse button's tooltip) are no
  longer hidden under the top bar; the rest of the time the top bar's popups
  stay above it

## 0.12.1 (2026-10-13)

- Autofilled text inputs (input, password, number and tags inputs) no
  longer show the browser's own fill as a patch inside the box: the box
  takes `$ui-field-autofill-bg` (a faint accent tint; set it to
  `$ui-field-bg` for none) and the text stays `$ui-text`

## 0.12.0 (2026-10-13)

To check when upgrading:

- Components with a `locale` prop (date picker, number input, slider,
  progress) now default to `uiLocale.locale`, which is the browser's locale
  until set, rather than 'en-GB': call `uiLocale.set('en-GB')` at startup to
  keep UK dates and numbers for every visitor
- Text props that had English defaults (`emptyText`, `loadingText`,
  `placeholder`, `label`…) now default to null and take uiLocale's words;
  text you pass still wins
- A numeric `ui-stat` value is now formatted (1204 shows as "1,204")
- Selected text takes `$ui-selection` (a tint of the accent)

New:

- `uiLocale` (`@milktop/imba-ui/locale`): the app's locale and the
  components' words in one list, English and French built in, with
  overrides merged over it; Zag's screen-reader labels follow it too
- `ui-event-calendar`: events by the hour (day, n days, work week, week),
  resources as columns, select to book (`slotselect`), drag or keyboard to
  move and resize (`eventchange`), all-day events, `isAvailable` shading and
  refusals, pinned placing, event and slot menus, extra rows, a toolbar with
  views and a date jump; English and French words; dragging near an edge
  scrolls the grid (with a `height`) or the page; `resourceViews` picks the
  views split by resource (others show everyone together, in their colours),
  and `dayHeaderTag` gets the day's `events` and the `resources`
- `ui-sortable-list`: drag (or keyboard) to reorder, with announcements; no
  dependency (react-ui's is on dnd-kit)
- `formatNumber`, `formatBytes`, `formatRelative` and `ui-format-number`,
  `ui-format-bytes`, `ui-format-relative` (kept up to date); charts, stats,
  sliders and attachments format with them

Ported from react-ui:

- New components: `ui-kbd`, `ui-divider`, `ui-prose`, `ui-highlight`,
  `ui-rolling-number`, `ui-native-select`, `ui-time-input`, `ui-editable`,
  `ui-tree-view`, `ui-swatch-picker`, `ui-donut-chart`, and `confirm()`
  (`@milktop/imba-ui/confirm`)
- `ui-badge`: `removable` tags (an ✕ that emits `remove`)
- `ui-avatar`: `status` dot ('online', 'away', 'busy', 'offline' or a colour)
- `ui-radio-group`: `variant='cards'` (with item icons);
  `ui-checkbox-group`: `variant='cards'` or `'chips'`; `ui-checkbox`:
  `description` and `icon`
- `ui-stat`: numbers are formatted (`format`, Intl's options) and can roll
  (`animate`)
- `ui-dialog` emits `exitcomplete` once it has closed and animated out
- `$ui-selection` (selected text) and `$ui-highlight` tokens
- `ui-select`: `valueTag` (the chosen item in the box, and in tags) and
  `startTag` (before the value or search box, given the chosen item)
- `ui-date-picker`: `inline`; typing puts in the locale's separators; a
  typed date it can't take (past min/max, unavailable, not whole) stays,
  marked invalid with the reason and the input's validity, and emits
  `invalidchange`
- `ui-attachments`: `label` and ui-field wiring, `disabled` (read only),
  `switchable` and `persist` (a grid/list switch, remembered),
  `layoutchange`, and `name`/`keptName` for plain form posts
- `ui-fields` is always a `<fieldset>` (no role unless it has a legend or is
  disabled), so toggling `disabled` no longer throws

## 0.11.0 (2026-10-08)

- `ui-alert`: variants tint themselves from `$ui-accent`, `$ui-success`,
  `$ui-warning` or `$ui-danger`, translucent so they read the same on a card
  or the canvas, and follow your theme. In dark mode they're no longer
  near-black, and the message is tinted text instead of grey
- `$ui-warning` token (amber), for cautions

## 0.10.0 (2026-10-08)

- Field tokens: `$ui-field-bg`, `$ui-field-border` and
  `$ui-field-border-hover` style form controls (input, textarea, password,
  number, tags, pin, select, date picker, checkbox, radio, editor). In dark
  mode fields sit a step below the card with a stronger border, so they no
  longer blend into it; light mode is unchanged apart from the hover border
- Form controls darken their border on hover

## 0.9.1 (2026-10-08)

- Popups (menu, popover, tooltip, hover card, select, date picker) keep
  their z-index, so they no longer open under positioned content further
  down the page, such as a `ui-card`

## 0.9.0 (2026-10-08)

- `$ui-icon-stroke` sets the line weight of stroke icons such as Lucide's
  (`2` by default), for the whole app or one part of it; icons keep their
  string names
- Playground: the Theming page has an icon weight control

## 0.8.0 (2026-10-08)

- `ui-tabs`: tabs take a `count` or `dot`, like a button's (with `max`,
  `pulse`, `countColor` and `countLabel`); `counts='corner'` puts them top
  right. The focus ring is drawn inside the tab, so the scrolling list can't
  clip it
- `ui-dialog`, `ui-sheet`: `modal=false` leaves the page usable: no
  backdrop, no focus trap, the page still scrolls and clicking outside
  doesn't close it
- `ui-input`, `ui-select`: `quiet` hides the border and fill until hovered
  or focused (and shows plain text when disabled), for dense editable rows
- `ui-select`: the list is at least as wide as the trigger, and grows to fit
  its options (up to 24rem)
- Sidebar tokens: `$ui-sidebar-surface`, `$ui-sidebar-heading`,
  `$ui-sidebar-icon` and `$ui-sidebar-hover-text`, enough for a coloured
  sidebar
- `ui-button`: an icon with a trailing icon (a menu's chevron) keeps its
  padding instead of turning square
- Playground: the Appearance panel shows its settings as code to paste

## 0.7.2 (2026-10-08)

- `ui-button`: an icon button with a `count` or `dot` and no `aria-label`
  stays square (or round), instead of picking up text padding from its
  screen-reader count

## 0.7.1 (2026-10-07)

- `ui-select` (searchable): emptying the input clears a single pick, so
  select-all and Backspace clears the value. A partial edit (a deleted
  letter, an abandoned search) still reverts to the picked item's label on
  blur, now also when a server search left the list open
- Playground: the version shows beside the logo

## 0.7.0 (2026-10-07)

One `ui-select` for every pick. **`ui-combobox` is removed**: use
`<ui-select searchable>` (and `import '@milktop/imba-ui/select'`); its props
carry over.

- `ui-select`: a button by default, or an input that filters the list with
  `searchable`, `load` (server search) or `oncreate`
- `oncreate`: offers "Create …" for typed text that matches nothing and calls
  it with the text; return the new item (or a promise of it) to select it
- `multiple` with picks ticked in the list, or as `tags` (always tags when
  searchable), styled by `variant`; `hideSelected` takes picks out of the list
- `deselectable`, `closeOnSelect`, `clearable`, `emptyText`
- `itemTag`, `createTag`, `emptyTag`: tags rendering an option (given
  `item`), the create option and the empty state (given `query`)
- Picking several, Enter picks a run (the highlight keeps its place), and
  Backspace removes the last pick
- Search ranks labels starting with the text first; stray text reverts to the
  pick when focus leaves

Also:

- `ui-avatar-group`: avatars in an overlapping stack, ringed in
  `$ui-avatar-ring`, with `max` and a "+N" whose tooltip lists the rest;
  `size`, `spacing`, `color`, `square`, `letters`, `tooltip`
- `ui-card`: `variant` ('elevated', 'outline', 'subtle'), `icon`, `divided`,
  `href` (the whole card a link, lifting on hover) and `size`; the footer sits
  on a faint band, and an empty body no longer adds padding

## 0.6.0 (2026-10-06)

Part names made consistent, so the same job has the same class everywhere.
Renamed (update any app CSS that targets them):

- `ui-toast`, `ui-timeline-item`: `.title` → `.heading`
- `ui-alert`: `.dismiss` → `.close`, `.message` → `.description`
- `ui-banner`: `.message` → `.description`
- `ui-collapsible`, `ui-nav-group`: `.toggle` → `.trigger`
- `ui-nav-group`, `ui-sidebar-user`: `.chevron` → `.indicator`
- `ui-sidebar-user`: `.user` (its button) → `.trigger`
- `ui-accordion-item`: `.content-inner` → `.inner`
- `ui-button`: `.spoken` → `.sr-only`

Also: the playground's Props panel lists each component's parts, and the
readme shows styling one instance's parts with `css >>> .part`.

## 0.5.8 (2026-10-06)

- `ui-sidebar`: tokens for its items' size and resting text,
  `$ui-sidebar-item-height`, `-item-padding`, `-item-radius` and
  `-item-text` (used by `ui-nav-item` and `ui-nav-group`'s toggle). Like the
  colour tokens, they can be set on `ui-sidebar` from an app component to
  restyle just that sidebar, without `@important`

## 0.5.7 (2026-10-06)

- `ui-sidebar`: theme tokens for its items, so the current page (aria-current)
  and hovers can be restyled without fighting specificity:
  `$ui-sidebar-hover`, `$ui-sidebar-active`, `-active-text`,
  `-active-weight`, `-active-shadow`, and `$ui-sidebar-inset-hover`,
  `-inset-active`, `-inset-active-shadow` for the inset layout. The inset
  layout no longer sets `--ui-sidebar-active` on the sidebar (set
  `$ui-sidebar-inset-active` instead)

## 0.5.6 (2026-10-06)

- `ui-sidebar-user`: `letters` and `color`, passed to its avatar
- `ui-avatar`: `data-color` is always set (`accent` by default); switching
  back to accent left `data-color="undefined"`

## 0.5.5 (2026-10-06)

- `ui-avatar`: `size` also takes a number in Imba's spacing units
  (`size=8` is 32px, like `w:8`), with the initials scaling to match
- `ui-avatar`: `tooltip` shows the name in a tooltip on hover (handy for
  stacks); `tooltip='…'` shows that text instead

## 0.5.4 (2026-10-06)

- `ui-avatar`: `letters=1` shows one initial instead of two; `color` sets
  the background ('accent' by default, or 'gray', 'red', 'orange', 'amber',
  'green', 'teal', 'blue', 'purple', 'pink'), and `color='auto'` picks one
  from the name, so the same person always gets the same colour
- `ui-tooltip`: text wraps even inside a nowrap trigger (ui-segmented's
  labels)

## 0.5.3 (2026-10-06)

- `size` ('sm', 'md' or 'lg', like ui-button) on `ui-segmented` and
  `ui-theme-toggle` (every variant, the icon menu included); 'md' is
  unchanged

## 0.5.2 (2026-10-06)

- `ui-theme-toggle`: `iconOnly` styles only apply while the menu shows; with
  `mobile='menu'` they also hit the segmented control on wide screens,
  covering the selected scheme's white indicator

## 0.5.1 (2026-10-06)

- `ui-theme-toggle`: `variant='menu'` (one button showing the current choice,
  opening a menu of them all) and `variant='toggle'` (one button flipping
  light and dark); `mobile` picks the variant below `breakpoint` (768px), e.g.
  `mobile='menu'`; `iconOnly` lists just the icons in the menu, and
  `keepOpen` keeps it open after a choice

## 0.5.0 (2026-10-06)

- `ui-theme-toggle`: System comes first (system, light, dark); `options`
  sets which schemes show and their order

## 0.4.2 (2026-10-06)

- Menu links: `href` on `ui-menu-item` and on `items` entries renders the
  item as `<a href>`; subclass ui-menu with `linkTag = 'inertia-link'` for
  Inertia. Enter on a link goes through the app's router (Zag's own click
  doesn't bubble, so it caused a full page load)
- `items` entries without a `value` use their label, like ui-menu-item
  (they all shared the key "undefined" and emitted nothing)
- `ui-menu-item` and the checkbox/radio tags now wrap their item element
  (`display: contents`), so it can be a link

## 0.4.1 (2026-10-06)

- `ui-sidebar-user`: takes ui-menu's child tags (items, submenus, groups,
  checkbox and radio items) as its content, as well as `items`

## 0.4.0 (2026-10-06)

- `ui-menu`: child tags as an alternative (or addition) to `items`:
  `ui-menu-item`, `ui-menu-separator` and `ui-menu-group` (a labelled group)
- Nested menus: `ui-submenu`, or an `items` entry with its own `items`;
  submenu selections reach the outer menu's `select` (ui-context-menu too)
- Checkbox and radio items: `{ type: 'checkbox' | 'radio', … }` entries
  (the menu updates their `checked` and emits `change`), or
  `ui-menu-checkbox` and `ui-menu-radio-group` with `ui-menu-radio`, which
  take `bind=`
- `keepOpen`: on a menu, an `items` entry or a child tag, keeps the menu open
  after an item is chosen
- Menu styles are now global CSS keyed on Zag's `data-scope=menu` parts, so
  they reach the child tags and submenus

## 0.3.2 (2026-10-06)

- Peer range for `imba` is now `>=2.0.0-alpha.253 <2.0.0-alpha- || ^2.0.0`:
  `^2.0.0-alpha.253` also matched `2.0.0-nightly.0`, which lacks
  `imba/runtime` and breaks the Vite plugin

## 0.3.1 (2026-10-06)

- `ui-sidebar-user`: 13px text, like the nav items
- 13px text uses Imba's `fs:sm-`, which also sets a 20px line height:
  command menu rows are now 32px tall (were 34px), like menu items

## 0.3.0 (2026-10-06)

- `ui-sidebar`: the edge strip shows only in the rail by default
  (`edge='rail'`); `edge=true` brings it back when expanded

## 0.2.0 (2026-10-05)

- `colorScheme` (`@milktop/imba-ui/color-scheme`): light, dark or system,
  saved and kept in step across tabs; toggles `dark` and `color-scheme` on `<html>`
- `ui-theme-toggle`: an icon-only segmented control driving it
- `ui-segmented`: `tooltips` (on by default with `iconOnly`), also shown on
  keyboard focus; checked, focus and disabled item styles now apply
- `ui-tooltip`: `show!` and `hide!`

## 0.1.0 (2026-10-05)

First tagged version: about 50 components on Zag machines (forms, pickers,
overlays, navigation, display, charts and a TipTap editor), the app shell,
the `$ui-*` theme, and the playground at https://imba-ui.pages.dev.
