import '../theme.imba'
import './base.imba'

global css @keyframes ui-skeleton-pulse
	50% opacity:0.5

tag ui-skeleton < ui-skeleton-base
	css
		d:block min-height:4 rd:$ui-radius bg:$ui-hover animation:ui-skeleton-pulse 1.6s ease-in-out infinite
		&.circle rd:full min-height:0
		&.text min-height:0 bg:transparent d:flex fld:column g:2 animation:none
		.line d:block h:3 rd:sm bg:$ui-hover animation:ui-skeleton-pulse 1.6s ease-in-out infinite
			&.last w:60%
