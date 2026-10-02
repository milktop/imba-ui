import source from './badge.imba?raw'

tag page-badge
	<self>
		<demo-page source=source heading='Badge' intro='ui-badge is a short label for a status or count.'>
			<demo-section heading='Variants'>
				<div.row>
					<ui-badge> "Draft"
					<ui-badge variant='accent'> "New"
					<ui-badge variant='success'> "Paid"
					<ui-badge variant='warning'> "Due soon"
					<ui-badge variant='danger'> "Overdue"
					<ui-badge variant='outline'> "Archived"

			<demo-section heading='Icons and dots'>
				<div.row>
					<ui-badge variant='success' icon='lucide:check'> "Confirmed"
					<ui-badge variant='accent' icon='lucide:video'> "Online"
					<ui-badge variant='success' dot> "Active"
					<ui-badge variant='danger' dot> "Offline"

			<demo-section heading='Small, beside text'>
				<div.row>
					<span> "Messages"
					<ui-badge size='sm' variant='accent'> "3"
					<span> "Maths with Ada"
					<ui-badge size='sm'> "GCSE"
