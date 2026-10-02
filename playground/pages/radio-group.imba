import source from './radio-group.imba?raw'

tag page-radio-group
	length = 45
	lengths = [
		{ value: 30, label: '30 minutes', description: 'A quick check-in or homework help' }
		{ value: 45, label: '45 minutes', description: 'Our most popular length' }
		{ value: 60, label: '60 minutes', description: 'Room for a full topic and practice' }
		{ value: 90, label: '90 minutes', description: 'Only for exam preparation', disabled: true }
	]
	level = null
	levels = ['GCSE', 'A level', 'University']

	<self>
		<demo-page source=source heading='Radio group' intro='ui-radio-group picks one of a list of options; arrow keys move the selection. For a compact row of short options see Segmented.'>
			<demo-section heading='With descriptions'>
				<ui-fields>
					<ui-field span=6 label='Lesson length'>
						<ui-radio-group items=lengths bind=length>
				<div.out>
					<json-print data={ length }>
					<div.set>
						<button @click=(length = 60)> "60 minutes"

			<demo-section heading='Horizontal'>
				<ui-fields>
					<ui-field span=6 label='Level' hint='Starts with nothing selected'>
						<ui-radio-group items=levels orientation='horizontal' bind=level>
				<div.out>
					<json-print data={ level }>
					<div.set>
						<button @click=(level = null)> "Clear"
