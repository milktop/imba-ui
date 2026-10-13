# Headless keyboard key, or a shortcut of several.
#
#   <ui-kbd> "Esc"
#   <ui-kbd keys=['⌘', 'K']>
#
# - `keys`: several keys, each in its own box (without it, the content is one key)
# - `size`: 'sm' or 'md' (default)
tag ui-kbd-base
	prop keys = null
	prop size = 'md'

	<self .{size} .several=!!keys>
		if keys
			for key in keys
				<kbd.key> key
		else
			<kbd.key> <slot>
