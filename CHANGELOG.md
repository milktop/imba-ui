# Changelog

Until 1.0, a minor version may change props or markup; patch versions only
fix things.

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
