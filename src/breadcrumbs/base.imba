import { icons } from '../icons.imba'
import '../popover/base.imba'

# Headless breadcrumbs: where the current page sits, as a trail of links.
#
#   <ui-breadcrumbs items=[
#     { label: 'Home', href: '/', icon: 'lucide:house' }
#     { label: 'Students', href: '/students' }
#     { label: 'Ada Lovelace' }
#   ]>
#
# The last item is the current page (aria-current, not a link). Items without
# `href` show as plain text. Or write the trail as markup:
#
#   <ui-breadcrumbs>
#     <ui-breadcrumb href='/'> 'Home'
#     <ui-breadcrumb current> 'Students'
#
# - `separator`: text between crumbs ('/', '›', …); a chevron by default
# - `max`: with more items than this, the middle ones fold into a "…" button
#   that lists them in a popover (items only). They also fold, as many as
#   needed, when the trail doesn't fit its width.
# - `label`: the nav's accessible name
#
# Links are <a href>, which Imba's router picks up. For Inertia, subclass it
# and set `linkTag = 'inertia-link'` (ui-breadcrumb reads its parent's).

# Finds the breadcrumbs a ui-breadcrumb sits in.
def closestTrail el
	let node = el.parentElement
	node = node.parentElement until !node or node.isUiBreadcrumbs
	node

# Stands for the folded items in the trail. The list isn't keyed, so apps
# can build fresh item objects every render.
const MORE = { more: yes }

tag ui-breadcrumbs-base
	prop items = null
	prop separator = null
	prop max = null
	prop label = 'Breadcrumb'

	isUiBreadcrumbs = yes
	linkTag = 'a'
	folded = no

	# How many items show: `max`, or fewer when they don't fit (`#fit`).
	get limit do Math.max(2, Math.min(max or Infinity, #fit or Infinity))

	# Folded: the first item, a "…" for the folded ones, then the rest.
	get collapsed do !!(items and items.length > limit)
	get foldedItems do collapsed ? items.slice(1, items.length - (limit - 1)) : []
	get entries
		return items or [] unless collapsed
		[items[0], MORE, ...items.slice(items.length - (limit - 1))]

	def mount
		#observer = new ResizeObserver(do fit!)
		#observer.observe(self)

	def unmount
		#observer..disconnect!

	# Folds one more item at a time until the trail fits. While measuring the
	# crumbs don't shrink (--shrink), so overflow shows; it all happens before
	# the browser paints.
	def fit
		return unless items and $list and $list.clientWidth
		#fit = null
		$list.style.setProperty('--shrink', '0')
		render!
		let shown = Math.min(limit, items.length)
		while $list.scrollWidth > $list.clientWidth and shown > 2
			#fit = shown = shown - 1
			render!
		$list.style.removeProperty('--shrink')

	# Refits when the items change.
	def rendered
		let key = "{(items or []).map(do $1.label).join('|')}|{max}"
		return if key == #fitKey
		#fitKey = key
		globalThis.queueMicrotask do fit!

	def isLast item do item == items[items.length - 1]

	<self>
		<nav aria-label=label>
			<ol$list.list>
				for entry, i in entries
					<li.crumb>
						if i > 0
							<span.separator aria-hidden='true'>
								if separator
									separator
								else
									<ui-icon path=icons.right size=14>
						if entry == MORE
							<ui-popover bind=folded placement='bottom-start'>
								<button.more slot='trigger' type='button' aria-label="Show {foldedItems.length} more"> "…"
								<ol.folded>
									for item in foldedItems
										<li>
											<{item.href ? linkTag : 'span'}.folded-link href=item.href @click=(folded = no)>
												<iconify-icon.icon icon=item.icon aria-hidden='true'> if item.icon
												<span> item.label
						else
							<{entry.href and !isLast(entry) ? linkTag : 'span'}.link .current=isLast(entry) href=(isLast(entry) ? undefined : entry.href) aria-current=(isLast(entry) ? 'page' : undefined)>
								<iconify-icon.icon icon=entry.icon aria-hidden='true'> if entry.icon
								<span.text> entry.label
				<slot>

# One crumb, for breadcrumbs written as markup. `current` marks the page
# you're on; without `href` it's plain text. Its separator hides when it's
# the first.
tag ui-breadcrumb-base
	prop href = null
	prop icon = null
	prop current = false

	get trail do closestTrail(self)
	get linkTag do trail..linkTag or 'a'
	get isLink do !!href and !current

	<self role='listitem'>
		<span.separator aria-hidden='true'>
			if trail..separator
				trail.separator
			else
				<ui-icon path=icons.right size=14>
		<{isLink ? linkTag : 'span'}.link .current=current href=(isLink ? href : undefined) aria-current=(current ? 'page' : undefined)>
			<iconify-icon.icon icon=icon aria-hidden='true'> if icon
			<span.text> <slot>
