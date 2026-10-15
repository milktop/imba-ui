import '../theme.imba'
import '../button/index.imba'
import { closestWith } from '../app-shell/base.imba'
import { icons } from '../icons.imba'
import { uiLocale } from '../locale.imba'

# A search box that opens its ui-command: a `field` button with a search
# icon, the text, and the menu's shortcut on the right (hidden on small
# screens, which rarely have a keyboard).
#
#   <ui-command items=commands>
#     <ui-command-trigger slot='trigger'>
#
#   <ui-command items=commands>
#     <ui-command-trigger slot='trigger' variant='ghost'> "Find a client"
#
# - The text defaults to "Search…" in the app's locale
# - `shortcut`: the hint's text; by default the menu's own (`hotkeyText`,
#   '⌘K' or 'Ctrl K'), null for none
# - `icon`: an Iconify name in place of the search icon
# - `variant`, `size`, `block`, `round`: as on ui-button
tag ui-command-trigger < ui-button
	prop variant = 'field'
	prop shortcut = undefined

	get command do closestWith(self, 'isUiCommand')
	get shortcutText do shortcut !== undefined ? shortcut : command..hotkeyText

	# The menu is only found once the trigger sits in its slot, after the
	# first render.
	def rendered
		super
		render! if shortcutText !== #shown

	def render
		toggleAttribute('disabled', !!disabled)
		#shown = shortcutText
		let key = command..hotkey

		<self .{variant} .{size} .block=block .round=round aria-keyshortcuts=(key ? "Meta+{key.toUpperCase!} Control+{key.toUpperCase!}" : undefined)>
			if icon
				<iconify-icon.icon icon=icon aria-hidden='true'>
			else
				<span.icon> <ui-icon path=icons.search size=16>
			<span.text> <slot> uiLocale.messages.command.search
			if #shown
				<kbd.shortcut aria-hidden='true'> #shown

	css
		.icon d:grid place-items:center
		.text flg:1 ta:left of:hidden text-overflow:ellipsis
		.shortcut d:none @md:inline-flex ai:center h:5 px:1.5 ml:2 box-sizing:border-box
			bd:1px solid $ui-border rd:5px bg:$ui-hover c:$ui-muted ff:$ui-font fs:11px fw:500 lh:1 ws:nowrap
		&.field@hover .shortcut bc:$ui-field-border-hover
