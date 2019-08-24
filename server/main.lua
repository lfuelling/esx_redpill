ESX = nil

--- Event listener for getting the ESX object
TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

--- Event listener for a message sent to a phone
RegisterNetEvent('esx_phone:send')
AddEventHandler('esx_phone:send', function(phoneNumber, message, anon, position)
    if phoneNumber == omegaContact.number then
        TriggerClientEvent(eventNamespace .. omegaContact.namespace, source, anon, message)
    elseif phoneNumber == blockedContact.number then
        TriggerClientEvent(eventNamespace .. blockedContact.namespace, source, anon, message)
    end
end)

--- Event listener for setting the job
RegisterNetEvent(eventNamespace .. "setJob")
AddEventHandler(eventNamespace .. "setJob", function(isHacker)
    if isHacker then
        ESX.GetPlayerFromId(source).setJob('hacker', 0)
    else
        ESX.GetPlayerFromId(source).setJob('unemployed', 0)
    end
end)

--- Event listener to advence in the job
RegisterNetEvent(eventNamespace .. "advJob")
AddEventHandler(eventNamespace .. "advJob", function(level)
    if level > 0 then
        ESX.GetPlayerFromId(source).setJob('hacker', level)
    else
        ESX.GetPlayerFromId(source).setJob('unemployed', 0)
    end
end)
