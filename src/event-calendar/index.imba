import '../theme.imba'
import './base.imba'
import '../button/index.imba'
import '../popover/index.imba'
import '../date-picker/index.imba'
import '../segmented/index.imba'
import '../context-menu/index.imba'

tag ui-event-calendar < ui-event-calendar-base
	buttonTag = 'ui-button'
	popoverTag = 'ui-popover'
	datePickerTag = 'ui-date-picker'
	segmentedTag = 'ui-segmented'
	menuTag = 'ui-context-menu'

	css
		pos:relative d:flex fld:column g:3 w:100% min-width:0 c:$ui-text ff:$ui-font fs:sm

		.toolbar d:flex ai:center g:2 3 flw:wrap
		.nav d:flex ai:center g:1
		.title d:inline-flex ai:center g:1.5 m:0 py:1 px:2 bd:none rd:$ui-radius bg:transparent c:inherit font:inherit fs:md fw:600 cursor:pointer
			iconify-icon c:$ui-muted fs:sm
			@hover bg:$ui-hover
			@focus-visible outline:2px solid $ui-ring-soft
		.actions d:flex ai:center g:2 ml:auto
		# The month the title opens: the popover is the card.
		.jump d:contents
		.jump >>> .content w:auto p:2
		.jump >>> ui-date-picker .content shadow:none bd:none p:0

		# A time gutter, then a column per day (or per resource within each
		# day); it scrolls sideways when narrow.
		# The gutter is as wide as its widest label, however many columns there are.
		.grid d:grid gtc:max-content repeat(var(--columns), minmax(6.5rem, 1fr)) ofx:auto
			bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 2px) shadow:$ui-card-shadow
		.corner, .day-header, .resource-header bg:$ui-surface bdb:1px solid $ui-border
		.day-header d:flex ai:baseline jc:center g:1.5 p:2 bdl:1px solid $ui-border c:$ui-muted fs:xs
			strong c:$ui-text fs:md- fw:600
		.day-header.today strong d:inline-grid place-items:center min-width:6.5 h:6.5 rd:full bg:$ui-accent c:$ui-accent-text
		.resource-header d:flex ai:center jc:center g:2 min-width:0 p:2 bdl:1px solid $ui-border fs:sm- fw:500 ta:center of:hidden
		.resource-header.colored shadow:inset 0 3px 0 var(--resource-color)
		# A clickable header fills its cell, looking the same.
		.header-button d:inherit fl:1 ai:inherit jc:inherit g:inherit min-width:0 m:-1.5 p:1.5 bd:none rd:$ui-radius bg:transparent c:inherit font:inherit cursor:pointer
			@hover bg:$ui-hover
			@focus-visible outline:2px solid $ui-ring-soft

		# Extra rows (e.g. the day's messages): a label, then a cell per day or column.
		.row-label d:flex ai:center jc:flex-end pr:2 bdb:1px solid $ui-border c:$ui-muted fs:xs
		.row-cell d:flex ai:center min-width:0 min-height:8 p:1 box-sizing:border-box bdl:1px solid $ui-border bdb:1px solid $ui-border fs:xs
		.row-cell.clickable cursor:pointer outline:none
			@hover bg:color-mix(in srgb, $ui-accent 6%, transparent)
			@focus-visible shadow:inset 0 0 0 2px $ui-ring-soft

		# All-day and multi-day events, in lanes along the top; the gutter column
		# grows to fit the longest label ("Journée", in French).
		.all-day-label d:flex ai:center jc:flex-end px:2 ws:nowrap bdb:1px solid $ui-border c:$ui-muted fs:11px
		.fold d:inline-flex ai:center g:0.5 p:0 bd:none bg:transparent c:inherit font:inherit fs:11px cursor:pointer
			@hover c:$ui-text
		.all-day pos:relative gc:2 / -1 h:calc(var(--lanes) * 1.625rem + 0.5rem) bdb:1px solid $ui-border bdl:1px solid $ui-border
			# A line between the days it spans.
			background-image:linear-gradient(to right, transparent calc(100% - 1px), var(--ui-border) calc(100% - 1px))
			background-size:calc(100% / var(--columns)) 100%
		.all-day.selectable cursor:cell touch-action:none
		.all-day-event --event-color:$ui-accent pos:absolute h:5.5 box-sizing:border-box px:2 bd:2px solid $ui-surface rd:calc($ui-radius + 2px)
			bg:color-mix(in srgb, var(--event-color) 22%, var(--ui-surface)) c:$ui-text font:inherit fs:xs fw:500 ta:left ws:nowrap of:hidden text-overflow:ellipsis cursor:pointer
			@focus-visible outline:2px solid $ui-ring outline-offset:1px
		.all-day-event.continued rd:0 calc($ui-radius + 2px) calc($ui-radius + 2px) 0 bdl:none
		.all-day-event.blocked --event-color:$ui-muted
			background:repeating-linear-gradient(-45deg, color-mix(in srgb, var(--ui-muted) 20%, transparent) 0 2px, transparent 2px 8px), color-mix(in srgb, var(--ui-muted) 12%, var(--ui-surface))
		.more pos:absolute h:5.5 px:2 box-sizing:border-box bd:none bg:transparent c:$ui-muted font:inherit fs:11px fw:500 ta:left cursor:pointer
			@hover c:$ui-text td:underline

		.gutter pos:relative min-width:14 h:calc(var(--hour-height) * var(--hours))
		.hour pos:absolute r:2 transform:translateY(-50%) c:$ui-muted fs:11px ws:nowrap
			@first-child transform:translateY(2px)
		# Hour lines, with a fainter one at the half hour.
		.day pos:relative h:calc(var(--hour-height) * var(--hours)) bdl:1px solid $ui-border
			background-image:linear-gradient(var(--ui-border) 1px, transparent 1px), linear-gradient(color-mix(in srgb, var(--ui-border) 45%, transparent) 1px, transparent 1px)
			background-size:100% var(--hour-height), 100% var(--hour-height)
			background-position:0 0, 0 calc(var(--hour-height) / 2)
		.day.today bgc:color-mix(in srgb, $ui-accent 5%, transparent)
		.day.selectable cursor:cell touch-action:none
		# Pressing and dragging selects times, not the text on them.
		.day, .all-day, .event us:none
		&.placing .day cursor:copy
		# With resources over several days, a stronger line where each day starts.
		.two-rows > .day.first, .two-rows > .day-header bdl:1px solid $ui-muted

		.event, .all-day-event
			&[data-color=success] --event-color:$ui-success
			&[data-color=warning] --event-color:$ui-warning
			&[data-color=danger] --event-color:$ui-danger
			&[data-color=neutral] --event-color:$ui-muted
		.event --event-color:$ui-accent pos:absolute zi:1 d:flex fld:column g:0.5 box-sizing:border-box of:hidden py:1 px:1.5
			bd:2px solid $ui-surface bdl:3px solid var(--event-color) rd:0 calc($ui-radius + 2px) calc($ui-radius + 2px) 0
			bg:color-mix(in srgb, var(--event-color) 16%, var(--ui-surface)) c:$ui-text font:inherit fs:xs ta:left cursor:pointer
			@hover bg:color-mix(in srgb, var(--event-color) 24%, var(--ui-surface))
			@focus-visible outline:2px solid $ui-ring outline-offset:1px zi:3
		.event.editable touch-action:none
		# Short events: title and time on one line.
		.event.compact fld:row ai:center g:1.5 py:0 bdt:1px solid $ui-surface bdb:1px solid $ui-surface lh:1.2
		.event.dragging zi:4 cursor:grabbing shadow:$ui-shadow o:0.92
		# Blocked time: hatched and grey.
		.event.blocked --event-color:$ui-muted
			background:repeating-linear-gradient(-45deg, color-mix(in srgb, var(--ui-muted) 18%, transparent) 0 2px, transparent 2px 8px), color-mix(in srgb, var(--ui-muted) 10%, var(--ui-surface))
		# Saving: faded, and not draggable.
		.event.pending o:0.55 bdl:3px dashed var(--event-color) cursor:progress
		# Being placed elsewhere.
		.event.being-placed outline:2px dashed $ui-accent outline-offset:1px
		# Dropped here, it'd be refused.
		.event.invalid --event-color:$ui-danger bg:color-mix(in srgb, $ui-danger 14%, $ui-surface) cursor:not-allowed
		.event-title fw:600 ws:nowrap of:hidden text-overflow:ellipsis
		.event-time c:$ui-muted ws:nowrap
		# The bottom edge drags to resize.
		.resize pos:absolute l:0 r:0 b:0 h:2 cursor:ns-resize
			@after content:'' pos:absolute l:50% b:2px w:5 h:2px transform:translateX(-50%) rd:2px bg:var(--event-color) o:0 transition:opacity 120ms
		.event@hover .resize@after o:0.6

		.selection pos:absolute l:2px r:2px zi:2 box-sizing:border-box py:1 px:1.5 rd:calc($ui-radius + 2px)
			bg:color-mix(in srgb, var(--resource-color, var(--ui-accent)) 18%, transparent) bd:1px dashed var(--resource-color, var(--ui-accent))
			c:$ui-text fs:xs fw:500 pointer-events:none
		.all-day-selection t:2px b:2px l:auto r:auto
		.placing-selection bg:color-mix(in srgb, $ui-accent 12%, $ui-surface) bs:solid
		.selection.invalid bc:$ui-danger bg:color-mix(in srgb, $ui-danger 12%, transparent) c:$ui-danger
		# The slot under the pointer, in its resource's colour (grey where it can't be used).
		.hover pos:absolute l:0 r:0 zi:0 pointer-events:none bg:color-mix(in srgb, var(--resource-color, var(--ui-accent)) 12%, transparent)
		.hover.invalid bg:transparent
		.now pos:absolute l:0 r:0 zi:2 h:2px bg:$ui-danger pointer-events:none
			@before content:'' pos:absolute l:-4px t:-3px w:8px h:8px rd:full bg:$ui-danger
		# Where a dragged event came from.
		.ghost pos:absolute box-sizing:border-box bd:1px dashed $ui-border rd:calc($ui-radius + 2px) bg:color-mix(in srgb, $ui-muted 6%, transparent) pointer-events:none
		# Time that can't be used: hatched, with its reason on hover.
		.unavailable pos:absolute l:0 r:0 cursor:not-allowed
			background:repeating-linear-gradient(-45deg, color-mix(in srgb, var(--ui-muted) 14%, transparent) 0 1px, transparent 1px 7px), color-mix(in srgb, var(--ui-muted) 7%, transparent)

		# Placing a pinned event: a bar saying so, above the grid.
		.pinned-bar d:flex ai:center g:2 py:1.5 pr:1.5 pl:3 bd:1px dashed $ui-accent rd:calc($ui-radius + 2px)
			bg:color-mix(in srgb, $ui-accent 8%, $ui-surface) c:$ui-accent-soft-text fs:sm-
			> span flg:1

		# Scrolling inside `height`: header rows stick (each below the last; tops
		# set by the component), the gutter sticks left.
		.grid.scroll pos:relative of:auto
		.grid.scroll > .sticky pos:sticky zi:5 bgc:$ui-surface
		.grid.scroll > .corner, .grid.scroll > .all-day-label, .grid.scroll > .row-label l:0 zi:6
		.grid.scroll > .gutter pos:sticky l:0 zi:4 bg:$ui-surface
		# A header with its menu open (focus is in it) sits above the rows below.
		.grid.scroll > .sticky@focus-within zi:7

		.menu-anchor pos:fixed t:0 l:0 w:0 h:0 of:hidden pointer-events:none
		.status pos:absolute w:1px h:1px of:hidden clip:rect(0 0 0 0) ws:nowrap
