ESX = nil
local guiEnabled = false
local phoneReady = false

local nextMissionTrigger = nil

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

--- Event handler for generating a new random "next mission delay"
AddEventHandler(eventNamespace .. "getNextTriggerTime", function()
    nextMissionTrigger = os.time(os.date("!*t")) + math.random(30, 300);
end)

--- Event handler for esx_phone initialization
RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
    phoneReady = true
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

--- Marker logic
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isHacking or isHacker() then
            drawPcMarkers()
        end
    end
end)

function timeForNextMission()
    return not nextMissionTrigger == nil and os.time(os.date("!*t")) >= nextMissionTrigger
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if not isHacker() then
            _tutorialLogic()
        elseif isInFirstMission() and timeForNextMission() then
            _firstMissionLogic()
        elseif isInSecondMission() and timeForNextMission() then
            _secondMissionLogic()
        else
            Citizen.Wait(20000) -- wait 20 secs
        end
    end
end)
