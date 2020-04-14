ESX                           = nil
local PlayerData              = {}
local intruderDetected 		  = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
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

        for k in pairs(Config.ProximityAlarms) do

        local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
        local dist = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, Config.ProximityAlarms[k].x, Config.ProximityAlarms[k].y, Config.ProximityAlarms[k].z)

        if dist <= Config.Distance then
			local playerPed = GetPlayerPed(-1)
			if intruderDetected == false and PlayerData.job.name ~= Config.Job then
				local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
				TriggerServerEvent('esx_phone:send', Config.Job, 'An intruder is within ' ..Config.Distance.. 'm of your treehouse ', true, {x =x, y =y, z =z})
			end															
		
			intruderDetected = true
			Citizen.Wait(Config.AlertTime)
			intruderDetected = false
			end
        end
    end
end)
