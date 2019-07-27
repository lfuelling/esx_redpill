ESX = nil

RedpillMarker = { x = -2050.62, y = 3236.5, z = 31.5 } -- Fort Zancudo bunker elevator

CommRoom = { x = 154.31, y = -764.62, z = 258.2, hdg = 164.48, -- IAA Building top floor comm room
             Pc = { x = 153.25, y = -767.46, z = 258.15 } } -- Desk with switched on monitors in comm room

LiveInvader = {
    AdminPc = { x = -1053.16, y = -230.2, z = 44.02 }, -- LiveInvader server room pc
    DevPc = { x = -1050.67, y = -240.57, z = 44.02 }, -- Dev pc next to main meeting room
}

Carrier = {
    BridgePc = { x = 3084.72, y = -4686.57, z = 27.25 } -- laptop at bridge of carrier
}

Merryweather = { -- Merryweather Dock
    DualMonitorPc1 = { x = 570.88, y = -3123.73, z = 18.77 },
    DualMonitorPc2 = { x = 563.08, y = -3124.32, z = 18.77 }
}

Lester = { -- Lesters Home
    MainPc = { x = 1275.73, y = -1710.53, z = 54.77 },
    SecondaryPc = { x = 1272.31, y = -1711.54, z = 54.77 },
    FactoryPc = { x = 707.39, y = -966.97, z = 30.41 }
}

Franklin = { -- Franklins (new) Home
    KitchenPc = { x = -7.82, y = 520.31, z = 174.63 }
}

Stores = { -- Some stores
    GasStation1Pc = { x = 1159.77, y = -315.2, z = 69.21 },
    TequiLaLaDjPc = { x = -560.83, y = 280.8, z = 85.68 }
}

Bank = { -- The bank next to the cinema (not UD)
    OfficePc = { x = 247.42, y = 208.71, z = 110.28 },
    BackOfficePc1 = { x = 261.2, y = 204.95, z = 110.29 },
    BackOfficePc2 = { x = 264.42, y = 211.12, z = 110.29 },
    VaultPc = { x = 264.82, y = 219.85, z = 101.68 },
}

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
    drawGenericMarker(CommRoom.Pc.x, CommRoom.Pc.y, CommRoom.Pc.z)
    drawGenericMarker(LiveInvader.AdminPc.x, LiveInvader.AdminPc.y, LiveInvader.AdminPc.z)
    drawGenericMarker(LiveInvader.DevPc.x, LiveInvader.DevPc.y, LiveInvader.DevPc.z)
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

        if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'hacker' and not IsDead then
            drawPcMarkers()
        else
            drawGenericMarker(RedpillMarker.x, RedpillMarker.y, RedpillMarker.z)

            if GetDistanceBetweenCoords(RedpillMarker.x, RedpillMarker.y, RedpillMarker.z, GetEntityCoords(GetPlayerPed(-1), true)) < 15 then
                if GetDistanceBetweenCoords(RedpillMarker.x, RedpillMarker.y, RedpillMarker.z, GetEntityCoords(GetPlayerPed(-1), true)) < 2 then
                    Citizen.Wait(2000) -- wait for elevator doors
                    DoScreenFadeOut(1000)
                    Citizen.Wait(1500)
                    SetEntityCoords(GetPlayerPed(-1), CommRoom.x, CommRoom.y, CommRoom.z)
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

        if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'hacker' and not IsDead then

        elseif GetDistanceBetweenCoords(CommRoom.Pc.x, CommRoom.Pc.y, CommRoom.Pc.z, GetEntityCoords(GetPlayerPed(-1), true)) > 2 then
            drawGenericMarker(CommRoom.Pc.x, CommRoom.Pc.y, CommRoom.Pc.z)
            ESX.ShowHelpNotification(_U('intro_help_text'))
        end

    end
end)