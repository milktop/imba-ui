import '../theme.imba'
import './base.imba'

global css
	@keyframes ui-command-fade-in
		from opacity:0
	@keyframes ui-command-fade-out
		to opacity:0
	@keyframes ui-command-in
		from opacity:0 transform:scale(0.97)
	@keyframes ui-command-out
		to opacity:0 transform:scale(0.97)

tag ui-command < ui-command-base
	css
		# The wrappers stay out of layout; the trigger sits where it was written.
		d:contents
		.trigger-slot d:contents
		.sr-only pos:absolute w:1px h:1px of:hidden clip:rect(0 0 0 0) ws:nowrap m:-1px p:0 bd:0

		.backdrop inset:0 pos:fixed zi:100 bg:rgba(0,0,0,0.45)
			&[data-state=open] animation:ui-command-fade-in 120ms ease-out
			&[data-state=closed] animation:ui-command-fade-out 100ms ease-in forwards
		# Near the top, so the panel stays put as results come and go. Clicks
		# pass through to the backdrop, which closes it.
		.positioner inset:0 pos:fixed zi:100 d:flex jc:center ai:flex-start p:4 pt:4 @sm:12vh box-sizing:border-box pointer-events:none
		.content d:flex fld:column w:100% max-width:36rem max-height:min(32rem, calc(100dvh - 32px)) box-sizing:border-box of:hidden
			bg:$ui-surface c:$ui-text ff:$ui-font fs:sm bd:1px solid $ui-border rd:calc($ui-radius + 6px) shadow:$ui-shadow outline:none pointer-events:auto
			&[data-state=open] animation:ui-command-in 140ms ease-out
			&[data-state=closed] animation:ui-command-out 100ms ease-in forwards
		.root d:flex fld:column min-height:0 flg:1

		.search d:flex ai:center g:2.5 px:4 h:12 fls:0 bdb:1px solid $ui-border
		.search-icon c:$ui-muted fls:0
		.input flg:1 min-width:0 h:100% p:0 bd:none bg:transparent c:inherit ff:inherit fs:md outline:none
			@placeholder c:$ui-muted
		.key d:inline-flex ai:center jc:center min-width:5 h:5 px:1 box-sizing:border-box bd:1px solid $ui-border rd:sm bg:$ui-hover c:$ui-muted ff:inherit fs:11px lh:1
		.esc d:none @sm:inline-flex

		.list flg:1 min-height:0 ofy:auto p:2 outline:none scroll-padding-block:2
		.status py:10 ta:center c:$ui-muted
		.group + .group mt:2
		.group-label px:2.5 pt:1.5 pb:1 fs:xs fw:500 c:$ui-muted
		.item d:flex ai:center g:3 px:2.5 py:2 min-height:9 box-sizing:border-box rd:$ui-radius cursor:pointer user-select:none
			&[data-highlighted] bg:$ui-hover
			&[data-disabled] o:0.4 cursor:not-allowed
		.icon fs:16px w:4 h:4 fls:0 c:$ui-muted
		.text d:flex fld:column flg:1 min-width:0
		.label of:hidden text-overflow:ellipsis ws:nowrap
		.description fs:xs c:$ui-muted of:hidden text-overflow:ellipsis ws:nowrap
		.shortcut fls:0 c:$ui-muted ff:inherit fs:xs

		.hints d:none @sm:flex g:4 px:4 py:2.5 fls:0 bdt:1px solid $ui-border fs:xs c:$ui-muted
			span d:flex ai:center g:1
