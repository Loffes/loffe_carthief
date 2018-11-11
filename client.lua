local PlayerData = {}
ESX                           = nil

local cinema = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local debug = true
local blockinput = false
local carThief = false
local cirklar = { 
	["~g~[E] ~w~" .. _U('start_hint')] = { ["x"] = -2172.95, ["y"] = 4284.63, ["z"] = 48.27, ["mission"] = 0}
} 


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30000) -- every 30 seconds
		ESX.TriggerServerCallback('loffe_carthief:getTimeLeft', function(timeleft)
			if timeleft > 0 then
				TriggerServerEvent('loffe_carthief:updateTime') -- update the database time
			else
				Citizen.Wait(30000)
				if debug then
					print(timeleft)
				end
			end
		end)
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		for k, v in pairs(cirklar) do
			local coords = GetEntityCoords(GetPlayerPed(-1))
			if GetDistanceBetweenCoords(coords, v["x"], v["y"], v["z"], true) < 100 then
				DrawMarker(27, v["x"], v["y"], v["z"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
				if GetDistanceBetweenCoords(coords, v["x"], v["y"], v["z"], true) < 1.5 then
					DrawText3D(v["x"], v["y"], v["z"]+0.9, k, 0.80)
					if IsControlPressed(0, 38) and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name ~= 'police' then
						Wait(50)
						TriggerServerEvent('loffe_carthief:startMission', v["mission"])
						Wait(950)
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		if cinema then
		local hasCinema = false
			while cinema do
				Wait(5)
				DrawRect(0.5, 0.075, 1.0, 0.15, 0, 0, 0, 255)
				DrawRect(0.5, 0.925, 1.0, 0.15, 0, 0, 0, 255)
				SetDrawOrigin(0.0, 0.0, 0.0, 0)
				DisplayRadar(false)
			end
		end
	end
end)

RegisterNetEvent('loffe_carthief:mission0')
AddEventHandler('loffe_carthief:mission0', function()
	SetEntityCoords(GetPlayerPed(-1), -2173.39, 4285.6, 48.26)
	SetEntityHeading(GetPlayerPed(-1), 11.6)
	TriggerServerEvent('loffe_carthief:wait')
	blockinput = true
	cinema = true
	TriggerEvent('es:setMoneyDisplay', 0.0)
	ESX.UI.HUD.SetDisplay(0.0)
	TriggerEvent('esx_status:setDisplay', 0.0)
	DisplayRadar(false)
	RequestModel(599294057)
	while not HasModelLoaded(599294057) do
		Wait(0)
	end
	local SpawnObject = CreatePed(4, 599294057, -2173.3, 4291.63, 48.18)
	SetEntityHeading(SpawnObject, 186.59)
	FreezeEntityPosition(SpawnObject, true)
	local dictPed = "mini@strip_club@idles@bouncer@base"
	RequestAnimDict(dictPed)
	while not HasAnimDictLoaded(dictPed) do
		Citizen.Wait(100)
	end
	TaskPlayAnim(SpawnObject, dictPed, "base", 8.0, 8.0, -1, 50, 0, false, false, false)
	local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	SetCamCoord(cam, -2176.92, 4287.89, 50.73)
	SetCamRot(cam, 0.0, 0.0, 270.05, 0)
	RenderScriptCams(1, 0, 0, 1, 1)
	TaskGoToCoordAnyMeans(GetPlayerPed(-1), -2172.92, 4289.36, 48.2, 1.0, 0, 0, 786603, 1.0)
	Wait(3000)
	local dict = "amb@world_human_cop_idles@male@idle_b"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
	TaskPlayAnim(GetPlayerPed(-1), dict, "idle_d", 8.0, 8.0, -1, 50, 0, false, false, false)
	TriggerServerEvent("InteractSound_SV:PlayOnSource", Config.AudioFile, 1.0)
	Wait(Config.AudioFileLength*1000)
	cinema = false
	TriggerEvent('es:setMoneyDisplay', 1.0)
	ESX.UI.HUD.SetDisplay(1.0)
	TriggerEvent('esx_status:setDisplay', 1.0)
	DisplayRadar(true)
	DestroyCam(createdCamera, 0)
	RenderScriptCams(0, 0, 1, 1, 1)
	createdCamera = 0
	ClearTimecycleModifier("scanline_cam_cheap")
	SetFocusEntity(GetPlayerPed(PlayerId()))
	blockinput = false
	Wait(200)
	enableActions()
	FreezeEntityPosition(SpawnObject, false)
	ClearPedTasks(SpawnObject)
	ClearPedTasks(GetPlayerPed(-1))
	TaskGoToCoordAnyMeans(SpawnObject, -2175.4, 4294.96, 48.2, 1.0, 0, 0, 786603, 1.0)
	carThief = true
	Wait(5000)
	DeleteEntity(SpawnObject)
	Blip = AddBlipForCoord(53.63, -1877.22, 21.51)
	SetBlipRoute(Blip, true)
	SetBlipColour(Blip, 11)
	SetBlipRouteColour(Blip, 11)
	repeat
		Citizen.Wait(500)
		local coords = GetEntityCoords(GetPlayerPed(-1))
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		ClearPrints()
        SetTextEntry_2("STRING")
        AddTextComponentString(_U('drive_text'))
		DrawSubtitleTimed(500, 1)
			if GetDistanceBetweenCoords(coords, 53.63, -1877.22, 21.51, true) < 50 then
				nearCar = 1
			end
		else
		ClearPrints()
        SetTextEntry_2("STRING")
        AddTextComponentString(_U('not_in_vehicle'))
		DrawSubtitleTimed(500, 1)
		end
	until(nearCar == 1)
	RemoveBlip(Blip)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if carThief then
			local coords = GetEntityCoords(GetPlayerPed(-1))
			local vehicleModel = GetHashKey("kuruma")

			RequestModel(vehicleModel)

			while not HasModelLoaded(vehicleModel) do
				Citizen.Wait(0)
			end
			if GetDistanceBetweenCoords(coords, 53.63, -1877.22, 21.51, true) < 50 then
				local spawned_cars = CreateVehicle(vehicleModel, 53.63, -1877.22, 21.51, 137.47, true, false)
				SetVehicleOnGroundProperly(spawned_cars)
				local hasTjuvkopplat = 0
				repeat
					Citizen.Wait(500)
					if IsPedInVehicle(GetPlayerPed(-1), spawned_cars, false) then
						TriggerServerEvent('esx_phone:send', 'police', (_U('police_message')), true, {x = 53.63, y = -1877.22, z = 137.47}, true)
						ClearPrints()
						SetTextEntry_2("STRING")
						AddTextComponentString(_U('hot_wire').. '.')
						DrawSubtitleTimed(500, 1)
						Citizen.Wait(500)
						ClearPrints()
						SetTextEntry_2("STRING")
						AddTextComponentString(_U('hot_wire').. '..')
						DrawSubtitleTimed(500, 1)
						Citizen.Wait(500)
						ClearPrints()
						SetTextEntry_2("STRING")
						AddTextComponentString(_U('hot_wire').. '...')
						DrawSubtitleTimed(500, 1)
						Citizen.Wait(500)
						ClearPrints()
						SetTextEntry_2("STRING")
						AddTextComponentString(_U('hot_wire').. '.')
						DrawSubtitleTimed(500, 1)
						Citizen.Wait(500)
						ClearPrints()
						SetTextEntry_2("STRING")
						AddTextComponentString(_U('hot_wire').. '..')
						DrawSubtitleTimed(500, 1)
						Citizen.Wait(500)
						ClearPrints()
						SetTextEntry_2("STRING")
						AddTextComponentString(_U('hot_wire').. '...')
						DrawSubtitleTimed(500, 1)
						Citizen.Wait(500)
						hasTjuvkopplat = 1
					end
				until(hasTjuvkopplat == 1)
				local timesUntilSendareLoss = 240
				repeat
				Citizen.Wait(500)
				if IsPedInVehicle(GetPlayerPed(-1), spawned_cars, false) then
					ClearPrints()
					SetTextEntry_2("STRING")
					AddTextComponentString(_U('remove_transmitter_1') .. timesUntilSendareLoss .. _U('remove_transmitter_2'))
					DrawSubtitleTimed(1000, 1)
					Citizen.Wait(400)
					local vehicleCoords = GetEntityCoords(spawned_cars)
					local Position = {x = vehicleCoords.x, y = vehicleCoords.y, z = vehicleCoords.z}
					TriggerServerEvent('loffe_carthief:moveblip', Position)
					timesUntilSendareLoss = timesUntilSendareLoss - 1
				end
				until(timesUntilSendareLoss == 0)
				timesUntilSendareLoss = 240
				Blip = AddBlipForCoord(-2192.39, 4265.86, 47.72)
				SetBlipRoute(Blip, true)
				SetBlipColour(Blip, 11)
				SetBlipRouteColour(Blip, 11)
				TriggerServerEvent('loffe_carthief:removeblip')
				local hasSoldVehicle = 0
				repeat
				Citizen.Wait(500)
				local coords = GetEntityCoords(GetPlayerPed(-1))
					if IsPedInVehicle(GetPlayerPed(-1), spawned_cars, false) then
							if GetDistanceBetweenCoords(coords, -2192.39, 4265.86, 47.72, true) < 5 then
								TaskEveryoneLeaveVehicle(spawned_cars)
								TaskLeaveVehicle(GetPlayerPed(-1), spawned_cars, 0)
								Wait(5000)
								ClearPedTasksImmediately(GetPlayerPed(-1))
								SetVehicleDoorsLocked(spawned_cars, 2)
								RemoveBlip(Blip)
								TriggerServerEvent('loffe_carthief:questFinished')
								hasSoldVehicle = 1
							end
						ClearPrints()
						SetTextEntry_2("STRING")
						AddTextComponentString(_U('drive_text'))
						DrawSubtitleTimed(500, 1)
					end
				until(hasSoldVehicle == 1)
				RemoveBlip(Blip)
				local hasRemovedCar = false
				while not hasRemovedCar do
					Wait(1000)
					local coordsMe = GetEntityCoords(GetPlayerPed(-1))
					local coordsCar = GetEntityCoords(spawned_cars)
					if GetDistanceBetweenCoords(coordsMe, coordsCar) > 50 then
						SetEntityAsMissionEntity(spawned_cars, 0, 0)
						DeleteVehicle(spawned_cars)
						hasRemovedCar = true
						carThief = false
					end
				end
			end
		end	
	end
end)

RegisterNetEvent('loffe_carthief:killblip')
AddEventHandler('loffe_carthief:killblip', function()
    RemoveBlip(CarBlip)
end)

RegisterNetEvent('loffe_carthief:setblip')
AddEventHandler('loffe_carthief:setblip', function(position)
	CarBlip = AddBlipForCoord(position.x, position.y, position.z)
	SetBlipSprite(CarBlip , 161)
	SetBlipScale(CarBlip , 2.0)
	SetBlipColour(CarBlip, 3)
	PulseBlip(CarBlip)
end)

function enableActions()
	EnableAllControlActions(0)
	EnableAllControlActions(1)
	EnableAllControlActions(2)
	EnableAllControlActions(3)
	EnableAllControlActions(4)
	EnableAllControlActions(5)
	EnableAllControlActions(6)
	EnableAllControlActions(7)
	EnableAllControlActions(8)
	EnableAllControlActions(9)
	EnableAllControlActions(10)
	EnableAllControlActions(11)
	EnableAllControlActions(12)
	EnableAllControlActions(13)
	EnableAllControlActions(14)
	EnableAllControlActions(15)
	EnableAllControlActions(16)
	EnableAllControlActions(17)
	EnableAllControlActions(18)
	EnableAllControlActions(19)
	EnableAllControlActions(20)
	EnableAllControlActions(21)
	EnableAllControlActions(22)
	EnableAllControlActions(23)
	EnableAllControlActions(24)
	EnableAllControlActions(25)
	EnableAllControlActions(26)
	EnableAllControlActions(27)
	EnableAllControlActions(28)
	EnableAllControlActions(29)
	EnableAllControlActions(30)
	EnableAllControlActions(31)
end

Citizen.CreateThread(function()
	local count
	while true do
		Citizen.Wait(0)
		if blockinput then
			count = 1
			DisableAllControlActions(0)
			DisableAllControlActions(1)
			DisableAllControlActions(2)
			DisableAllControlActions(3)
			DisableAllControlActions(4)
			DisableAllControlActions(5)
			DisableAllControlActions(6)
			DisableAllControlActions(7)
			DisableAllControlActions(8)
			DisableAllControlActions(9)
			DisableAllControlActions(10)
			DisableAllControlActions(11)
			DisableAllControlActions(12)
			DisableAllControlActions(13)
			DisableAllControlActions(14)
			DisableAllControlActions(15)
			DisableAllControlActions(16)
			DisableAllControlActions(17)
			DisableAllControlActions(18)
			DisableAllControlActions(19)
			DisableAllControlActions(20)
			DisableAllControlActions(21)
			DisableAllControlActions(22)
			DisableAllControlActions(23)
			DisableAllControlActions(24)
			DisableAllControlActions(25)
			DisableAllControlActions(26)
			DisableAllControlActions(27)
			DisableAllControlActions(28)
			DisableAllControlActions(29)
			DisableAllControlActions(30)
			DisableAllControlActions(31)
		else
		Citizen.Wait(500)
		end
	end
end)

function DrawText3D(x, y, z, text, scale)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
 
    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 215)
 
    AddTextComponentString(text)
    DrawText(_x, _y)
 
    local factor = (string.len(text)) / 230
    DrawRect(_x, _y + 0.0250, 0.095 + factor, 0.06, 41, 11, 41, 100)
end