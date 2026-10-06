import source from './menu.imba?raw'

tag page-menu
	selected = null
	actions = [
		{ value: 'edit', label: 'Edit', icon: 'lucide:pencil', shortcut: '⌘E' }
		{ value: 'duplicate', label: 'Duplicate', icon: 'lucide:copy', shortcut: '⌘D' }
		{ value: 'share', label: 'Share', icon: 'lucide:share-2', disabled: true }
		{ separator: true }
		{ value: 'delete', label: 'Delete', icon: 'lucide:trash-2', danger: true }
	]
	account = [
		{ value: 'profile', label: 'Profile', icon: 'lucide:user' }
		{ value: 'settings', label: 'Settings', icon: 'lucide:settings' }
		{ separator: true }
		{ value: 'logout', label: 'Log out', icon: 'lucide:log-out' }
	]
	lesson = [
		{ value: 'reschedule', label: 'Reschedule', icon: 'lucide:calendar-clock' }
		{ value: 'notes', label: 'Add notes', icon: 'lucide:notebook-pen' }
		{ separator: true }
		{ group: 'Student' }
		{ value: 'message', label: 'Send message', icon: 'lucide:message-square' }
		{ value: 'profile', label: 'View profile', icon: 'lucide:user' }
	]
	more = [
		{ group: 'Lesson' }
		{ value: 'reschedule', label: 'Reschedule', icon: 'lucide:calendar-clock' }
		{ value: 'notes', label: 'Add notes', icon: 'lucide:notebook-pen' }
		{ separator: true }
		{ group: 'Student' }
		{ value: 'message', label: 'Send message', icon: 'lucide:message-square' }
		{ value: 'profile', label: 'View profile', icon: 'lucide:user' }
	]
	file = [
		{ value: 'new', label: 'New lesson', icon: 'lucide:file-plus', shortcut: '⌘N' }
		{ label: 'Share', icon: 'lucide:share-2', items: [
			{ value: 'email', label: 'Email', icon: 'lucide:mail' }
			{ value: 'link', label: 'Copy link', icon: 'lucide:link' }
			{ label: 'Export', icon: 'lucide:download', items: [
				{ value: 'pdf', label: 'PDF' }
				{ value: 'csv', label: 'CSV' }
			] }
		] }
		{ separator: true }
		{ value: 'archive', label: 'Archive', icon: 'lucide:archive' }
	]
	view = [
		{ type: 'checkbox', value: 'grid', label: 'Show grid', checked: true }
		{ type: 'checkbox', value: 'rulers', label: 'Show rulers', shortcut: '⌘R' }
		{ separator: true }
		{ group: 'Sort by' }
		{ type: 'radio', name: 'sort', value: 'name', label: 'Name', checked: true }
		{ type: 'radio', name: 'sort', value: 'date', label: 'Date' }
		{ type: 'radio', name: 'sort', value: 'size', label: 'Size' }
	]
	changed = null
	clicked = null
	pages = [
		{ label: 'Buttons', icon: 'lucide:mouse-pointer-click', href: '/button' }
		{ label: 'Dialogs', icon: 'lucide:app-window', href: '/dialog' }
		{ separator: true }
		{ label: 'Copy page link', icon: 'lucide:link' }
	]
	showGrid = yes
	showRulers = no
	sort = 'name'

	css
		.area d:grid place-items:center h:32 w:100% bd:1px dashed $ui-border rd:$ui-radius c:$ui-muted fs:sm user-select:none
			&[data-state=open] bc:$ui-accent c:$ui-text

	<self>
		<demo-page source=source heading='Menu' intro='ui-menu is a dropdown of actions, and ui-context-menu the same on right-click. Items come from an `items` array or from child tags (ui-menu-item, ui-menu-group, ui-menu-separator, ui-submenu, ui-menu-checkbox, ui-menu-radio-group). Submenus nest, and checkbox and radio items keep their state. Arrow keys move through it, typing jumps to an item, and it emits `select` with the item’s value.'>
			<demo-section heading='Actions' uses='actions'>
				<ui-menu items=actions @select=(selected = e.detail)>
					<ui-button slot='trigger' iconEnd='lucide:chevron-down'> "Actions"
				<div.out>
					<json-print data={ selected }>
					<p.note> "Icons, shortcuts, a disabled item, a separator and a danger item."

			<demo-section heading='Actions as child tags'>
				<ui-menu @select=(selected = e.detail)>
					<ui-button slot='trigger' iconEnd='lucide:chevron-down'> "Actions"
					<ui-menu-item value='edit' icon='lucide:pencil' shortcut='⌘E'> "Edit"
					<ui-menu-item value='duplicate' icon='lucide:copy' shortcut='⌘D'> "Duplicate"
					<ui-menu-item value='share' icon='lucide:share-2' disabled> "Share"
					<ui-menu-separator>
					<ui-menu-item value='delete' icon='lucide:trash-2' danger> "Delete"
				<div.out>
					<json-print data={ selected }>
					<p.note> "The same menu written as markup: ui-menu-item takes the same options as `items` entries, and its content is the label."

			<demo-section heading='Groups, aligned to the end' uses='more'>
				<div.row>
					<span> "Maths with Ada, Thursday 16:00"
					<ui-menu items=more placement='bottom-end' @select=(selected = e.detail)>
						<ui-button slot='trigger' variant='ghost' icon='lucide:ellipsis' aria-label='More'>
				<div.out>
					<json-print data={ selected }>

			<demo-section heading='Label and sections' uses='account lesson'>
				<div.row>
					<ui-menu items=account label='My account' @select=(selected = e.detail)>
						<ui-button slot='trigger' iconEnd='lucide:chevron-down'> "Account"
					<ui-menu items=lesson label='Maths with Ada' @select=(selected = e.detail)>
						<ui-button slot='trigger' iconEnd='lucide:chevron-down'> "Lesson"
				<div.out>
					<json-print data={ selected }>
					<p.note> '`label` sits above the items. For sections, add `{ group: "Label" }` items (and `{ separator: true }` lines) between them.'

			<demo-section heading='Groups as child tags'>
				<ui-menu label='Maths with Ada' @select=(selected = e.detail)>
					<ui-button slot='trigger' iconEnd='lucide:chevron-down'> "Lesson"
					<ui-menu-group label='Lesson'>
						<ui-menu-item value='reschedule' icon='lucide:calendar-clock'> "Reschedule"
						<ui-menu-item value='notes' icon='lucide:notebook-pen'> "Add notes"
					<ui-menu-separator>
					<ui-menu-group label='Student'>
						<ui-menu-item value='message' icon='lucide:message-square'> "Send message"
						<ui-menu-item value='profile' icon='lucide:user'> "View profile"
				<div.out>
					<json-print data={ selected }>
					<p.note> "ui-menu-group wraps its items under a heading (marked up as a group for screen readers)."

			<demo-section heading='Submenus' uses='file'>
				<ui-menu items=file @select=(selected = e.detail)>
					<ui-button slot='trigger' iconEnd='lucide:chevron-down'> "File"
				<div.out>
					<json-print data={ selected }>
					<p.note> "An entry with its own `items` opens a submenu, on hover or the right arrow key. Submenus nest, and their selections reach the outer menu's `select`."

			<demo-section heading='Submenus as child tags'>
				<ui-menu @select=(selected = e.detail)>
					<ui-button slot='trigger' iconEnd='lucide:chevron-down'> "File"
					<ui-menu-item value='new' icon='lucide:file-plus' shortcut='⌘N'> "New lesson"
					<ui-submenu label='Share' icon='lucide:share-2'>
						<ui-menu-item value='email' icon='lucide:mail'> "Email"
						<ui-menu-item value='link' icon='lucide:link'> "Copy link"
						<ui-submenu label='Export' icon='lucide:download'>
							<ui-menu-item value='pdf'> "PDF"
							<ui-menu-item value='csv'> "CSV"
					<ui-menu-separator>
					<ui-menu-item value='archive' icon='lucide:archive'> "Archive"
				<div.out>
					<json-print data={ selected }>

			<demo-section heading='Items and child tags together' uses='account'>
				<ui-menu items=account @select=(selected = e.detail)>
					<ui-button slot='trigger' iconEnd='lucide:chevron-down'> "Account"
					<ui-menu-separator>
					<ui-submenu label='Theme' icon='lucide:palette' items=['Light', 'Dark', 'System']>
				<div.out>
					<json-print data={ selected }>
					<p.note> "Child tags follow the `items`. A ui-submenu takes `items` too, and a plain string is both an item's label and its value."

			<demo-section heading='Links and click handlers' uses='pages'>
				<div.row>
					<ui-menu items=pages @select=(selected = e.detail)>
						<ui-button slot='trigger' iconEnd='lucide:chevron-down'> "Go to"
					<ui-menu>
						<ui-button slot='trigger' iconEnd='lucide:chevron-down'> "More"
						<ui-menu-item href='/button' icon='lucide:mouse-pointer-click'> "Buttons"
						<ui-menu-item href='/dialog' icon='lucide:app-window'> "Dialogs"
						<ui-menu-separator>
						<ui-menu-item icon='lucide:link' @click=(clicked = 'Copy page link')> "Copy page link"
				<div.out>
					<json-print data={ selected: selected, clicked: clicked }>
					<p.note> 'Items with `href` are links (`<a>`, or `linkTag` for Inertia), so middle-click and "open in new tab" work. Neither needs a `value`: an item without one uses its label. A child tag can take its own `@click` (Enter clicks the highlighted item too).'

			<demo-section heading='Checkbox and radio items' uses='view'>
				<ui-menu items=view keepOpen @change=(changed = e.detail)>
					<ui-button slot='trigger' iconEnd='lucide:chevron-down'> "View"
				<div.out>
					<json-print data={ changed }>
					<p.note> 'Entries with `type: "checkbox"` or `type: "radio"` (one checked per `name`). The menu updates their `checked` and emits `change` with `{ type, name, value, checked }`; `keepOpen` keeps it open while you tick several.'

			<demo-section heading='Checkbox and radio items as child tags'>
				<ui-menu>
					<ui-button slot='trigger' iconEnd='lucide:chevron-down'> "View"
					<ui-menu-checkbox bind=showGrid keepOpen> "Show grid"
					<ui-menu-checkbox bind=showRulers shortcut='⌘R' keepOpen> "Show rulers"
					<ui-menu-separator>
					<ui-menu-radio-group bind=sort label='Sort by'>
						<ui-menu-radio value='name'> "Name"
						<ui-menu-radio value='date'> "Date"
						<ui-menu-radio value='size'> "Size"
				<div.out>
					<json-print data={ showGrid: showGrid, showRulers: showRulers, sort: sort }>
					<p.note> "ui-menu-checkbox and ui-menu-radio-group take `bind=` (or `checked` and `value` with `@change`). Here only the checkboxes have `keepOpen`, so picking a sort order closes the menu."

			<demo-section heading='Context menu' uses='actions'>
				<p.note> "ui-context-menu opens the same menu at the pointer when you right-click (or long-press) its area. It takes `items`, child tags and submenus like ui-menu."
				<ui-context-menu items=actions label='Lesson' @select=(selected = e.detail)>
					<div.area slot='trigger'> "Right-click here"
					<ui-menu-separator>
					<ui-submenu label='Move to' icon='lucide:folder-input'>
						<ui-menu-item value='maths'> "Maths"
						<ui-menu-item value='physics'> "Physics"
				<div.out>
					<json-print data={ selected }>
