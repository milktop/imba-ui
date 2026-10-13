import source from './event-calendar.imba?raw'
import { toaster } from '../../src/toast/index.imba'
import { confirm } from '../../src/confirm/index.imba'
import { fr } from '../../src/locale.imba'

# Days of this week (Monday + offset), so there's always something to see.
const pad = do(n) String(n).padStart(2, '0')
def dayOf offset
	let d = new Date
	d.setDate(d.getDate! - ((d.getDay! + 6) % 7) + offset)
	"{d.getFullYear!}-{pad(d.getMonth! + 1)}-{pad(d.getDate!)}"
const todayIso = dayOf((new Date().getDay! + 6) % 7)
def addDay iso
	let d = new Date("{iso.slice(0, 10)}T00:00")
	d.setDate(d.getDate! + 1)
	"{d.getFullYear!}-{pad(d.getMonth! + 1)}-{pad(d.getDate!)}{iso.slice(10)}"
const minutesOf = do(iso) Number(iso.slice(11, 13)) * 60 + Number(iso.slice(14, 16))

const initialLessons = [
	{ id: 1, title: 'Ada Lovelace', subject: 'Maths', start: "{dayOf(0)}T16:00", end: "{dayOf(0)}T17:00" }
	{ id: 2, title: 'Alan Turing', subject: 'Physics', start: "{dayOf(0)}T17:30", end: "{dayOf(0)}T18:15", color: 'success' }
	{ id: 3, title: 'Grace Hopper', subject: 'English', start: "{dayOf(1)}T10:00", end: "{dayOf(1)}T11:00", color: 'warning' }
	{ id: 4, title: 'Katherine Johnson', subject: 'Maths', start: "{dayOf(2)}T15:00", end: "{dayOf(2)}T16:30" }
	{ id: 5, title: 'Margaret Hamilton', subject: 'Chemistry', start: "{dayOf(2)}T15:30", end: "{dayOf(2)}T16:30", color: 'danger' }
	{ id: 6, title: 'Tim Berners-Lee', subject: 'Physics', start: "{dayOf(3)}T09:00", end: "{dayOf(3)}T10:00", color: 'success' }
	{ id: 7, title: 'Ada Lovelace', subject: 'Maths', start: "{dayOf(3)}T16:00", end: "{dayOf(3)}T17:00" }
	{ id: 8, title: 'Barbara Liskov', subject: 'Computing', start: "{dayOf(4)}T13:00", end: "{dayOf(4)}T14:30", color: 'neutral' }
	{ id: 10, title: 'Half term', start: dayOf(4), end: dayOf(6), allDay: yes, color: 'neutral' }
	{ id: 11, title: 'Mock exams', start: dayOf(1), end: dayOf(2), allDay: yes, color: 'warning' }
	{ id: 9, title: 'Study group', subject: 'Revision', start: "{dayOf(5)}T10:00", end: "{dayOf(5)}T12:00", color: '#8b5cf6' }
]

const vets = [
	{ id: 'jones', title: 'Dr Jones', role: 'Small animals', color: 'teal' }
	{ id: 'patel', title: 'Dr Patel', role: 'Surgery', color: 'purple' }
	{ id: 'okafor', title: 'Dr Okafor', role: 'Exotics', color: 'orange' }
	{ id: 'nurse', title: 'Nurse Kim', role: 'Vaccinations', color: 'blue' }
]
const kindColor = { Consult: 'accent', Surgery: 'danger', Vaccination: 'success', 'Check-up': 'neutral' }
const speciesIcon = { dog: 'lucide:dog', cat: 'lucide:cat', rabbit: 'lucide:rabbit', bird: 'lucide:bird' }
def at vet, from, to, pet, species, owner, kind
	{ id: "{vet}-{from}", resourceId: vet, start: "{todayIso}T{from}", end: "{todayIso}T{to}", title: pet, pet, species, owner, kind, color: kindColor[kind] }
const initialAppointments = [
	at('jones', '09:00', '09:15', 'Biscuit', 'dog', 'A. Lovelace', 'Consult')
	at('jones', '09:30', '10:00', 'Mittens', 'cat', 'A. Turing', 'Check-up')
	at('jones', '11:00', '11:15', 'Rex', 'dog', 'G. Hopper', 'Consult')
	at('patel', '09:00', '11:30', 'Luna', 'dog', 'K. Johnson', 'Surgery')
	at('patel', '13:00', '14:00', 'Oscar', 'cat', 'M. Hamilton', 'Surgery')
	at('okafor', '10:00', '10:30', 'Thumper', 'rabbit', 'T. Berners-Lee', 'Consult')
	at('okafor', '10:15', '10:45', 'Kiwi', 'bird', 'B. Liskov', 'Check-up')
	at('nurse', '09:15', '09:30', 'Poppy', 'dog', 'D. Knuth', 'Vaccination')
	at('nurse', '09:30', '09:45', 'Smudge', 'cat', 'R. Perlman', 'Vaccination')
	at('nurse', '14:00', '14:15', 'Bella', 'dog', 'F. Allen', 'Vaccination')
]
# Each vet's hours and lunch, as minutes of the day.
const hours = {
	jones: { from: 8 * 60, to: 17 * 60, lunch: [12 * 60 + 30, 13 * 60 + 30], note: 'Dr Jones works 8:00 to 17:00' }
	patel: { from: 9 * 60, to: 18 * 60, lunch: [13 * 60, 14 * 60], note: 'Dr Patel works 9:00 to 18:00' }
	okafor: { from: 8 * 60, to: 13 * 60, note: 'Dr Okafor works mornings only' }
	nurse: { from: 8 * 60, to: 16 * 60, lunch: [12 * 60, 12 * 60 + 30], note: 'Nurse Kim works 8:00 to 16:00' }
}

# A vet's header: avatar, name and role.
tag VetHeader
	prop resource
	css d:flex ai:center g:2 min-width:0 ta:left
		.name d:block fw:500 of:hidden text-overflow:ellipsis ws:nowrap
		.role d:block fs:xs fw:400 c:$ui-muted of:hidden text-overflow:ellipsis ws:nowrap
	<self>
		<ui-avatar size='sm' name=resource.title.replace('Dr ', '') color=resource.color>
		<span [min-width:0]>
			<span.name> resource.title
			<span.role> resource.role

# An appointment: the pet's species and name, the owner, and its kind.
tag AppointmentBlock
	prop event
	prop compact
	css d:flex fld:column g:0.5 min-width:0
		&.compact fld:row ai:center g:1.5
		.pet d:flex ai:center g:1.5 min-width:0 fw:600
		.owner c:$ui-muted of:hidden text-overflow:ellipsis ws:nowrap
	<self .compact=compact>
		if event.blocked
			<span [fw:500 c:$ui-muted]> event.title
		else
			<span.pet>
				<iconify-icon icon=speciesIcon[event.species]>
				<span [of:hidden text-overflow:ellipsis ws:nowrap]> event.pet
			<span.owner> event.owner
			<span> <ui-badge size='sm'> event.kind unless compact

# The day's messages for the team, in a row above the all-day strip.
tag DayMessages
	prop date
	css d:flex flw:wrap g:1
		button cursor:pointer rd:sm bd:none px:1.5 py:0.5 fs:11px c:white bg:#f59e0b
			&.urgent bg:#ef4444
	<self>
		for message in (closest('page-event-calendar')..messages or []).filter(do $1.date == date.toLocaleDateString('sv'))
			<button .urgent=message.urgent type='button' @click.stop=toaster.info(title: message.text)> message.text

# Presences: who's in each day, and when.
const staff = [
	{ id: 'jones', title: 'Dr Jones', color: '#0d9488', surgery: yes }
	{ id: 'patel', title: 'Dr Patel', color: '#7c3aed', surgery: yes }
	{ id: 'okafor', title: 'Dr Okafor', color: '#d97706', surgery: no }
	{ id: 'nurse', title: 'Nurse Kim', color: '#2563eb', surgery: no }
]
const periodHours = {
	day: [{ start: '08:00', end: '12:30' }, { start: '13:30', end: '18:00' }]
	am: [{ start: '08:00', end: '13:00' }]
	pm: [{ start: '13:00', end: '18:00' }]
}
const periodName = { day: 'all day', am: 'mornings', pm: 'afternoons' }
def visit_ id, vet, from, to, pet, owner, kind
	{ id, resourceId: vet, start: "{todayIso}T{from}", end: "{todayIso}T{to}", title: pet, pet, owner, kind }

# A present vet's header: who, when, and a menu to change their day.
tag PresenceVet
	prop resource
	css d:flex ai:center g:2 w:100% min-width:0 ta:left
		.text flg:1 min-width:0
		.name d:block of:hidden text-overflow:ellipsis ws:nowrap
		.when d:block fs:xs fw:400 c:$ui-muted
	# It renders from its props (the period is on the resource): a tag whose
	# props don't change isn't rendered again.
	get page do closest('page-event-calendar')
	get period do resource.period
	<self>
		<ui-avatar size='sm' name=resource.title.replace(/^(Dr|Nurse) /, '') color='auto'>
		<span.text>
			<span.name> resource.title
			<span.when> periodName[period]
		<ui-menu placement='bottom-end' @select.stop=(e.detail == 'remove' and page.removeVet(resource)) @change.stop=page.changePeriod(resource, e.detail.value)
			items=[
				{ type: 'radio', name: "period-{resource.id}", value: 'am', label: 'Morning', checked: period == 'am' }
				{ type: 'radio', name: "period-{resource.id}", value: 'pm', label: 'Afternoon', checked: period == 'pm' }
				{ type: 'radio', name: "period-{resource.id}", value: 'day', label: 'All day', checked: period == 'day' }
				{ separator: yes }
				{ label: 'Remove from this day', value: 'remove', icon: 'lucide:user-minus', danger: yes }
			]>
			<ui-button slot='trigger' size='sm' variant='ghost' icon='lucide:ellipsis' aria-label="{resource.title}'s day">

# A lesson in the work week: the student's avatar, name and subject.
tag LessonCard
	prop event
	css d:flex ai:flex-start g:1.5 min-width:0
		.name d:block fw:600 of:hidden text-overflow:ellipsis ws:nowrap
		.subject d:block c:$ui-muted of:hidden text-overflow:ellipsis ws:nowrap
	<self>
		<ui-avatar size=5 name=event.title color='auto'>
		<span [min-width:0]>
			<span.name> event.title
			<span.subject> event.subject

# French: busy all-day events, enough to fold the strip.
const busy = [0, 1, 2, 3].map do(n)
	{ id: "fete-{n}", title: ['Formation', 'Inventaire', 'Congrès', 'Portes ouvertes'][n], start: dayOf(n % 2), end: dayOf(2 + (n % 2)), allDay: yes, color: ['accent', 'success', 'warning', 'neutral'][n] }

tag page-event-calendar
	# A tutor's week.
	lessons = initialLessons
	view = 'week'
	date = todayIso
	range = ''

	def book slot
		let when = slot.allDay ? (slot.start == slot.end ? slot.start : "{slot.start} to {slot.end}") : "{slot.start.slice(0, 10)}, {slot.start.slice(11)} to {slot.end.slice(11)}"
		return unless await confirm(heading: (slot.allDay ? 'Add an all-day event?' : 'Book a lesson?'), description: when, confirmLabel: (slot.allDay ? 'Add' : 'Book'))
		lessons = [...lessons, slot.allDay ? { id: Date.now!, title: 'Day off', start: slot.start, end: slot.end, allDay: yes, color: 'neutral' } : { id: Date.now!, title: 'New lesson', subject: 'Maths', start: slot.start, end: slot.end }]

	def openDay day
		date = day
		view = 'day'

	def moveLesson detail
		lessons = lessons.map(do $1.id == detail.event.id ? Object.assign({}, $1, detail.change) : $1)

	# A vet clinic's day.
	appointments = initialAppointments
	pinned = null
	messages = [
		{ id: 1, date: todayIso, text: 'X-ray machine serviced at 14:00', urgent: yes }
		{ id: 2, date: todayIso, text: 'Order more rabies vaccine' }
	]
	clinicRows = [{ key: 'messages', label: 'Messages', tag: DayMessages, clickable: yes }]

	# The clinic's rules, in one place: hours, lunch, days away, clashes.
	def available q
		let vet = hours[q.resourceId]
		return yes if !vet or q.allDay
		let away = appointments.find(do $1.allDay and $1.resourceId == q.resourceId and $1.start <= q.start.slice(0, 10) and $1.end >= q.start.slice(0, 10))
		return "{vets.find(do $1.id == q.resourceId).title} is away" if away
		let from = minutesOf(q.start)
		let to = minutesOf(q.end)
		return vet.note if from < vet.from or to > vet.to
		return 'Lunch' if vet.lunch and from < vet.lunch[1] and to > vet.lunch[0]
		# Clashes only for bookings and drops: the shading needn't show them.
		return yes if q.shading
		let clash = appointments.find(do !$1.allDay and $1 != q.event and $1.resourceId == q.resourceId and $1.start < q.end and $1.end > q.start)
		clash ? "Clashes with {clash.pet}" : yes

	# Saved after a moment: pending meanwhile.
	def updateAppointment detail
		let id = detail.event.id
		appointments = appointments.map(do $1.id == id ? Object.assign({}, $1, detail.change, { pending: yes }) : $1)
		pinned = null
		setTimeout(&, 900) do
			appointments = appointments.map(do $1.id == id ? Object.assign({}, $1, { pending: no }) : $1)
			imba.commit!

	# Shift held, or a whole day: block it instead of booking it.
	def bookVet slot
		let vet = vets.find(do $1.id == slot.resourceId)
		if slot.keys..shiftKey or slot.allDay
			appointments = [...appointments, { id: "block-{Date.now!}", resourceId: slot.resourceId, start: slot.start, end: slot.end, allDay: slot.allDay, blocked: yes, title: (slot.allDay ? 'Away' : 'Blocked'), color: 'neutral' }]
			return toaster.info(title: "{vet.title}: {slot.allDay ? 'away' : 'time blocked'}")
		appointments = [...appointments, { id: "new-{Date.now!}", resourceId: slot.resourceId, start: slot.start, end: slot.end, title: 'New patient', pet: 'New patient', species: 'dog', owner: '—', kind: 'Consult', color: 'accent' }]
		toaster.success(title: "Booked with {vet.title}", description: "{slot.start.slice(11)} to {slot.end.slice(11)}")

	# Right-click (or the Menu key on a focused appointment).
	def appointmentMenu a
		if a.blocked
			return [{ label: 'Unblock', icon: 'lucide:unlock', onSelect: (do appointments = appointments.filter(do $1.id != a.id)) }]
		[
			{ group: "{a.pet} ({a.owner})" }
			{ label: 'Open', icon: 'lucide:file-text', onSelect: (do toaster.info(title: a.pet, description: a.kind)) }
			{ label: 'Move…', icon: 'lucide:move', onSelect: (do pinned = a) }
			{ label: 'Duplicate tomorrow', icon: 'lucide:copy', onSelect: (do appointments = [...appointments, Object.assign({}, a, { id: "{a.id}-copy-{Date.now!}", start: addDay(a.start), end: addDay(a.end) })]) }
			{ separator: yes }
			{ label: 'Cancel appointment', icon: 'lucide:x', danger: yes, onSelect: (do
				if await confirm(heading: "Cancel {a.pet}'s appointment?", danger: yes, confirmLabel: 'Cancel it', cancelLabel: 'Keep')
					appointments = appointments.filter(do $1.id != a.id)
					imba.commit!) }
		]

	def slotActions slot
		return [{ label: 'Mark away all day', icon: 'lucide:plane', onSelect: (do bookVet(slot)) }] if slot.allDay
		[
			{ label: "Book {slot.start.slice(11)}", icon: 'lucide:calendar-plus', onSelect: (do bookVet(slot)) }
			{ label: 'Block this time', icon: 'lucide:ban', onSelect: (do bookVet(Object.assign({}, slot, { keys: { shiftKey: yes } }))) }
		]

	def addMessage detail
		let text = globalThis.prompt('Message for the team')
		messages = [...messages, { id: Date.now!, date: detail.date, text }] if text

	# The same week, in French: its words and dates.
	# Presences: the vets in each day (other days: Dr Jones and Nurse Kim).
	presenceDate = todayIso
	presences = { [todayIso]: { jones: 'day', patel: 'am', nurse: 'day' } }
	visits = [
		visit_('a1', 'jones', '09:00', '09:30', 'Biscuit', 'A. Lovelace', 'Consult')
		visit_('a2', 'jones', '14:00', '15:30', 'Luna', 'K. Johnson', 'Surgery')
		visit_('a3', 'patel', '10:00', '10:30', 'Mittens', 'A. Turing', 'Consult')
		visit_('a4', 'nurse', '09:15', '09:30', 'Poppy', 'D. Knuth', 'Vaccination')
		Object.assign(visit_('a5', 'nurse', '11:00', '11:30', 'Kiwi', 'B. Liskov', 'Consult'), { color: 'danger' })
	]

	get presentToday do presences[presenceDate] or { jones: 'day', nurse: 'day' }

	def setPresent next
		presences = Object.assign({}, presences, { [presenceDate]: next })

	# The columns: the vets in that day, available for their period. Kept
	# while they don't change, so the calendar's shading stays cached.
	get presentVets
		let present = presentToday
		let key = JSON.stringify(present)
		unless #vetsKey == key
			#vetsKey = key
			#vets = staff.filter(do present[$1.id]).map do(v)
				Object.assign({}, v, { period: present[v.id], hours: periodHours[present[v.id]], offLabel: (present[v.id] == 'day' ? 'Lunch break' : "{v.title} works {periodName[present[v.id]]}") })
		#vets

	get absentVets do staff.filter(do !presentToday[$1.id]).map(do { label: $1.title, value: $1.id })

	def visitClash q
		return yes if q.shading
		let clash = visits.find(do $1 != q.event and $1.resourceId == q.resourceId and $1.start < q.end and $1.end > q.start)
		clash ? "Clashes with {clash.pet}" : yes

	# Saved by a pretend server: pending meanwhile; surgery can't go to a vet who doesn't operate.
	def saveVisit detail
		let before = detail.event
		visits = visits.map(do $1.id == before.id ? Object.assign({}, $1, detail.change, { pending: yes }) : $1)
		setTimeout(&, 900) do
			let vet = staff.find(do $1.id == (detail.change.resourceId ?? before.resourceId))
			let refused = before.kind == 'Surgery' and !vet.surgery
			visits = visits.map(do $1.id == before.id ? (refused ? before : Object.assign({}, $1, { pending: no })) : $1)
			toaster.error(title: "{vet.title} doesn't do surgery", description: "{before.pet} stays with its vet.") if refused
			imba.commit!

	def bookVisit slot
		visits = [...visits, { id: "n{Date.now!}", resourceId: slot.resourceId, start: slot.start, end: slot.end, title: 'New patient', pet: 'New patient', owner: '—', kind: 'Consult' }]

	def removeVet vet
		let theirs = visits.filter(do $1.resourceId == vet.id and $1.start.startsWith(presenceDate)).length
		return toaster.error(title: "{vet.title} has {theirs} appointment{theirs > 1 ? 's' : ''} today", description: 'Move them to another vet first.') if theirs
		let rest = Object.assign({}, presentToday)
		delete rest[vet.id]
		setPresent(rest)

	# A vet's period changed: say which of their appointments are now outside it.
	def changePeriod vet, period
		setPresent(Object.assign({}, presentToday, { [vet.id]: period }))
		let clock = do(time) Number(time.slice(0, 2)) * 60 + Number(time.slice(3, 5))
		let outside = visits.filter do(v)
			v.resourceId == vet.id and v.start.startsWith(presenceDate) and !periodHours[period].some(do(h) minutesOf(v.start) >= clock(h.start) and minutesOf(v.end) <= clock(h.end))
		toaster.warning(title: "{vet.title} now works {periodName[period]}", description: "Outside those hours: {outside.map(do "{$1.pet} at {$1.start.slice(11)}").join(', ')}") if outside.length

	# French, with a full all-day strip.
	frenchEvents = [...initialLessons, ...busy]

	def addFrench slot
		frenchEvents = [...frenchEvents, { id: Date.now!, title: (slot.allDay ? 'Journée bloquée' : 'Nouveau cours'), start: slot.start, end: slot.end, allDay: slot.allDay, color: (slot.allDay ? 'neutral' : 'accent') }]

	# Selecting asks first (choosing it from the menu already says so).
	def askFrench slot
		let when = slot.allDay ? (slot.start == slot.end ? slot.start : "du {slot.start} au {slot.end}") : "{slot.start.slice(0, 10)}, de {slot.start.slice(11)} à {slot.end.slice(11)}"
		addFrench(slot) if await confirm(heading: (slot.allDay ? 'Bloquer ces journées ?' : 'Ajouter un cours ?'), description: when, confirmLabel: (slot.allDay ? 'Bloquer' : 'Ajouter'), cancelLabel: 'Annuler')

	def frenchMenu event
		[
			{ label: 'Ouvrir', icon: 'lucide:file-text', onSelect: (do toaster.info(title: event.title)) }
			{ separator: yes }
			{ label: 'Supprimer', icon: 'lucide:trash-2', danger: yes, onSelect: (do frenchEvents = frenchEvents.filter(do $1.id != event.id)) }
		]

	<self>
		<demo-page source=source heading='Event calendar' intro="ui-event-calendar shows events by the hour: a day, a few days or a week across, hours down, and optionally a column per resource. Select a time to book it, drag events to move or resize them (or use the keyboard), and shade what isn't available.">
			<demo-section heading='A tutor’s week' uses='book moveLesson openDay'>
				<ui-event-calendar events=lessons views=['day', 3, 'workweek', 'week'] selectable editable clickableDays bind:view=view bind:date=date
					@slotselect=book(e.detail) @eventchange=moveLesson(e.detail)
					@dayclick=openDay(e.detail)
					@rangechange=(range = "{e.detail.start} to {e.detail.end}")
					@eventclick=toaster.info(title: e.detail.title, description: e.detail.subject)>
				<div.out>
					<p.note> "Drag down an empty part of a day to select a time (or click a slot) and book it; drag along the all-day strip to add an all-day event. Drag a lesson to move it, or its bottom edge to change its length; or focus it and use the arrow keys (Shift+↑↓ for its length). Click the title to jump to a date, or a day's header to open that day."
					<json-print data={ view, date, range }>

			<demo-section heading='A vet clinic’s day' uses='available updateAppointment bookVet appointmentMenu slotActions addMessage'>
				<ui-event-calendar events=appointments resources=vets view='day' views=['day', 3] slotMinutes=15 hourHeight='5rem'
					startHour=8 endHour=18 height='34rem' scrollToTime='now' selectable editable clickableResources
					isAvailable=(do(q) available(q)) bind:pinned=pinned eventMenu=(do(a) appointmentMenu(a)) slotMenu=(do(slot) slotActions(slot)) rows=clinicRows
					eventTag=AppointmentBlock resourceTag=VetHeader eventLabel=(do(a) "{a.pet or a.title}, {a.kind or ''}")
					@eventchange=updateAppointment(e.detail) @slotselect=bookVet(e.detail) @rowclick=addMessage(e.detail)
					@unavailable=toaster.error(title: e.detail.reason)
					@resourceclick=toaster.info(title: e.detail.resource.title, description: e.detail.resource.role)
					@eventclick=(e.detail.blocked or toaster.info(title: "{e.detail.pet} ({e.detail.owner})", description: e.detail.kind, action: { label: 'Move…', onClick: (do pinned = e.detail) }))>
				<div.out>
					<p.note> "A column per vet, 15-minute slots, inside a fixed height that opens at the current time. Hours, lunch and clashes come from isAvailable (hatched, the reason on hover; bookings and drops there are refused). Hold Shift while selecting to block time; select in the all-day strip to mark a vet away. Moves save for a moment (pending). Right-click an appointment or an empty time for a menu; Move… places it anywhere (pinned). Click the messages row to add one."

			<demo-section heading='Presences, colours and saving' uses='visitClash saveVisit bookVisit removeVet changePeriod'>
				<ui-event-calendar events=visits resources=presentVets view='day' views=[] bind:date=presenceDate slotMinutes=15 hourHeight='4rem'
					startHour=8 endHour=18 height='30rem' scrollToTime='08:00' selectable editable resourceTag=PresenceVet eventTag=AppointmentBlock
					isAvailable=(do(q) visitClash(q)) eventLabel=(do(a) "{a.pet}, {a.kind}")
					@eventchange=saveVisit(e.detail) @slotselect=bookVisit(e.detail) @unavailable=toaster.error(title: e.detail.reason)>
					<div slot='actions' [d:contents]>
						if absentVets.length
							<ui-menu placement='bottom-end' items=absentVets @select.stop=setPresent(Object.assign({}, presentToday, { [e.detail]: 'day' }))>
								<ui-button slot='trigger' size='sm' icon='lucide:user-plus'> "Add a vet"
				<div.out>
					<p.note> "Who's in each day is managed here: Add a vet (toolbar), or a vet's ⋯ for morning, afternoon, all day or remove. A presence becomes the column's `hours` (with lunch on full days), so the rest of the day is shaded and refused with the reason. Appointments take their vet's colour unless they set one. Moves save through a pretend server: pending meanwhile, and moving surgery to Dr Okafor or Nurse Kim fails and rolls back."

			<demo-section heading='Weekdays, your own content'>
				<ui-event-calendar events=initialLessons.filter(do !$1.allDay) view='workweek' views=[] startHour=9 endHour=19 eventTag=LessonCard>
					<ui-button slot='actions' size='sm' variant='primary' icon='lucide:calendar-plus'> "Book"
				<div.out>
					<p.note> "`view='workweek'` and the hours you teach; `eventTag` draws each lesson; the `actions` slot sits in the toolbar. Without `selectable` or `editable` it's read only."

			<demo-section heading='In French, with a full all-day strip' uses='askFrench addFrench frenchMenu'>
				<ui-event-calendar events=frenchEvents locale='fr-FR' translations=fr.calendar views=['day', 'week'] allDayMax=3 startHour=8 endHour=20 selectable editable
					eventMenu=(do(event) frenchMenu(event)) slotMenu=(do(slot) [{ label: (slot.allDay ? 'Bloquer la journée' : "Ajouter un cours à {slot.start.slice(11)}"), icon: 'lucide:plus', onSelect: (do addFrench(slot)) }])
					@slotselect=askFrench(e.detail) @eventclick=toaster.info(title: e.detail.title)
					@eventchange=(frenchEvents = frenchEvents.map(do $1.id == e.detail.event.id ? Object.assign({}, $1, e.detail.change) : $1))>
				<div.out>
					<p.note> "`locale` sets its dates and times and `translations` its words (with uiLocale.set('fr-FR') the whole app follows instead). Past `allDayMax` lanes the all-day strip folds into “+2 de plus”; the label opens it. Editable like the others: select, move, resize, right-click."
