function ExecuteRPCommand(command)
    if command == "help" then
        return { result = true, print = "Available commands: 'help', 'echo'" }
    elseif command == "echo" then
        return { result = true, print = command }
    else
        return { result = false, print = "Unknown command: '" .. command .. "'!" }
    end
end