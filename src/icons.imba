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
	info: 'M12 22a10 10 0 1 0 0-20 10 10 0 0 0 0 20zM12 16v-4M12 8h.01'
	success: 'M22 11.08V12a10 10 0 1 1-5.93-9.14M22 4 12 14.01l-3-3'
	warning: 'm21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3zM12 9v4M12 17h.01'
	user: 'M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2M12 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8z'
	copy: 'M8 8h12a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H10a2 2 0 0 1-2-2zM4 16a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2'
	upload: 'M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M17 8l-5-5-5 5M12 3v12'
	file: 'M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7zM14 2v4a2 2 0 0 0 2 2h4'
	error: 'M12 22a10 10 0 1 0 0-20 10 10 0 0 0 0 20zM15 9l-6 6M9 9l6 6'
}
