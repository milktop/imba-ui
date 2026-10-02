# Shared pieces for the playground pages.

export const subjects = [
	{ value: 1, label: 'Maths' }
	{ value: 2, label: 'English' }
	{ value: 3, label: 'Physics' }
	{ value: 4, label: 'Chemistry' }
	{ value: 5, label: 'Biology' }
	{ value: 6, label: 'History' }
	{ value: 7, label: 'Latin', disabled: true }
	{ value: 8, label: 'Computer Science' }
]

# Page content belongs to each page's scope, so demo helpers (JSON readouts,
# buttons that set values) are styled globally under demo-section.
global css
	demo-section
		pre fs:xs c:$ui-muted m:0 ws:pre-wrap word-break:break-all
		.out d:vflex g:2 mt:1
		.indent d:vflex g:2 pl:6
		.set d:hcl g:2 flw:wrap
		.set button bd:1px solid $ui-border bg:transparent c:inherit rd:md fs:xs px:2 py:1 cursor:pointer
			@hover bg:$ui-hover
		# Stand-in buttons until there's a ui-button.
		.btn d:inline-flex ai:center jc:center g:2 h:9 px:3 bd:1px solid $ui-border bg:$ui-surface c:inherit rd:$ui-radius fs:sm ff:inherit cursor:pointer
			@hover bg:$ui-hover
			@focus-visible outline:2px solid $ui-ring-soft bc:$ui-ring
			&.primary bg:$ui-accent bc:$ui-accent c:$ui-accent-text
			&.icon w:9 px:0

tag demo-page
	prop heading
	prop intro
	css
		d:block
		h1 fs:xl fw:700 m:0
		.intro m:0 mt:1 c:$ui-muted fs:sm
	<self>
		<h1> heading
		<p.intro> intro if intro
		<slot>

tag demo-section
	prop heading
	css
		d:vtl g:4 py:8 bdb:1px solid $ui-border
		&:last-child bdb:none
		h2 fs:md fw:600 m:0
	<self>
		<h2> heading
		<slot>
