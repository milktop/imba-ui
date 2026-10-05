import source from './stat.imba?raw'

tag page-stat
	<self>
		<demo-page source=source heading='Stat' intro='ui-stat shows a headline number with its label, and optionally a change, help text and an icon. ui-stats lays several out in a responsive grid.'>
			<demo-section heading='One stat'>
				<ui-stat label='Lessons this month' value=52 change=12.5 changeLabel='vs September'>

			<demo-section heading='In a grid'>
				<ui-stats>
					<ui-stat label='Students' value=36 change=4 changeUnit='' changeLabel='new this month'>
					<ui-stat label='Lessons' value=52 change=12.5>
					<ui-stat label='Revenue' value='£1,820' change=-3.2>
					<ui-stat label='Cancellations' value=3 change=-40 invert help='Fewer is better, so down is green'>

			<demo-section heading='Cards with icons' bare>
				<ui-stats variant='cards' columns=3>
					<ui-stat icon='lucide:users' label='Active students' value=31 change=6.9>
					<ui-stat icon='lucide:calendar-check' label='Attendance' value='92' unit='%' change=1.2>
					<ui-stat icon='lucide:clock' label='Hours taught' value='48.5' unit='h' change=-2.1>

			<demo-section heading='One divided card' bare>
				<ui-stats variant='divided' columns=3>
					<ui-stat label='Invoiced' value='£2,140' help='October so far'>
					<ui-stat label='Paid' value='£1,820' change=8>
					<ui-stat label='Outstanding' value='£320' change=15 invert>

			<demo-section heading='Sizes'>
				<ui-stats columns=3>
					<ui-stat size='sm' label='Small' value='1,204'>
					<ui-stat label='Medium' value='1,204'>
					<ui-stat size='lg' label='Large' value='1,204'>
