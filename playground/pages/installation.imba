import pkg from '../../package.json'

export const repo = 'https://github.com/milktop/imba-ui'

const version = "v{pkg.version}"

const install = """
npm install github:milktop/imba-ui#{version}
# or, while developing locally
npm install file:../../imba/ui
"""

const viteConfig = '''
// vite.config.js
export default defineConfig({
  optimizeDeps: { exclude: ['@milktop/imba-ui'] },
})
'''

const imports = '''
# Everything at once…
import '@milktop/imba-ui'

# …or only the components you use
import '@milktop/imba-ui/date-picker'
import '@milktop/imba-ui/select'
'''

const usage = '''
<ui-date-picker label='Lesson date' bind=lesson.date>
<ui-select label='Subject' items=subjects labelKey='name' valueKey='id' searchable bind=subjectId>
'''

const headless = '''
import '@milktop/imba-ui/date-picker/base'

tag lesson-date-picker < ui-date-picker-base
	css
		.cell rd:full
			&[data-selected] bg:$brand
'''

tag page-installation
	css
		d:block
		h1 fs:xl fw:700 m:0
		.intro m:0 mt:1 c:$ui-muted fs:sm
		section d:vflex g:3 py:5
		h2 fs:md fw:600 m:0
		p m:0 fs:sm lh:1.6
		code ff:mono fs:xs
		a c:$ui-accent-soft-text
		.links d:hflex flw:wrap g:2 mt:3

	<self>
		<h1> "Installation"
		<p.intro> "Add the package to an Imba app built with Vite, import the components, and use their tags."
		<div.links>
			<a href=repo target='_blank' rel='noopener'>
				<ui-badge variant='outline'> "GitHub"
			<a href="{repo}/tags" target='_blank' rel='noopener'>
				<ui-badge variant='outline'> "Latest: {version}"

		<section>
			<h2> "Install"
			<p>
				"The package ships Imba source rather than a build, so your app compiles it. Install a tagged version from "
				<a href="{repo}/tags" target='_blank' rel='noopener'> "GitHub"
				". Icons come with it ("
				<code> "iconify-icon"
				" is a dependency)."
			<code-block lang='sh' code=install>

		<section>
			<h2> "Configure Vite"
			<p>
				"Compile "
				<code> ".imba"
				" files with the Vite plugin from "
				<code> "@milktop/inertia-imba"
				", and keep Vite's dependency optimiser away from the package's source:"
			<code-block lang='js' code=viteConfig>

		<section>
			<h2> "Import"
			<p> "Import each component once, e.g. in the app's entry. Styled components bring the theme with them."
			<code-block code=imports>

		<section>
			<h2> "Use"
			<p>
				"Values are two-way: "
				<code> "bind="
				", "
				<code> "bind:value="
				", or "
				<code> "value"
				" with "
				<code> "@change"
				". They're plain values: ISO dates, and the items' own values."
			<code-block code=usage>

		<section>
			<h2> "Style"
			<p>
				"Brand the components with the "
				<a route-to='/theming'> "$ui-* tokens"
				". For a different look altogether, subclass a headless "
				<code> "ui-<name>-base"
				" tag and style its parts:"
			<code-block code=headless>

		<section>
			<h2> "Upgrade"
			<p> "Install the newer tag. Until 1.0, a minor version (0.2) may change props or markup; patch versions (0.1.1) only fix things. The changelog lists what changed."
