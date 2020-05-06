local numberAdded = false
local fourthMissionDone = false
local fourthMissionStarted = false
local fourthMissionIntroDone = false

--- Event handler for messages sent to the blocked contact (fourth mission)
RegisterNetEvent(eventNamespace .. blockedContact.namespace)
AddEventHandler(eventNamespace .. blockedContact.namespace, function(anon, message)
    if isInFourthMission() then
        local responseMsg = ""
        if anon then
            responseMsg = responseMsg .. _U('intro_msg_text_anon_obv')
        end
        if message == Locations.Bank.BackOfficePc1.machine.user then
            completeFourthMission()
            fourthMissionDone = true;
        else
            ESX.ShowAdvancedNotification(blockedContact.name, _U('mission_4_msg_subtitle_re'), -- title, subtitle
                    responseMsg .. _U('mission_4_msg_text_fail'), -- message
                    "CHAR_BLOCKED", 1) -- contact photo, symbol
        end
    end
end)

function _fourthMissionLogic()
    if (not numberAdded and not fourthMissionDone) then
        if not fourthMissionStarted then
            TriggerEvent('esx_phone:addSpecialContact', blockedContact.name, blockedContact.number, blockedContact.base64Icon)
            numberAdded = true
            fourthMissionStarted = true
        elseif fourthMissionStarted then
            TriggerEvent('esx_phone:addSpecialContact', blockedContact.name, blockedContact.number, blockedContact.base64Icon)
            numberAdded = true
        end
    end
    if fourthMissionStarted and not fourthMissionDone and not fourthMissionIntroDone then
        ESX.ShowAdvancedNotification(blockedContact.name, _U('mission_4_msg_subtitle'), -- title, subtitle
                _U('mission_4_msg_text_start'), -- message
                "CHAR_BLOCKED", 1) -- contact photo, symbol
        fourthMissionIntroDone = true
    end
end

--- Completes the third mission and advances the job rank
function completeFourthMission()
    ESX.ShowAdvancedNotification(blockedContact.name, _U('mission_4_msg_subtitle_re'), -- title, subtitle
            responseMsg .. _U('mission_4_msg_text_final'), -- message
            "CHAR_BLOCKED", 1) -- contact photo, symbol
    Citizen.Wait(1500)
    TriggerServerEvent(eventNamespace .. "advJob", 4)
    Citizen.Wait(1500)
    TriggerEvent('esx_phone:removeSpecialContact', blockedContact.number)
    TriggerEvent(eventNamespace .. "getNextTriggerTime")
end

--- Checks if player is in fourth mission.
-- @return true if job is hacker and rank is 3
function isInFourthMission()
    return isHacker() and ESX.GetPlayerData().job.grade_name == 'pentester'
end
