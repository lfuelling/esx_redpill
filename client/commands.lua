local function commandEnabled(table, expected)
    for _, val in ipairs(table) do
        if val == expected then
            return true
        end
    end
    return false
end

local function startsWith(str, start)
    return str:sub(1, #start) == start
end

local function endsWith(str, ending)
    return ending == "" or str:sub(-#ending) == ending
end

local function countElems(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

local function __help(commands)
    output = "Available commands: 'help'"
    for _, val in ipairs(commands) do
        output = output .. ", '" .. val .. "'";
    end
    return output
end

local function __ipAL(machine)
    return "1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000\n" ..
            "\tlink/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00\n" ..
            "\tinet 127.0.0.1/8 scope host lo\n\t\tvalid_lft forever preferred_lft forever\n" ..
            "\tinet6 ::1/128 scope host\n\t\tvalid_lft forever preferred_lft forever\n" ..

            "2: " .. machine.ip.interface .. ": <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000\n" ..
            "\tlink/ether a1:e4:31:c9:10:4f brd ff:ff:ff:ff:ff:ff\n" ..
            "\tinet " .. machine.ip.address .. "/" .. machine.ip.subnet .. " brd " .. machine.ip.network .. " scope global dynamic noprefixroute " .. machine.ip.interface .. "\n\t\tvalid_lft 37214sec preferred_lft 37214sec"
end

local function __unameA(machine)
    return "RedpillOS " .. machine.hostname .. " " ..
            machine.version .. "-generic " ..
            "Thu 2010/06/17 13:37 UTC" ..
            " x86_64 Redpill"
end

local function __ls(machine)
    output = "total " .. countElems(machine.files)
    for _, file in ipairs(machine.files) do
        output = output .. "\n" .. file.path;
    end
    return output
end

local function __cat(machine, command)
    for _, file in ipairs(machine.files) do
        -- yes, I'm THAT cheap
        if command == 'cat ' .. file.path then
            if file.action ~= NIL then
                -- some files trigger events
                TriggerEvent("term:" .. file.action)
            end
            return file.content
        end
    end
    return command .. ": No such file or directory!"
end

function ExecuteRPCommand(command, machine)
    if startsWith(command, "help") then
        return __help(machine.commands)
    elseif startsWith(command, "echo") and commandEnabled(machine.commands, "echo") then
        return command
    elseif startsWith(command, "ip") and commandEnabled(machine.commands, "ip") then
        return __ipAL(machine)
    elseif startsWith(command, "uname") and commandEnabled(machine.commands, "uname") then
        return __unameA(machine)
    elseif startsWith(command, "ls") and commandEnabled(machine.commands, "ls") then
        return __ls(machine)
    elseif startsWith(command, "cat") and commandEnabled(machine.commands, "cat") then
        return __cat(machine, command)
    else
        return "Unknown command: '" .. command .. "'!"
    end
end
