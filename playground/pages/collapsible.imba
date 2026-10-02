import source from './collapsible.imba?raw'

tag page-collapsible
	more = no

	<self>
		<demo-page source=source heading='Collapsible' intro='ui-collapsible opens and closes a section with a height animation. For several related sections, see Accordion.'>
			<demo-section heading='With a heading'>
				<ui-collapsible heading='Lesson notes'>
					<p> "Covered fractions and decimals; homework is worksheet 4. Next week: percentages."

			<demo-section heading='Own trigger'>
				<p> "Ada has taught maths for twelve years and specialises in GCSE preparation."
				<ui-collapsible bind=more>
					<ui-button slot='trigger' variant='link' iconEnd=(more ? 'lucide:chevron-up' : 'lucide:chevron-down')> more ? "Show less" : "Show more"
					<p> "She studied mathematics at Cambridge and has helped over 200 students improve by at least two grades."
				<div.out>
					<json-print data={ more }>
					<div.set>
						<button @click=(more = !more)> "Toggle from outside"
