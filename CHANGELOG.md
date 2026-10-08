# Changelog

Until 1.0, a minor version may change props or markup; patch versions only
fix things.

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
