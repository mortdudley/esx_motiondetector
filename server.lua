RegisterServerEvent('esx_motiondetector:Broadcast')
AddEventHandler('esx_motiondetector:Broadcast', function(coords)
    TriggerClientEvent('esx_motiondetector:Notify', -1, coords)
end)