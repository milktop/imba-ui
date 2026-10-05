import '../theme.imba'
import '../popover/index.imba'
import '../input/index.imba'
import '../button/index.imba'
import './base.imba'

tag ui-editor < ui-editor-base
	css
		d:block pos:relative w:100% min-width:0 box-sizing:border-box bg:$ui-surface bd:1px solid $ui-border rd:$ui-radius c:$ui-text ff:$ui-font fs:sm
		&.focused bc:$ui-ring outline:2px solid $ui-ring-soft
		&:has([aria-invalid=true]) bc:$ui-danger
		&.disabled bg:$ui-hover

		.toolbar d:flex ai:center flw:wrap g:0.5 p:1 bdb:1px solid $ui-border
		.tool d:grid place-items:center w:8 h:8 p:0 bd:none rd:calc($ui-radius - 2px) bg:transparent c:$ui-muted fs:16px cursor:pointer
			@hover c:$ui-text bg:$ui-hover
			@focus-visible outline:2px solid $ui-ring-soft
			@disabled o:0.35 cursor:default bg:transparent
			&[aria-pressed=true] c:$ui-text bg:$ui-hover
		.divider w:1px h:5 mx:1 bg:$ui-border
		.link-form d:flex fld:column g:2 w:64
		.link-actions d:flex jc:flex-end g:2

		# The editable area (ProseMirror renders it, so styled through >>>).
		.content >>> .ProseMirror min-height:var(--min-height) max-height:var(--max-height) ofy:auto px:3 py:2.5 outline:none lh:1.6 overflow-wrap:anywhere
		.content >>> :is(p, ul, ol, blockquote, h2, h3) m:0 mb:2
		.content >>> .ProseMirror > *@last-child mb:0
		.content >>> h2 fs:lg fw:600 lh:1.3 mt:3
		.content >>> h3 fs:md fw:600 lh:1.3 mt:2.5
		.content >>> :is(ul, ol) pl:5
		.content >>> ul list-style:disc
		.content >>> ol list-style:decimal
		.content >>> li > p m:0
		.content >>> blockquote pl:3 bdl:3px solid $ui-border c:$ui-muted
		.content >>> code px:1 py:0.5 rd:sm bg:$ui-hover ff:mono fs:0.9em
		.content >>> a c:$ui-accent td:underline text-underline-offset:2px
		# TipTap's placeholder: on the first empty paragraph.
		.content >>> p.is-editor-empty@first-child@before content:attr(data-placeholder) float:left h:0 c:$ui-muted pointer-events:none

		.count pos:absolute r:2.5 b:1.5 fs:xs c:$ui-muted pointer-events:none
			&.over c:$ui-danger
