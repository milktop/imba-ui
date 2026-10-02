import 'imba/preflight.css'
import 'iconify-icon'
import '../src/index.imba'
import './demo.imba'
import './pages/buttons.imba'
import './pages/inputs.imba'
import './pages/pickers.imba'
import './pages/choices.imba'
import './pages/forms.imba'
import './pages/overlays.imba'

global css
	body m:0 bg:$ui-surface c:$ui-text ff:system-ui
	html.dark body bg:#09090b

const pages = [
	{ path: '/buttons', title: 'Buttons', about: 'Variants, sizes, icons, loading' }
	{ path: '/inputs', title: 'Inputs', about: 'Input, number input, textarea' }
	{ path: '/pickers', title: 'Pickers', about: 'Date picker, select, combobox' }
	{ path: '/choices', title: 'Choices', about: 'Checkbox and radio groups, switch, segmented' }
	{ path: '/forms', title: 'Forms', about: 'Fields, fieldsets, validation' }
	{ path: '/overlays', title: 'Overlays', about: 'Tooltip, dialog, menu, popover, toast' }
]

tag page-home
	css
		d:block
		h1 fs:xl fw:700 m:0
		p m:0 mt:1 c:$ui-muted fs:sm
		.cards d:grid gtc:1fr @sm:1fr 1fr g:4 mt:8
		a d:block p:4 bd:1px solid $ui-border rd:lg c:inherit td:none
			@hover bg:$ui-hover
		strong d:block fw:600
		span d:block mt:1 fs:sm c:$ui-muted
	<self>
		<h1> "Imba UI"
		<p> "Imba components on Zag state machines. Pick a group:"
		<div.cards> for page in pages
			<a route-to=page.path>
				<strong> page.title
				<span> page.about

tag playground
	dark = document.documentElement.classList.contains('dark')

	def toggleTheme
		dark = !dark
		document.documentElement.classList.toggle('dark', dark)

	css
		d:grid gtc:1fr @md:200px 1fr min-height:100vh
		.sidebar d:vflex g:4 p:4 @md:6 bdb:1px solid $ui-border @md:none
			@md bdr:1px solid $ui-border pos:sticky t:0 h:100vh box-sizing:border-box
		.brand d:hcs c:inherit td:none fw:700
		# A scrolling row of links on phones, a column on wider screens.
		nav d:hflex @md:vflex g:1 ofx:auto mx:-1 px:1
		nav a d:block px:3 py:1.5 rd:md c:$ui-muted fs:sm td:none ws:nowrap
			@hover c:$ui-text bg:$ui-hover
			&.active c:$ui-text bg:$ui-hover fw:500
		.theme mt:auto as:flex-start bd:1px solid $ui-border bg:transparent c:inherit rd:md px:3 py:1.5 fs:sm cursor:pointer
			@!md d:none
		.theme-sm bd:1px solid $ui-border bg:transparent c:inherit rd:md px:2 py:1 fs:xs cursor:pointer
			@md d:none
		main min-width:0 max-width:880px w:100% box-sizing:border-box p:4 @md:8

	<self>
		<aside.sidebar>
			<div.brand>
				<a route-to='/' [c:inherit td:none]> "Imba UI"
				<button.theme-sm @click=toggleTheme> dark ? "Light" : "Dark"
			<nav> for page in pages
				<a route-to=page.path> page.title
			<button.theme @click=toggleTheme> dark ? "Light" : "Dark"
		<main>
			<page-home route='/'>
			<page-buttons route='/buttons'>
			<page-inputs route='/inputs'>
			<page-pickers route='/pickers'>
			<page-choices route='/choices'>
			<page-forms route='/forms'>
			<page-overlays route='/overlays'>
		# One toaster for the app; pages call toaster.success(…) etc.
		<ui-toaster>

imba.mount <playground>
