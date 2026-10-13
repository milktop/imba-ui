# Headless divider: a line between things, across (between sections) or up
# (between toolbar buttons), with an optional label in the middle.
#
#   <ui-divider>
#   <ui-divider label='or'>
#   <ui-divider orientation='vertical'>
#
# - `label`: text in the line (or the default slot)
# - `align`: where the label sits: 'center' (default), 'start' or 'end'
# - `orientation`: 'horizontal' (default) or 'vertical' (as tall as its row)
# - `variant`: 'solid' (default), 'dashed' or 'dotted'
# - `spacing`: the room either side, a CSS length (0.75rem across, 0.5rem up)
tag ui-divider-base
	prop label = null
	prop align = 'center'
	prop orientation = 'horizontal'
	prop variant = 'solid'
	prop spacing = null

	# Slotted content counts as a label too, so it's checked once rendered.
	def rendered
		flags.toggle('labelled', !!$label.textContent.trim! or $label.children.length > 0)

	def render
		spacing ? style.setProperty('--spacing', spacing) : style.removeProperty('--spacing')
		# A labelled line is a separator with a name; a plain one only a separator.
		<self role='separator' aria-orientation=orientation .{orientation} .{variant} .{align}>
			<span$label.label> <slot> label
