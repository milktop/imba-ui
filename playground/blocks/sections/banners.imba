# A slim announcement across the top of the content.
tag banner-announcement
	open = yes
	css
		.bar d:flex ai:center g:3 px:4 py:2.5 rd:calc($ui-radius + 2px) bg:$ui-accent c:$ui-accent-text fs:sm
		.text flg:1
		a c:inherit fw:600 td:underline text-underline-offset:2px
		.close d:grid place-items:center w:7 h:7 bd:none rd:$ui-radius bg:transparent c:inherit cursor:pointer
			@hover bg:rgba(255,255,255,0.15)
		.again fs:sm
	<self>
		if open
			<div.bar>
				<iconify-icon icon='lucide:sparkles'>
				<span.text>
					"Lesson notes can now be shared with parents. "
					<a href='#'> "See how"
				<button.close type='button' aria-label='Dismiss' @click=(open = no)> <iconify-icon icon='lucide:x'>
		else
			<ui-button.again size='sm' variant='ghost' @click=(open = yes)> "Show the banner again"

# A prompt to do something next, with an illustration-like icon.
tag banner-prompt
	css
		d:flex ai:center g:5 flw:wrap p:6 rd:calc($ui-radius + 6px) bd:1px solid $ui-border bg:$ui-surface
		.icon d:grid place-items:center w:14 h:14 fls:0 rd:full bg:$ui-accent-soft c:$ui-accent-soft-text fs:28px
		.text flg:1 min-width:16rem
		h3 m:0 fs:md fw:600
		p m:0 mt:1 c:$ui-muted fs:sm
		.actions d:flex g:2
	<self>
		<span.icon> <iconify-icon icon='lucide:calendar-sync'>
		<div.text>
			<h3> "Connect your calendar"
			<p> "Lessons appear in Google or Outlook, and busy times block bookings."
		<div.actions>
			<ui-button variant='ghost'> "Later"
			<ui-button variant='primary'> "Connect"

# Getting started: progress and the steps left.
tag banner-onboarding
	steps = [
		{ label: 'Add your first student', done: yes }
		{ label: 'Set your availability', done: yes }
		{ label: 'Book a lesson', done: no }
		{ label: 'Send an invoice', done: no }
	]
	get done do steps.filter(do $1.done).length
	css
		max-width:28rem
		ul d:flex fld:column g:2.5 m:0 mt:4 p:0 list-style:none
		li d:flex ai:center g:2.5
		.tick d:grid place-items:center w:5 h:5 rd:full bd:1.5px solid $ui-border c:transparent fs:12px
		.done .tick bg:$ui-success bc:$ui-success c:white
		.done .label c:$ui-muted td:line-through
	<self>
		<ui-card heading='Get started' description="{done} of {steps.length} done">
			<ui-progress value=(done / steps.length * 100) label='Setup progress'>
			<ul> for step in steps
				<li .done=step.done>
					<span.tick> <iconify-icon icon='lucide:check'>
					<span.label> step.label

export const examples = [
	{ heading: 'Announcement', tag: 'banner-announcement' }
	{ heading: 'Prompt', tag: 'banner-prompt' }
	{ heading: 'Onboarding checklist', tag: 'banner-onboarding' }
]
