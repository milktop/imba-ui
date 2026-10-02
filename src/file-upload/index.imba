import '../theme.imba'
import './base.imba'

tag ui-file-upload < ui-file-upload-base
	css
		d:block c:$ui-text ff:$ui-font min-width:0

		.label d:block fs:sm fw:500 mb:1.5
		.dropzone d:vcc g:1.5 p:6 box-sizing:border-box ta:center bg:$ui-surface bd:1px dashed $ui-border rd:$ui-radius fs:sm cursor:pointer outline:none
			@hover bc:$ui-muted
			@focus-visible bc:$ui-ring outline:2px solid $ui-ring-soft
			&[data-dragging] bg:$ui-accent-soft bc:$ui-accent
			&[data-invalid] bc:$ui-danger
			&[data-disabled] o:0.5 cursor:not-allowed
		.icon c:$ui-muted
		.browse p:0 bd:none bg:transparent c:$ui-accent ff:inherit fs:inherit fw:500 cursor:pointer
			@hover td:underline
		.hint c:$ui-muted fs:xs
		.files d:vflex g:2 m:0 mt:3 p:0 list-style:none
		.file d:flex ai:center g:3 p:2 pr:1 bd:1px solid $ui-border rd:$ui-radius fs:sm
		.preview d:block fls:0 w:8 h:8 rd:sm obj:cover bg:$ui-hover
			&.generic d:grid place-items:center c:$ui-muted
		.name fl:1 min-width:0 of:hidden text-overflow:ellipsis ws:nowrap
		.size c:$ui-muted fs:xs ws:nowrap
		.rejected .preview c:$ui-danger
		.reason c:$ui-danger fs:xs ws:nowrap
		.remove d:grid place-items:center fls:0 w:7 h:7 bd:none bg:transparent rd:sm c:$ui-muted cursor:pointer
			@hover bg:$ui-hover c:$ui-text
