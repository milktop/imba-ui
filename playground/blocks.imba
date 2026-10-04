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

# One variant: a heading, a Preview/Code switch, then the preview or code.
tag block-example
	prop heading
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
		d:block mb:10
		header d:flex ai:center jc:space-between g:4 mb:3
		h2 m:0 fs:md fw:600
		.preview p:4 @md:6 bd:1px solid $ui-border rd:calc($ui-radius + 6px) bg:$ui-canvas
		.code pos:relative
			pre m:0 p:5 pr:16 bg:$ui-hover rd:calc($ui-radius + 6px) ff:mono fs:xs lh:1.6 tab-size:2 ofx:auto max-height:60vh ofy:auto
			.copy pos:absolute t:3 r:3 h:7 px:2 bd:1px solid $ui-border bg:$ui-surface c:$ui-muted rd:md fs:xs ff:inherit cursor:pointer
				@hover c:$ui-text

	<self>
		<header>
			<h2> heading
			<ui-segmented items=views bind=view>
		<div.preview hidden=(view != 'preview')> <slot>
		<div.code hidden=(view != 'code')>
			<pre> <code> for tok in highlightImba(code)
				<span .tok-{tok.kind or 'plain'}> tok.text
			<button.copy @click=copy> copied ? "Copied" : "Copy"

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
