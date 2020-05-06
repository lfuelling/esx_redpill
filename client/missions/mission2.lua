local numberAdded = false
local secondMissionDone = false
local secondMissionStarted = false
local secondMissionIntroDone = false

--- Event handler for messages sent to the blocked contact (second mission)
RegisterNetEvent(eventNamespace .. blockedContact.namespace)
AddEventHandler(eventNamespace .. blockedContact.namespace, function(anon, message)
    if isInSecondMission() then
        local responseMsg = ""
        if anon then
            responseMsg = responseMsg .. _U('intro_msg_text_anon_obv')
        end
        if message == Locations.LifeInvader.DevPc.ip.address then
            completeSecondMission()
            secondMissionDone = true;
        else
            ESX.ShowAdvancedNotification(blockedContact.name, _U('mission_2_msg_subtitle'), -- title, subtitle
                    responseMsg .. _U('mission_2_msg_text_fail'), -- message
                    "CHAR_BLOCKED", 1) -- contact photo, symbol
        end
    end
end)

function _secondMissionLogic()
    if (not numberAdded and not secondMissionDone) then
        if not secondMissionStarted then
            TriggerEvent('esx_phone:addSpecialContact', blockedContact.name, blockedContact.number, blockedContact.base64Icon)
            numberAdded = true
            secondMissionStarted = true
        elseif secondMissionStarted then
            TriggerEvent('esx_phone:addSpecialContact', blockedContact.name, blockedContact.number, blockedContact.base64Icon)
            numberAdded = true
        end
    end
    if secondMissionStarted and not secondMissionDone and not secondMissionIntroDone then
        ESX.ShowAdvancedNotification(blockedContact.name, _U('mission_2_msg_subtitle'), -- title, subtitle
                _U('mission_2_msg_text_start'), -- message
                "CHAR_BLOCKED", 1) -- contact photo, symbol
        secondMissionIntroDone = true
    end
end

--- Completes the second mission and advances the job rank
function completeSecondMission()
    ESX.ShowAdvancedNotification(blockedContact.name, _U('mission_2_msg_subtitle'), -- title, subtitle
            responseMsg .. _U('mission_2_msg_text_final'), -- message
            "CHAR_BLOCKED", 1) -- contact photo, symbol
    Citizen.Wait(1500)
    TriggerServerEvent(eventNamespace .. "advJob", 2)
    Citizen.Wait(1500)
    TriggerEvent('esx_phone:removeSpecialContact', blockedContact.number)
end

--- Checks if player is in second mission.
-- @return true if job is hacker and rank is 1
function isInSecondMission()
    return isHacker() and ESX.GetPlayerData().job.grade_name == 'scriptkid'
end
