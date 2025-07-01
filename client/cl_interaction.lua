local isNuiOpen = false

CreateThread(function()
    CreateThread(function()
        while true do
            Wait(0)
            if (not isNuiOpen) then
                Wait(500)
                goto continue
            end

            -- Check if the player should still see the overlay
            local vehicle, vehicleModel, canHaveSirensOrLights = CanPlayerInteract()
            if (vehicle == 0 or not canHaveSirensOrLights) then
                ToggleNui(not isNuiOpen)
            end

            ::continue::
        end
    end)

    if (Config.EnableKeyMapping) then
        -- If key mapping is enabled, we need to create commands to couple to the keys
        for type, data in pairs(Config.Keys) do
            for index, control in pairs(data) do
                local commandName = 'gs_els:' .. tostring(type) .. tostring(index)
                if (type == 'Menu') then
                    commandName = 'gs_els:toggle_menu'
                end
                RegisterCommand(commandName, function(source, args, raw)
                    local vehicle, vehicleModel, canHaveSirensOrLights = CanPlayerInteract()
                    if (vehicle == nil) then return end
                    if (type == 'Sirens' and canHaveSirensOrLights) then
                        ToggleSiren(vehicle, index)
                    elseif (type == 'Lights' and canHaveSirensOrLights) then
                        ToggleLight(vehicle, index)
                    elseif (type == 'Menu' and canHaveSirensOrLights) then
                        ToggleNui(not isNuiOpen)
                    elseif (type == 'Indicators') then
                        ToggleIndicator(vehicle, index)
                    end
                end, false)

                -- We map the key
                RegisterKeyMapping(commandName, control.info, 'keyboard', control.label)
            end
        end

        -- If we map the keys, we do not need to run the thread below
        return
    end

    -- If the keys are not mapped, we use the thread to detect key presses
    while true do
        Wait(0)

        -- Do all the required checks first in CanPlayerInteract
        local vehicle, vehicleModel, canHaveSirensOrLights = CanPlayerInteract()
        if (vehicle == nil) then
            Wait(500)
            goto continue
        end

        -- Disable all defined controls
        for type, data in pairs(Config.Keys) do
            for index, control in pairs(data) do
                DisableControlAction(0, control.key, true)
            end
        end

        -- Check for indicator key presses
        for index, control in pairs(Config.Keys.Indicators) do
            if (IsDisabledControlJustPressed(0, control.key)) then
                ToggleIndicator(vehicle, index)
                Wait(250)
                goto continue
            end
        end

        if (not canHaveSirensOrLights) then
            goto continue
        end

        -- Check for toggle-menu press
        if (IsDisabledControlJustPressed(0, Config.Keys.Menu[1].key)) then
            ToggleNui(not isNuiOpen)
        end

        -- Check for siren key presses
        for k, v in pairs(Config.Vehicles[vehicleModel].Sirens) do
            if (IsDisabledControlJustPressed(0, Config.Keys.Sirens[k].key)) then
                ToggleSiren(vehicle, k)
                Wait(250)
                goto continue
            end
        end

        -- Check for light key presses
        for k, v in pairs(Config.Vehicles[vehicleModel].Lights) do
            if (IsDisabledControlJustPressed(0, Config.Keys.Lights[k].key)) then
                ToggleLight(vehicle, k)
                Wait(250)
                goto continue
            end
        end

        ::continue::
    end
end)

function CanPlayerInteract()
    -- Check if the player is in a vehicle
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if (vehicle == 0) then
        return nil
    end

    -- Check if the player is the driver (or passenger if allowed)
    if (not DoesPlayerHavePanelControl(vehicle)) then
        return nil
    end

    -- Check if the vehicle is in the config
    local canHaveSirensOrLights = false
    local vehicleModel = GetEntityModel(vehicle)
    if (Config.Vehicles[vehicleModel] and CanVehicleHaveLightsOrSirens(vehicle)) then
        canHaveSirensOrLights = true
    end

    return vehicle, vehicleModel, canHaveSirensOrLights
end

function DoesPlayerHavePanelControl(vehicle)
    local ped = PlayerPedId()
    local driver = GetPedInVehicleSeat(vehicle, -1)
    local passenger = GetPedInVehicleSeat(vehicle, 0)
    if (driver ~= ped and (Config.AllowControlFromPassengerSeat and passenger ~= ped)) then
        return false
    end

    return true
end

function CanVehicleHaveLightsOrSirens(vehicle)
    local vehicleExists = DoesEntityExist(vehicle)
    local vehicleIsNotBroken = GetVehicleEngineHealth(vehicle) > Config.MinimumEngineHealth
    local vehicleIsNotInWater = not IsEntityInWater(vehicle)

    return vehicleExists and vehicleIsNotBroken and vehicleIsNotInWater
end

-- Function to show/hide NUI
function ToggleNui(show)
    isNuiOpen = show

    local buttons = {}
    if (show) then
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        buttons = GetVehicleOverlayButtons(vehicle)

        -- Sync the siren state with the menu
        local sirenState = Entity(vehicle).state.siren or 'OFF'
        UpdateSirenStateNui(sirenState)

        -- Sync the light states with the menu
        local lightStates = Entity(vehicle).state.lights or {}
        UpdateLightStateNui(lightStates)

        -- Sync the indicator state with the menu
        local indicatorState = Entity(vehicle).state.indicator or 0
        UpdateIndicatorStateNui(indicatorState)

        -- Sync the headlight state with the menu
        local retval, lightsOn, highBeamsOn = GetVehicleLightsState(vehicle)
        UpdateHeadLightStateNui(lightsOn, highBeamsOn)
    end

    SendNUIMessage({
        type = "ui",
        display = show,
        buttons = buttons
    })
end

-- NUI callback to close the UI
RegisterNUICallback('closeUI', function(data, cb)
    ToggleNui(false)
    cb('ok')
end)

function UpdateSirenStateNui(sirenState, doSound)
    SendNUIMessage({
        type = "updateSirenState",
        state = sirenState,
        doSound = doSound or false,
    })
end

function UpdateLightStateNui(lightStates, doSound)
    SendNUIMessage({
        type = "updateLightState",
        state = lightStates,
        doSound = doSound or false,
    })
end

function UpdateIndicatorStateNui(indicatorState)
    SendNUIMessage({
        type = "updateIndicatorState",
        state = indicatorState
    })
end

function UpdateHeadLightStateNui(lightsOn, highBeamsOn)
    SendNUIMessage({
        type = "updateHeadLightState",
        state = {
            lightsOn = lightsOn,
            highBeamsOn = highBeamsOn,
        }
    })
end

function GetVehicleOverlayButtons(vehicle)
    local buttons = {}

    -- Check if the vehicle is in the config
    local vehicleModel = GetEntityModel(vehicle)
    if (not Config.Vehicles[vehicleModel]) then
        return buttons
    end

    for lightIndex, lightData in pairs(Config.Vehicles[vehicleModel].Lights) do
        local buttonName = lightData.button or 'fallback'
        local buttonData = Config.OverlayButtons[buttonName]

        buttons[tostring(lightIndex)] = {
            text = buttonData.text,
            color = buttonData.color
        }
    end

    return buttons
end
