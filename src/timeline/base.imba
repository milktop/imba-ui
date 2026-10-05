# Headless timeline: events down a line, newest or oldest first, e.g. a
# student's history.
#
#   <ui-timeline items=[
#     { title: 'Lesson booked', time: '2 Oct', icon: 'lucide:calendar-plus' }
#     { title: 'Invoice paid', time: '1 Oct', description: '£120', color: 'success' }
#   ]>
#
# Or as markup, when an event needs more than text:
#
#   <ui-timeline>
#     <ui-timeline-item title='Note added' time='30 Sep' icon='lucide:notebook-pen'>
#       <ui-card> …
#
# - `items`: plain objects with an item's fields (only `title` is needed)
# - `variant`: 'line' (default) or 'cards' (each item's content in a card)
# - `size`: 'sm' or 'md' (default)
tag ui-timeline-base
	prop items = null
	prop variant = 'line'
	prop size = 'md'

	itemTag = 'ui-timeline-item-base'

	<self .{variant} .{size}>
		<ol.list>
			if items
				for item in items
					<{itemTag} title=item.title time=item.time icon=item.icon color=item.color description=item.description>
			<slot>

# One event; content in its slot shows under the title.
#
# - `title`: the event
# - `time`: when, as text (format it first)
# - `description`: a line under the title
# - `icon`: an Iconify icon in a circle; without one, a dot
# - `color`: tints the marker: 'accent', 'success', 'warning' or 'danger'
#   (grey by default)
tag ui-timeline-item-base
	prop title = null
	prop time = null
	prop description = null
	prop icon = null
	prop color = null

	<self role='listitem' .{color or 'neutral'}>
		<div.marker aria-hidden='true'>
			if icon
				<span.icon> <iconify-icon icon=icon>
			else
				<span.dot>
		<div.body>
			<div.header>
				<span.title> title if title
				<time.time> time if time
			<div.description> description if description
			<div.content> <slot>
