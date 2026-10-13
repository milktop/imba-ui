import source from './tree-view.imba?raw'

const clinic = [
	{ value: 'north', label: 'North clinic', icon: 'lucide:building-2', children: [
		{ value: 'north-consult-1', label: 'Consult room 1', icon: 'lucide:door-open' }
		{ value: 'north-consult-2', label: 'Consult room 2', icon: 'lucide:door-open' }
		{ value: 'north-theatre', label: 'Theatre', icon: 'lucide:scissors' }
	] }
	{ value: 'south', label: 'South clinic', icon: 'lucide:building-2', children: [
		{ value: 'south-consult', label: 'Consult room', icon: 'lucide:door-open' }
		{ value: 'south-kennels', label: 'Kennels', children: [
			{ value: 'south-kennels-dogs', label: 'Dogs' }
			{ value: 'south-kennels-cats', label: 'Cats' }
		] }
	] }
	{ value: 'mobile', label: 'Mobile van', icon: 'lucide:truck', disabled: true }
]

tag page-tree-view
	picked = null
	selected = []
	open = ['north']
	granted = ['north-theatre']

	css
		ui-tree-view w:72

	<self>
		<demo-page source=source heading='Tree view' intro='ui-tree-view shows nested items that open and close. Arrow keys move through it (← → close and open), typing jumps, Enter selects.'>
			<demo-section heading='Sites and rooms'>
				<ui-tree-view items=clinic label='Rooms' bind=selected bind:expanded=open @select=(picked = e.detail.label)>
				<div.out>
					<json-print data={ picked, selected, open }>
					<div.set>
						<button @click=(open = ['north', 'south', 'south-kennels'])> "Open all"
						<button @click=(selected = ['south-consult'])> "Select the south consult room"

			<demo-section heading='With checkboxes'>
				<ui-tree-view items=clinic checkable bind:checked=granted expanded=['north', 'south']>
				<div.out>
					<json-print data={ granted }>
