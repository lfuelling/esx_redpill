local function commandEnabled(table, expected)
    for _, val in ipairs(table) do
        if val == expected then
            return true
        end
    end
    return false
end

function ExecuteRPCommand(command, machine)
    if command == "help" and commandEnabled(machine.commands, "help") then
        return { result = true, print = "Available commands: 'help', 'echo'" }
    elseif command == "echo" and commandEnabled(machine.commands, "echo") then
        return { result = true, print = command }
    else
        return { result = false, print = "Unknown command: '" .. command .. "'!" }
    end
end