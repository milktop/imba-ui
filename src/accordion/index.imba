import '../theme.imba'
import './base.imba'

global css @keyframes ui-accordion-in
	from opacity:0 transform:translateY(-4px)

tag ui-accordion < ui-accordion-base
	css
		d:block w:100% c:$ui-text ff:$ui-font bdt:1px solid $ui-border

tag ui-accordion-item < ui-accordion-item-base
	css
		d:block bdb:1px solid $ui-border
		.heading m:0 fs:inherit fw:inherit
		.trigger d:flex ai:center jc:space-between g:4 w:100% py:4 px:0 bd:none bg:transparent c:inherit ff:inherit fs:sm fw:500 ta:left cursor:pointer
			@hover td:underline
			@focus-visible outline:2px solid $ui-ring-soft outline-offset:2px rd:sm
			@disabled o:0.5 cursor:not-allowed td:none
		.indicator d:inline-flex c:$ui-muted transition:transform 200ms
			&[data-state=open] transform:rotate(180deg)
		.content
			&[data-state=open] animation:ui-accordion-in 180ms ease-out
		.inner pb:4 c:$ui-muted fs:sm
