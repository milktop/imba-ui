import '../avatar/base.imba'
import '../tooltip/base.imba'

# Headless avatar group: avatars in an overlapping stack, each ringed in the
# page colour, with a "+3" for the rest.
#
#   <ui-avatar-group items=students max=4 tooltip>
#   <ui-avatar-group size='sm'>
#     <ui-avatar name='Ada Lovelace'>
#     <ui-avatar name='Alan Turing'>
#
# - `items`: { name, src, color } objects (or names), shown as avatars; or
#   put ui-avatars in it yourself
# - `max`: with `items`, show this many and a "+N" for the rest (its tooltip
#   lists them)
# - `size`, `color`, `square`, `letters`: passed to each avatar
# - `tooltip`: each name in a tooltip on hover
# - `spacing`: 'tight', 'normal' (default) or 'loose', how much they overlap
# - `label`: what the group is, for assistive tech ('6 people' with `items`)
# - the ring is $ui-avatar-ring (the surface by default): set it to the
#   background the group sits on
tag ui-avatar-group-base
	prop items = null
	prop max = null
	prop size = 'md'
	prop color = 'accent'
	prop square = false
	prop letters = 2
	prop tooltip = false
	prop spacing = 'normal'
	prop label = null

	# The avatar tag to render; the styled group uses the styled one.
	avatarTag = 'ui-avatar-base'

	get people do (items or []).map(do(item) typeof item == 'string' ? { name: item } : item)
	get shown do max and people.length > max ? people.slice(0, max) : people
	get hidden do people.slice(shown.length)
	get named do ['sm', 'md', 'lg', 'xl'].includes(size)
	get hiddenNames do hidden.map(do $1.name).join(', ')

	<self role='group' aria-label=(label or (items ? "{people.length} people" : undefined)) data-size=(named ? size : 'custom') data-spacing=spacing
		style=(named ? undefined : "--avatar-size: {Number(size) * 0.25}rem")>
		for person in shown
			<{avatarTag} key=(person.name or person.src) size=size square=square letters=letters color=(person.color or color) name=person.name src=person.src tooltip=(tooltip or null)>
		<slot>
		if hidden.length
			<ui-tooltip content=hiddenNames>
				<span.more .square=square aria-label="{hidden.length} more: {hiddenNames}"> "+{hidden.length}"
