import source from './sortable-list.imba?raw'

# A row's content: the topic and how long it takes.
tag TopicRow
	prop item
	prop index
	prop dragging
	css d:flex ai:center jc:space-between g:3
		.minutes c:$ui-muted fs:xs font-variant-numeric:tabular-nums
	<self>
		<span> "{index + 1}. {item.title}"
		<span.minutes> "{item.minutes} min"

tag page-sortable-list
	topics = [
		{ id: 1, title: 'Warm-up questions', minutes: 5 }
		{ id: 2, title: 'Completing the square', minutes: 15 }
		{ id: 3, title: 'Worked examples', minutes: 10 }
		{ id: 4, title: 'Practice', minutes: 15 }
		{ id: 5, title: 'Exit quiz', minutes: 5 }
	]
	steps = ['Check the homework', 'Read chapter 4', 'Write a summary', 'Book the next lesson']
	moved = null

	<self>
		<demo-page source=source heading='Sortable list' intro="ui-sortable-list lets people put rows in order: drag a row by its grip, or focus the grip, press Space, move it with the arrow keys and press Space again (Escape puts it back). Screen readers hear each step.">
			<demo-section heading='Lesson plan'>
				<ui-sortable-list label='Lesson plan' itemTag=TopicRow bind=topics @move=(moved = e.detail)>
				<div.out>
					<json-print data={ order: topics.map(do $1.id), moved: moved and { title: moved.item.title, from: moved.from, to: moved.to } }>

			<demo-section heading='Plain rows, dragged anywhere'>
				<ui-sortable-list variant='plain' handle=no label='Steps' bind=steps>
				<div.out>
					<json-print data={ steps }>

			<demo-section heading='Disabled'>
				<ui-sortable-list items=steps disabled label='Steps, fixed'>
