Config = {}

Config.Locale = 'en'

Config.MaxPayment = 75000
Config.MinPayment = 50000
Config.ChanceWeapon = 100 -- chance to get a weapon when mission succeeded, 0 = off 100 = always 

Config.AudioFile = '' -- interactsound audiofile to play when in cutscene
Config.AudioFileLength = 10 -- length for the audiofile (seconds)

Config.HoursSucess = 3 -- hours you need to be active on the server until you can steal a car again if you succeed (will start counting when active on the server for 30 seconds)
Config.HoursFailure = 6 -- hours you need to be active on the server until you can steal a car again if you fail (will start counting when active on the server for 30 seconds)

Config.CopsRequired = 0 -- cops required to start mission, not finished

Config.amountOfDropoff = 2 -- (amount of dropoffPoints)

Config.dropoffPoints = { -- x,y,z = where you leave the vehicle, sx,sy,sz,sh = x,y,z for vehicle spawn + heading for vehicle
	[1] = { x = -2192.39, y = 4265.86, z = 47.72, sx = 53.63, sy = -1877.22, sz = 21.51, sh = 137.47, model = "kuruma"},
	[2] = { x = -2192.39, y = 4265.86, z = 47.72, sx = 28.84, sy = -67.57, sz = 61.88, sh = 113.85, model = "exemplar"}
}