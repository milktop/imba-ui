import { subjects } from '../demo.imba'
import source from './combobox.imba?raw'

tag page-combobox
	searched = null
	many = []
	tutor = null

	# Fake server search with latency.
	def findTutors query
		const all = ['Ada Lovelace', 'Alan Turing', 'Grace Hopper', 'Katherine Johnson', 'Marie Curie', 'Rosalind Franklin'].map(do(name, i) { id: i + 1, name })
		await new Promise(do setTimeout($1, 400))
		all.filter(do $1.name.toLowerCase!.includes(query.toLowerCase!))

	<self>
		<demo-page source=source heading='Combobox' intro='ui-combobox is a text input that filters a list as you type, locally or from a server.'>
			<demo-section heading='Single'>
				<ui-fields>
					<ui-field span=6 label='Subject'>
						<ui-combobox items=subjects placeholder='Search subjects' bind=searched>
				<div.out>
					<json-print data={ searched }>
					<div.set>
						<button @click=(searched = 3)> "Physics"
						<button @click=(searched = null)> "Clear"

			<demo-section heading='Multiple'>
				<ui-fields>
					<ui-field span=6 label='Subjects' hint='Selections show as removable tags'>
						<ui-combobox items=subjects multiple placeholder='Add…' bind=many>
				<div.out>
					<json-print data={ many }>
					<div.set>
						<button @click=(many = [1, 5])> "Maths + Biology"

			<demo-section heading='Server search'>
				<ui-fields>
					<ui-field span=6 label='Tutor' hint='load(query) is called as you type (400ms fake latency)'>
						<ui-combobox load=findTutors labelKey='name' valueKey='id' placeholder='Type a name' @change=(tutor = e.detail)>
				<div.out>
					<json-print data={ tutor }>
