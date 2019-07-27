ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterNetEvent('esx_phone:send')
AddEventHandler('esx_phone:send', function(phoneNumber, message, anon, position)
    if phoneNumber == omegaContact.number then
        TriggerClientEvent(eventNamespace .. "messageIn", source, anon, message)
    end
end)
