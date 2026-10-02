# Small stroke icons used by the components (Lucide paths). They inherit
# colour from currentColor and size from the `size` prop.

tag ui-icon
	prop size = 16
	prop path = ''

	css d:inline-flex

	<self>
		<svg width=size height=size viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width=2 stroke-linecap='round' stroke-linejoin='round' aria-hidden='true'>
			<path d=path>

export const icons = {
	calendar: 'M8 2v4M16 2v4M3 10h18M5 4h14a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2z'
	x: 'M18 6 6 18M6 6l12 12'
	left: 'm15 18-6-6 6-6'
	right: 'm9 18 6-6-6-6'
	down: 'm6 9 6 6 6-6'
	check: 'M20 6 9 17l-5-5'
	minus: 'M5 12h14'
	plus: 'M5 12h14M12 5v14'
}
