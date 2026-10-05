import '../theme.imba'
import '../tooltip/index.imba'
import '../menu/index.imba'
import '../avatar/index.imba'
import './base.imba'

global css
	@keyframes ui-drawer-in
		from transform:translateX(-100%)
	@keyframes ui-backdrop-in
		from opacity:0
	@keyframes ui-flyout-in
		from opacity:0 transform:translateX(-4px)

# A grid: the sidebar down the left, the top bar and page beside it. Below
# the breakpoint the sidebar leaves the grid and slides in as a drawer.
tag ui-app-shell < ui-app-shell-base
	css
		d:grid gtc:$ui-sidebar-width 1fr gtr:auto 1fr min-height:100dvh
		grid-template-areas:"sidebar topbar" "sidebar main"
		# The main area sits on the canvas; the sidebar and top bar on the surface.
		bg:$ui-canvas c:$ui-text ff:$ui-font
		transition:grid-template-columns 200ms ease
		&.rail gtc:$ui-sidebar-rail-width 1fr
		&.mobile gtc:1fr grid-template-areas:"topbar" "main"
		# Inset: the page is a rounded panel on the canvas, and the sidebar and
		# top bar sit flat on the surface around it.
		&.inset bg:$ui-surface
		# The panel is set apart by its colour alone, with room around it.
		&.inset >>> [data-ui-page] bg:$ui-canvas mx:3 mb:3 rd:calc($ui-radius + 10px)
		&.inset.mobile >>> [data-ui-page] mx:2 mb:2
		&.inset >>> [data-ui-topbar] bdb:none
		# The sidebar is grey too, so the white frame (top bar and the gap round
		# the panel) is a layer of its own; its hover and active items go white.
		&.inset >>> [data-ui-sidebar] bdr:none bg:$ui-canvas
			--ui-sidebar-hover:color-mix(in srgb, $ui-surface 75%, transparent)
			--ui-sidebar-active:$ui-surface
			--ui-sidebar-active-shadow:0 1px 2px rgba(0,0,0,0.06)
		.backdrop pos:fixed inset:0 zi:40 bg:rgba(0,0,0,0.4) animation:ui-backdrop-in 200ms ease-out

tag ui-sidebar < ui-sidebar-base
	sectionTag = 'ui-nav-section'
	groupTag = 'ui-nav-group'
	itemTag = 'ui-nav-item'

	css
		grid-area:sidebar d:flex fld:column min-width:0 box-sizing:border-box
		# Sticky makes it a stacking context, so it needs a z-index to keep its
		# flyouts above the page (and below the top bar's popups).
		pos:sticky t:0 zi:35 h:100dvh of:hidden bg:$ui-surface bdr:1px solid $ui-border fs:sm
		&.mobile pos:fixed l:0 t:0 b:0 zi:50 w:min(18rem, 85vw) shadow:$ui-shadow
			d:none
		&.mobile.open d:flex animation:ui-drawer-in 200ms ease-out

		.header d:flex ai:center jc:space-between g:2 h:3.5rem px:2 fls:0 box-sizing:border-box
		.logo d:flex ai:center min-width:0 of:hidden pl:2 fw:700 ws:nowrap
		.logo-collapsed d:none
		.logo-full d:flex ai:center min-width:0
		&.rail .logo pl:0 w:100% jc:center
		&.rail .logo-collapsed d:flex
		&.rail .logo-collapsed + .logo-full d:none
		&.rail .logo-collapsed@empty d:none
		&.rail .logo-collapsed@empty + .logo-full d:flex
		.logo >>> div[slot] d:contents

		.icon-button d:inline-flex ai:center jc:center w:8 h:8 fls:0 p:0 bd:none rd:$ui-radius bg:transparent c:$ui-muted cursor:pointer
			@hover bg:var(--ui-sidebar-hover, $ui-hover) c:$ui-text
			@focus-visible outline:2px solid $ui-ring-soft
		.nav d:flex fld:column g:4 flg:1 min-height:0 ofy:auto ofx:hidden px:2 py:2
		.footer d:flex fld:column g:1 px:2 py:3 fls:0
			&:not(:has(*)) d:none
		&.rail .footer ai:center

		# The edge strip sits over the border, inside the sidebar (which clips
		# overflow); a line shows on hover, and the cursor points the way it goes.
		.edge pos:absolute t:0 b:0 r:0 zi:1 w:1.5 p:0 bd:none bg:transparent outline:none cursor:w-resize
			# A 1px accent line over the border; the strip itself stays wider, so
			# it's easy to hit.
			@after content:'' pos:absolute t:0 b:0 r:0 w:1px bg:transparent transition:background 150ms
			@hover@after bg:$ui-accent
		&.rail .edge cursor:e-resize

# The heading fades out in the rail; a divider keeps sections apart.
tag ui-nav-section < ui-nav-section-base
	css
		d:flex fld:column g:0.5
		.heading-row d:flex ai:center jc:space-between g:2 h:6 pr:1
		.heading flg:1 px:3 fs:xs fw:600 c:$ui-muted ws:nowrap of:hidden d:flex ai:center transition:opacity 150ms
		.collapse-all d:grid place-items:center w:6 h:6 p:0 bd:none rd:calc($ui-radius - 2px) bg:transparent c:$ui-muted fs:14px cursor:pointer o:0.7
			@hover o:1 c:$ui-text bg:var(--ui-sidebar-hover, $ui-hover)
			@focus-visible outline:2px solid $ui-ring-soft
		.items d:flex fld:column g:0.5
		&.rail .heading o:0

# Shared by items and groups: icons stay put as the sidebar narrows, labels
# fade and are clipped.
tag ui-nav-item < ui-nav-item-base
	css
		d:block
		.link d:flex ai:center g:3 w:100% h:8.5 pl:3 pr:2 box-sizing:border-box bd:none rd:$ui-radius bg:transparent c:$ui-muted ff:inherit fs:13px ta:left td:none ws:nowrap cursor:pointer
			@hover bg:var(--ui-sidebar-hover, $ui-hover) c:$ui-text
			@focus-visible outline:2px solid $ui-ring-soft outline-offset:-2px
		&.active .link bg:var(--ui-sidebar-active, $ui-hover) shadow:var(--ui-sidebar-active-shadow, none) c:$ui-text fw:500
		.icon fs:16px fls:0 w:4 h:4
		.text flg:1 min-width:0 of:hidden text-overflow:ellipsis transition:opacity 150ms
		.badge fls:0 min-width:5 h:5 px:1.5 box-sizing:border-box d:inline-flex ai:center jc:center rd:full bg:$ui-accent-soft c:$ui-accent-soft-text fs:xs fw:500
			&:empty d:none
		&.rail .text, &.rail .badge o:0

tag ui-nav-group < ui-nav-group-base
	css
		d:block
		.toggle d:flex ai:center g:3 w:100% h:8.5 pl:3 pr:2 box-sizing:border-box bd:none rd:$ui-radius bg:transparent c:$ui-muted ff:inherit fs:13px ta:left ws:nowrap cursor:pointer
			@hover bg:var(--ui-sidebar-hover, $ui-hover) c:$ui-text
			@focus-visible outline:2px solid $ui-ring-soft outline-offset:-2px
		&.flyout .toggle bg:var(--ui-sidebar-active, $ui-hover) shadow:var(--ui-sidebar-active-shadow, none) c:$ui-text
		.icon fs:16px fls:0 w:4 h:4
		.text flg:1 min-width:0 of:hidden text-overflow:ellipsis transition:opacity 150ms
		.chevron c:$ui-muted transition:transform 200ms, opacity 150ms
		&.open .chevron transform:rotate(180deg)
		&.rail .text, &.rail .chevron o:0
		# Nested items are indented under the group's label.
		.panel d:flex fld:column g:0.5 mt:0.5 ml:5 pl:2 bdl:1px solid $ui-border
		.flyout-heading d:none
		# In the rail: a panel beside the toggle. The wrapper's left padding
		# bridges the gap, so the pointer can cross to it without closing it.
		&.rail .children pos:fixed t:var(--flyout-top) l:var(--flyout-left) zi:50 pl:2
		&.rail .panel m:0 p:1.5 min-width:44 bd:1px solid $ui-border rd:calc($ui-radius + 2px) bg:$ui-surface shadow:$ui-shadow animation:ui-flyout-in 120ms ease-out
			# On the white flyout, hovers are grey again.
			--ui-sidebar-hover:$ui-hover --ui-sidebar-active:$ui-hover --ui-sidebar-active-shadow:none
		&.rail .flyout-heading d:block px:3 pt:1 pb:1.5 fs:xs fw:600 c:$ui-muted

tag ui-sidebar-user < ui-sidebar-user-base
	css
		d:block w:100%
		.user d:flex ai:center g:2.5 w:100% p:1.5 box-sizing:border-box bd:none rd:$ui-radius bg:transparent c:$ui-text ff:inherit fs:sm ta:left ws:nowrap cursor:pointer
			@hover bg:var(--ui-sidebar-hover, $ui-hover)
			@focus-visible outline:2px solid $ui-ring-soft outline-offset:-2px
			&[aria-expanded=true] bg:var(--ui-sidebar-active, $ui-hover) shadow:var(--ui-sidebar-active-shadow, none)
		.avatar fls:0
		.text d:flex fld:column flg:1 min-width:0 lh:1.3 transition:opacity 150ms
		.name fw:500 of:hidden text-overflow:ellipsis
		.description fs:xs c:$ui-muted of:hidden text-overflow:ellipsis
			&:empty d:none
		.chevron fls:0 c:$ui-muted fs:14px
		&.rail .text, &.rail .chevron o:0
		# As wide as the trigger when it opens upwards (Zag sets
		# --reference-width), and never narrower than 13rem.
		>>> .content min-width:max(13rem, var(--reference-width)) box-sizing:border-box

tag ui-topbar < ui-topbar-base
	css
		grid-area:topbar d:flex ai:center g:3 h:3.5rem px:4 @md:6 box-sizing:border-box min-width:0
		pos:sticky t:0 zi:36 bg:$ui-surface bdb:1px solid $ui-border
		.menu d:inline-flex ai:center jc:center w:9 h:9 ml:-2 fls:0 p:0 bd:none rd:$ui-radius bg:transparent c:$ui-text cursor:pointer
			@hover bg:$ui-hover
			@focus-visible outline:2px solid $ui-ring-soft
		.start d:flex ai:center g:3 flg:1 min-width:0
		.end d:flex ai:center g:2 fls:0
			&:not(:has(*)) d:none
		.start >>> div[slot], .end >>> div[slot=end] d:contents

tag ui-page < ui-page-base
	css
		grid-area:main d:block min-width:0 box-sizing:border-box p:4 @md:8
		.inner mx:auto max-width:56rem
		&[data-align=start] .inner ml:0
		&[data-width=narrow] .inner max-width:40rem
		&[data-width=wide] .inner max-width:80rem
		&[data-width=full] .inner max-width:none
		.header d:flex fld:column g:2 mb:6
		.breadcrumbs fs:sm c:$ui-muted
			&:not(:has(*)) d:none
		.titles d:flex ai:flex-start jc:space-between g:4 flw:wrap
		.heading m:0 fs:2xl fw:700 lh:1.2
		.description m:0 mt:1 c:$ui-muted fs:sm
		.actions d:flex g:2 fls:0
			&:not(:has(*)) d:none
		.actions >>> div[slot=actions] d:contents
