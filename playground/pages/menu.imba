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

	css
		.area d:grid place-items:center h:32 w:100% bd:1px dashed $ui-border rd:$ui-radius c:$ui-muted fs:sm user-select:none
			&[data-state=open] bc:$ui-accent c:$ui-text

	<self>
		<demo-page source=source heading='Menu' intro='ui-menu is a dropdown of actions, and ui-context-menu the same on right-click. Arrow keys move through it, typing jumps to an item, and it emits `select` with the item’s value.'>
			<demo-section heading='Actions'>
				<ui-menu items=actions @select=(selected = e.detail)>
					<ui-button slot='trigger' iconEnd='lucide:chevron-down'> "Actions"
				<div.out>
					<json-print data={ selected }>
					<p.note> "Icons, shortcuts, a disabled item, a separator and a danger item."

			<demo-section heading='Groups, aligned to the end'>
				<div.row>
					<span> "Maths with Ada, Thursday 16:00"
					<ui-menu items=more placement='bottom-end' @select=(selected = e.detail)>
						<ui-button slot='trigger' variant='ghost' icon='lucide:ellipsis' aria-label='More'>
				<div.out>
					<json-print data={ selected }>

			<demo-section heading='Label and sections'>
				<div.row>
					<ui-menu items=account label='My account' @select=(selected = e.detail)>
						<ui-button slot='trigger' iconEnd='lucide:chevron-down'> "Account"
					<ui-menu items=lesson label='Maths with Ada' @select=(selected = e.detail)>
						<ui-button slot='trigger' iconEnd='lucide:chevron-down'> "Lesson"
				<div.out>
					<json-print data={ selected }>
					<p.note> '`label` sits above the items. For sections, add `{ group: "Label" }` items (and `{ separator: true }` lines) between them.'

			<demo-section heading='Context menu'>
				<p.note> "ui-context-menu opens the same menu at the pointer when you right-click (or long-press) its area."
				<ui-context-menu items=actions label='Lesson' @select=(selected = e.detail)>
					<div.area slot='trigger'> "Right-click here"
				<div.out>
					<json-print data={ selected }>
