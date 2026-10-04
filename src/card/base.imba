# Headless card: a surface grouping related content.
#
#   <ui-card heading='Next lesson' description='Thursday at 16:00'>
#     <ui-button slot='actions' size='sm'> 'Reschedule'
#     …body…
#     <div slot='footer'> …
#
# - `heading`, `description`: the header, with an `actions` slot beside it
# - default slot: the body; `footer` slot: a footer strip
# - `flush`: no padding round the body, for content that runs edge to edge
#   (a `flush` ui-table, a list with its own dividers)
tag ui-card-base
	prop heading = null
	prop description = null
	prop flush = false

	<self .flush=flush>
		if heading or description
			<header.header>
				<div.titles>
					<h3.heading> heading if heading
					<p.description> description if description
				<div.actions> <slot name='actions'>
		<div.body> <slot>
		<footer.footer> <slot name='footer'>
