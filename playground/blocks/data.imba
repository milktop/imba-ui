# Made-up data shared by the blocks.

const first = ['Ada', 'Alan', 'Grace', 'Katherine', 'Margaret', 'Tim', 'Edsger', 'Barbara', 'Donald', 'Radia', 'Frances', 'John']
const last = ['Lovelace', 'Turing', 'Hopper', 'Johnson', 'Hamilton', 'Berners-Lee', 'Dijkstra', 'Liskov', 'Knuth', 'Perlman', 'Allen', 'McCarthy']
const subjectNames = ['Maths', 'English', 'Physics', 'Chemistry']
const statuses = ['Active', 'Active', 'Active', 'Paused', 'New']

export const students = Array.from(length: 30) do(_, i)
	let name = "{first[i % 12]} {last[(i * 5 + Math.floor(i / 12)) % 12]}"
	{
		id: i + 1
		name: name
		email: "{name.split(' ')[0].toLowerCase!}.{name.split(' ')[1].toLowerCase!}@example.com"
		year: 7 + (i * 3) % 7
		subject: subjectNames[i % 4]
		status: statuses[i % 5]
		lessons: (i * 13) % 40
	}

export const subjectItems = subjectNames.map do(name) { value: name, label: name }

export const upcoming = [
	{ id: 1, student: 'Ada Lovelace', subject: 'Maths', when: 'Today, 16:00', length: '60 min' }
	{ id: 2, student: 'Alan Turing', subject: 'Physics', when: 'Today, 17:30', length: '45 min' }
	{ id: 3, student: 'Grace Hopper', subject: 'English', when: 'Tomorrow, 10:00', length: '60 min' }
	{ id: 4, student: 'Katherine Johnson', subject: 'Maths', when: 'Thu, 15:00', length: '90 min' }
	{ id: 5, student: 'Margaret Hamilton', subject: 'Chemistry', when: 'Fri, 11:00', length: '60 min' }
]

export const activity = [
	{ title: 'Invoice paid by Alan Turing', time: '2h ago', color: 'success', description: '£140 for September' }
	{ title: 'Lesson booked with Grace Hopper', time: '5h ago', color: 'accent' }
	{ title: 'Ada Lovelace cancelled', time: 'Yesterday', color: 'danger', description: 'Rescheduled for Thursday' }
	{ title: 'New student: Radia Perlman', time: '2 days ago' }
]
