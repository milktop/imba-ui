import '../theme.imba'
import './base.imba'

tag ui-editable < ui-editable-base
	css
		d:block min-width:0 c:$ui-text ff:$ui-font fs:sm
		.label d:block mb:1 fs:sm fw:500
		.row d:flex ai:center g:1 min-width:0
		.area fl:1 min-width:0
		# As text until clicked: a faint box on hover says it can be edited.
		.preview d:block mx:-1.5 py:1 px:1.5 rd:calc($ui-radius - 2px) of:hidden text-overflow:ellipsis ws:nowrap cursor:text
			@hover bg:$ui-hover
			&[data-placeholder-shown] c:$ui-muted
		&[data-disabled] .preview cursor:default bg:transparent
		.input w:100% box-sizing:border-box mx:-1.5 py:1 px:1.5 bd:1px solid $ui-ring rd:calc($ui-radius - 2px) outline:2px solid $ui-ring-soft
			bg:$ui-field-bg c:inherit font:inherit
		.controls d:flex g:0.5 fls:0
		.trigger d:grid place-items:center w:7 h:7 p:0 bd:none rd:calc($ui-radius - 2px) bg:transparent c:$ui-muted fs:sm cursor:pointer
			@hover bg:$ui-hover c:$ui-text
			@focus-visible outline:2px solid $ui-ring-soft
		# The pencil shows on hover (and when focused), to keep the text clean.
		.edit o:0
			@focus-visible o:1
		&@hover .edit o:1
		.submit c:$ui-accent
