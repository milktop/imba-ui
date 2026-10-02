import source from './tags-input.imba?raw'

tag page-tags-input
	topics = ['fractions', 'algebra']
	emails = []

	def isEmail details do /^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(details.inputValue)

	<self>
		<demo-page source=source heading='Tags input' intro='ui-tags-input adds free-form tags with Enter or a comma. For picking from a fixed list, use a multiple Combobox. Tags are grey by default; variant="accent" or "outline" change that.'>
			<demo-section heading='Topics'>
				<ui-fields>
					<ui-field span=6 label='Topics covered' hint='Double-click a tag to edit it'>
						<ui-tags-input placeholder='Add a topic' bind=topics>
				<div.out>
					<json-print data={ topics }>
					<div.set>
						<button @click=(topics = ['geometry'])> "Only geometry"
						<button @click=(topics = [])> "Clear"

			<demo-section heading='Variants'>
				<ui-fields>
					<ui-field span=4 label='Subtle (default)'>
						<ui-tags-input bind=topics>
					<ui-field span=4 label='Accent'>
						<ui-tags-input variant='accent' bind=topics>
					<ui-field span=4 label='Outline'>
						<ui-tags-input variant='outline' bind=topics>
				<div.out>
					<div.set>
						<button @click=(topics = ['fractions', 'algebra', 'geometry', 'trigonometry', 'statistics', 'probability', 'calculus'])> "Fill with 7"

			<demo-section heading='Validated, with a limit'>
				<ui-fields>
					<ui-field span=6 label='Invite parents' hint='Valid emails only, up to 3; paste a list to add several'>
						<ui-tags-input placeholder='name@example.com' max=3 addOnPaste validate=isEmail bind=emails>
				<div.out>
					<json-print data={ emails }>
