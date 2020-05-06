local numberAdded = false
local thirdMissionDone = false
local thirdMissionStarted = false
local thirdMissionIntroDone = false

--- Event handler for messages sent to the blocked contact (third mission)
RegisterNetEvent(eventNamespace .. blockedContact.namespace)
AddEventHandler(eventNamespace .. blockedContact.namespace, function(anon, message)
    if isInThirdMission() then
        local responseMsg = ""
        if anon then
            responseMsg = responseMsg .. _U('intro_msg_text_anon_obv')
        end
        if message == Locations.Bank.VaultPc.ip.address then
            completeThirdMission()
            thirdMissionDone = true;
        else
            ESX.ShowAdvancedNotification(blockedContact.name, _U('mission_3_msg_subtitle_re'), -- title, subtitle
                    responseMsg .. _U('mission_3_msg_text_fail'), -- message
                    "CHAR_BLOCKED", 1) -- contact photo, symbol
        end
    end
end)

function _thirdMissionLogic()
    if (not numberAdded and not thirdMissionDone) then
        if not thirdMissionStarted then
            TriggerEvent('esx_phone:addSpecialContact', blockedContact.name, blockedContact.number, blockedContact.base64Icon)
            numberAdded = true
            thirdMissionStarted = true
        elseif thirdMissionStarted then
            TriggerEvent('esx_phone:addSpecialContact', blockedContact.name, blockedContact.number, blockedContact.base64Icon)
            numberAdded = true
        end
    end
    if thirdMissionStarted and not thirdMissionDone and not thirdMissionIntroDone then
        ESX.ShowAdvancedNotification(blockedContact.name, _U('mission_3_msg_subtitle'), -- title, subtitle
                _U('mission_3_msg_text_start'), -- message
                "CHAR_BLOCKED", 1) -- contact photo, symbol
        thirdMissionIntroDone = true
    end
end

--- Completes the third mission and advances the job rank
function completeThirdMission()
    ESX.ShowAdvancedNotification(blockedContact.name, _U('mission_3_msg_subtitle_re'), -- title, subtitle
            responseMsg .. _U('mission_3_msg_text_final'), -- message
            "CHAR_BLOCKED", 1) -- contact photo, symbol
    Citizen.Wait(1500)
    TriggerServerEvent(eventNamespace .. "advJob", 3)
    Citizen.Wait(1500)
    TriggerEvent('esx_phone:removeSpecialContact', blockedContact.number)
    TriggerEvent(eventNamespace .. "getNextTriggerTime")
end

--- Checks if player is in third mission.
-- @return true if job is hacker and rank is 2
function isInThirdMission()
    return isHacker() and ESX.GetPlayerData().job.grade_name == 'developer'
end
