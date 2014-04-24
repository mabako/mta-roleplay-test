help_menu =
{
	name = "Help",
	camera = { { matrix = { 1480, -1620, 13.8, 1480, -1623, 14.5 }, interior = 0, dimension = 20 } },
	
	-- when a window is going to be created, this function is called to fill it
	window = {
		text = "Welcome to the Help System\n\nJust select the topic that interests you in the menu on the left.\n\nIf this help didn't help you any further, You can always ask online admins for help by using /report (F2)"
	},
	{
		name = "Getting Started",
		multi = true,
		{
			name = "Arrival",
			camera = {
				{ matrix = { 1733 ,-1854, 16, 1802, -1920, -11, 0, 70 }, interior = 0, dimension = 0 },
				{ matrix = { 1707, -2183, 15, 1638, -2254, 10, 0, 70 }, interior = 0, dimension = 0 },
				{ matrix = { 1470, -1760, 22, 1535, -1833, 0, 0, 70 }, interior = 0, dimension = 0 }
			},
			window = {
				bottom = true,
				text = "Since you just arrived into town, you might want to go look for a job. The best way to do that is to go to City Hall.\nLegal jobs are the best way to go if you don't want to get in trouble, if you're into criminal activities, read the jobs section."
			}
		},
		
		{
			name = "Start your Journey",
			camera = {
				{ matrix = { 1948, -1745, 16, 1914, -1838, -0, 0, 70 }, interior = 0, dimension = 0 },
				{ matrix = { 1777, -1368, 41, 1747, -1301, -25, 0, 70 }, interior = 0, dimension = 0 }
			},
			window = {
				bottom = true,
				text = "Now that you're making money from you're job, you might want to go make some new friends? If so, maybe you should visit Idlewood Gas, it's filled with people.\nOr you want to hit a club? Who knows, but it's all up to you.\nIt's your life, you live it how you want!"
			},
		}
	},
	{
		name = "Factions",
		window = {
			bottom = true,
			text = "If you're wanting to join a faction you'll have to roleplay get into one, or you may have to apply for it at the following website:\n\nwww.mta.vg\n\nFor some government factions you have to apply on the website."
		},
	},
	{
		name = "Jobs",
		camera = {
			{ matrix = { 383, 174, 1009.7, 380, 174, 1009.6 }, interior = 3, dimension = 125 },
			{ matrix = { 1485, -1620, 72, 1485, -1720, 72 },   interior = 0, dimension = 0 },
			{ matrix = { 1483, -1710, 13.4, 1483, -1805, 44 }, interior = 0, dimension = 0 }
		},
		window = {
			text = "You can get all legal jobs from the City Hall.\n\nJust walk up to the Employee on the middle desk and choose what you want to do.\n\nIf you want to take illegal jobs, you need to find the person who's offering it."
		},
		{
			name = "Delivery Driver",
			multi = true,
			-- page one: depot (start)
			{
				name = "Delivery Driver",
				camera = {
					{ matrix = { -96, -1130, 25, -31, -1119, -50 }, interior = 0, dimension = 0 },
					{ matrix = { -92, -1090, 14, -41, -1175, -1 },  interior = 0, dimension = 0 }
				},
				window = {
					bottom = true,
					text = "\nOnce you've signed up for the Delivery Job, you can take a Truck from RS Haul, which is located just West of Los Santos.\n\nIf no Trucks are available, you may need to wait for one to come back, or look for another job."
				}
			},
			
			-- page two: checkpoints
			{
				name = "Delivery Driver II",
				camera = {
					{ matrix = { 1811, -1830, 22, 1886, -1873, -28 }, interior = 0, dimension = 20 }
				},
				window = {
					bottom = true,
					text = "As soon as you enter the truck, a blip will appear on the radar indicating your target location, and a marker will hint the drop-off spot to you.\n\nSimply wait at that spot for a couple of seconds, and drive to the next one.\n\nThe wage depends on the Truck's health."
				},
				onInit =
					function( )
						marker = createMarker( 1826.69140625, -1845.1533203125, 13.578125, "checkpoint", 4, 255, 200, 0, 150 )
						setElementDimension( marker, 20 )
						
						vehicle = createVehicle( 414,  1826, -1845, 13.6, 0, 0, 30 )
						setElementDimension( vehicle, 20 )
					end,
				onExit =
					function( )
						destroyElement( marker )
						marker = nil
						
						destroyElement( vehicle )
						vehicle = nil
					end
			},
			
			-- page three: depot
			{
				name = "Delivery Driver III",
				camera = {
					{ matrix = { -96, -1130, 25, -31, -1119, -50 }, interior = 0, dimension = 20 },
					{ matrix = { -92, -1090, 14, -41, -1175, -1 },  interior = 0, dimension = 20 }
				},
				window = {
					bottom = true,
					text = "\nWhen you think you've collected enough money from your trucking runs, head back to the Depot to collect your wage.\n\nEven if you quit during delivery job, your wage will be paid to you nevertheless."
				},
				onInit =
					function( )
						marker = createMarker(-69.087890625, -1111.1103515625, 0.64266717433929, "checkpoint", 4, 255, 0, 0, 150)
						setElementDimension( marker, 20 )
						setMarkerIcon( marker, "finish" )
					end,
				onExit =
					function( )
						destroyElement( marker )
						marker = nil
					end
			}
		},
		{
			name = "Taxi Driver",
			multi = true,
			-- page one: Getting the Job
			{
				name = "Taxi Driver I",
				camera = {
					{ matrix = { 1451, -1723, 46, 1515, -1779, -6, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 1512, -1730, 16, 1436, -1795, 14, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 1470, -1760, 22, 1535, -1833, 0, 0, 70 }, interior = 0, dimension = 0 }
				},
				window = {
					bottom = true,
					text = "\nTo become a Taxi Driver, you must first go to City Hall (The Building on your screen).\nAs you walk inside of the building, walk up to the person behind the desk and right click on them.\nSelect the Taxi Driver Job and hit accept.\nOnce you do all that, you're able to move onto the next step of being a Taxi Driver!"
				}
			},
			
			-- page two: starting the job
			{
				name = "Taxi Driver II",
				camera = {
					{ matrix = { 1819, -1815, 29, 1754, -1887, 6, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 1756, -1950, 32, 1803, -1869, 5, 0, 70 }, interior = 0, dimension = 0 }
				},
				window = {
					bottom = true,
					text = "\nThis is where you go after you've gotten the job to get your Taxi.\nThis is Unity Station, and the Taxi's are located in the back of the station's parking lot.\nOnce you've completed this step you're ready to start working!"
				},
			},
			
			-- page three: On Duty
			{
				name = "Taxi Driver III",
				camera = {
					{ matrix = { 1810, -1750, 45, 1833, -1664, -0, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 2058, -1147, 76, 1982, -1190, 28, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 2044, -1442, 48, 1956, -1468, 10, 0, 70 }, interior = 0, dimension = 0 }
				},
				window = {
					bottom = true,
					text = "\nNow, you're on your way to making money as a Taxi Driver! From here on everything you do is quite easy and simple.\nFrom now on, you just drive around, and wait for calls or for someone who wants a ride.\nOnce you get a call, go to the location stated, then do your job!"
				},
			} 
		},
		{
			name = "Bus Driver",
			multi = true,
			-- page one: Getting the job
			{
				name = "Bus Driver I",
				camera = {
					{ matrix = { 1451, -1723, 46, 1515, -1779, -6, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 1512, -1730, 16, 1436, -1795, 14, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 1470, -1760, 22, 1535, -1833, 0, 0, 70 }, interior = 0, dimension = 0 }
				},
				window = {
					bottom = true,
					text = "\nTo become a Bus Driver, you must first go to City Hall (The Building on your screen).\nAs you walk inside of the building, walk up to the person behind the desk and right click on them.\nSelect the Bus Driver Job and hit accept.\nOnce you do all that, you're able to move onto the next step of being a Bus Driver!"
				}
			},
			
			-- page two: Starting the job
			{
				name = "Bus Driver II",
				camera = {
					{ matrix = { 1819, -1815, 29, 1754, -1887, 6, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 1756, -1950, 32, 1803, -1869, 5, 0, 70 }, interior = 0, dimension = 0 }
				},
				window = {
					bottom = true,
					text = "\nThis is where you go after you've gotten the job to get your Bus.\nThis is Unity Station, and the Busses are located in the back of the station's parking lot.\nOnce you've completed this step you're ready to start working!"
				},
			},
			
			-- page three: On Duty
			{
				name = "Bus Driver III", 
				camera = {
					{ matrix = { 1810, -1750, 45, 1833, -1664, -0, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 2058, -1147, 76, 1982, -1190, 28, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 2044, -1442, 48, 1956, -1468, 10, 0, 70 }, interior = 0, dimension = 0 }
				},
				window = {
					bottom = true,
					text = "After you type /startbus, you notice a lot of blips on your map. Yellow and red. What your objective is to do is to go through the yellow markers, and stop at the red ones.\n\nRed = Stop | Yellow = Route\n\nJust continue doing that and you'll get paid."
				},
			},
		},
		{
			name = "City Maintenance",
			multi = true,
			-- page one: getting the job
			{
				name = "City Maintenance I",
				camera = {
					{ matrix = { 1451, -1723, 46, 1515, -1779, -6, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 1512, -1730, 16, 1436, -1795, 14, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 1470, -1760, 22, 1535, -1833, 0, 0, 70 }, interior = 0, dimension = 0 }
				},
				window = {
					bottom = true,
					text = "\nTo become a City Maintenance, you must first go to City Hall (The Building on your screen).\nAs you walk inside of the building, walk up to the person behind the desk and right click on them.\nSelect the City Maintenance and hit accept.\nOnce you do all that, you're able to move onto the next step of being a City Maintenance!"
				},
			},
			
			-- page two: how to do the job
			{
				name = "City Maintenance II",
				camera = {
					{ matrix = { 1810, -1750, 45, 1833, -1664, -0, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 2058, -1147, 76, 1982, -1190, 28, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 2044, -1442, 48, 1956, -1468, 10, 0, 70 }, interior = 0, dimension = 0 }
				},
				window = {
					bottom = true,
					text = "\nAs City Maintenance, your objective is to go around the city, and clean all those grafitti tags off the walls that people do.\nAll you have to do is find the grafitti, and spray over it with your spraycan.\nEverytime you clean some grafitti, you get a small amount of money."
				},
			}
		},
		{
			name = "Mechanic",
			window = {
				bottom = true,
				text = "\nAs a Mechanic, you can fix peoples vehicles if it's need, or add onto them.\nYou do this buy having a certain amount of money on you (Each Upgrade/Repair costs money), and you right click the vehicle you're wanting to work on. You select 'Fix/Upgrade' then choose the option."
			}
		},
		{
			name = "Locksmith",
			window = {
				bottom = true,
				text = "\nAs a Locksmith, there's nothing really important to do. It's not a job that many people require, but it sure is useful.\nWhat you do is you can make duplicate keys of Vehicle/Business/House keys if you have the original copy."
			}
		},
		{
			name = "Illegal Jobs",
			camera = {
				{ matrix = { 1425, -1334, 23, 1402, -1241, -2, 0, 70 }, interior = 0, dimension = 0 }
			},
			window = {
				bottom = true,
				text = "\nIllegal Jobs can be anything you want to roleplay that is illegal. There is no actual job you can get that is illegal.\n\nThere is no actual 'illegal' job, the possibilities are endless!"
			}
		}
	},
	{
		name = "Vehicles",
		multi = true,
		-- page one: Grotti Dealership (Cars)
		{
			name = "Grotti Dealership",
			camera = {
				{ matrix = { 556, -1263, 34, 526, -1342, -19, 0, 70 }, interior = 0, dimension = 0 },
				{ matrix = { 507, -1280, 34, 591, -1296, -16, 0, 70 }, interior = 0, dimension = 0 }
			},
			window = {
				bottom = true,
				text = "\nThis is where you can buy a vehicle for yourself if you have enough money, and a license.\nThere is a variety of vehicles that you can buy from thie dealership.\nREMINDER: /vehpos to park your vehicle and save it's position so it spawns there."
			}
		},
		
		-- page two: The Rusted Anchor (Boats)
		{
			name = "The Rusted Anchor",
			camera = {
				{ matrix = { 736, -1727, 14, 676, -1657, -24, 0, 70 }, interior = 0, dimension = 0 },
				{ matrix = { 697, -1681, 18, 758, -1743, -29, 0, 70 }, interior = 0, dimension = 0 },
				{ matrix = { 170, -1765, 28, 104, -1836, 3, 0, 70 }, interior = 0, dimension = 0 },
				{ matrix = { 37, -1835, 24, 130, -1816, -6, 0, 70 }, interior = 0, dimension = 0 }
			},
			window = {
				bottom = true,
				text = "\nNow, this is where you can buy a boat if you've got the extra cash. You must have a license to do this, too. There is about 5 different boats you can buy with your hard earned money. The boating dock is located in Santa Maria Beach.\nREMINDER: /vehpos to park your boat and save it's position so it spawns there."
			},
		}
	}
}