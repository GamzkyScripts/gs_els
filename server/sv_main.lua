RegisterNetEvent('gs_els:toggleSiren', function(vehicleNetId, index)
    -- Get the vehicle
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if (not vehicle) then
        return
    end

    -- Check if the vehicle is in the config
    local vehicleModel = GetEntityModel(vehicle)
    if (not Config.Vehicles[vehicleModel]) then
        return
    end

    -- Check if the siren is in the config
    local siren = Config.Vehicles[vehicleModel].Sirens[index]
    if (not siren) then
        return
    end

    -- Toggle the siren
    local enabledSirenIndex = Entity(vehicle).state.siren
    if (enabledSirenIndex == index) then
        Entity(vehicle).state.siren = nil
    else
        Entity(vehicle).state.siren = index
    end

    DebugPrint('Siren ' .. index .. ' toggled for vehicle ' .. vehicleNetId .. ' (was enabled: ' .. tostring(enabledSirenIndex == index) .. ')')
end)

RegisterNetEvent('gs_els:toggleLight', function(vehicleNetId, index)
    -- Get the vehicle
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if (not vehicle) then
        return
    end

    -- Check if the vehicle is in the config
    local vehicleModel = GetEntityModel(vehicle)
    if (not Config.Vehicles[vehicleModel]) then
        return
    end

    -- Check if the light is in the config
    local light = Config.Vehicles[vehicleModel].Lights[index]
    if (not light) then
        return
    end

    -- Check if the light is already enabled, disable it in this case
    local enabledLightIndices = Entity(vehicle).state.lights or {}
    local lightWasEnabled = false
    for key, lightIndex in pairs(enabledLightIndices) do
        if (lightIndex == index) then
            enabledLightIndices[key] = nil
            lightWasEnabled = true
            break
        end
    end

    -- If the light was not enabled, enable it
    if (not lightWasEnabled) then
        -- Check if the light is part of a group
        local newLightGroup = light.group
        if (newLightGroup) then
            -- Check if the group is already enabled, if so, disable all lights from that group
            for key, lightIndex in pairs(enabledLightIndices) do
                local group = Config.Vehicles[vehicleModel].Lights[lightIndex].group
                if (group == newLightGroup) then
                    enabledLightIndices[key] = nil
                end
            end
        end

        enabledLightIndices[#enabledLightIndices + 1] = index
    end

    -- Update the light state
    Entity(vehicle).state.lights = enabledLightIndices
    DebugPrint('Light ' .. index .. ' toggled for vehicle ' .. vehicleNetId .. ' (was enabled: ' .. tostring(lightWasEnabled) .. ')')
end)

RegisterNetEvent('gs_els:toggleIndicator', function(vehicleNetId, index)
    -- Get the vehicle
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if (not vehicle) then
        return
    end

    -- We can only handle index 1 (left), index 2 (right) and index 3 (both)
    if (index ~= 1 and index ~= 2 and index ~= 3) then
        DebugPrint("The toggled indicator index is not equal to 1, 2 or 3.")
        return
    end

    -- Check if the current index is toggled off
    local newIndex = index
    local currentIndicatorIndex = Entity(vehicle).state.indicator
    if (currentIndicatorIndex == index) then
        newIndex = 0
    end

    -- Update all clients
    Entity(vehicle).state.indicator = newIndex
end)

function DebugPrint(message)
    if (Config.DebugMode) then
        print(message)
    end
end
