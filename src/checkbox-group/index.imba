import '../theme.imba'
import './base.imba'
import '../checkbox/index.imba'

tag ui-checkbox-group < ui-checkbox-group-base
	checkboxTag = 'ui-checkbox'

	css
		d:block c:$ui-text ff:$ui-font

		.label d:block fs:sm fw:500 mb:1.5
		.group d:vflex g:2
		.items d:vflex g:2
			&.horizontal d:hflex flw:wrap g:2 4
			&.indented pl:6
