import '../theme.imba'
import './base.imba'

tag ui-tags-input < ui-tags-input-base
	css
		d:block c:$ui-text ff:$ui-font min-width:0

		.label d:block fs:sm fw:500 mb:1.5
		.control d:flex ai:center g:1 min-height:$ui-control-height pl:1.5 pr:1 py:1 box-sizing:border-box bg:$ui-surface bd:1px solid $ui-border rd:$ui-radius fs:sm cursor:text
			@focus-within bc:$ui-ring outline:2px solid $ui-ring-soft
			&[data-invalid] bc:$ui-danger
			&[data-disabled] o:0.5
		.tags d:flex flw:wrap ai:center fl:1 min-width:0 g:1.5
		.preview d:hcl g:1 h:6.5 pl:2.5 pr:1 box-sizing:border-box rd:calc($ui-radius - 2px) fs:sm- fw:500 lh:1 bd:1px solid transparent
			&[data-highlighted] outline:2px solid $ui-ring
		.text ws:nowrap of:hidden text-overflow:ellipsis max-width:48
		.remove d:grid place-items:center w:4.5 h:4.5 p:0 bd:none bg:transparent rd:sm c:inherit o:0.6 cursor:pointer
			@hover o:1 bg:rgba(0,0,0,0.08)
		.edit h:6.5 px:2 w:28 box-sizing:border-box bd:1px solid $ui-ring rd:calc($ui-radius - 2px) bg:$ui-surface c:inherit ff:inherit fs:sm- outline:none
		.input fl:1 min-width:16 h:6.5 px:1 bd:none bg:transparent outline:none c:inherit fs:inherit ff:inherit
			@placeholder c:$ui-muted
		.clear d:grid place-items:center fls:0 as:center w:7 h:7 bd:none bg:transparent rd:sm c:$ui-muted cursor:pointer
			@hover bg:$ui-hover c:$ui-text
			&[hidden] d:none

		# Subtle (default): grey; accent: the soft accent tint; outline: bordered.
		&.subtle .preview bg:$ui-hover c:$ui-text
		&.accent .preview bg:$ui-accent-soft c:$ui-accent-soft-text
		&.outline .preview bg:$ui-surface bc:$ui-border c:$ui-text
