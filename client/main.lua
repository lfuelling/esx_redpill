ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

local guiEnabled = false
local isHacking = false
local tutorialDone = false
local phoneReady = false
local numberAdded = false

-- shows the GUI
function EnableGui(enable, machineToHack)
    SetNuiFocus(enable)
    guiEnabled = enable

    SendNUIMessage({
        type = "enableui",
        enable = enable,
        machine = machineToHack
    })
end

AddEventHandler(eventNamespace .. "tutorialDone", function()
    tutorialDone = true
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
    phoneReady = true
end)

RegisterNetEvent(eventNamespace .. omegaContact.namespace)
AddEventHandler(eventNamespace .. omegaContact.namespace, function(anon, message)
    local responseMsg = ""
    if anon then
        responseMsg = responseMsg .. _U('intro_msg_text_anon')
    end
    if message == Locations.Lester.MainPc.machine.hostname then
        ESX.ShowAdvancedNotification(omegaContact.name, _U('intro_msg_subtitle_done'), -- title, subtitle
                responseMsg .. _U('intro_msg_text_final1'), -- message
                "CHAR_OMEGA", 1) -- contact photo, symbol
        Citizen.Wait(1500)
        TriggerServerEvent(eventNamespace .. "setJob", true)
        Citizen.Wait(1500)
        ESX.ShowAdvancedNotification(omegaContact.name, _U('intro_msg_subtitle_final'), -- title, subtitle
                _U('intro_msg_text_final2'), -- message
                "CHAR_OMEGA", 1) -- contact photo, symbol
    else
        ESX.ShowAdvancedNotification(omegaContact.name, _U('intro_msg_subtitle_wrong'), -- title, subtitle
                responseMsg .. _U('intro_msg_text_fail'), -- message
                "CHAR_OMEGA", 1) -- contact photo, symbol
    end
end)

RegisterNUICallback('escape', function(data)
    EnableGui(false, NIL)
end)

RegisterNUICallback('command', function(data)
    if data.command then
        SendNUIMessage({
            type = 'terminalOut',
            output = ExecuteRPCommand(data.command, data.machine),
        })
    else
        SendNUIMessage({
            type = 'terminalOut',
            output = "",
        })
    end
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

function drawPcMarkers()
    -- draw markers for all hackable pcs
    for _, location in pairs(Locations) do
        __drawPcMarkers(location)
    end
end

function __drawPcMarkers(location)
    if location.x ~= NIL then
        -- some locations are not machines
        if location.machine ~= NIL then
            drawGenericMarker(location.x, location.y, location.z - 1.001)
            if GetDistanceBetweenCoords(location.x, location.y, location.z, GetEntityCoords(GetPlayerPed(-1), true)) < 2 then
                if IsControlJustPressed(1, 38) then
                    EnableGui(true, location.machine)
                else
                    ESX.ShowHelpNotification(missionMarker.hint)
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

-- mission logic
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if ESX.GetPlayerData().job == 'hacker' and not isHacking then
            isHacking = true
            tutorialDone = true
        end

        if isHacking then
            drawPcMarkers()
            if phoneReady and tutorialDone and not numberAdded then
                TriggerEvent('esx_phone:addSpecialContact', omegaContact.name, omegaContact.number, omegaContact.base64Icon)
                numberAdded = true
            end
        else
            if numberAdded then
                TriggerEvent('esx_phone:removeSpecialContact', omegaContact.number)
                numberAdded = false
            end
            if tutorialDone then
                tutorialDone = false
            end
            drawGenericMarker(Locations.RedpillMarker.Entry.x, Locations.RedpillMarker.Entry.y, Locations.RedpillMarker.Entry.z - 1.001)

            if GetDistanceBetweenCoords(Locations.RedpillMarker.Entry.x, Locations.RedpillMarker.Entry.y, Locations.RedpillMarker.Entry.z, GetEntityCoords(GetPlayerPed(-1), true)) < 7 then
                if GetDistanceBetweenCoords(Locations.RedpillMarker.Entry.x, Locations.RedpillMarker.Entry.y, Locations.RedpillMarker.Entry.z, GetEntityCoords(GetPlayerPed(-1), true)) < 2 then
                    Citizen.Wait(2000) -- wait for elevator doors
                    DoScreenFadeOut(1000)
                    Citizen.Wait(500)
                    SetEntityCoords(GetPlayerPed(-1), Locations.CommRoom.Entry.x, Locations.CommRoom.Entry.y, Locations.CommRoom.Entry.z, Locations.CommRoom.Entry.hdg)
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
                else
                    ESX.ShowHelpNotification(_U('intro_help_text'))
                end
            end
        end
    end
end)

-- intro/tutorial logic
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if isHacking then
            drawGenericMarker(Locations.CommRoom.Exit.x, Locations.CommRoom.Exit.y, Locations.CommRoom.Exit.z - 1.0001)

            if GetDistanceBetweenCoords(Locations.CommRoom.Exit.x, Locations.CommRoom.Exit.y, Locations.CommRoom.Exit.z, GetEntityCoords(GetPlayerPed(-1), true)) < 2 then
                if IsControlJustPressed(1, 38) then
                    DoScreenFadeOut(1000)
                    Citizen.Wait(500)
                    SetEntityCoords(GetPlayerPed(-1), Locations.RedpillMarker.Exit.x, Locations.RedpillMarker.Exit.y, Locations.RedpillMarker.Exit.z)
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
                else
                    if tutorialDone then
                        ESX.ShowHelpNotification(_U('press_interact_to_exit'))
                    else
                        ESX.ShowHelpNotification(_U('press_interact_to_quit'))
                    end
                end
            end


        end
    end
end)