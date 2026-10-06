import '../theme.imba'
import './base.imba'
export { toaster, createToaster } from './base.imba'

global css @keyframes ui-spin
	to transform:rotate(360deg)

tag ui-toast < ui-toast-base
	css
		d:flex ai:flex-start g:3 w:22rem max-width:calc(100vw - 2rem) p:3 pr:10 box-sizing:border-box
		bg:$ui-surface c:$ui-text ff:$ui-font fs:sm bd:1px solid $ui-border rd:calc($ui-radius + 2px) shadow:$ui-shadow outline:none
		# Zag positions each toast through these variables. Toasts behind the
		# front one shrink a little (Zag's own --scale would mirror them).
		translate:var(--x) var(--y)
		scale:calc(2 - (var(--base-scale, 1)))
		zi:var(--z-index) h:var(--height) opacity:var(--opacity)
		transition:translate 400ms, transform 400ms, opacity 400ms, height 400ms
		transition-timing-function:cubic-bezier(0.21, 1.02, 0.73, 1)
		&[data-state=closed]
			transition:translate 400ms, transform 400ms, opacity 200ms
			transition-timing-function:cubic-bezier(0.06, 0.71, 0.55, 1)
		@focus-visible outline:2px solid $ui-ring-soft

		.icon fls:0 mt:0.5 c:$ui-muted
		&[data-type=success] .icon c:#16a34a
		&[data-type=warning] .icon c:#d97706
		&[data-type=error] .icon c:$ui-danger
		&[data-type=info] .icon c:$ui-accent
		.spinner d:block w:4 h:4 mt:0.5 box-sizing:border-box bd:2px solid currentColor bc:currentColor transparent currentColor currentColor rd:full animation:ui-spin 0.7s linear infinite
		.text fl:1 min-width:0
		.heading fw:600
		.description c:$ui-muted
		.heading + .description mt:0.5
		.action as:center fls:0 h:7 px:2.5 bd:1px solid $ui-border bg:$ui-surface c:$ui-text rd:md fs:xs fw:500 ff:inherit cursor:pointer
			@hover bg:$ui-hover
		.close pos:absolute t:2 r:2 d:grid place-items:center w:7 h:7 bd:none bg:transparent rd:sm c:$ui-muted cursor:pointer
			@hover bg:$ui-hover c:$ui-text

tag ui-toaster < ui-toaster-base
	toastTag = 'ui-toast'
	css d:contents
