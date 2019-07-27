ESX = nil
local guiEnabled = false
local isHacking = false

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

RegisterNUICallback('escape', function(data, cb)
    EnableGui(false, NIL)
    cb('ok')
end)

RegisterNUICallback('command', function(data, cb)
    if data.command then
        cb(ExecuteRPCommand(data.command, data.machine)) -- see client/commands.lua
    else
        cb({ result = true, print = "" }) -- empty commands return 0 in bash
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
    for _, location in ipairs(Locations) do
        __drawPcMarkers(location)
    end
end

function __drawPcMarkers(location)
    if location.x == NIL then
        -- if we have a location inside
        for _, l2 in ipairs(location) do
            __drawPcMarkers(l2)
        end
    elseif location.machine then
        -- some locations are not machines
        drawGenericMarker(location.x, location.y, location.z - 1.001)
        if GetDistanceBetweenCoords(location.x, location.y, location.z, GetEntityCoords(GetPlayerPed(-1), true)) < 2 then
            if IsControlJustPressed(1, 38) then
                EnableGui(true, location.machine)
            else
                ESX.ShowHelpNotification(_U('press_interact_to_hack'))
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

-- intro/start of mission logic
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if isHacking then
            drawPcMarkers()
        else
            drawGenericMarker(Locations.RedpillMarker.Entry.x, Locations.RedpillMarker.Entry.y, Locations.RedpillMarker.Entry.z - 1.001)

            if GetDistanceBetweenCoords(Locations.RedpillMarker.Entry.x, Locations.RedpillMarker.Entry.y, Locations.RedpillMarker.Entry.z, GetEntityCoords(GetPlayerPed(-1), true)) < 7 then
                if GetDistanceBetweenCoords(Locations.RedpillMarker.Entry.x, Locations.RedpillMarker.Entry.y, Locations.RedpillMarker.Entry.z, GetEntityCoords(GetPlayerPed(-1), true)) < 2 then
                    Citizen.Wait(2000) -- wait for elevator doors
                    DoScreenFadeOut(1000)
                    Citizen.Wait(500)
                    SetEntityCoords(GetPlayerPed(-1), Locations.CommRoom.x, Locations.CommRoom.y, Locations.CommRoom.z)
                    DoScreenFadeIn(1000)
                    isHacking = true
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
                    SetEntityCoords(Locations.RedpillMarker.Exit.x, Locations.RedpillMarker.Exit.y, Locations.RedpillMarker.Exit.z)
                    DoScreenFadeIn(1000)
                    isHacking = false
                else
                    ESX.ShowHelpNotification(_U('press_interact_to_exit'))
                end
            end
        end
    end
end)