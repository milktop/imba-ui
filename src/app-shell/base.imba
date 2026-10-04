import { icons } from '../icons.imba'
import '../tooltip/base.imba'
import '../menu/base.imba'
import '../avatar/base.imba'

# Headless app layout: a sidebar with the logo and navigation, a top bar and
# the page.
#
#   <ui-app-shell persist='sidebar'>
#     <ui-sidebar>
#       <app-logo slot='logo'>
#       <ui-nav-section heading='Menu'>
#         <ui-nav-item icon='lucide:home' href='/' active=isHome> 'Dashboard'
#         <ui-nav-group icon='lucide:settings' label='Settings'>
#           <ui-nav-item href='/settings/billing'> 'Billing'
#       <div slot='footer'> …
#     <ui-topbar>
#       …search…
#       <div slot='end'> …
#     <ui-page heading='Students'> …
#
# On wide screens the sidebar collapses to an icon rail (its button, or
# ⌘/Ctrl+B); labels then show as tooltips and groups open as a flyout. Below
# `breakpoint` px it becomes a drawer, opened from the top bar's menu button
# and closed by Escape, the backdrop or following a link.
#
# - `collapsed`: bindable (`bind=` or `bind:collapsed=`)
# - `persist`: a localStorage key to remember the collapsed state
# - `inset`: the page becomes a rounded panel inset from the edges, with the
#   sidebar and top bar flat around it
#
# The parts find the shell by walking up the DOM, so they can be subclassed
# or wrapped freely.

# Finds the nearest ancestor with `flag` set (shell, sidebar, …).
export def closestWith el, flag
	let node = el.parentElement
	node = node.parentElement until !node or node[flag]
	node

tag ui-app-shell-base
	prop collapsed = false
	prop persist = null
	prop breakpoint = 768
	prop inset = false

	isUiAppShell = yes
	drawerOpen = no
	mobile = no

	# `bind=` targets `data`, which aliases `collapsed` here.
	get data do collapsed
	set data v do collapsed = v

	# The rail only exists on wide screens; on phones the sidebar is a drawer.
	get rail do collapsed and !mobile

	def setup
		if persist
			try
				let saved = globalThis.localStorage.getItem(persist)
				data = saved == 'true' if saved != null

	def mount
		#media = globalThis.matchMedia("(max-width: {breakpoint - 1}px)")
		#onMedia = do
			mobile = #media.matches
			drawerOpen = no unless mobile
			refresh!
		#media.addEventListener('change', #onMedia)
		#onMedia!
		#onKey = do(e)
			if e.key == 'Escape' and drawerOpen
				closeDrawer!
			# Not in rich text editors, where it means bold.
			elif (e.metaKey or e.ctrlKey) and e.key.toLowerCase! == 'b' and !mobile and !e.target.isContentEditable
				e.preventDefault!
				toggle!
		globalThis.addEventListener('keydown', #onKey)

	# Re-renders the shell and its parts at once. They were rendered by the app,
	# maybe before the shell was in the page, and the app's next commit waits
	# for an animation frame.
	def refresh
		# Where the main area starts, for things fixed to the viewport that
		# should centre over it (ui-action-bar).
		let left = mobile ? '0px' : (rail ? 'var(--ui-sidebar-rail-width)' : 'var(--ui-sidebar-width)')
		globalThis.document.documentElement.style.setProperty('--ui-main-left', left)
		render!
		# `commit` renders and runs the `rendered` hook.
		for part in querySelectorAll('[data-ui-shell-part]')
			part.commit!
		imba.commit!

	def unmount
		globalThis.document.documentElement.style.removeProperty('--ui-main-left')
		#media..removeEventListener('change', #onMedia)
		globalThis.removeEventListener('keydown', #onKey)

	# Collapses the sidebar, or on phones opens and closes the drawer.
	def toggle
		return (drawerOpen ? closeDrawer! : openDrawer!) if mobile
		data = !data
		try globalThis.localStorage.setItem(persist, String(data)) if persist
		emit('collapsechange', data)
		refresh!

	def openDrawer
		#returnFocus = globalThis.document.activeElement
		drawerOpen = yes
		refresh!

	def closeDrawer
		return unless drawerOpen
		drawerOpen = no
		refresh!
		#returnFocus..focus!

	<self .rail=rail .mobile=mobile .inset=inset .drawer-open=drawerOpen>
		<slot>
		if mobile and drawerOpen
			<div.backdrop @click=closeDrawer>

# The sidebar: logo, navigation (its default slot, or `items`) and a footer.
#
# `items`: sections as data, e.g.
#   [{ heading: 'Menu', items: [{ label, icon, href, active, badge, items }] }]
tag ui-sidebar-base
	prop items = null
	prop label = 'Main'
	# A thin strip along the right edge that collapses or expands it on click.
	prop edge = true

	isUiSidebar = yes

	# Tags for `items`; the styled sidebar uses the styled ones.
	sectionTag = 'ui-nav-section-base'
	groupTag = 'ui-nav-group-base'
	itemTag = 'ui-nav-item-base'

	get shell do closestWith(self, 'isUiAppShell')
	get rail do !!shell..rail
	get mobile do !!shell..mobile

	def close do shell..closeDrawer!
	def toggle do shell..toggle!

	# Focus moves into the drawer once it's shown (and back to the menu
	# button when it closes, see the shell).
	def rendered
		let open = !!shell..drawerOpen
		querySelector('.nav :is(a, button)')..focus! if open and !#wasOpen
		#wasOpen = open

	# In the rail the `logo-collapsed` slot replaces the logo when given;
	# otherwise the logo is clipped to the rail's width.
	<self .rail=rail .mobile=mobile .open=!!shell..drawerOpen data-ui-shell-part data-ui-sidebar role=(mobile ? 'dialog' : undefined) aria-label=(mobile ? label : undefined)>
		<div.header>
			<div.logo>
				<div.logo-collapsed> <slot name='logo-collapsed'>
				<div.logo-full> <slot name='logo'>
			if mobile
				<button.icon-button type='button' aria-label='Close menu' @click=close> <ui-icon path=icons.x size=16>
			elif !rail
				<ui-tooltip content='Collapse sidebar (⌘B)' placement='right'>
					<button.icon-button type='button' aria-label='Collapse sidebar' @click=toggle> <ui-icon path=icons.panelClose size=16>
		<nav.nav aria-label=label>
			if items
				for section in items
					<{sectionTag} heading=section.heading>
						for item in section.items
							if item.items
								<{groupTag} label=item.label icon=item.icon>
									for child in item.items
										<{itemTag} href=child.href icon=child.icon active=child.active badge=child.badge> child.label
							else
								<{itemTag} href=item.href icon=item.icon active=item.active badge=item.badge> item.label
			<slot>
		<div.footer>
			<slot name='footer'>
			if rail
				<ui-tooltip content='Expand sidebar (⌘B)' placement='right'>
					<button.icon-button.expand type='button' aria-label='Expand sidebar' @click=toggle> <ui-icon path=icons.panelOpen size=16>
		# Mouse only: keyboard users have the buttons above and ⌘B. It never
		# takes focus (mousedown is prevented), so no focus ring is left behind.
		if edge and !mobile
			<button.edge type='button' tabIndex=-1 aria-hidden='true' title=(rail ? 'Expand sidebar' : 'Collapse sidebar') @mousedown.prevent @click=toggle>


# A labelled group of nav items. The heading hides in the rail.
tag ui-nav-section-base
	prop heading = null

	get rail do !!closestWith(self, 'isUiAppShell')..rail

	<self .rail=rail data-ui-shell-part role='group' aria-label=heading>
		<div.heading aria-hidden='true'> heading if heading
		<div.items> <slot>

# A nav link (or a button without `href`). In the rail its label becomes a
# tooltip. Following it closes the mobile drawer.
#
# - `active`: marks the current page (aria-current)
# - `badge`: a count or short text at the end
#
# It renders <a href>, which Imba's router picks up. For Inertia, subclass it
# and set `linkTag = 'inertia-link'`.
tag ui-nav-item-base
	prop href = null
	prop icon = null
	prop active = false
	prop badge = null
	prop label = null

	linkTag = 'a'

	get shell do closestWith(self, 'isUiAppShell')
	# Inside a group's flyout the label stays visible.
	get rail do !!shell..rail and !closestWith(self, 'isUiNavGroup')
	get text do label or $text..textContent.trim! or ''

	def followed
		shell..closeDrawer!

	<self .active=active .rail=rail data-ui-shell-part>
		<ui-tooltip content=text placement='right' disabled=!rail>
			if href
				<{linkTag}.link href=href aria-current=(active ? 'page' : undefined) aria-label=(rail ? text : undefined) @click=followed>
					<iconify-icon.icon icon=icon aria-hidden='true'> if icon
					<span$text.text> <slot>
					<span.badge> badge if badge != null
			else
				<button.link type='button' aria-label=(rail ? text : undefined)>
					<iconify-icon.icon icon=icon aria-hidden='true'> if icon
					<span$text.text> <slot>
					<span.badge> badge if badge != null

# Nav items under a heading that opens and closes. In the rail it shows its
# icon, and the items open beside it as a flyout: on hover, or on click for
# keyboard and touch. Escape, leaving it or following a link closes it.
#
# The items are rendered once, in the same place either way: Imba can't move
# slotted content between branches, so the flyout is the same element
# positioned fixed (which also escapes the sidebar's overflow).
tag ui-nav-group-base
	prop label = ''
	prop icon = null
	prop open = false

	isUiNavGroup = yes
	flyout = no

	get shell do closestWith(self, 'isUiAppShell')
	get rail do !!shell..rail

	# `bind=` targets `data`, which aliases `open` here.
	get data do open
	set data v do open = v

	# Open by default when one of its items is the current page.
	def mount
		data = yes if querySelector('[aria-current=page]') and !data

	def showFlyout
		return unless rail
		let box = $toggle.getBoundingClientRect!
		style.setProperty('--flyout-top', "{box.top}px")
		style.setProperty('--flyout-left', "{box.right}px")
		flyout = yes

	def hideFlyout
		flyout = no

	def toggleClicked
		if !rail
			data = !data
		elif flyout
			hideFlyout!
		else
			showFlyout!

	def focusLeft e
		hideFlyout! unless contains(e.relatedTarget)

	def escaped
		return unless flyout
		hideFlyout!
		$toggle.focus!

	<self .open=data .rail=rail data-ui-shell-part .flyout=(rail and flyout) @pointerenter=showFlyout @pointerleave=hideFlyout @focusout=focusLeft @keydown.esc=escaped>
		<button$toggle.toggle type='button' aria-expanded=String(rail ? flyout : !!data) aria-label=(rail ? label : undefined) @click=toggleClicked>
			<iconify-icon.icon icon=icon aria-hidden='true'> if icon
			<span.text> label
			<ui-icon.chevron path=icons.down size=14>
		<div.children hidden=(rail ? !flyout : !data) @click=(hideFlyout! if e.target.closest('a'))>
			<div.panel>
				<div.flyout-heading aria-hidden='true'> label
				<slot>

# The signed-in user, for the sidebar's footer: avatar, name and a line
# under it, opening a menu of account actions upwards (to the right in the
# rail, where only the avatar shows).
#
#   <ui-sidebar-user slot='footer' name='Ada Lovelace' description='ada@example.com'
#     items=[{ label: 'Profile', value: 'profile', icon: 'lucide:user' }, …]
#     @select=account(e.detail)>
#
# Emits `select` with the chosen item's value, like ui-menu.
tag ui-sidebar-user-base
	prop name = ''
	prop description = null
	prop src = null
	prop items = []

	get shell do closestWith(self, 'isUiAppShell')
	get rail do !!shell..rail

	<self .rail=rail data-ui-shell-part>
		<ui-menu items=items placement=(rail ? 'right-end' : 'top-start')>
			<button.user slot='trigger' type='button' aria-label=(rail ? name : undefined)>
				<ui-avatar.avatar name=name src=src size='sm'>
				<span.text>
					<span.name> name
					<span.description> description if description
				<iconify-icon.chevron icon='lucide:chevrons-up-down' aria-hidden='true'>

# The bar above the page: a menu button on phones, then its content and an
# `end` slot on the right.
tag ui-topbar-base
	get shell do closestWith(self, 'isUiAppShell')

	def openMenu do shell..openDrawer!

	<self data-ui-shell-part data-ui-topbar>
		if shell..mobile
			<button.menu type='button' aria-label='Open menu' aria-expanded=String(!!shell.drawerOpen) @click=openMenu> <ui-icon path=icons.menu size=18>
		<div.start> <slot>
		<div.end> <slot name='end'>

# The page area: an optional header (heading, description, breadcrumbs and
# actions) above the content.
#
# - `width`: 'narrow', 'default', 'wide' or 'full'
tag ui-page-base
	prop heading = null
	prop description = null
	prop width = 'default'

	<self data-width=width data-ui-page>
		<div.inner>
			if heading or description
				<header.header>
					<div.breadcrumbs> <slot name='breadcrumbs'>
					<div.titles>
						<div>
							<h1.heading> heading if heading
							<p.description> description if description
						<div.actions> <slot name='actions'>
			<div.content> <slot>
