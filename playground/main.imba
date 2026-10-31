import 'imba/preflight.css'
import 'iconify-icon'
import '../src/index.imba'
import { toaster } from '../src/toast/index.imba'
import { colorScheme } from '../src/color-scheme.imba'
import './demo.imba'
import { applyAppearance, loadAppearance } from './appearance.imba'
import './pages/theming.imba'
import './pages/headless.imba'
import './pages/tokens.imba'
import './pages/locale.imba'
import { repo } from './pages/installation.imba'
import pkg from '../package.json'
import './pages/button.imba'
import './pages/copy-button.imba'
import './pages/avatar.imba'
import './pages/badge.imba'
import './pages/kbd.imba'
import './pages/divider.imba'
import './pages/prose.imba'
import './pages/highlight.imba'
import './pages/rolling-number.imba'
import './pages/card.imba'
import './pages/table.imba'
import './pages/data-list.imba'
import './pages/stat.imba'
import './pages/charts.imba'
import './pages/timeline.imba'
import './pages/alert.imba'
import './pages/banner.imba'
import './pages/skeleton.imba'
import './pages/spinner.imba'
import './pages/empty-state.imba'
import './pages/progress.imba'
import './pages/collapsible.imba'
import './pages/tree-view.imba'
import './pages/sortable-list.imba'
import './pages/input.imba'
import './pages/number-input.imba'
import './pages/time-input.imba'
import './pages/textarea.imba'
import './pages/editable.imba'
import './pages/editor.imba'
import './pages/password-input.imba'
import './pages/phone-input.imba'
import './pages/pin-input.imba'
import './pages/slider.imba'
import './pages/tags-input.imba'
import './pages/file-upload.imba'
import './pages/attachments.imba'
import './pages/select.imba'
import './pages/date-picker.imba'
import './pages/date-range-filter.imba'
import './pages/event-calendar.imba'
import './pages/native-select.imba'
import './pages/swatch-picker.imba'
import './pages/checkbox.imba'
import './pages/radio-group.imba'
import './pages/switch.imba'
import './pages/segmented.imba'
import './pages/theme-toggle.imba'
import './pages/appearance-panel.imba'
import './pages/fields.imba'
import './pages/tooltip.imba'
import './pages/popover.imba'
import './pages/hover-card.imba'
import './pages/dialog.imba'
import './pages/confirm.imba'
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
		{ path: '/avatar', title: 'Avatar', about: 'Images with initials fallback, and groups' }
		{ path: '/badge', title: 'Badge', about: 'Statuses, counts and tags' }
		{ path: '/kbd', title: 'Kbd', about: 'Keys and shortcuts' }
		{ path: '/divider', title: 'Divider', about: 'Lines between things, with labels' }
		{ path: '/prose', title: 'Prose', about: 'Rich text, as the editor saved it' }
		{ path: '/highlight', title: 'Highlight', about: 'Search matches marked in text' }
		{ path: '/rolling-number', title: 'Rolling number', about: 'Digits that roll to a new value' }
		{ path: '/card', title: 'Card', about: 'Grouped content on a surface' }
		{ path: '/table', title: 'Table', about: 'Sorting, selection, paging' }
		{ path: '/data-list', title: 'Data list', about: 'Labels and values' }
		{ path: '/stat', title: 'Stat', about: 'Headline numbers and trends' }
		{ path: '/charts', title: 'Charts', about: 'Area, bar, donut and sparklines' }
		{ path: '/timeline', title: 'Timeline', about: 'Events down a line' }
	] }
	{ title: 'Feedback', icon: 'lucide:bell', pages: [
		{ path: '/alert', title: 'Alert', about: 'Messages in the page' }
		{ path: '/banner', title: 'Banner', about: 'Announcements across the page' }
		{ path: '/progress', title: 'Progress', about: 'Bars and circles' }
		{ path: '/skeleton', title: 'Skeleton', about: 'Loading placeholders' }
		{ path: '/spinner', title: 'Spinner', about: 'Short waits' }
		{ path: '/empty-state', title: 'Empty state', about: 'Nothing here yet' }
	] }
	{ title: 'Inputs', icon: 'lucide:text-cursor-input', pages: [
		{ path: '/input', title: 'Input', about: 'Text with icons, prefix and suffix' }
		{ path: '/password-input', title: 'Password input', about: 'Show/hide, new or current password' }
		{ path: '/phone-input', title: 'Phone input', about: 'Numbers with their country flag' }
		{ path: '/number-input', title: 'Number input', about: 'Steppers, clamping, formatting' }
		{ path: '/time-input', title: 'Time input', about: 'A time of day, typed or picked' }
		{ path: '/textarea', title: 'Textarea', about: 'Grows with its content' }
		{ path: '/editable', title: 'Editable', about: 'Text you click to edit in place' }
		{ path: '/editor', title: 'Editor', about: 'Rich text on TipTap' }
		{ path: '/tags-input', title: 'Tags input', about: 'Free-form tags' }
		{ path: '/pin-input', title: 'Pin input', about: 'Codes, one box per character' }
		{ path: '/slider', title: 'Slider', about: 'Single values and ranges' }
		{ path: '/file-upload', title: 'File upload', about: 'Dropzone with previews' }
		{ path: '/attachments', title: 'Attachments', about: 'Files added to a page or form' }
	] }
	{ title: 'Pickers', icon: 'lucide:list-checks', pages: [
		{ path: '/select', title: 'Select', about: 'Pick one or several; search, load or create' }
		{ path: '/date-picker', title: 'Date picker', about: 'Dates and ranges, keyboard stepping' }
		{ path: '/date-range-filter', title: 'Date range filter', about: 'Preset ranges beside a calendar' }
		{ path: '/event-calendar', title: 'Event calendar', about: 'Events by the hour: book, move, resize' }
		{ path: '/native-select', title: 'Native select', about: "The browser's own select, styled" }
		{ path: '/swatch-picker', title: 'Swatch picker', about: 'A colour from a few swatches' }
	] }
	{ title: 'Choices', icon: 'lucide:circle-check', pages: [
		{ path: '/checkbox', title: 'Checkbox', about: 'Single, groups and select-all' }
		{ path: '/radio-group', title: 'Radio group', about: 'One of a list, with descriptions' }
		{ path: '/switch', title: 'Switch', about: 'On/off toggles' }
		{ path: '/segmented', title: 'Segmented', about: 'A compact row of options' }
		{ path: '/theme-toggle', title: 'Theme toggle', about: 'Light, dark or the OS setting' }
		{ path: '/appearance', title: 'Appearance', about: 'Mode, accent and sidebar style' }
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
		{ path: '/confirm', title: 'Confirm', about: 'Await a yes or no from anywhere' }
		{ path: '/sheet', title: 'Sheet', about: 'Panels that slide in from an edge' }
		{ path: '/action-bar', title: 'Action bar', about: 'Actions for a selection' }
		{ path: '/menu', title: 'Menu', about: 'Dropdowns and context menus' }
		{ path: '/toast', title: 'Toast', about: 'Notifications' }
	] }
	{ title: 'Disclosure', icon: 'lucide:chevrons-up-down', pages: [
		{ path: '/tabs', title: 'Tabs', about: 'Panels behind tabs' }
		{ path: '/accordion', title: 'Accordion', about: 'Expandable sections' }
		{ path: '/collapsible', title: 'Collapsible', about: 'A section that opens and closes' }
		{ path: '/tree-view', title: 'Tree view', about: 'Nested items that open and close' }
		{ path: '/sortable-list', title: 'Sortable list', about: 'Rows put in order by dragging' }
	] }
]

tag page-home
	css
		d:block
		h1 fs:xl fw:700 m:0
		p m:0 mt:1 c:$ui-muted fs:sm
		h2 fs:xs fw:600 tt:uppercase ls:0.05em c:$ui-muted m:0 mt:8 mb:3
		.cards d:grid gtc:1fr @sm:1fr 1fr @lg:1fr 1fr 1fr g:3
		a d:block p:3 bg:$ui-surface bd:1px solid $ui-border rd:lg c:inherit td:none shadow:$ui-card-shadow
			@hover bc:$ui-muted
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
		# The version, as a quiet pill after the name.
		.version px:1.5 py:0.5 rd:full bg:$ui-hover c:$ui-muted fs:11px fw:500 lh:1 font-variant-numeric:tabular-nums
		# The ⌘K trigger: a search box on wide screens, an icon on phones.
		.search w:auto @md:56 px:2.5 @md:3
			>>> .text d:none @md:block
		.github d:inline-flex ai:center jc:center w:$ui-control-height-sm h:$ui-control-height-sm rd:$ui-radius c:$ui-muted fs:lg
			@hover c:$ui-text bg:$ui-hover
			@focus-visible outline:2px solid $ui-ring-soft
		.mark d:inline-flex ai:center jc:center w:7 h:7 fls:0 rd:$ui-radius bg:$ui-accent c:$ui-accent-text fs:xs fw:700

	# ⌘K: every page, then a few actions.
	commands = [
		...groups.flatMap do(group) group.pages.map do(page)
			{ label: page.title, description: page.about, href: page.path, icon: group.icon, group: group.title }
		...blocks.map do(block)
			{ label: block.title, description: block.about, href: block.path, icon: block.icon, group: 'Blocks' }
		{ label: 'Theming', description: 'Ways to change the look, app to part', href: '/theming', icon: 'lucide:palette', group: 'Guides' }
		{ label: 'Headless', description: 'The unstyled tags, and styling your own', href: '/headless', icon: 'lucide:box', group: 'Guides', keywords: ['base', 'unstyled'] }
		{ label: 'Tokens', description: 'Every $ui-* variable, light and dark', href: '/tokens', icon: 'lucide:swatch-book', group: 'Guides', keywords: ['variables', 'colours', 'css'] }
		{ label: 'Locale', description: 'Language, dates and numbers', href: '/locale', icon: 'lucide:languages', group: 'Guides' }
		{ label: 'Installation', description: 'Install, configure Vite, import', href: '/installation', icon: 'lucide:download', group: 'Guides' }
		{ label: 'GitHub', description: 'Source, releases and issues', href: repo, icon: 'mdi:github', group: 'Guides', keywords: ['repo', 'source'] }
		{ label: 'Toggle sidebar', value: 'sidebar', icon: 'lucide:panel-left', shortcut: '⌘B', group: 'Playground' }
		{ label: 'Light theme', value: 'light', icon: 'lucide:sun', group: 'Playground', keywords: ['appearance', 'mode'] }
		{ label: 'Dark theme', value: 'dark', icon: 'lucide:moon', group: 'Playground', keywords: ['appearance', 'mode'] }
	]

	def run command
		if command == 'sidebar'
			document.querySelector('ui-app-shell').toggle!
		elif command == 'light' or command == 'dark'
			colorScheme.value = command

	def account action
		toaster.info(title: "Picked “{action}”")

	# Home, then the page's group and the page.
	# The appearance panel's Width, or by default: blocks wide, components default.
	get pageWidth
		let chosen = document.documentElement.dataset.pageWidth
		return chosen if chosen and chosen != 'auto'
		router.pathname.startsWith('/blocks/') ? 'wide' : 'default'

	get trail
		for group in groups
			for page in group.pages
				return [{ label: 'Imba UI', href: '/' }, { label: group.title }, { label: page.title }] if page.path == router.pathname
		for block in blocks
			return [{ label: 'Imba UI', href: '/' }, { label: 'Blocks' }, { label: block.group }, { label: block.title }] if block.path == router.pathname
		return [{ label: 'Imba UI', href: '/' }, { label: 'Theming' }] if router.pathname == '/theming'
		return [{ label: 'Imba UI', href: '/' }, { label: 'Headless' }] if router.pathname == '/headless'
		return [{ label: 'Imba UI', href: '/' }, { label: 'Tokens' }] if router.pathname == '/tokens'
		return [{ label: 'Imba UI', href: '/' }, { label: 'Locale' }] if router.pathname == '/locale'
		return [{ label: 'Imba UI', href: '/' }, { label: 'Installation' }] if router.pathname == '/installation'
		[{ label: 'Imba UI', href: '/' }, { label: 'Overview' }]

	<self>
		<ui-app-shell persist='imba-ui:sidebar' inset=(document.documentElement.dataset.layout == 'inset')>
			# An accordion: opening a group closes the others; the group holding the
			# current page opens as you navigate.
			<ui-sidebar accordion>
				<a.brand slot='logo' href='/'>
					<span.mark> "UI"
					<span> "Imba UI"
					<span.version title='Version'> "v{pkg.version}"
				<span.mark slot='logo-collapsed'> "UI"
				<ui-nav-section>
					<ui-nav-item icon='lucide:house' href='/' active=(router.pathname == '/')> "Overview"
					<ui-nav-item icon='lucide:palette' href='/theming' active=(router.pathname == '/theming')> "Theming"
					<ui-nav-item icon='lucide:box' href='/headless' active=(router.pathname == '/headless')> "Headless"
					<ui-nav-item icon='lucide:swatch-book' href='/tokens' active=(router.pathname == '/tokens')> "Tokens"
					<ui-nav-item icon='lucide:languages' href='/locale' active=(router.pathname == '/locale')> "Locale"
					<ui-nav-item icon='lucide:download' href='/installation' active=(router.pathname == '/installation')> "Installation"
				<ui-nav-section heading='Components'>
					for group in groups
						<ui-nav-group key=group.title label=group.title icon=group.icon open=group.pages.some(do $1.path == router.pathname)>
							for page in group.pages
								<ui-nav-item key=page.path href=page.path active=(router.pathname == page.path)> page.title
				<ui-nav-section heading='Blocks'>
					for group in ['Sections', 'Pages']
						<ui-nav-group key=group label=group icon=(group == 'Pages' ? 'lucide:app-window' : 'lucide:layout-panel-top') open=blocks.some(do $1.group == group and $1.path == router.pathname)>
							for block in blocks.filter(do $1.group == group)
								<ui-nav-item key=block.path href=block.path active=(router.pathname == block.path)> block.title
				<ui-sidebar-user slot='footer' name='Ada Lovelace' description='ada@example.com' @select=account(e.detail)>
					<ui-menu-item value='profile' icon='lucide:user'> "Profile"
					<ui-menu-item value='settings' icon='lucide:settings' shortcut='⌘,'> "Settings"
					<ui-submenu label='Theme' icon='lucide:palette'>
						<ui-menu-radio-group bind=colorScheme.value>
							<ui-menu-radio value='light' icon='lucide:sun'> "Light"
							<ui-menu-radio value='dark' icon='lucide:moon'> "Dark"
							<ui-menu-radio value='system' icon='lucide:monitor'> "System"
					<ui-menu-separator>
					<ui-menu-item value='logout' icon='lucide:log-out' danger> "Log out"
			<ui-topbar>
				<ui-breadcrumbs items=trail>
				<div slot='end'>
					<ui-command$command items=commands @select=run(e.detail)>
						<ui-command-trigger.search slot='trigger' size='sm' aria-label='Search'>
					<a.github href=repo target='_blank' rel='noopener' aria-label='GitHub repository'>
						<iconify-icon icon='mdi:github' aria-hidden='true'>
					<appearance-panel>
			<ui-page width=pageWidth align=(document.documentElement.dataset.pageAlign or 'center')>
				<page-home route='/'>
				<page-theming route='/theming'>
				<page-headless route='/headless'>
				<page-tokens route='/tokens'>
				<page-locale route='/locale'>
				<page-installation route='/installation'>
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
				<page-kbd route='/kbd'>
				<page-divider route='/divider'>
				<page-prose route='/prose'>
				<page-highlight route='/highlight'>
				<page-rolling-number route='/rolling-number'>
				<page-card route='/card'>
				<page-table route='/table'>
				<page-data-list route='/data-list'>
				<page-stat route='/stat'>
				<page-charts route='/charts'>
				<page-timeline route='/timeline'>
				<page-alert route='/alert'>
				<page-banner route='/banner'>
				<page-skeleton route='/skeleton'>
				<page-spinner route='/spinner'>
				<page-empty-state route='/empty-state'>
				<page-progress route='/progress'>
				<page-collapsible route='/collapsible'>
				<page-tree-view route='/tree-view'>
				<page-sortable-list route='/sortable-list'>
				<page-input route='/input'>
				<page-number-input route='/number-input'>
				<page-time-input route='/time-input'>
				<page-textarea route='/textarea'>
				<page-editable route='/editable'>
				<page-editor route='/editor'>
				<page-password-input route='/password-input'>
				<page-phone-input route='/phone-input'>
				<page-pin-input route='/pin-input'>
				<page-slider route='/slider'>
				<page-tags-input route='/tags-input'>
				<page-file-upload route='/file-upload'>
				<page-attachments route='/attachments'>
				<page-select route='/select'>
				<page-date-picker route='/date-picker'>
				<page-date-range-filter route='/date-range-filter'>
				<page-event-calendar route='/event-calendar'>
				<page-native-select route='/native-select'>
				<page-swatch-picker route='/swatch-picker'>
				<page-checkbox route='/checkbox'>
				<page-radio-group route='/radio-group'>
				<page-switch route='/switch'>
				<page-segmented route='/segmented'>
				<page-theme-toggle route='/theme-toggle'>
				<page-appearance-panel route='/appearance'>
				<page-fields route='/fields'>
				<page-tooltip route='/tooltip'>
				<page-popover route='/popover'>
				<page-hover-card route='/hover-card'>
				<page-dialog route='/dialog'>
				<page-confirm route='/confirm'>
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
