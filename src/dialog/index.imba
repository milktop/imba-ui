import '../theme.imba'
import './base.imba'

global css
	@keyframes ui-fade-in
		from opacity:0
	@keyframes ui-fade-out
		to opacity:0
	@keyframes ui-dialog-in
		from opacity:0 transform:translateY(8px) scale(0.97)
	@keyframes ui-dialog-out
		to opacity:0 transform:translateY(8px) scale(0.97)

tag ui-dialog < ui-dialog-base
	css
		# The wrappers stay out of layout; the trigger sits where it was written.
		d:contents
		.trigger-slot d:contents

		.backdrop inset:0 pos:fixed zi:100 bg:rgba(0,0,0,0.45)
			&[data-state=open] animation:ui-fade-in 150ms ease-out
			&[data-state=closed] animation:ui-fade-out 120ms ease-in forwards
		# Covers the screen to centre the panel, but lets clicks through to the
		# backdrop so clicking outside closes it.
		.positioner inset:0 pos:fixed zi:100 d:grid place-items:center p:4 pointer-events:none
		.content pos:relative d:flex fld:column w:100% max-width:32rem max-height:calc(100vh - 32px) box-sizing:border-box
			bg:$ui-surface c:$ui-text ff:$ui-font fs:sm bd:1px solid $ui-border rd:calc($ui-radius + 4px) shadow:$ui-shadow outline:none pointer-events:auto
			&.sm max-width:24rem
			&.lg max-width:44rem
			&[data-state=open] animation:ui-dialog-in 180ms ease-out
			&[data-state=closed] animation:ui-dialog-out 120ms ease-in forwards
		.header px:6 pt:6 pr:12
		.heading m:0 fs:lg fw:600
		.description m:0 mt:1.5 c:$ui-muted
		.body px:6 py:4 ofy:auto
			&:empty d:none
		.header + .body pt:4
		.footer d:flex jc:flex-end g:2 flw:wrap px:6 pb:6
			&:not(:has(*)) d:none
		# A slotted wrapper <div> steps aside, so its buttons are the flex items
		# (a button slotted directly keeps its own box).
		.footer >>> div[slot=footer] d:contents
		.close pos:absolute t:4 r:4 d:grid place-items:center w:8 h:8 bd:none bg:transparent rd:md c:$ui-muted cursor:pointer
			@hover bg:$ui-hover c:$ui-text
			@focus-visible outline:2px solid $ui-ring-soft
