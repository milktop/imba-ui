import source from './headless.imba?raw'

const fruits = ['Apple', 'Banana', 'Cherry']
const views = [{ value: 'day', label: 'Day' }, { value: 'week', label: 'Week' }, { value: 'month', label: 'Month' }]

# A menu with a look of its own, on the headless tag. Its content is part of
# the markup it inherits; the items are child tags, so `>>>` reaches them.
# Zag's attributes carry the state: data-highlighted, data-state=checked.
#
#   import '@milktop/imba-ui/menu/base'
tag ink-menu < ui-menu-base
	css
		>>> [data-part=content] min-width:40 p:1 bg:$ui-text c:$ui-surface rd:0 outline:none ff:mono fs:sm
		>>> .group-label px:2 py:1 o:0.6 fs:xs tt:uppercase ls:0.08em
		>>> .item d:flex ai:center g:2 px:2 py:1 cursor:pointer
			&[data-highlighted] bg:$ui-surface c:$ui-text
			&[data-state=checked] fw:700
		>>> .end ml:auto o:0.6

# A headless avatar that shows the styled tooltip: composite headless tags
# render headless children, and a field names each child tag.
tag tipped-avatar < ui-avatar-base
	tooltipTag = 'ui-tooltip'

tag page-headless
	fruit = 'Banana'
	view = 'week'
	tab = 'one'
	on = yes
	inked = 'week'

	css
		.pair d:grid gtc:1fr 1fr g:6 ai:start
			@!640 gtc:1fr
		.pair h3 m:0 0 2 fs:xs fw:500 c:$ui-muted ff:mono

	<self>
		<demo-page source=source heading='Headless' intro="Every component comes in two tags: the styled one (ui-menu) and a headless one with the same behaviour, markup and Zag state attributes but none of the look (ui-menu-base). Import a headless tag on its own from its `/base` entry point (`@milktop/imba-ui/menu/base`). It stays unstyled with the styled library loaded too, so the two can share a page.">
			<demo-section heading='Menu'>
				<div.pair>
					<div>
						<h3> "ui-menu"
						<ui-menu>
							<ui-button slot='trigger' iconEnd='lucide:chevron-down'> fruit
							<ui-menu-radio-group bind=fruit label='Fruit' indicator='highlight'>
								for name in fruits
									<ui-menu-radio value=name> name
					<div>
						<h3> "ui-menu-base"
						<ui-menu-base>
							<button slot='trigger' type='button'> fruit
							<ui-menu-radio-group-base bind=fruit label='Fruit'>
								for name in fruits
									<ui-menu-radio-base value=name> name
				<div.out>
					<p.note> "Both menus set the same value. The headless one still opens, closes, moves with the arrow keys and ticks the checked radio; only the look is gone."

			<demo-section heading='Tabs, switch and segmented'>
				<div.pair>
					<div>
						<h3> "Styled"
						<ui-tabs bind=tab>
							<ui-tab value='one' label='One'> <p> "First panel"
							<ui-tab value='two' label='Two'> <p> "Second panel"
						<ui-switch label='Notifications' bind=on>
						<ui-segmented items=views bind=view>
					<div>
						<h3> "Headless"
						<ui-tabs-base bind=tab>
							<ui-tab-base value='one' label='One'> <p> "First panel"
							<ui-tab-base value='two' label='Two'> <p> "Second panel"
						<ui-switch-base label='Notifications' bind=on>
						<ui-segmented-base items=views bind=view>

			<demo-section heading='Select and tooltip'>
				<div.pair>
					<div>
						<h3> "Styled"
						<ui-select items=fruits bind=fruit>
						<ui-tooltip content='Saved a minute ago'>
							<ui-button> "Hover me"
					<div>
						<h3> "Headless"
						<ui-select-base items=fruits bind=fruit>
						<ui-tooltip-base content='Saved a minute ago'>
							<button type='button'> "Hover me"

			<demo-section heading='Your own look' uses='ink-menu'>
				<ink-menu>
					<button slot='trigger' type='button'> "View: {inked}"
					<ui-menu-radio-group-base bind=inked label='View'>
						for item in views
							<ui-menu-radio-base value=item.value>
								item.label
								<span slot='end'> item.value[0].toUpperCase!
				<div.out>
					<p.note> "Subclass the headless tag and style its parts (each has a class, and Zag's `data-part`). Items, groups and radios are child tags, so reach them with `>>>`; their states are Zag's attributes (`data-highlighted`, `data-state=checked`). Theme tokens like $ui-text still work."

			<demo-section heading='Headless composites' uses='tipped-avatar'>
				<div.pair>
					<div>
						<h3> "ui-avatar-base"
						<ui-avatar-base name='Ada Lovelace' tooltip>
					<div>
						<h3> "tipped-avatar"
						<tipped-avatar name='Ada Lovelace' tooltip>
				<div.out>
					<p.note> "Headless tags that contain other components render the headless ones (ui-avatar-base's tooltip is ui-tooltip-base), so nothing styled slips in. A field names each child tag (`tooltipTag`, `popoverTag`, `menuTag`, …): set one to use another tag there, styled or your own."
