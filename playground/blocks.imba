import { highlightImba } from './demo.imba'

# The blocks: composed examples of common app screens, each its own file in
# blocks/ (its source is shown under Code).
export const blocks = [
	{ group: 'Sections', path: '/blocks/headings', title: 'Page headings', icon: 'lucide:heading', about: 'Titles with actions, breadcrumbs and meta' }
	{ group: 'Sections', path: '/blocks/panels', title: 'Card panels', icon: 'lucide:panel-top', about: 'Cards holding tables and lists' }
	{ group: 'Sections', path: '/blocks/lists', title: 'Stacked lists', icon: 'lucide:rows-3', about: 'People, lessons and links in rows' }
	{ group: 'Sections', path: '/blocks/forms', title: 'Form layouts', icon: 'lucide:square-pen', about: 'Card forms, settings sections, danger zones' }
	{ group: 'Sections', path: '/blocks/feeds', title: 'Feeds', icon: 'lucide:messages-square', about: 'Notes with a composer, activity' }
	{ group: 'Sections', path: '/blocks/banners', title: 'Banners', icon: 'lucide:megaphone', about: 'Announcements, prompts and onboarding' }
	{ group: 'Pages', path: '/blocks/dashboard', title: 'Dashboard', icon: 'lucide:layout-dashboard', about: 'Stats, upcoming lessons and recent activity' }
	{ group: 'Pages', path: '/blocks/profile', title: 'Profile', icon: 'lucide:id-card', about: 'A student: header, tabs, details and history' }
	{ group: 'Pages', path: '/blocks/list', title: 'List page', icon: 'lucide:list', about: 'Search, filters, a selectable table and paging' }
	{ group: 'Pages', path: '/blocks/settings', title: 'Settings', icon: 'lucide:settings', about: 'Form sections with a save bar' }
	{ group: 'Pages', path: '/blocks/sign-in', title: 'Sign in', icon: 'lucide:log-in', about: 'A centred sign-in card' }
	{ group: 'Pages', path: '/blocks/empty-states', title: 'Empty states', icon: 'lucide:inbox', about: 'First run, no results and not found' }
]

# The source of `tag name` in a file: its lines (with the comment above it)
# up to the next top-level definition.
export def tagSource source, name
	let lines = (source or '').split('\n')
	let start = lines.findIndex(do $1 == "tag {name}" or $1.startsWith("tag {name} "))
	return '' if start < 0
	start-- while start > 0 and lines[start - 1].startsWith('#')
	# The next definition, less the comments right above it.
	let next = lines.findIndex(do(line, i) i > start and /^(tag|const|def|export|import) /.test(line) and !line.startsWith("tag {name}"))
	next = lines.length if next < 0
	next-- while next > start and (lines[next - 1].startsWith('#') or !lines[next - 1].trim!)
	lines.slice(start, next).join('\n').trim!

# A page of section blocks: several variants, each with its own preview and
# code (the variant's tag, plus any `helpers` tags it uses).
tag block-examples
	prop heading
	prop intro
	prop source = ''
	prop examples = []

	css
		d:block
		h1 fs:xl fw:700 m:0
		.intro m:0 mt:1 mb:6 c:$ui-muted fs:sm

	<self>
		<h1> heading
		<p.intro> intro if intro
		for example in examples
			<block-example key=example.tag heading=example.heading code=[example.tag, ...(example.helpers or [])].map(do tagSource(source, $1)).join('\n\n')>
				<{example.tag}>

# A preview framed like a window: a slim bar (a title or description, and
# the Preview/Code switch) above the block or its code. The bar is the
# playground's, not part of the block.
tag block-frame
	prop caption
	prop code = ''
	view = 'preview'
	copied = no
	views = [{ value: 'preview', label: 'Preview' }, { value: 'code', label: 'Code' }]

	def copy
		await globalThis.navigator.clipboard.writeText(code)
		copied = yes
		imba.commit!
		setTimeout(&, 1500) do
			copied = no
			imba.commit!

	css
		d:block bd:1px solid $ui-border rd:calc($ui-radius + 6px) of:hidden bg:$ui-canvas
		.bar d:flex ai:center jc:space-between g:4 py:2 pl:4 pr:2 bg:$ui-surface bdb:1px solid $ui-border
		.caption c:$ui-muted fs:sm min-width:0 of:hidden text-overflow:ellipsis ws:nowrap
		.bar-actions d:flex ai:center g:2 fls:0
		.preview p:4 @md:8
		.code pre m:0 p:5 ff:mono fs:xs lh:1.6 tab-size:2 ofx:auto max-height:70vh ofy:auto bg:$ui-surface

	# Both views stay rendered (one hidden), so the slotted block isn't moved.
	<self>
		<div.bar>
			<span.caption> caption
			<div.bar-actions>
				if view == 'code'
					<ui-button size='sm' variant='ghost' icon=(copied ? 'lucide:check' : 'lucide:copy') @click=copy> copied ? "Copied" : "Copy"
				<ui-segmented items=views bind=view>
		<div.preview hidden=(view != 'preview')> <slot>
		<div.code hidden=(view != 'code')>
			<pre> <code> for tok in highlightImba(code)
				<span .tok-{tok.kind or 'plain'}> tok.text

# One variant on a sections page.
tag block-example
	prop heading
	prop code = ''
	css d:block mb:8
	<self>
		<block-frame caption=heading code=code> <slot>

# A page block: the block alone, filling the main area as it would in an
# app. A floating pill in the corner switches to its code (and copies it).
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
		.code pre m:0 p:5 ff:mono fs:xs lh:1.6 tab-size:2 ofx:auto bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 6px)
		.switch pos:fixed r:4 b:4 zi:40 d:flex ai:center g:1 p:1 bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 6px) shadow:$ui-shadow

	# Both views stay rendered (one hidden), so the slotted block isn't moved.
	<self>
		<div hidden=(view != 'preview')> <slot>
		<div.code hidden=(view != 'code')>
			<pre> <code> for tok in highlightImba(code)
				<span .tok-{tok.kind or 'plain'}> tok.text
		<div.switch>
			if view == 'code'
				<ui-button size='sm' variant='ghost' icon=(copied ? 'lucide:check' : 'lucide:copy') @click=copy> copied ? "Copied" : "Copy"
			<ui-segmented items=views bind=view aria-label="{heading}: preview or code">

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

# Sections: smaller blocks that pages are made of.
import { examples as headingExamples } from './blocks/sections/headings.imba'
import { examples as panelExamples } from './blocks/sections/panels.imba'
import { examples as listExamples } from './blocks/sections/lists.imba'
import { examples as formExamples } from './blocks/sections/forms.imba'
import { examples as feedExamples } from './blocks/sections/feeds.imba'
import { examples as bannerExamples } from './blocks/sections/banners.imba'
import headingsSource from './blocks/sections/headings.imba?raw'
import panelsSource from './blocks/sections/panels.imba?raw'
import listsSource from './blocks/sections/lists.imba?raw'
import formsSource from './blocks/sections/forms.imba?raw'
import feedsSource from './blocks/sections/feeds.imba?raw'
import bannersSource from './blocks/sections/banners.imba?raw'

tag page-block-headings
	<self> <block-examples heading='Page headings' intro='The top of a page: its title, what it’s for, and its main actions.' source=headingsSource examples=headingExamples>

tag page-block-panels
	<self> <block-examples heading='Card panels' intro='Cards holding a table or list edge to edge (ui-card and ui-table with `flush`), or a figure and a checklist.' source=panelsSource examples=panelExamples>

tag page-block-lists
	<self> <block-examples heading='Stacked lists' intro='Rows of people, lessons or links, for when a table is too much.' source=listsSource examples=listExamples>

tag page-block-forms
	<self> <block-examples heading='Form layouts' intro='A form in a card, a settings section, and a destructive action set apart.' source=formsSource examples=formExamples>

tag page-block-feeds
	<self> <block-examples heading='Feeds' intro='Notes and comments with a box to add one, and recent activity.' source=feedsSource examples=feedExamples>

tag page-block-banners
	<self> <block-examples heading='Banners' intro='An announcement, a prompt for what to do next, and an onboarding checklist.' source=bannersSource examples=bannerExamples>
