import source from './native-select.imba?raw'

tag page-native-select
	species = 'Cat'
	room = null
	rooms = [
		{ value: 1, label: 'Consult 1', group: 'Ground floor' }
		{ value: 2, label: 'Consult 2', group: 'Ground floor' }
		{ value: 3, label: 'Surgery', group: 'First floor' }
		{ value: 4, label: 'Recovery', group: 'First floor', disabled: true }
	]

	css
		.sizes ai:flex-end
		.sizes ui-native-select w:40

	<self>
		<demo-page source=source heading='Native select' intro="ui-native-select is the browser's own select, styled like the inputs: the phone's own picker, long lists without search, and plain form posts. For anything more, use ui-select.">
			<demo-section heading='Basic'>
				<ui-fields>
					<ui-field span=6 label='Species'>
						<ui-native-select items=['Dog', 'Cat', 'Rabbit', 'Guinea pig'] bind=species>
				<div.out>
					<json-print data={ species }>

			<demo-section heading='Groups and a placeholder'>
				<ui-fields>
					<ui-field span=6 label='Room' hint='Choosing the placeholder clears it'>
						<ui-native-select items=rooms placeholder='Pick a room' bind=room>
				<div.out>
					<json-print data={ room }>
					<div.set>
						<button @click=(room = 3)> "Surgery"

			<demo-section heading='Sizes, with its own label'>
				<div.row.sizes>
					<ui-native-select size='sm' label='Small' items=['One', 'Two']>
					<ui-native-select label='Medium' items=['One', 'Two']>
					<ui-native-select size='lg' label='Large' items=['One', 'Two']>
