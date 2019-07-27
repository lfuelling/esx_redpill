ESX = nil
local guiEnabled = false

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
    drawGenericMarker(Locations.CommRoom.Pc.x, Locations.CommRoom.Pc.y, Locations.CommRoom.Pc.z)
    drawGenericMarker(Locations.LiveInvader.AdminPc.x, Locations.LiveInvader.AdminPc.y, Locations.LiveInvader.AdminPc.z)
    drawGenericMarker(Locations.LiveInvader.DevPc.x, Locations.LiveInvader.DevPc.y, Locations.LiveInvader.DevPc.z)
end

function drawGenericMarker(x, y, z)
    DrawMarker(1, x, y, z,
            0, 0, 0, -- dir
            0, 0, 0, -- rot
            1.0, 1.0, 1.0, -- scale
            0, 0, 255, 200, -- rgba
            false, -- bob
            false, -- face
            2, -- p19
            false, -- rotate
            NULL, -- texture dict
            NULL, -- texture name
            true) -- draw on intersecting
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'hacker' then
            drawPcMarkers()
        else
            drawGenericMarker(Locations.RedpillMarker.x, Locations.RedpillMarker.y, Locations.RedpillMarker.z)

            if GetDistanceBetweenCoords(Locations.RedpillMarker.x, Locations.RedpillMarker.y, Locations.RedpillMarker.z, GetEntityCoords(GetPlayerPed(-1), true)) < 15 then
                if GetDistanceBetweenCoords(Locations.RedpillMarker.x, Locations.RedpillMarker.y, Locations.RedpillMarker.z, GetEntityCoords(GetPlayerPed(-1), true)) < 2 then
                    Citizen.Wait(2000) -- wait for elevator doors
                    DoScreenFadeOut(1000)
                    Citizen.Wait(500)
                    SetEntityCoords(GetPlayerPed(-1), Locations.CommRoom.x, Locations.CommRoom.y, Locations.CommRoom.z)
                    DoScreenFadeIn(1000)
                else
                    ESX.ShowHelpNotification(_U('intro_help_text'))
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'hacker' then

        elseif GetDistanceBetweenCoords(Locations.CommRoom.Pc.x, Locations.CommRoom.Pc.y, Locations.CommRoom.Pc.z, GetEntityCoords(GetPlayerPed(-1), true)) > 2 then
            drawGenericMarker(Locations.CommRoom.Pc.x, Locations.CommRoom.Pc.y, Locations.CommRoom.Pc.z)
            ESX.ShowHelpNotification(_U('intro_help_text'))
        end

    end
end)