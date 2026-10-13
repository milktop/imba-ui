import '../theme.imba'
import { confirm, confirmHost } from './base.imba'
import '../dialog/index.imba'
import '../button/index.imba'
import '../input/index.imba'
import '../alert/index.imba'

export { confirm }

tag ui-confirm < ui-confirm-base
	dialogTag = 'ui-dialog'
	buttonTag = 'ui-button'
	inputTag = 'ui-input'
	alertTag = 'ui-alert'

	css
		d:contents
		.confirm-body d:flex fld:column g:3 fs:sm
		.content m:0
		.type d:flex fld:column g:1.5
		.type-label c:$ui-muted
		.type-label strong c:$ui-text fw:600

confirmHost.tag = 'ui-confirm'
