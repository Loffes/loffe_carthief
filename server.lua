ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-------------------- INSERT INTO DATABASE --------------------

AddEventHandler( "playerConnecting", function(name)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchScalar("SELECT * FROM carthief WHERE identifier = @identifier", {['@identifier'] = identifier})
	if not result then
		MySQL.Sync.execute("INSERT INTO carthief (`identifier`, `timeleft`) VALUES (@identifier, @timeleft)",{['@identifier'] = identifier, ['timeleft'] = 0})
		print('/////////////////////////////// loffe_carthief ///////////////////////////////')
		print('Spelaren med steamnamet ' .. name .. ' lades in i databasen "carthief", ' .. name .. 's hexkod är: ' .. identifier)
		print('/////////////////////////////////////////////////////////////////////////')
    end
end)

-------------------- DATABASE --------------------

RegisterServerEvent('loffe_carthief:updateTime')
AddEventHandler('loffe_carthief:updateTime', function()
	local identifier = GetPlayerIdentifiers(source)[1]
	MySQL.Async.fetchScalar('SELECT timeleft FROM carthief WHERE identifier=@identifier',
    {
        ['@identifier'] = identifier
    }, function(timeleft)
		if timeleft ~= 0 then
			local newtime = timeleft - 1
			MySQL.Async.execute("UPDATE carthief SET timeleft=@timeleft WHERE identifier=@identifier", {['@identifier'] = identifier, ['@timeleft'] = newtime})
		end
	end)
end)

RegisterServerEvent('loffe_carthief:questFinished')
AddEventHandler('loffe_carthief:questFinished', function()
	local identifier = GetPlayerIdentifiers(source)[1]
	local xPlayer = ESX.GetPlayerFromId(source)
	local payment = math.random(Config.MinPayment, Config.MaxPayment) -- vad man får för att göra uppdraget, 50-75 tusen.
	xPlayer.addMoney(payment)
	sendNotification(source, _U('mission_finished') .. payment .. _U('money'), 'success', 4500)
	MySQL.Async.execute("UPDATE carthief SET timeleft=@timeleft WHERE identifier=@identifier", {['@identifier'] = identifier, ['@timeleft'] = Config.HoursSucess*120}) 
	local weaponRandom = math.random(1, 100)
	if weaponRandom <= Config.ChanceWeapon then
		xPlayer.addWeapon("WEAPON_COMBATPISTOL", math.random(50, 150))
	end
end)

RegisterServerEvent('loffe_carthief:wait')
AddEventHandler('loffe_carthief:wait', function()
	local identifier = GetPlayerIdentifiers(source)[1]

	MySQL.Async.execute("UPDATE carthief SET timeleft=@timeleft WHERE identifier=@identifier", {['@identifier'] = identifier, ['@timeleft'] = Config.HoursFailure*120}) 
end)

ESX.RegisterServerCallback('loffe_carthief:getTimeLeft', function(source, cb)
	local identifier = GetPlayerIdentifiers(source)[1]
	MySQL.Async.fetchScalar('SELECT timeleft FROM carthief WHERE identifier=@identifier',
    {
        ['@identifier'] = identifier
    }, function(timeleft)
		cb(timeleft)
	end)
end)

-------------------- POLICE BLIPS --------------------

RegisterServerEvent('loffe_carthief:removeblip')
AddEventHandler('loffe_carthief:removeblip', function()
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('loffe_carthief:killblip', xPlayers[i])
		else
			TriggerClientEvent('loffe_carthief:killblip', xPlayers[i]) 
		end
	end
end)

RegisterServerEvent('loffe_carthief:moveblip')
AddEventHandler('loffe_carthief:moveblip', function(position)
	local xPlayers = ESX.GetPlayers()

	-- Remove old one and place a new one
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('loffe_carthief:killblip', xPlayers[i])
		else
			TriggerClientEvent('loffe_carthief:killblip', xPlayers[i]) 
		end
	end

	

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('loffe_carthief:setblip', xPlayers[i], position)
		end
	end
end)

-------------------- START MISSION --------------------

RegisterServerEvent('loffe_carthief:startMission')
AddEventHandler('loffe_carthief:startMission', function(mission)
    local _source    = source
    local identifier = GetPlayerIdentifiers(_source)[1]
	MySQL.Async.fetchScalar('SELECT timeleft FROM carthief WHERE identifier=@identifier',
    {
        ['@identifier'] = identifier
    }, function(timeleft)
		if timeleft == 0 then
			if mission == 0 then
				local policeConnected = 0
				local xPlayers = ESX.GetPlayers()
				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
					if xPlayer.job.name == 'police' then
						policeConnected = policeConnected + 1
					end
				end
				if policeConnected >= Config.CopsRequired then
					TriggerClientEvent('loffe_carthief:mission0', _source)
				else
					sendNotification(_source, _U('no_cops'), 'error', 5500)
				end
			end
		else
			sendNotification(_source, _U('play_server') .. math.ceil(timeleft/120) .. _U('until_steal'), 'error', 5500)
			
		end
	end)
end)

function sendNotification(xSource, message, messageType, messageTimeout)
    TriggerClientEvent("pNotify:SendNotification", xSource, {
        text = message,
        type = messageType,
        queue = "lmfao",
        timeout = messageTimeout,
        layout = "bottomCenter"
    })
end