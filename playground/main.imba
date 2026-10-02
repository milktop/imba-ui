import 'imba/preflight.css'
import 'iconify-icon'
import '../src/index.imba'
import './demo.imba'
import { applyAppearance, loadAppearance } from './appearance.imba'
import './pages/button.imba'
import './pages/input.imba'
import './pages/number-input.imba'
import './pages/textarea.imba'
import './pages/password-input.imba'
import './pages/pin-input.imba'
import './pages/slider.imba'
import './pages/tags-input.imba'
import './pages/file-upload.imba'
import './pages/select.imba'
import './pages/combobox.imba'
import './pages/date-picker.imba'
import './pages/checkbox.imba'
import './pages/radio-group.imba'
import './pages/switch.imba'
import './pages/segmented.imba'
import './pages/fields.imba'
import './pages/tooltip.imba'
import './pages/popover.imba'
import './pages/dialog.imba'
import './pages/menu.imba'
import './pages/toast.imba'
import './pages/tabs.imba'
import './pages/accordion.imba'

global css
	body m:0 bg:$ui-surface c:$ui-text ff:system-ui
	html.dark body bg:#09090b

# One page per component, grouped in the sidebar.
const groups = [
	{ title: 'Actions', pages: [
		{ path: '/button', title: 'Button', about: 'Variants, sizes, icons, loading' }
	] }
	{ title: 'Inputs', pages: [
		{ path: '/input', title: 'Input', about: 'Text with icons, prefix and suffix' }
		{ path: '/password-input', title: 'Password input', about: 'Show/hide, new or current password' }
		{ path: '/number-input', title: 'Number input', about: 'Steppers, clamping, formatting' }
		{ path: '/textarea', title: 'Textarea', about: 'Grows with its content' }
		{ path: '/tags-input', title: 'Tags input', about: 'Free-form tags' }
		{ path: '/pin-input', title: 'Pin input', about: 'Codes, one box per character' }
		{ path: '/slider', title: 'Slider', about: 'Single values and ranges' }
		{ path: '/file-upload', title: 'File upload', about: 'Dropzone with previews' }
	] }
	{ title: 'Pickers', pages: [
		{ path: '/select', title: 'Select', about: 'One or more from a list' }
		{ path: '/combobox', title: 'Combobox', about: 'Filter as you type, or search a server' }
		{ path: '/date-picker', title: 'Date picker', about: 'Dates and ranges, keyboard stepping' }
	] }
	{ title: 'Choices', pages: [
		{ path: '/checkbox', title: 'Checkbox', about: 'Single, groups and select-all' }
		{ path: '/radio-group', title: 'Radio group', about: 'One of a list, with descriptions' }
		{ path: '/switch', title: 'Switch', about: 'On/off toggles' }
		{ path: '/segmented', title: 'Segmented', about: 'A compact row of options' }
	] }
	{ title: 'Forms', pages: [
		{ path: '/fields', title: 'Fields', about: 'Grid, labels, hints, errors, fieldsets' }
	] }
	{ title: 'Overlays', pages: [
		{ path: '/tooltip', title: 'Tooltip', about: 'Hints on hover and focus' }
		{ path: '/popover', title: 'Popover', about: 'Floating panels' }
		{ path: '/dialog', title: 'Dialog', about: 'Modals and confirmations' }
		{ path: '/menu', title: 'Menu', about: 'Dropdowns of actions' }
		{ path: '/toast', title: 'Toast', about: 'Notifications' }
	] }
	{ title: 'Disclosure', pages: [
		{ path: '/tabs', title: 'Tabs', about: 'Panels behind tabs' }
		{ path: '/accordion', title: 'Accordion', about: 'Expandable sections' }
	] }
]

tag page-home
	css
		d:block
		h1 fs:xl fw:700 m:0
		p m:0 mt:1 c:$ui-muted fs:sm
		h2 fs:xs fw:600 tt:uppercase ls:0.05em c:$ui-muted m:0 mt:8 mb:3
		.cards d:grid gtc:1fr @sm:1fr 1fr @lg:1fr 1fr 1fr g:3
		a d:block p:3 bd:1px solid $ui-border rd:lg c:inherit td:none
			@hover bg:$ui-hover
		strong d:block fw:600 fs:sm
		span d:block mt:0.5 fs:xs c:$ui-muted
	<self>
		<h1> "Imba UI"
		<p> "Imba components on Zag state machines, one page each."
		for group in groups
			<h2> group.title
			<div.cards> for page in group.pages
				<a route-to=page.path>
					<strong> page.title
					<span> page.about

tag playground
	css
		d:grid gtc:1fr @md:210px 1fr min-height:100vh
		.sidebar d:vflex g:4 p:4 @md:5 min-width:0 bdb:1px solid $ui-border @md:none
			@md bdr:1px solid $ui-border pos:sticky t:0 h:100vh box-sizing:border-box ofy:auto
		.brand d:hcs fw:700
			a c:inherit td:none
		# A scrolling row of links on phones, grouped columns on wider screens.
		nav d:hflex @md:vflex fls:0 g:1 @md:4 ofx:auto @md:visible mx:-1 px:1
		.group d:contents @md:vflex g:0.5
		.group-title d:none @md:block px:3 mb:1 fs:xs fw:600 tt:uppercase ls:0.05em c:$ui-muted
		nav a d:block px:3 py:1.5 rd:md c:$ui-muted fs:sm td:none ws:nowrap
			@hover c:$ui-text bg:$ui-hover
			&.active c:$ui-text bg:$ui-hover fw:500
		main min-width:0 max-width:880px w:100% box-sizing:border-box p:4 @md:8

	<self>
		<aside.sidebar>
			<div.brand>
				<a route-to='/'> "Imba UI"
			<nav> for group in groups
				<div.group>
					<span.group-title> group.title
					for page in group.pages
						<a route-to=page.path> page.title
		<main>
			<page-home route='/'>
			<page-button route='/button'>
			<page-input route='/input'>
			<page-number-input route='/number-input'>
			<page-textarea route='/textarea'>
			<page-password-input route='/password-input'>
			<page-pin-input route='/pin-input'>
			<page-slider route='/slider'>
			<page-tags-input route='/tags-input'>
			<page-file-upload route='/file-upload'>
			<page-select route='/select'>
			<page-combobox route='/combobox'>
			<page-date-picker route='/date-picker'>
			<page-checkbox route='/checkbox'>
			<page-radio-group route='/radio-group'>
			<page-switch route='/switch'>
			<page-segmented route='/segmented'>
			<page-fields route='/fields'>
			<page-tooltip route='/tooltip'>
			<page-popover route='/popover'>
			<page-dialog route='/dialog'>
			<page-menu route='/menu'>
			<page-toast route='/toast'>
			<page-tabs route='/tabs'>
			<page-accordion route='/accordion'>
		<appearance-panel>
		# One toaster for the app; pages call toaster.success(…) etc.
		<ui-toaster>

# Saved appearance first, so a reload doesn't flash the defaults.
applyAppearance(loadAppearance!)
imba.mount <playground>
