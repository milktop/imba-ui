import './list.imba'
import './search.imba'

# Headless select: pick from a list. A button that opens it, or, with
# `searchable`, `load` or `oncreate`, an input you type into to filter it.
#
#   <ui-select label='Level' items=['GCSE', 'A Level'] bind=level>
#   <ui-select label='Student' items=students labelKey='name' valueKey='id' searchable bind=studentId>
#   <ui-select label='City' load=searchCities labelKey='name' valueKey='id' bind=cityId>
#   <ui-select label='Topics' items=topics multiple oncreate=addTopic bind=picked>
#
# - `items`: strings, or objects (see `labelKey`, `valueKey`, `disabledKey`)
# - `value`: the item's own value, or an array of them with `multiple`;
#   `bind=` (or `bind:value=`) works, and `change` is emitted with it
# - `multiple`: pick several; picked items show ticked in the list
# - `tags`: with `multiple`, show the picks as tags in the box (always, when
#   searchable); `variant` sets their look: 'subtle', 'accent' or 'outline'
# - `hideSelected`: with `multiple`, picked items leave the list
# - `searchable`: type to filter the list (labels starting with the text first)
# - `load`: async function(query) returning items, for server search; implies
#   searchable (debounced by `debounce` ms, `loadingText` meanwhile)
# - `oncreate`: function(query) called when someone picks "Create …" for text
#   that matches no item; implies searchable. Return the new item (or a
#   promise of it) to select it, or handle it yourself
# - `deselectable`: clicking the picked item again clears it (without search)
# - `closeOnSelect`: close the list after a pick (on by default, except with `multiple`)
# - `clearable`: a button to clear it
# - `placeholder`, `emptyText` (when nothing matches)
# - `name`: for plain form posts
# - `size`: 'sm' or 'md'; `placement`: where the list opens ('bottom-start')
# - `quiet`: no border, fill or arrow until hovered, focused or open, and
#   plain text when disabled; for selects in table rows
# - `itemTag`: a tag rendering an option's content, given `item`
# - `createTag`: a tag rendering the create option's content, given `query`
# - `emptyTag`: a tag shown when nothing matches, given `query`
#
# Picking several, Enter picks a run (the highlight keeps its place), and
# Backspace removes the last pick.
tag ui-select-base < ui-control
	prop label = null
	prop items = []
	prop value = null
	prop placeholder = null
	prop labelKey = 'label'
	prop valueKey = 'value'
	prop disabledKey = 'disabled'
	prop multiple = false
	prop tags = false
	prop variant = 'subtle'
	prop hideSelected = false
	prop searchable = false
	prop load = null
	prop debounce = 200
	prop loadingText = 'Loading…'
	prop oncreate = null
	prop deselectable = false
	prop closeOnSelect = null
	prop clearable = false
	prop emptyText = 'No matches'
	prop name = null
	prop size = 'md'
	prop quiet = false
	prop placement = 'bottom-start'
	prop disabled = false
	prop itemTag = null
	prop createTag = null
	prop emptyTag = null

	# The tags for each mode; the styled select uses the styled ones.
	listTag = 'ui-list-select-base'
	searchTag = 'ui-search-select-base'

	get searching do !!(searchable or load or oncreate)

	# The inner select's change: the value here follows (and through it a
	# `bind=`), and the app re-renders, as it would after the inner's own.
	def changed e
		data = e.detail
		imba.commit!

	# The inner select's change bubbles on to this one's listeners.
	<self .searching=searching>
		if searching
			<{searchTag}.inner label=label items=items value=data placeholder=placeholder labelKey=labelKey valueKey=valueKey disabledKey=disabledKey
				multiple=multiple variant=variant hideSelected=hideSelected load=load debounce=debounce loadingText=loadingText oncreate=oncreate
				closeOnSelect=closeOnSelect clearable=clearable emptyText=emptyText name=name size=size quiet=quiet placement=placement disabled=disabled
				itemTag=itemTag createTag=createTag emptyTag=emptyTag @change=changed(e)>
		else
			<{listTag}.inner label=label items=items value=data placeholder=placeholder labelKey=labelKey valueKey=valueKey disabledKey=disabledKey
				multiple=multiple tags=tags variant=variant hideSelected=hideSelected deselectable=deselectable closeOnSelect=closeOnSelect
				clearable=clearable emptyText=emptyText name=name size=size quiet=quiet placement=placement disabled=disabled
				itemTag=itemTag emptyTag=emptyTag @change=changed(e)>
