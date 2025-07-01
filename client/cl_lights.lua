local vehiclesWithActiveLights = {}

-- Thread that starts the light patterns when the lights are turned on but not running
CreateThread(function()
    while true do
        Wait(250)
        for vehicle, lightData in pairs(vehiclesWithActiveLights) do
            for lightIndex, isActive in pairs(lightData) do
                if (not isActive and CanVehicleHaveLightsOrSirens(vehicle)) then
                    StartLightPattern(vehicle, lightIndex)
                end
            end
        end
    end
end)

-- Engine handler, we need to keep the engine running when the player exits a vehicle with active lights
CreateThread(function()
    if (not Config.KeepEngineRunning) then return end
    local inVehicleLastTime = false
    while true do
        inVehicleLastTime = IsPedInAnyVehicle(ped, true)
        Wait(100)

        -- If the ped just enterd a vehicle, we skip the check
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) and not inVehicleLastTime then
            goto continue
        end

        -- If the previous vehicle is not valid, we skip the check
        local lastVehicle = GetVehiclePedIsIn(ped, true)
        if not DoesEntityExist(lastVehicle) then
            goto continue
        end

        -- If the vehicle is not in a good state, we skip the check
        if GetVehicleEngineHealth(lastVehicle) < Config.MinimumEngineHealth then
            goto continue
        end

        -- If the vehicle does not have any active lights, we skip the check
        if not vehiclesWithActiveLights[lastVehicle] then
            goto continue
        end

        -- We turn on the engine of the last vehicle
        SetVehicleEngineOn(lastVehicle, true, true, false)

        ::continue::
    end
end)

-- Thread that checks what vehicles with lights are closest to the player
local nearbyVehiclesWithLights = {}
CreateThread(function()
    if (not Config.MaximumAmountOfVehiclesWithLights) then return end
    while true do
        Wait(500)
        nearbyVehiclesWithLights = {}
        local playerCoords = GetEntityCoords(PlayerPedId())
        local vehicleDistances = {}

        -- First collect all vehicles and their distances
        for vehicleWithLight, _ in pairs(vehiclesWithActiveLights) do
            if DoesEntityExist(vehicleWithLight) then
                local vehicleCoords = GetEntityCoords(vehicleWithLight)
                local distance = #(playerCoords - vehicleCoords)
                table.insert(vehicleDistances, {
                    vehicle = vehicleWithLight,
                    distance = distance
                })
            end
        end

        -- Sort vehicles by distance
        table.sort(vehicleDistances, function(a, b)
            return a.distance < b.distance
        end)

        -- Take only the closest N vehicles
        for i = 1, math.min(Config.MaximumAmountOfVehiclesWithLights, #vehicleDistances) do
            nearbyVehiclesWithLights[vehicleDistances[i].vehicle] = true
        end
    end
end)

function ToggleLight(vehicle, index)
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

    -- Toggle the light
    local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)
    TriggerServerEvent('gs_els:toggleLight', vehicleNetId, index)
    -- DebugPrint('Light ' .. index .. ' toggled for vehicle ' .. vehicleNetId)
end

AddStateBagChangeHandler('lights', nil, function(bagName, key, lightIndices)
    -- We first make sure the vehicle is correctly loaded
    local startTime = GetGameTimer()
    local vehicle = 0
    while (vehicle == 0 and GetGameTimer() - startTime < 1000) do
        vehicle = GetEntityFromStateBagName(bagName)
        Wait(0)
    end
    if vehicle == 0 then return end

    -- Get the vehicle model and check if it is in the config
    local vehicleModel = GetEntityModel(vehicle)
    if (not Config.Vehicles[vehicleModel]) then
        DebugPrint('Vehicle ' .. vehicleModel .. ' is not defined in the config')
        return
    end

    -- Check if we are driving or co-driving the vehicle, if so we update the menu
    if (DoesPlayerHavePanelControl(vehicle)) then
        UpdateLightStateNui(lightIndices, true)
    end

    -- If the lightIndices is emtpy, remove the vehicle from the list, no lights are active
    if (lightIndices == nil) then
        vehiclesWithActiveLights[vehicle] = {}
        return
    end

    -- If the vehicle is not in the list, we add it, there is at least 1 light active
    if (not vehiclesWithActiveLights[vehicle]) then
        vehiclesWithActiveLights[vehicle] = {}
    end

    -- All the lightIndices that are not in the list, we add them
    for key, lightIndex in pairs(lightIndices) do
        if (not vehiclesWithActiveLights[vehicle][lightIndex]) then
            vehiclesWithActiveLights[vehicle][lightIndex] = false
            DebugPrint('Light ' .. lightIndex .. ' added to vehicle ' .. vehicle)
        end
    end

    -- Check if any indices are in the list, which are not in lightIndices, we remove them as these are no longer active
    for vehicleLightIndex, isActive in pairs(vehiclesWithActiveLights[vehicle]) do
        local shouldLightBeActive = false
        for key, enabledLightIndex in pairs(lightIndices) do
            if (vehicleLightIndex == enabledLightIndex) then
                shouldLightBeActive = true
                break
            end
        end
        if (not shouldLightBeActive) then
            vehiclesWithActiveLights[vehicle][vehicleLightIndex] = nil
            DebugPrint('Light ' .. vehicleLightIndex .. ' removed from vehicle ' .. vehicle)
        end
    end
end)

function StartLightPattern(vehicle, lightIndex)
    -- Get the vehicle model and check if it is in the config
    local vehicleModel = GetEntityModel(vehicle)
    if (not Config.Vehicles[vehicleModel]) then return end

    -- Get the light and check if it is in the config
    local light = Config.Vehicles[vehicleModel].Lights[lightIndex]
    if (not light) then return end

    -- Get the pattern and check if is defined
    local patternIndex = light.Pattern
    if (not patternIndex) then return end

    -- Get the pattern data and check if it is in the config
    local patternStrings = Config.Patterns[patternIndex]
    if (not patternStrings) then
        DebugPrint('Pattern ' .. patternIndex .. ' is not defined in the config')
        return
    end

    -- Convert the pattern string to a table and check if all extras in the pattern are available
    local patternTable = PatternStringToTable(patternStrings)
    if (not CanVehicleModelRunPattern(vehicleModel, patternTable)) then
        DebugPrint('Pattern ' .. patternIndex .. ' includes extras that are undefined in vehicles.lua for model: ' .. GetDisplayNameFromVehicleModel(vehicleModel) .. ', lightIndex: ' .. lightIndex)
        return
    end

    -- We set the lights to activated
    vehiclesWithActiveLights[vehicle][lightIndex] = true

    -- We disable the auto repair, otherwise the vehicle will be repaired when changing the extras
    SetVehicleAutoRepairDisabled(vehicle, true)

    local intensityMultiplier = GetIntensityMultiplier(GetClockHours())

    -- Loop over all extras in the pattern
    local vehicleExtras = Config.Vehicles[vehicleModel].Extras
    for extra, pattern in pairs(patternTable) do
        -- We create a thread for each extra in the pattern
        CreateThread(function()
            local shouldThreadBeActive = true
            local extraHasLightEnabled = false

            -- Create a faster thread to handles the extras and lights
            CreateThread(function()
                while shouldThreadBeActive do
                    Wait(0)
                    for key, disableExtra in pairs(pattern) do
                        if (not shouldThreadBeActive) then break end
                        SetVehicleExtra(vehicle, extra, disableExtra)

                        -- If the maximum amount of vehicles with lights is not set, we always draw the lights, otherwise we only draw the lights if the vehicle is nearby
                        local isNearby = Config.MaximumAmountOfVehiclesWithLights == nil or nearbyVehiclesWithLights[vehicle]
                        if isNearby and vehicleExtras[extra].Range > 0 and vehicleExtras[extra].Intensity > 0 then
                            if (not extraHasLightEnabled) then
                                CreateThread(function()
                                    extraHasLightEnabled = true
                                    local boneIndex = GetEntityBoneIndexByName(vehicle, 'extra_' .. extra)
                                    while IsVehicleExtraTurnedOn(vehicle, extra) do
                                        Wait(0)
                                        -- Get the origin of the light and the configured light coords
                                        local lightOriginCoords = GetWorldPositionOfEntityBone(vehicle, boneIndex)
                                        local lightCoords = GetOffsetFromEntityInWorldCoords(vehicle, vehicleExtras[extra].Offset.x, vehicleExtras[extra].Offset.y, vehicleExtras[extra].Offset.z)

                                        -- Define the directional vector indicating the direction of the light
                                        local forwardVector = {
                                            x = lightCoords.x - lightOriginCoords.x,
                                            y = lightCoords.y - lightOriginCoords.y,
                                            z = lightCoords.z - lightOriginCoords.z
                                        }
                                        
                                        -- Draw the light
                                        local color = Config.Colors[vehicleExtras[extra].Color]
                                        DrawSpotLight(lightCoords.x, lightCoords.y, lightCoords.z,
                                            forwardVector.x,
                                            forwardVector.y,
                                            forwardVector.z,
                                            color.r,
                                            color.g,
                                            color.b,
                                            vehicleExtras[extra].Range,
                                            vehicleExtras[extra].Intensity * intensityMultiplier,
                                            0.0, 180.0, vehicleExtras[extra].Range / 2)

                                        if (Config.DebugMode) then
                                            DrawLine(lightOriginCoords.x, lightOriginCoords.y, lightOriginCoords.z, lightCoords.x, lightCoords.y, lightCoords.z, 255, 255, 255, 25.0)
                                        end
                                    end
                                    extraHasLightEnabled = false
                                end)
                            end
                        end
                        Wait(100)
                    end
                end
            end)

            -- A slower thread that checks if the thread should be active
            while ShouldLightBeActive(vehicle, lightIndex) do
                Wait(100)
                intensityMultiplier = GetIntensityMultiplier(GetClockHours())
            end

            -- The lights should no longer be active, so we disabled it
            shouldThreadBeActive = false
            SetVehicleExtra(vehicle, extra, true)

            -- If the light is still present in the list, we simply set it to false, the script will have to activate the light again when possible
            if vehiclesWithActiveLights[vehicle][lightIndex] then
                vehiclesWithActiveLights[vehicle][lightIndex] = false
            end
        end)
    end
end

function ShouldLightBeActive(vehicle, lightIndex)
    local vehicleCanHaveLightsOrSirens = CanVehicleHaveLightsOrSirens(vehicle)
    local lightIsActive = vehiclesWithActiveLights[vehicle][lightIndex]
    return vehicleCanHaveLightsOrSirens and lightIsActive
end

function GetIntensityMultiplier(inGameHour)
    local intensityDay = Config.DayTimeIntensityMultiplier
    local intensityNight = Config.NightTimeIntensityMultiplier

    -- If it's night time (0-4 or 20-24), return night intensity
    if inGameHour < 5 or inGameHour >= 20 then
        return intensityNight
    end

    -- For day time (4-20), create a smooth transition
    -- Convert hour to a 0-1 range for the day period (4-20)
    local normalizedHour = (inGameHour - 6) / 14

    -- Use cosine to create a smooth curve centered at 12:00
    -- Shift the cosine wave so it peaks at 12:00 (normalizedHour = 0.5)
    local normalizedValue = (math.cos((normalizedHour - 0.5) * math.pi) + 1) / 2

    -- Interpolate between night and day intensity
    return intensityNight + (intensityDay - intensityNight) * normalizedValue
end

function CanVehicleModelRunPattern(vehicleModel, patternTable)
    local availableExtras = Config.Vehicles[vehicleModel].Extras
    for extra, pattern in pairs(patternTable) do
        if (availableExtras[extra] == nil) then
            return false
        end
    end 

    return true
end