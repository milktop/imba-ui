# Headless empty state: what to show where a list or page has nothing yet.
#
# - `icon`: an Iconify name; `heading`, `description`
# - `actions` slot (or the default slot): e.g. a button to create the first item
tag ui-empty-state-base
	prop icon = null
	prop heading = null
	prop description = null

	<self>
		if icon
			<span.icon-wrap> <iconify-icon.icon icon=icon aria-hidden='true'>
		<h3.heading> heading if heading
		<p.description> description if description
		<div.actions>
			<slot name='actions'>
			<slot>
