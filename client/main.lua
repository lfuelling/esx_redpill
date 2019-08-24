ESX = nil
local guiEnabled = false
local isHacking = false
local tutorialDone = false
local tutorialFinished = false
local phoneReady = false
local numberAdded = false
local firstMissionDone = false
local firstMissionStarted = false
local firstMissionIntroDone = false

--- Shows the GUI
-- Not extracted to functions.lua because it uses local vars
function EnableGui(enable, machineToHack)
    SetNuiFocus(enable)
    guiEnabled = enable

    SendNUIMessage({
        type = "enableui",
        enable = enable,
        machine = machineToHack
    })
end

--- Event handler for tutorial completion
AddEventHandler(eventNamespace .. "tutorialDone", function()
    tutorialDone = true
end)

--- Event handler for esx_phone initialization
RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
    phoneReady = true
end)

--- Event handler for a message sent to omega (tutorial)
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
        TriggerEvent('esx_phone:removeSpecialContact', omegaContact.number)
    else
        ESX.ShowAdvancedNotification(omegaContact.name, _U('intro_msg_subtitle_wrong'), -- title, subtitle
                responseMsg .. _U('intro_msg_text_fail'), -- message
                "CHAR_OMEGA", 1) -- contact photo, symbol
    end
end)

--- Event handler for player death
AddEventHandler('esx:onPlayerDeath', function()
    if isHacking and not tutorialDone then
        isHacking = false;
    end
    if tutorialFinished and not isHacker() then
        tutorialFinished = false
    end
end)

--- Event handler for messages sent to the blocked contact (first mission)
RegisterNetEvent(eventNamespace .. blockedContact.namespace)
AddEventHandler(eventNamespace .. blockedContact.namespace, function(anon, message)
    local responseMsg = ""
    if anon then
        responseMsg = responseMsg .. _U('intro_msg_text_anon_obv')
    end
    if message == Locations.LifeInvader.AdminPc.machine.version then
        completeFirstMission()
    else
        ESX.ShowAdvancedNotification(blockedContact.name, _U('mission_1_msg_subtitle_re'), -- title, subtitle
                responseMsg .. _U('mission_1_msg_text_fail'), -- message
                "CHAR_BLOCKED", 1) -- contact photo, symbol
    end
end)

--- NativeUI callback for quitting the PC UI
RegisterNUICallback('escape', function(data)
    EnableGui(false, NIL)
end)

--- NativeUI callback for executing a command on a PC
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

--- Thread to get the ESX object
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

--- Tutorial logic
Citizen.CreateThread(function()
    while not tutorialFinished do
        Citizen.Wait(0)
        if isHacking then
            if phoneReady and not tutorialDone and not numberAdded then
                TriggerEvent('esx_phone:addSpecialContact', omegaContact.name, omegaContact.number, omegaContact.base64Icon)
                numberAdded = true
            end
            if not tutorialDone then
                drawGenericMarker(Locations.CommRoom.Exit.x, Locations.CommRoom.Exit.y, Locations.CommRoom.Exit.z - 1.0001)

                if GetDistanceBetweenCoords(Locations.CommRoom.Exit.x, Locations.CommRoom.Exit.y, Locations.CommRoom.Exit.z, GetEntityCoords(GetPlayerPed(-1), true)) < 2 then
                    if IsControlJustPressed(1, 38) then
                        finishTutorial(tutorialDone)
                    else
                        if tutorialDone then
                            ESX.ShowHelpNotification(_U('press_interact_to_exit'))
                        else
                            ESX.ShowHelpNotification(_U('press_interact_to_quit'))
                        end
                    end
                end
            end
        else
            -- if not hacking
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
                    startTutorial()
                else
                    ESX.ShowHelpNotification(_U('intro_help_text'))
                end
            end
        end
        if isHacker() then
            tutorialFinished = true
        end
    end
end)

--- first mission logic
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if (not numberAdded and not firstMissionDone) then
            if not firstMissionStarted and math.random(0, 100) == 50 then
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
        if isInSecondMission() then
            break
        end
    end
end)

--- Marker logic
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isHacking or isHacker() then
            drawPcMarkers()
        end
    end
end)
