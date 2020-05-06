local numberAdded = false
local firstMissionDone = false
local firstMissionStarted = false
local firstMissionIntroDone = false

--- Event handler for messages sent to the blocked contact (first mission)
RegisterNetEvent(eventNamespace .. blockedContact.namespace)
AddEventHandler(eventNamespace .. blockedContact.namespace, function(anon, message)
    if isInFirstMission() then
        local responseMsg = ""
        if anon then
            responseMsg = responseMsg .. _U('intro_msg_text_anon_obv')
        end
        if message == Locations.LifeInvader.AdminPc.machine.version then
            completeFirstMission()
            firstMissionDone = true;
        else
            ESX.ShowAdvancedNotification(blockedContact.name, _U('mission_1_msg_subtitle_re'), -- title, subtitle
                    responseMsg .. _U('mission_1_msg_text_fail'), -- message
                    "CHAR_BLOCKED", 1) -- contact photo, symbol
        end
    end
end)

function _firstMissionLogic()
    if (not numberAdded and not firstMissionDone) then
        if not firstMissionStarted then
            TriggerEvent('esx_phone:addSpecialContact', blockedContact.name, blockedContact.number, blockedContact.base64Icon)
            numberAdded = true
            firstMissionStarted = true
        elseif firstMissionStarted then
            TriggerEvent('esx_phone:addSpecialContact', blockedContact.name, blockedContact.number, blockedContact.base64Icon)
            numberAdded = true
        end
    end
    if firstMissionStarted and not firstMissionDone and not firstMissionIntroDone then
        ESX.ShowAdvancedNotification(blockedContact.name, _U('mission_1_msg_subtitle'), -- title, subtitle
                _U('mission_1_msg_text_start'), -- message
                "CHAR_BLOCKED", 1) -- contact photo, symbol
        firstMissionIntroDone = true
    end
end

--- Completes the first mission and advances the job rank
function completeFirstMission()
    ESX.ShowAdvancedNotification(blockedContact.name, _U('mission_1_msg_subtitle_re'), -- title, subtitle
            responseMsg .. _U('mission_1_msg_text_final'), -- message
            "CHAR_BLOCKED", 1) -- contact photo, symbol
    Citizen.Wait(1500)
    TriggerServerEvent(eventNamespace .. "advJob", 1)
    Citizen.Wait(1500)
    TriggerEvent('esx_phone:removeSpecialContact', blockedContact.number)
    TriggerEvent(eventNamespace .. "getNextTriggerTime")
end

--- Checks if player is in first mission.
-- @return true if job is hacker and rank is 0
function isInFirstMission()
    return isHacker() and ESX.GetPlayerData().job.grade_name == 'noob'
end
