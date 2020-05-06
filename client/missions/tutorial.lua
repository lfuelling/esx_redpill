local numberAdded = false
local isHacking = false
local tutorialDone = false
local tutorialFinished = false

--- Event handler for tutorial completion
AddEventHandler(eventNamespace .. "tutorialDone", function()
    tutorialDone = true
end)

--- Event handler for player death during tutorial
AddEventHandler('esx:onPlayerDeath', function()
    if isHacking and not tutorialDone then
        isHacking = false;
    end
    if tutorialFinished and not isHacker() then
        tutorialFinished = false
    end
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

function _tutorialLogic()
    if isHacking then
        if phoneReady and not tutorialDone and not numberAdded then
            TriggerEvent('esx_phone:addSpecialContact', omegaContact.name, omegaContact.number, omegaContact.base64Icon)
            numberAdded = true
        end
        if not tutorialDone then
            drawGenericMarker(Locations.CommRoom.Exit.x, Locations.CommRoom.Exit.y, Locations.CommRoom.Exit.z - 1.0001)

            if GetDistanceBetweenCoords(Locations.CommRoom.Exit.x, Locations.CommRoom.Exit.y, Locations.CommRoom.Exit.z, GetEntityCoords(PlayerPedId(), true)) < 2 then
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
        TriggerEvent('esx_phone:removeSpecialContact', omegaContact.number)
        numberAdded = false
        tutorialDone = false
        tutorialFinished = false
        drawGenericMarker(Locations.RedpillMarker.Entry.x, Locations.RedpillMarker.Entry.y, Locations.RedpillMarker.Entry.z - 1.001)

        if GetDistanceBetweenCoords(Locations.RedpillMarker.Entry.x, Locations.RedpillMarker.Entry.y, Locations.RedpillMarker.Entry.z, GetEntityCoords(PlayerPedId(), true)) < 7 then
            if GetDistanceBetweenCoords(Locations.RedpillMarker.Entry.x, Locations.RedpillMarker.Entry.y, Locations.RedpillMarker.Entry.z, GetEntityCoords(PlayerPedId(), true)) < 2 then
                startTutorial()
            else
                ESX.ShowHelpNotification(_U('intro_help_text'))
            end
        end
    end
    if isHacker() then
        tutorialFinished = true
        TriggerEvent(eventNamespace .. "getNextTriggerTime")
    end
end