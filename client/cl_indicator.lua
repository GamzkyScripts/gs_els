function ToggleIndicator(vehicle, index)
    -- Make sure we are not in the debug-menu right now as we also need the arrow keys for this.
    if (debugging) then
        return
    end

    -- We make sure the vehicle is not in the blackisted classes
    local vehicleClass = GetVehicleClass(vehicle)
    for k, class in pairs(Config.IndicatorBlacklistClasses) do
        if vehicleClass == class then
            return
        end
    end

    -- Request update on server
    local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)
    TriggerServerEvent('gs_els:toggleIndicator', vehicleNetId, index)
    PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
end

local vehicleIndicatorList = {}
AddStateBagChangeHandler('indicator', nil, function(bagName, key, indicatorIndex)
    -- We first make sure the vehicle is correctly loaded
    local startTime = GetGameTimer()
    local vehicle = 0
    while (vehicle == 0 and GetGameTimer() - startTime < 1000) do
        vehicle = GetEntityFromStateBagName(bagName)
        Wait(0)
    end
    if vehicle == 0 then return end

    -- Check if we are driving or co-driving the vehicle, if so we update the menu
    if (DoesPlayerHavePanelControl(vehicle)) then
        UpdateIndicatorStateNui(indicatorIndex)
    end

    -- If the indicator is disabled, remove it from the list
    if (indicatorIndex == 0) then
        SetVehicleIndicatorLights(vehicle, 0, false)
        SetVehicleIndicatorLights(vehicle, 1, false)
        vehicleIndicatorList[vehicle] = nil
        return
    end

    -- Update the indicator status in the list
    vehicleIndicatorList[vehicle] = indicatorIndex
end)

CreateThread(function()
    while true do
        Wait(500)
        -- Loop over the list and make sure all indicators are running as desired
        for vehicle, indicatorIndex in pairs(vehicleIndicatorList) do
            if (DoesEntityExist(vehicle)) then
                if GetVehicleIndicatorLights(vehicle) ~= indicatorIndex then
                    -- If they are turned off
                    if indicatorIndex == 0 then
                        SetVehicleIndicatorLights(vehicle, 0, false)
                        SetVehicleIndicatorLights(vehicle, 1, false)

                        -- If left-indicator should be blinking
                    elseif indicatorIndex == 1 then
                        SetVehicleIndicatorLights(vehicle, 0, false)
                        SetVehicleIndicatorLights(vehicle, 1, true)

                        -- If right indicator should be blinking
                    elseif indicatorIndex == 2 then
                        SetVehicleIndicatorLights(vehicle, 0, true)
                        SetVehicleIndicatorLights(vehicle, 1, false)

                        -- If both indicators should be blinking
                    elseif indicatorIndex == 3 then
                        SetVehicleIndicatorLights(vehicle, 0, true)
                        SetVehicleIndicatorLights(vehicle, 1, true)
                    end
                end
            else
                vehicleIndicatorList[vehicle] = nil
            end
        end
    end
end)
