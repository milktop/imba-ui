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
# An item has a `title`, `time`, `description` (or content in its slot), and
# a marker: an Iconify `icon` in a circle, or a dot. `color` tints it:
# 'accent', 'success', 'warning' or 'danger' (grey by default).
#
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
