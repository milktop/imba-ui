import source from './prose.imba?raw'

const notes = '<h2>Quadratics</h2><p>We worked through <strong>completing the square</strong> and when the formula is quicker.</p><ul><li>Factorise where you can</li><li>Otherwise use <code>x = (-b ± √(b² - 4ac)) / 2a</code></li></ul><blockquote>Check the discriminant first: it tells you how many roots to expect.</blockquote><p>Homework: <a href="#">worksheet 4</a>, questions 1–12.</p>'

tag page-prose
	<self>
		<demo-page source=source heading='Prose' intro='ui-prose styles rich text, such as the HTML a ui-editor saved, shown on a page. It looks like the editor, so what was written reads the same.'>
			<demo-section heading='Saved notes'>
				<ui-prose html=notes>

			<demo-section heading='Sizes, with markup'>
				<ui-prose size='sm'>
					<h3> "Small"
					<p> "For notes in a side panel or a card."
				<ui-prose size='lg'>
					<h3> "Large"
					<p> "For a page that's mostly reading."
