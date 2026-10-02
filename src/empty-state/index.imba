import '../theme.imba'
import './base.imba'

tag ui-empty-state < ui-empty-state-base
	css
		d:flex fld:column ai:center ta:center w:100% box-sizing:border-box py:10 px:6 c:$ui-text ff:$ui-font fs:sm
		.icon-wrap d:grid place-items:center w:12 h:12 mb:4 rd:full bg:$ui-hover c:$ui-muted
		.icon d:block w:6 h:6 fs:24px
		.heading m:0 fs:md fw:600
		.description m:0 mt:1 max-width:28rem c:$ui-muted
		.actions d:flex flw:wrap jc:center g:2 mt:5
			&:not(:has(*)) d:none
		.actions >>> div[slot=actions] d:contents
