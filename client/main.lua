ESX = nil
local guiEnabled = false
local isHacking = false

-- shows the GUI
function EnableGui(enable)
    SetNuiFocus(enable)
    guiEnabled = enable

    SendNUIMessage({
        type = "enableui",
        enable = enable
    })
end

RegisterNUICallback('escape', function(data, cb)
    EnableGui(false)
    cb('ok')
end)

RegisterNUICallback('command', function(data, cb)
    if data.command then
        cb(ExecuteRPCommand(data.command)) -- see client/commands.lua
    end
    cb({result = true, print = ""}) -- empty commands return 0 in bash
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
    drawGenericMarker(Locations.CommRoom.Pc.x, Locations.CommRoom.Pc.y, Locations.CommRoom.Pc.z - 1.0001)
    drawGenericMarker(Locations.LiveInvader.AdminPc.x, Locations.LiveInvader.AdminPc.y, Locations.LiveInvader.AdminPc.z - - 1.0001)
    drawGenericMarker(Locations.LiveInvader.DevPc.x, Locations.LiveInvader.DevPc.y, Locations.LiveInvader.DevPc.z - 1.0001)
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

        if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'hacker' then
            drawPcMarkers()
        else
            drawGenericMarker(Locations.RedpillMarker.x, Locations.RedpillMarker.y, Locations.RedpillMarker.z - 1.001)

            if GetDistanceBetweenCoords(Locations.RedpillMarker.x, Locations.RedpillMarker.y, Locations.RedpillMarker.z, GetEntityCoords(GetPlayerPed(-1), true)) < 5 then
                if GetDistanceBetweenCoords(Locations.RedpillMarker.x, Locations.RedpillMarker.y, Locations.RedpillMarker.z, GetEntityCoords(GetPlayerPed(-1), true)) < 2 then
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
                    SetEntityCoords(Locations.RedpillMarker.x, Locations.RedpillMarker.y, Locations.RedpillMarker.z)
                    DoScreenFadeIn(1000)
                    isHacking = false
                else
                    ESX.ShowHelpNotification(_U('press_interact_to_exit'))
                end
            end

            if GetDistanceBetweenCoords(Locations.CommRoom.Pc.x, Locations.CommRoom.Pc.y, Locations.CommRoom.Pc.z, GetEntityCoords(GetPlayerPed(-1), true)) < 2 then
                if IsControlJustPressed(1, 38) then
                    EnableGui(true)
                else
                    ESX.ShowHelpNotification(_U('press_interact_to_hack'))
                end
            else
                drawGenericMarker(Locations.CommRoom.Pc.x, Locations.CommRoom.Pc.y, Locations.CommRoom.Pc.z - 1.001)
            end
        end
    end
end)