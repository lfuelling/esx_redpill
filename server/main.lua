ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterNetEvent('esx_phone:send')
AddEventHandler('esx_phone:send', function(phoneNumber, message, anon, position)
    if phoneNumber == omegaContact.number then
        TriggerClientEvent(eventNamespace .. omegaContact.namespace, source, anon, message)
    end
end)

RegisterNetEvent(eventNamespace .. "setJob")
AddEventHandler(eventNamespace .. "setJob", function(isHacker)
    if isHacker then
        ESX.GetPlayerFromId(source).setJob('hacker', 0)
    else
        ESX.GetPlayerFromId(source).setJob('unemployed', 0)
    end
end)
