CreateThread(function()
    if (not Config.DebugMode) then return end

    local function tableToLuaString(tbl, indent)
        indent = indent or 0
        local str = ""
        local indentStr = string.rep("    ", indent)

        if type(tbl) == "table" then
            str = str .. "{\n"
            for k, v in pairs(tbl) do
                str = str .. indentStr .. "    "
                if type(k) == "number" then
                    str = str .. "[" .. k .. "] = "
                else
                    str = str .. k .. " = "
                end

                if type(v) == "table" then
                    if next(v) == nil then
                        str = str .. "{}"
                    else
                        local innerStr = ""
                        -- Handle other properties in specific order
                        local order = { "Color", "Offset", "Range", "Intensity" }
                        for _, prop in ipairs(order) do
                            if v[prop] then
                                if type(v[prop]) == "table" then
                                    if prop == "Offset" then
                                        innerStr = innerStr .. "Offset = { x = " .. (v[prop].x or 0) .. ", y = " .. (v[prop].y or 0) .. ", z = " .. (v[prop].z or 0) .. " }, "
                                    end
                                else
                                    if prop == "Color" then
                                        innerStr = innerStr .. "Color = '" .. v[prop] .. "', "
                                    else
                                        innerStr = innerStr .. prop .. " = " .. v[prop] .. ", "
                                    end
                                end
                            end
                        end
                        str = str .. "{ " .. innerStr:sub(1, -3) .. " }"
                    end
                elseif type(v) == "string" then
                    str = str .. '"' .. v .. '"'
                elseif type(v) == "boolean" then
                    str = str .. tostring(v)
                elseif type(v) == "number" then
                    str = str .. math.floor(v * 100) / 100
                end
                str = str .. ",\n"
            end
            str = str .. indentStr .. "}"
        end
        return str
    end

    RegisterNetEvent('gs_els:debug:export_extras', function(extras)
        -- Save as Lua export
        local luaString = "-- Copy the code below to the respective vehicle configuration in vehicles.lua \nExtras = " .. tableToLuaString(extras)
        SaveResourceFile(GetCurrentResourceName(), "export.lua", luaString, -1)
    end)
end)
