import { highlightImba } from './demo.imba'

# The blocks: composed examples of common app screens, each its own file in
# blocks/ (its source is shown under Code).
export const blocks = [
	{ path: '/blocks/dashboard', title: 'Dashboard', icon: 'lucide:layout-dashboard', about: 'Stats, upcoming lessons and recent activity' }
	{ path: '/blocks/profile', title: 'Profile', icon: 'lucide:id-card', about: 'A student: header, tabs, details and history' }
	{ path: '/blocks/list', title: 'List page', icon: 'lucide:list', about: 'Search, filters, a selectable table and paging' }
	{ path: '/blocks/settings', title: 'Settings', icon: 'lucide:settings', about: 'Form sections with a save bar' }
	{ path: '/blocks/sign-in', title: 'Sign in', icon: 'lucide:log-in', about: 'A centred sign-in card' }
	{ path: '/blocks/empty-states', title: 'Empty states', icon: 'lucide:inbox', about: 'First run, no results and not found' }
]

# A block's page: a live preview, or its source.
tag block-page
	prop heading
	prop intro
	prop source = ''
	view = 'preview'
	copied = no

	views = [{ value: 'preview', label: 'Preview' }, { value: 'code', label: 'Code' }]

	# The block's file without its imports.
	get code do source.split('\n').filter(do !$1.startsWith('import ')).join('\n').trim!

	def copy
		await globalThis.navigator.clipboard.writeText(code)
		copied = yes
		imba.commit!
		setTimeout(&, 1500) do
			copied = no
			imba.commit!

	css
		d:block
		header d:flex ai:flex-end jc:space-between g:4 flw:wrap mb:5
		h1 fs:xl fw:700 m:0
		.intro m:0 mt:1 c:$ui-muted fs:sm
		# On the canvas, like an app's main area.
		.preview p:4 @md:8 bd:1px solid $ui-border rd:calc($ui-radius + 6px) bg:$ui-canvas
		.code pos:relative
			pre m:0 p:5 pr:16 bg:$ui-hover rd:calc($ui-radius + 6px) ff:mono fs:xs lh:1.6 tab-size:2 ofx:auto max-height:70vh ofy:auto
			.copy pos:absolute t:3 r:3 h:7 px:2 bd:1px solid $ui-border bg:$ui-surface c:$ui-muted rd:md fs:xs ff:inherit cursor:pointer
				@hover c:$ui-text

	# Both views stay rendered (one hidden), so the slotted block isn't moved.
	<self>
		<header>
			<div>
				<h1> heading
				<p.intro> intro if intro
			<ui-segmented items=views bind=view>
		<div.preview hidden=(view != 'preview')> <slot>
		<div.code hidden=(view != 'code')>
			<pre> <code> for tok in highlightImba(code)
				<span .tok-{tok.kind or 'plain'}> tok.text
			<button.copy @click=copy> copied ? "Copied" : "Copy"

import './blocks/dashboard.imba'
import './blocks/profile.imba'
import './blocks/list.imba'
import './blocks/settings.imba'
import './blocks/sign-in.imba'
import './blocks/empty-states.imba'
import dashboardSource from './blocks/dashboard.imba?raw'
import profileSource from './blocks/profile.imba?raw'
import listSource from './blocks/list.imba?raw'
import settingsSource from './blocks/settings.imba?raw'
import signInSource from './blocks/sign-in.imba?raw'
import emptySource from './blocks/empty-states.imba?raw'

tag page-block-dashboard
	<self> <block-page heading='Dashboard' intro='A greeting with the main actions, a row of stats, then upcoming lessons beside recent activity.' source=dashboardSource>
		<block-dashboard>

tag page-block-profile
	<self> <block-page heading='Profile' intro='A person with their status and actions, then tabs: details and numbers, their lessons, and notes.' source=profileSource>
		<block-profile>

tag page-block-list
	<self> <block-page heading='List page' intro='Search, a subject filter and a filters sheet over a selectable, sortable table, with an action bar for the selection and paging.' source=listSource>
		<block-list>

tag page-block-settings
	<self> <block-page heading='Settings' intro='Sections with a title and description beside their fields, and a bar to save or discard changes.' source=settingsSource>
		<block-settings>

tag page-block-sign-in
	<self> <block-page heading='Sign in' intro='A centred card with the form, a social sign-in and a link to create an account.' source=signInSource>
		<block-sign-in>

tag page-block-empty-states
	<self> <block-page heading='Empty states' intro='Nothing yet, no results, a failed load and a missing page.' source=emptySource>
		<block-empty-states>
