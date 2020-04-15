ESX                           = nil
local PlayerData              = {}
local isInZone      		  = false

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
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		local playerPed = GetPlayerPed(-1)
		local playerCoords = GetEntityCoords(playerPed, false)
		local dist

		for k,v in pairs(Config.ProximityAlarms) do
			for k2,v2 in pairs(v) do 
				dist = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, v.coords)

				if dist <= v.alertDistance then
					isInZone = true
					if isInZone == true and PlayerData.job.name ~= v.whitelistedJob then
						TriggerServerEvent('esx_motiondetector:Broadcast', playerCoords)
					end															
				
					Citizen.Wait(Config.AlertTime)
					isInZone = false
				end
			end
		end
    end
end)

RegisterNetEvent('esx_motiondetector:Notify')
AddEventHandler('esx_motiondetector:Notify', function(coords)
	if Config.NotificationType == 1 then
		TriggerServerEvent('esx_phone:send', Config.Job, 'An intruder is within ' ..Config.Distance.. 'm of your hideout ', true, {x = coords.x, y = coords.y, z = coords.z})
	elseif Config.NotificationType == 2 then
		ESX.ShowNotification('An intruder is within ' ..Config.Distance.. 'm of your hideout ', false, true)
		PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
	end
end)