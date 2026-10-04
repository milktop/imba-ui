import '../theme.imba'
import './base.imba'

tag ui-card < ui-card-base
	css
		d:flex fld:column w:100% box-sizing:border-box min-width:0 bg:$ui-surface c:$ui-text bd:1px solid $ui-border rd:calc($ui-radius + 4px) ff:$ui-font fs:sm

		.header d:flex ai:flex-start jc:space-between g:4 px:5 pt:5
		.titles min-width:0
		.heading m:0 fs:md fw:600
		.description m:0 mt:1 c:$ui-muted
		.actions d:flex g:2 fls:0
			&:not(:has(*)) d:none
		# No empty check here: a body of plain text has no child elements.
		.body p:5
		.header + .body pt:4
		&.flush of:hidden
			.body p:0
			.header pb:4 bdb:1px solid $ui-border
			.header + .body pt:0
		.footer d:flex ai:center jc:flex-end g:2 px:5 py:3 bdt:1px solid $ui-border
			&:not(:has(*)) d:none
		# Slotted wrapper <div>s step aside, so their buttons are laid out here
		# (a button slotted directly keeps its own box).
		.actions >>> div[slot=actions], .footer >>> div[slot=footer] d:contents
