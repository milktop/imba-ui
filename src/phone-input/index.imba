import '../theme.imba'
import '../popover/index.imba'
import './base.imba'

tag ui-phone-input < ui-phone-input-base
	popoverTag = 'ui-popover'

	css
		d:block c:$ui-text ff:$ui-font min-width:0

		.label d:block fs:sm fw:500 mb:1.5
		.control d:hcl g:1 h:$ui-control-height pl:1 pr:2 box-sizing:border-box bg:$ui-field-bg bd:1px solid $ui-field-border rd:$ui-radius fs:sm
			@hover bc:$ui-field-border-hover
			@focus-within bc:$ui-ring outline:2px solid $ui-ring-soft
			@has(input@autofill) bg:$ui-field-autofill-bg
		&[data-invalid] .control bc:$ui-danger
		&[data-disabled] .control o:0.5
		.country d:hcc pos:relative fls:0 h:7 px:1.5 m:0 bd:none bg:transparent rd:sm c:inherit cursor:pointer
			@hover bg:$ui-hover
			@focus-visible outline:2px solid $ui-ring-soft
			@focus-within outline:2px solid $ui-ring-soft
		.flag fs:md lh:1
		.picker pos:absolute t:0 l:0 w:100% h:100% m:0 o:0 cursor:pointer fs:md
		.input fl:1 min-width:0 p:0 bd:none bg:transparent outline:none c:inherit fs:inherit ff:inherit
			@placeholder c:$ui-muted
			@autofill transition-property:background-color, color transition-delay:600000s -webkit-text-fill-color:$ui-text caret-color:$ui-text
		.type d:hcc fls:0 c:$ui-muted
		iconify-icon d:block w:1em h:1em fs:md

		.countries d:vflex w:18rem max-width:calc(100vw - 32px)
		.search m:2 mb:1 px:2.5 h:8 box-sizing:border-box bg:$ui-field-bg bd:1px solid $ui-field-border rd:$ui-radius c:inherit fs:sm ff:inherit outline:none
			@focus bc:$ui-ring outline:2px solid $ui-ring-soft
			@placeholder c:$ui-muted
		.list max-height:16rem ofy:auto p:1 pt:0
		.option d:hcl g:2 px:2 py:1.5 rd:sm fs:sm cursor:pointer
			&.active bg:$ui-hover
			&[aria-selected=true] fw:500
		.name fl:1 min-width:0 of:hidden text-overflow:ellipsis ws:nowrap
		.dial fls:0 c:$ui-muted fs:xs
		.empty px:2 py:3 c:$ui-muted fs:sm ta:center
