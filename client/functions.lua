--- Checks if player is in first mission.
-- @return true if job is hacker and rank is 0
function isInFirstMission()
    return ESX.GetPlayerData().job ~= NIL and
            ESX.GetPlayerData().job.name == 'hacker' and
            ESX.GetPlayerData().job.grade_name == 'noob'
end

--- Checks if player is in second mission.
-- @return true if job is hacker and rank is 1
function isInSecondMission()
    return ESX.GetPlayerData().job ~= NIL and
            ESX.GetPlayerData().job.name == 'hacker' and
            ESX.GetPlayerData().job.grade_name == 'scriptkid'
end

--- Checks if player has "Hacker" job.
-- @return true if player has hacker job
function isHacker()
    return ESX.GetPlayerData().job ~= NIL and
            ESX.GetPlayerData().job.name == 'hacker'
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

--- Draws the markers for all PC locations.
function drawPcMarkers()
    -- draw markers for all hackable pcs
    for _, location in pairs(Locations) do
        __drawPcMarkers(location)
    end
end

--- Draws a marker for a single PC location
function __drawPcMarkers(location)
    if location.x ~= NIL then
        -- some locations are not machines
        if location.machine ~= NIL then
            if GetDistanceBetweenCoords(location.x, location.y, location.z, GetEntityCoords(PlayerPedId(), true)) < 200 then
                drawGenericMarker(location.x, location.y, location.z - 1.001)
                if GetDistanceBetweenCoords(location.x, location.y, location.z, GetEntityCoords(PlayerPedId(), true)) < 2 then
                    if IsControlJustPressed(1, 38) then
                        EnableGui(true, location.machine)
                    else
                        ESX.ShowHelpNotification(missionMarker.hint)
                    end
                end
            end
        end
    else
        -- we need to go deeper
        for _, l2 in pairs(location) do
            if l2 ~= NIL then
                __drawPcMarkers(l2)
            end
        end
    end
end

--- Draws a marker using only location params
function drawGenericMarker(x, y, z)
    DrawMarker(1, x, y, z,
            0, 0, 0, -- dir
            0, 0, 0, -- rot
            1.0, 1.0, 1.0, -- scale
            0, 0, 240, 200, -- rgba
            false, -- bob
            false, -- face
            2, -- p19
            false, -- rotate
            NULL, -- texture dict
            NULL, -- texture name
            false) -- draw on intersecting
end

--- Starts the tutorial
function startTutorial()
    Citizen.Wait(2000) -- wait for elevator doors
    DoScreenFadeOut(1000)
    Citizen.Wait(500)
    SetEntityCoords(PlayerPedId(), Locations.CommRoom.Entry.x, Locations.CommRoom.Entry.y, Locations.CommRoom.Entry.z, Locations.CommRoom.Entry.hdg)
    DoScreenFadeIn(1000)
    isHacking = true
    Citizen.Wait(500)
    ESX.ShowAdvancedNotification(omegaContact.name, _U('intro_msg_subtitle1'), -- title, subtitle
            _U('intro_msg_text1'), -- message
            "CHAR_OMEGA", 1) -- contact photo, symbol
    Citizen.Wait(4000) -- give the user time to read
    ESX.ShowAdvancedNotification(omegaContact.name, _U('intro_msg_subtitle2'), -- title, subtitle
            _U('intro_msg_text2'), -- message
            "CHAR_OMEGA", 1) -- contact photo, symbol
end

--- Finishes the tutorial
function finishTutorial(tutorialDone)
    DoScreenFadeOut(1000)
    Citizen.Wait(500)
    SetEntityCoords(PlayerPedId(), Locations.RedpillMarker.Exit.x, Locations.RedpillMarker.Exit.y, Locations.RedpillMarker.Exit.z)
    DoScreenFadeIn(1000)
    Citizen.Wait(1500)
    if tutorialDone then
        ESX.ShowAdvancedNotification(omegaContact.name, _U('intro_msg_subtitle_done'), -- title, subtitle
                _U('intro_msg_text_done'), -- message
                "CHAR_OMEGA", 1) -- contact photo, symbol
    else
        isHacking = false
        Citizen.Wait(500)
        ESX.ShowAdvancedNotification(omegaContact.name, _U('intro_msg_subtitle_quit'), -- title, subtitle
                _U('intro_msg_text_quit'), -- message
                "CHAR_OMEGA", 1) -- contact photo, symbol
    end
end
