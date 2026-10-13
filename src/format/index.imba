import '../theme.imba'
import './base.imba'

export { formatNumber, formatBytes, formatRelative } from './base.imba'

tag ui-format-number < ui-format-number-base
	css d:inline font-variant-numeric:tabular-nums

tag ui-format-bytes < ui-format-bytes-base
	css d:inline font-variant-numeric:tabular-nums

tag ui-format-relative < ui-format-relative-base
	css d:inline
