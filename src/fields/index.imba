import '../theme.imba'
import './base.imba'
import '../field/index.imba'

tag ui-fields < ui-fields-base
	css
		d:block w:100% c:$ui-text ff:$ui-font

		.group m:0 p:0 bd:none min-width:0
		.legend p:0 mb:4 fs:md fw:600
		.description m:0 mt:-3 mb:4 fs:sm c:$ui-muted
		# The container fields query to stack when narrow.
		.grid d:grid gtc:repeat(12, minmax(0, 1fr)) g:4 container-type:inline-size
