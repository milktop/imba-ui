import 'imba/preflight.css'
import 'iconify-icon'
import '../src/index.imba'
import { toaster } from '../src/toast/index.imba'
import './demo.imba'
import { applyAppearance, loadAppearance } from './appearance.imba'
import './pages/button.imba'
import './pages/copy-button.imba'
import './pages/avatar.imba'
import './pages/badge.imba'
import './pages/card.imba'
import './pages/table.imba'
import './pages/data-list.imba'
import './pages/stat.imba'
import './pages/charts.imba'
import './pages/timeline.imba'
import './pages/alert.imba'
import './pages/skeleton.imba'
import './pages/spinner.imba'
import './pages/empty-state.imba'
import './pages/progress.imba'
import './pages/collapsible.imba'
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
import './pages/hover-card.imba'
import './pages/dialog.imba'
import './pages/sheet.imba'
import './pages/action-bar.imba'
import './pages/menu.imba'
import './pages/toast.imba'
import './pages/tabs.imba'
import './pages/accordion.imba'
import './pages/app-shell.imba'
import './pages/breadcrumbs.imba'
import './pages/command.imba'
import { blocks } from './blocks.imba'

global css
	body m:0 bg:$ui-surface c:$ui-text ff:system-ui
	html.dark body bg:#09090b

# One page per component, grouped in the sidebar.
const groups = [
	{ title: 'Actions', icon: 'lucide:mouse-pointer-click', pages: [
		{ path: '/button', title: 'Button', about: 'Variants, sizes, icons, loading' }
		{ path: '/copy-button', title: 'Copy button', about: 'Copy text with feedback' }
	] }
	{ title: 'Display', icon: 'lucide:layout-grid', pages: [
		{ path: '/avatar', title: 'Avatar', about: 'Images with initials fallback' }
		{ path: '/badge', title: 'Badge', about: 'Statuses and counts' }
		{ path: '/card', title: 'Card', about: 'Grouped content on a surface' }
		{ path: '/table', title: 'Table', about: 'Sorting, selection, paging' }
		{ path: '/data-list', title: 'Data list', about: 'Labels and values' }
		{ path: '/stat', title: 'Stat', about: 'Headline numbers and trends' }
		{ path: '/charts', title: 'Charts', about: 'Area, bar and sparklines' }
		{ path: '/timeline', title: 'Timeline', about: 'Events down a line' }
	] }
	{ title: 'Feedback', icon: 'lucide:bell', pages: [
		{ path: '/alert', title: 'Alert', about: 'Messages in the page' }
		{ path: '/progress', title: 'Progress', about: 'Bars and circles' }
		{ path: '/skeleton', title: 'Skeleton', about: 'Loading placeholders' }
		{ path: '/spinner', title: 'Spinner', about: 'Short waits' }
		{ path: '/empty-state', title: 'Empty state', about: 'Nothing here yet' }
	] }
	{ title: 'Inputs', icon: 'lucide:text-cursor-input', pages: [
		{ path: '/input', title: 'Input', about: 'Text with icons, prefix and suffix' }
		{ path: '/password-input', title: 'Password input', about: 'Show/hide, new or current password' }
		{ path: '/number-input', title: 'Number input', about: 'Steppers, clamping, formatting' }
		{ path: '/textarea', title: 'Textarea', about: 'Grows with its content' }
		{ path: '/tags-input', title: 'Tags input', about: 'Free-form tags' }
		{ path: '/pin-input', title: 'Pin input', about: 'Codes, one box per character' }
		{ path: '/slider', title: 'Slider', about: 'Single values and ranges' }
		{ path: '/file-upload', title: 'File upload', about: 'Dropzone with previews' }
	] }
	{ title: 'Pickers', icon: 'lucide:list-checks', pages: [
		{ path: '/select', title: 'Select', about: 'One or more from a list' }
		{ path: '/combobox', title: 'Combobox', about: 'Filter as you type, or search a server' }
		{ path: '/date-picker', title: 'Date picker', about: 'Dates and ranges, keyboard stepping' }
	] }
	{ title: 'Choices', icon: 'lucide:circle-check', pages: [
		{ path: '/checkbox', title: 'Checkbox', about: 'Single, groups and select-all' }
		{ path: '/radio-group', title: 'Radio group', about: 'One of a list, with descriptions' }
		{ path: '/switch', title: 'Switch', about: 'On/off toggles' }
		{ path: '/segmented', title: 'Segmented', about: 'A compact row of options' }
	] }
	{ title: 'Forms', icon: 'lucide:clipboard-list', pages: [
		{ path: '/fields', title: 'Fields', about: 'Grid, labels, hints, errors, fieldsets' }
	] }
	{ title: 'Navigation', icon: 'lucide:compass', pages: [
		{ path: '/app-shell', title: 'App shell', about: 'Sidebar, top bar and page' }
		{ path: '/breadcrumbs', title: 'Breadcrumbs', about: 'Where the page sits, with folding' }
		{ path: '/command', title: 'Command menu', about: '⌘K search and actions' }
	] }
	{ title: 'Overlays', icon: 'lucide:layers', pages: [
		{ path: '/tooltip', title: 'Tooltip', about: 'Hints on hover and focus' }
		{ path: '/popover', title: 'Popover', about: 'Floating panels' }
		{ path: '/hover-card', title: 'Hover card', about: 'Previews on hover' }
		{ path: '/dialog', title: 'Dialog', about: 'Modals and confirmations' }
		{ path: '/sheet', title: 'Sheet', about: 'Panels that slide in from an edge' }
		{ path: '/action-bar', title: 'Action bar', about: 'Actions for a selection' }
		{ path: '/menu', title: 'Menu', about: 'Dropdowns and context menus' }
		{ path: '/toast', title: 'Toast', about: 'Notifications' }
	] }
	{ title: 'Disclosure', icon: 'lucide:chevrons-up-down', pages: [
		{ path: '/tabs', title: 'Tabs', about: 'Panels behind tabs' }
		{ path: '/accordion', title: 'Accordion', about: 'Expandable sections' }
		{ path: '/collapsible', title: 'Collapsible', about: 'A section that opens and closes' }
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

# The playground runs in ui-app-shell: one nav group per component group.
tag playground
	css
		.brand d:flex ai:center g:2 c:inherit td:none
		# The ⌘K trigger: a search box on wide screens, an icon on phones.
		.search d:flex ai:center g:2 h:8 pl:2.5 pr:2.5 @md:1.5 w:auto @md:56 box-sizing:border-box bd:1px solid $ui-border rd:$ui-radius bg:$ui-surface c:$ui-muted ff:inherit fs:sm cursor:pointer
			@hover c:$ui-text bc:$ui-muted
			@focus-visible outline:2px solid $ui-ring-soft
			.search-text d:none @md:block flg:1 ta:left
			kbd d:none @md:inline-flex ai:center h:5 px:1.5 bd:1px solid $ui-border rd:sm bg:$ui-hover ff:inherit fs:11px
		.mark d:inline-flex ai:center jc:center w:7 h:7 fls:0 rd:$ui-radius bg:$ui-accent c:$ui-accent-text fs:xs fw:700

	accountItems = [
		{ label: 'Profile', value: 'profile', icon: 'lucide:user' }
		{ label: 'Settings', value: 'settings', icon: 'lucide:settings', shortcut: '⌘,' }
		{ separator: true }
		{ label: 'Log out', value: 'logout', icon: 'lucide:log-out', danger: true }
	]

	# ⌘K: every page, then a few actions.
	commands = [
		...groups.flatMap do(group) group.pages.map do(page)
			{ label: page.title, description: page.about, href: page.path, icon: group.icon, group: group.title }
		...blocks.map do(block)
			{ label: block.title, description: block.about, href: block.path, icon: block.icon, group: 'Blocks' }
		{ label: 'Toggle sidebar', value: 'sidebar', icon: 'lucide:panel-left', shortcut: '⌘B', group: 'Playground' }
		{ label: 'Light theme', value: 'light', icon: 'lucide:sun', group: 'Playground', keywords: ['appearance', 'mode'] }
		{ label: 'Dark theme', value: 'dark', icon: 'lucide:moon', group: 'Playground', keywords: ['appearance', 'mode'] }
	]

	def run command
		if command == 'sidebar'
			document.querySelector('ui-app-shell').toggle!
		elif command == 'light' or command == 'dark'
			document.querySelector('appearance-panel').update(scheme: command)

	def account action
		toaster.info(title: "Picked “{action}”")

	# Home, then the page's group and the page.
	get trail
		for group in groups
			for page in group.pages
				return [{ label: 'Imba UI', href: '/' }, { label: group.title }, { label: page.title }] if page.path == router.pathname
		for block in blocks
			return [{ label: 'Imba UI', href: '/' }, { label: 'Blocks' }, { label: block.group }, { label: block.title }] if block.path == router.pathname
		[{ label: 'Imba UI', href: '/' }, { label: 'Overview' }]

	<self>
		<ui-app-shell persist='imba-ui:sidebar' inset=(document.documentElement.dataset.layout == 'inset')>
			<ui-sidebar>
				<a.brand slot='logo' href='/'>
					<span.mark> "UI"
					<span> "Imba UI"
				<span.mark slot='logo-collapsed'> "UI"
				<ui-nav-section>
					<ui-nav-item icon='lucide:house' href='/' active=(router.pathname == '/')> "Overview"
				<ui-nav-section heading='Blocks'>
					for group in ['Sections', 'Pages']
						<ui-nav-group key=group label=group icon=(group == 'Pages' ? 'lucide:app-window' : 'lucide:layout-panel-top') open=yes>
							for block in blocks.filter(do $1.group == group)
								<ui-nav-item key=block.path href=block.path active=(router.pathname == block.path)> block.title
				<ui-nav-section heading='Components'>
					for group in groups
						<ui-nav-group key=group.title label=group.title icon=group.icon open=yes>
							for page in group.pages
								<ui-nav-item key=page.path href=page.path active=(router.pathname == page.path)> page.title
				<ui-sidebar-user slot='footer' name='Ada Lovelace' description='ada@example.com' items=accountItems @select=account(e.detail)>
			<ui-topbar>
				<ui-breadcrumbs items=trail>
				<div slot='end'>
					<ui-command$command items=commands @select=run(e.detail)>
						<button.search slot='trigger' type='button'>
							<iconify-icon icon='lucide:search' aria-hidden='true'>
							<span.search-text> "Search"
							<kbd> $command..hotkeyText
					<appearance-panel>
			<ui-page width=(router.pathname.startsWith('/blocks/') ? 'wide' : 'default')>
				<page-home route='/'>
				<page-block-headings route='/blocks/headings'>
				<page-block-panels route='/blocks/panels'>
				<page-block-lists route='/blocks/lists'>
				<page-block-forms route='/blocks/forms'>
				<page-block-feeds route='/blocks/feeds'>
				<page-block-banners route='/blocks/banners'>
				<page-block-dashboard route='/blocks/dashboard'>
				<page-block-profile route='/blocks/profile'>
				<page-block-detail route='/blocks/detail'>
				<page-block-list route='/blocks/table'>
				<page-block-settings route='/blocks/settings'>
				<page-block-sign-in route='/blocks/sign-in'>
				<page-block-empty-states route='/blocks/empty-states'>
				<page-button route='/button'>
				<page-copy-button route='/copy-button'>
				<page-avatar route='/avatar'>
				<page-badge route='/badge'>
				<page-card route='/card'>
				<page-table route='/table'>
				<page-data-list route='/data-list'>
				<page-stat route='/stat'>
				<page-charts route='/charts'>
				<page-timeline route='/timeline'>
				<page-alert route='/alert'>
				<page-skeleton route='/skeleton'>
				<page-spinner route='/spinner'>
				<page-empty-state route='/empty-state'>
				<page-progress route='/progress'>
				<page-collapsible route='/collapsible'>
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
				<page-hover-card route='/hover-card'>
				<page-dialog route='/dialog'>
				<page-sheet route='/sheet'>
				<page-action-bar route='/action-bar'>
				<page-menu route='/menu'>
				<page-toast route='/toast'>
				<page-tabs route='/tabs'>
				<page-accordion route='/accordion'>
				<page-app-shell route='/app-shell'>
				<page-breadcrumbs route='/breadcrumbs'>
				<page-command route='/command'>
		# One toaster for the app; pages call toaster.success(…) etc.
		<ui-toaster>

# Saved appearance first, so a reload doesn't flash the defaults.
applyAppearance(loadAppearance!)
imba.mount <playground>
