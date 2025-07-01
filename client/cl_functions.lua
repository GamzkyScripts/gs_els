function DebugPrint(message)
    if (Config.DebugMode) then
        print(message)
    end
end

function DeepCopyTable(table)
    local newTable = {}
    for k, v in pairs(table) do
        if type(v) == "table" then
            newTable[k] = DeepCopyTable(v)
        else
            newTable[k] = v
        end
    end
    return newTable
end

function ShowNotification(message)
    SetTextComponentFormat("STRING")
    AddTextComponentString(message)
    DisplayHelpTextFromStringLabel(0, false, true, -1)
end

function PatternStringToTable(patternStrings)
    local patternTable = {}
    for extra, patternString in pairs(patternStrings) do
        patternTable[extra] = {}
        patternString:gsub('.', function(c)
            -- We reverse the boolean, as SetVehicleExtra requires an isDisabled boolean
            table.insert(patternTable[extra], not (tonumber(c) == 1))
        end)
    end
    return patternTable
end
