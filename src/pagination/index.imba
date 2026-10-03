import '../theme.imba'
import './base.imba'

tag ui-pagination < ui-pagination-base
	css
		d:block c:$ui-text ff:$ui-font fs:sm
		.root d:flex ai:center jc:space-between g:4 flw:wrap
		.summary c:$ui-muted fs:xs
		.pages d:flex ai:center g:1 ml:auto
		.page, .nav-button d:inline-flex ai:center jc:center min-width:8 h:8 px:2 box-sizing:border-box bd:1px solid transparent rd:$ui-radius bg:transparent c:inherit ff:inherit fs:inherit cursor:pointer
			@hover bg:$ui-hover
			@focus-visible outline:2px solid $ui-ring-soft
			@disabled o:0.4 cursor:not-allowed bg:transparent
		.page[data-selected] bc:$ui-border bg:$ui-surface fw:600 shadow:0 1px 2px rgba(0,0,0,0.05)
		.ellipsis d:inline-flex ai:center jc:center min-width:8 h:8 c:$ui-muted
