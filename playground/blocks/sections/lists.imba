import { students } from '../data.imba'

# People: avatar, name and email, a role, and a menu per row.
tag list-people
	items = [
		{ value: 'message', label: 'Message', icon: 'lucide:message-square' }
		{ value: 'profile', label: 'View profile', icon: 'lucide:user' }
		{ separator: true }
		{ value: 'remove', label: 'Remove', icon: 'lucide:user-minus', danger: true }
	]
	css
		ul d:flex fld:column m:0 p:0 list-style:none bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 4px)
		li d:flex ai:center g:3 px:4 py:3 bdb:1px solid $ui-border
			@last-child bdb:none
		.who flg:1 min-width:0
		.name fw:500
		.email c:$ui-muted fs:xs of:hidden text-overflow:ellipsis ws:nowrap
	<self>
		<ul> for student, i in students.slice(0, 5)
			<li>
				<ui-avatar name=student.name>
				<div.who>
					<div.name> student.name
					<div.email> student.email
				<ui-badge variant=(i == 0 ? 'accent' : 'neutral')> i == 0 ? 'Parent' : 'Student'
				<ui-menu items=items label=student.name placement='bottom-end'>
					<ui-button slot='trigger' size='sm' variant='ghost' icon='lucide:ellipsis' aria-label="Actions for {student.name}">

# Lessons: a date tile, what and when, and a status.
tag list-lessons
	lessons = [
		{ day: '08', month: 'Oct', title: 'Maths with Ada Lovelace', time: 'Thu 16:00–17:00 · Online', status: 'Confirmed' }
		{ day: '09', month: 'Oct', title: 'Physics with Alan Turing', time: 'Fri 10:00–10:45 · Room 4', status: 'Confirmed' }
		{ day: '12', month: 'Oct', title: 'English with Grace Hopper', time: 'Mon 15:30–16:30 · Online', status: 'Unpaid' }
	]
	css
		ul d:flex fld:column g:2 m:0 p:0 list-style:none
		li d:flex ai:center g:4 p:3 bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 4px)
		.date d:flex fld:column ai:center jc:center w:12 h:12 fls:0 rd:$ui-radius bg:$ui-accent-soft c:$ui-accent-soft-text lh:1
			b fs:lg fw:700
			span fs:xs tt:uppercase mt:0.5
		.what flg:1 min-width:0
		.title fw:500
		.time c:$ui-muted fs:xs mt:0.5
	<self>
		<ul> for lesson in lessons
			<li>
				<div.date>
					<b> lesson.day
					<span> lesson.month
				<div.what>
					<div.title> lesson.title
					<div.time> lesson.time
				<ui-badge variant=(lesson.status == 'Unpaid' ? 'warning' : 'success') dot> lesson.status

# Links: an icon, a title and a hint, and a chevron, as in a settings menu.
tag list-links
	links = [
		{ icon: 'lucide:user', title: 'Profile', hint: 'Name, photo and bio' }
		{ icon: 'lucide:calendar', title: 'Availability', hint: 'When students can book' }
		{ icon: 'lucide:credit-card', title: 'Payments', hint: 'Bank details and payouts' }
		{ icon: 'lucide:bell', title: 'Notifications', hint: 'Emails and reminders' }
	]
	css
		ul m:0 p:0 list-style:none bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 4px) of:hidden max-width:28rem
		a d:flex ai:center g:3 px:4 py:3 c:inherit td:none bdb:1px solid $ui-border
			@hover bg:$ui-hover
			@focus-visible outline:2px solid $ui-ring-soft outline-offset:-2px
		li@last-child a bdb:none
		.icon d:grid place-items:center w:8 h:8 rd:$ui-radius bg:$ui-hover c:$ui-muted fs:16px
		.text flg:1
		.title fw:500
		.hint c:$ui-muted fs:xs
		.chevron c:$ui-muted
	<self>
		<ul> for link in links
			<li>
				<a href='#'>
					<span.icon> <iconify-icon icon=link.icon>
					<div.text>
						<div.title> link.title
						<div.hint> link.hint
					<iconify-icon.chevron icon='lucide:chevron-right'>

export const examples = [
	{ heading: 'People', tag: 'list-people' }
	{ heading: 'Lessons', tag: 'list-lessons' }
	{ heading: 'Links', tag: 'list-links' }
]
