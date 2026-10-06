import '../theme.imba'
import './base.imba'

# Zag measures the content into --height and keeps it shown until the
# closing animation ends.
global css
	@keyframes ui-collapsible-open
		from height:0 opacity:0
		to height:var(--height) opacity:1
	@keyframes ui-collapsible-close
		from height:var(--height) opacity:1
		to height:0 opacity:0

tag ui-collapsible < ui-collapsible-base
	css
		# Full width, so the toggle doesn't grow when the content opens.
		d:block w:100% c:$ui-text ff:$ui-font
		.trigger-slot d:contents

		.trigger d:flex ai:center jc:space-between g:3 w:100% py:2 px:0 bd:none bg:transparent c:inherit ff:inherit fs:sm fw:500 ta:left cursor:pointer outline:none rd:sm
			# A soft ring for keyboard focus only, not after a click.
			@focus-visible outline:2px solid $ui-ring-soft outline-offset:2px
			@disabled o:0.5 cursor:not-allowed
		.indicator d:inline-flex c:$ui-muted transition:transform 200ms
			&[data-state=open] transform:rotate(180deg)
		.content of:hidden
			&[data-state=open] animation:ui-collapsible-open 200ms ease-out
			&[data-state=closed] animation:ui-collapsible-close 160ms ease-in
		.inner pt:2 fs:sm
