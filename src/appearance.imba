# The app's accent colour and sidebar style, chosen by its users (with
# ui-appearance) or set in code, saved like colorScheme:
#
#   import { appearance } from '@milktop/imba-ui/appearance'
#   appearance.defaults = { accent: 'teal', sidebar: 'neutral-accent' }
#   appearance.update accent: 'violet', sidebar: 'dark'
#   appearance.load(user.appearance)        # a saved choice, e.g. from the server
#   appearance.onchange = do(value) save(value)
#
# - `accent`: a name from `accents` (Tailwind's scales, each 600 taking white
#   text), or `custom`: any hex colour, its scale worked out in the browser
#   (CSS relative colours keep its hue), e.g. to try a brand colour
# - `sidebar`: a name from `sidebarStyles`, light mode only (dark keeps its
#   own layers). 'default' leaves the theme's sidebar as it is.
# - `defaults`: what a visitor with nothing saved gets, and what `reset`
#   goes back to
# - `update(changes)` sets and saves them and calls `onchange` with
#   `value` ({ accent, custom, sidebar }); `load(value)` applies a saved one
#   without calling it
# - `restrict(accents, sidebars)` moves a choice outside those lists to their
#   first item (ui-appearance does this with its own lists); a custom colour
#   stays only when it's the default
#
# The accent becomes the $ui-accent-50 … -950 scale on <html>, which the
# accent tokens are steps of (see theme.imba); the sidebar style is
# `data-ui-sidebar-style` there. Saved in localStorage (`storageKey`), scale
# included, so a script in the page's <head> can paint it before the bundle
# loads (see the readme).

export const accentSteps = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950]

# [the scale, the text on its 500 (dark mode's accent)]
export const accents = {
	slate: [['#f8fafc', '#f1f5f9', '#e2e8f0', '#cbd5e1', '#94a3b8', '#64748b', '#475569', '#334155', '#1e293b', '#0f172a', '#020617'], 'white']
	blue: [['#eff6ff', '#dbeafe', '#bfdbfe', '#93c5fd', '#60a5fa', '#3b82f6', '#2563eb', '#1d4ed8', '#1e40af', '#1e3a8a', '#172554'], 'white']
	indigo: [['#eef2ff', '#e0e7ff', '#c7d2fe', '#a5b4fc', '#818cf8', '#6366f1', '#4f46e5', '#4338ca', '#3730a3', '#312e81', '#1e1b4b'], 'white']
	violet: [['#f5f3ff', '#ede9fe', '#ddd6fe', '#c4b5fd', '#a78bfa', '#8b5cf6', '#7c3aed', '#6d28d9', '#5b21b6', '#4c1d95', '#2e1065'], 'white']
	teal: [['#f0fdfa', '#ccfbf1', '#99f6e4', '#5eead4', '#2dd4bf', '#14b8a6', '#0d9488', '#0f766e', '#115e59', '#134e4a', '#042f2e'], '#042f2e']
	emerald: [['#ecfdf5', '#d1fae5', '#a7f3d0', '#6ee7b7', '#34d399', '#10b981', '#059669', '#047857', '#065f46', '#064e3b', '#022c22'], '#022c22']
	rose: [['#fff1f2', '#ffe4e6', '#fecdd3', '#fda4af', '#fb7185', '#f43f5e', '#e11d48', '#be123c', '#9f1239', '#881337', '#4c0519'], 'white']
}

export const sidebarStyles = ['default', 'neutral', 'neutral-accent', 'soft', 'tint', 'accent', 'dark', 'deep']

# Lightness and share of the colour's chroma per step, for a custom colour.
const ramp = [[0.98, 0.15], [0.95, 0.3], [0.9, 0.5], [0.83, 0.7], [0.74, 0.9], [0.65, 1], [0.56, 1], [0.48, 0.9], [0.4, 0.75], [0.33, 0.6], [0.23, 0.45]]

# A custom colour's scale, as CSS relative colours.
export def accentScale hex
	accentSteps.map do(step, i)
		let [l, c] = ramp[i]
		"oklch(from {hex} {l} calc(c * {c}) h)"

const isHex = do(v) typeof v == 'string' and /^#[0-9a-f]{6}$/i.test(v)

class Appearance
	#key = 'ui-appearance'
	#defaults = { accent: 'blue', custom: null, sidebar: 'default' }
	accent = 'blue'
	custom = null
	sidebar = 'default'
	onchange = null

	constructor
		return unless globalThis.document
		reload!

	get storageKey do #key
	# Set it before the page reads a value (it reloads the saved choice).
	set storageKey key
		#key = key
		reload!

	get defaults do #defaults
	set defaults value
		#defaults = Object.assign({ custom: null }, pick(value))
		reload!

	get value do { accent, custom, sidebar }

	# The scale showing: [50 … 950] colours, and the text on the 500.
	get scale do custom ? accentScale(custom) : accents[accent][0]
	get scaleText do custom ? 'white' : accents[accent][1]

	# Only known accents and sidebar styles, and hex colours.
	def pick value
		let out = {}
		return out unless value
		out.accent = value.accent if accents[value.accent]
		out.custom = value.custom if value.custom === null or isHex(value.custom)
		out.sidebar = value.sidebar if sidebarStyles.includes(value.sidebar)
		out

	def reload
		let saved = {}
		try saved = JSON.parse(globalThis.localStorage.getItem(#key) or '{}')
		Object.assign(self, #defaults, pick(saved))
		apply!

	def update changes
		Object.assign(self, pick(changes))
		apply!
		save!
		onchange(value) if onchange
		imba.commit!

	def load value
		Object.assign(self, pick(value))
		apply!
		save!
		imba.commit!

	def reset do update(#defaults)

	def restrict allowedAccents, allowedSidebars
		let fix = {}
		# A custom colour stays only if it's the app's own default
		let customOk = custom and custom == #defaults.custom
		if allowedAccents..length and !customOk and (custom or !allowedAccents.includes(accent))
			fix.accent = allowedAccents[0]
			fix.custom = null
		fix.sidebar = allowedSidebars[0] if allowedSidebars..length and !allowedSidebars.includes(sidebar)
		load(fix) if Object.keys(fix).length

	def apply
		return unless globalThis.document
		let root = globalThis.document.documentElement
		for color, i in scale
			root.style.setProperty("--ui-accent-{accentSteps[i]}", color)
		root.style.setProperty('--ui-accent-500-text', scaleText)
		if sidebar == 'default'
			delete root.dataset.uiSidebarStyle
		else
			root.dataset.uiSidebarStyle = sidebar

	def save
		try globalThis.localStorage.setItem(#key, JSON.stringify(Object.assign({ scale: scale, scaleText: scaleText }, value)))

export const appearance = new Appearance

# The sidebar styles: the shell's sidebar tokens, set for both layouts (the
# plain one's surface and the inset one's background), in light mode. They're
# set on the sidebar itself, so they win over tokens set on <html>.
global css
	html.!dark[data-ui-sidebar-style=neutral] [data-ui-sidebar], html.!dark[data-ui-sidebar-style=neutral-accent] [data-ui-sidebar]
		$ui-sidebar-hover:#eef0f3
		$ui-sidebar-inset-hover:#eef0f3
		$ui-sidebar-active:#e6e9ee
		$ui-sidebar-inset-active:#e6e9ee
		$ui-sidebar-inset-active-shadow:none

	# The current page's text in the accent
	html.!dark[data-ui-sidebar-style=neutral-accent] [data-ui-sidebar]
		$ui-sidebar-active-text:$ui-accent-800

	html.!dark[data-ui-sidebar-style=soft] [data-ui-sidebar]
		$ui-sidebar-hover:$ui-accent-soft
		$ui-sidebar-inset-hover:$ui-accent-soft
		$ui-sidebar-active:$ui-accent-soft
		$ui-sidebar-inset-active:$ui-accent-soft
		$ui-sidebar-inset-active-shadow:none

	html.!dark[data-ui-sidebar-style=tint] [data-ui-sidebar]
		$ui-sidebar-surface:$ui-accent-50
		$ui-sidebar-bg:$ui-accent-50
		$ui-sidebar-hover:color-mix(in srgb, $ui-accent-100 60%, transparent)
		$ui-sidebar-inset-hover:color-mix(in srgb, $ui-accent-100 60%, transparent)
		$ui-sidebar-active:$ui-accent-100
		$ui-sidebar-inset-active:$ui-accent-100
		$ui-sidebar-inset-active-shadow:none
		$ui-sidebar-active-text:$ui-accent-800

	# The coloured ones: white text, translucent white hovers, and the current
	# page a pill two steps from the sidebar's colour
	html.!dark[data-ui-sidebar-style=accent] [data-ui-sidebar], html.!dark[data-ui-sidebar-style=dark] [data-ui-sidebar], html.!dark[data-ui-sidebar-style=deep] [data-ui-sidebar]
		$ui-sidebar-text:white
		$ui-sidebar-muted:rgba(255,255,255,0.6)
		$ui-sidebar-border:transparent
		$ui-sidebar-item-text:rgba(255,255,255,0.88)
		$ui-sidebar-heading:rgba(255,255,255,0.55)
		$ui-sidebar-icon:rgba(255,255,255,0.7)
		$ui-sidebar-hover-text:white
		$ui-sidebar-active-text:white
		$ui-sidebar-hover:rgba(255,255,255,0.08)
		$ui-sidebar-inset-hover:rgba(255,255,255,0.08)
		$ui-sidebar-active-shadow:none
		$ui-sidebar-inset-active-shadow:none

	html.!dark[data-ui-sidebar-style=accent] [data-ui-sidebar]
		$ui-sidebar-surface:$ui-accent-600
		$ui-sidebar-bg:$ui-accent-600
		$ui-sidebar-item-text:white
		$ui-sidebar-heading:rgba(255,255,255,0.7)
		$ui-sidebar-icon:rgba(255,255,255,0.85)
		$ui-sidebar-hover:rgba(255,255,255,0.14)
		$ui-sidebar-inset-hover:rgba(255,255,255,0.14)
		$ui-sidebar-active:$ui-accent-800
		$ui-sidebar-inset-active:$ui-accent-800

	html.!dark[data-ui-sidebar-style=dark] [data-ui-sidebar]
		$ui-sidebar-surface:$ui-accent-900
		$ui-sidebar-bg:$ui-accent-900
		$ui-sidebar-active:$ui-accent-700
		$ui-sidebar-inset-active:$ui-accent-700

	html.!dark[data-ui-sidebar-style=deep] [data-ui-sidebar]
		$ui-sidebar-surface:$ui-accent-950
		$ui-sidebar-bg:$ui-accent-950
		$ui-sidebar-active:$ui-accent-800
		$ui-sidebar-inset-active:$ui-accent-800
