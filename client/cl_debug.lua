local controls = {
    save           = {
        key = 191, -- ENTER
        canHold = false,
    },
    cancel         = {
        key = 194, -- BACKSPACE
        canHold = false,
    },
    cycle_left     = {
        key = 174, -- ARROW LEFT
        canHold = false,
    },
    cycle_right    = {
        key = 175, -- ARROW RIGHT
        canHold = false,
    },
    cycle_color    = {
        key = 79, -- C
        canHold = false,
    },
    move_forward   = {
        key = 71, -- W
        canHold = true,
    },
    move_backward  = {
        key = 72, -- S
        canHold = true,
    },
    move_left      = {
        key = 63, -- A
        canHold = true,
    },
    move_right     = {
        key = 64, -- D
        canHold = true,
    },
    move_up        = {
        key = 44, -- Q
        canHold = true,
    },
    move_down      = {
        key = 86, -- E
        canHold = true,
    },
    range_up       = {
        key = 17, -- UP
        canHold = true,
    },
    range_down     = {
        key = 16, -- DOWN
        canHold = true,
    },
    intensity_up   = {
        key = 172, -- PAGE UP
        canHold = false,
    },
    intensity_down = {
        key = 173, -- PAGE DOWN
        canHold = false,
    },
    extra_disable  = {
        key = 59, -- LEFT/RIGHT Steering, just here such that it is disabled
        canHold = false,
    },
}

local function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

local function Button(ControlButton)
    ScaleformMovieMethodAddParamPlayerNameString(ControlButton)
end

local function setupScaleform(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    -- draw it once to set up layout
    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 0, 0)

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, controls.save.key, true))
    ButtonMessage("Save extras")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(2, controls.cancel.key, true))
    ButtonMessage("Close Menu")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(2, controls.cycle_right.key, true))
    ButtonMessage("")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(3)
    Button(GetControlInstructionalButton(2, controls.cycle_left.key, true))
    ButtonMessage("Cycle extra")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(4)
    Button(GetControlInstructionalButton(2, controls.cycle_color.key, true))
    ButtonMessage("Cycle color")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(5)
    Button(GetControlInstructionalButton(2, controls.move_up.key, true))
    ButtonMessage("")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(6)
    Button(GetControlInstructionalButton(2, controls.move_down.key, true))
    ButtonMessage("")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(7)
    Button(GetControlInstructionalButton(2, controls.move_right.key, true))
    ButtonMessage("")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(8)
    Button(GetControlInstructionalButton(2, controls.move_backward.key, true))
    ButtonMessage("")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(9)
    Button(GetControlInstructionalButton(2, controls.move_left.key, true))
    ButtonMessage("")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(10)
    Button(GetControlInstructionalButton(2, controls.move_forward.key, true))
    ButtonMessage("Move light source")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(11)
    Button(GetControlInstructionalButton(2, controls.range_up.key, true))
    ButtonMessage("")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(12)
    Button(GetControlInstructionalButton(2, controls.range_down.key, true))
    ButtonMessage("Change range")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(13)
    Button(GetControlInstructionalButton(2, controls.intensity_up.key, true))
    ButtonMessage("")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(14)
    Button(GetControlInstructionalButton(2, controls.intensity_down.key, true))
    ButtonMessage("Change intensity")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

local function GetNextKeyInTable(table, currentKey)
    local nextKey, nextValue = next(table, currentKey)
    if nextKey == nil then
        nextKey, nextValue = next(table, nextKey)
    end
    return nextKey
end

local function DrawText3D(coords, text, r, g, b)
    local x, y, z = table.unpack(coords)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)

    if onScreen then
        local factor = (string.len(text)) / 370

        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(true)
        SetTextColour(r or 255, g or 255, b or 255, 215)
        SetTextEntry('STRING')
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x, _y)
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
    end
end

local function switch(value)
    return function(cases)
        return (cases[value] or cases.default)(value)
    end
end

debugging = false
CreateThread(function()
    if (not Config.DebugMode) then return end

    local maxExtras = 20
    local extraData = {
        Color = 'blue',
        Range = 20.0,
        Intensity = 0.1,
        Offset = { x = 0.0, y = 0.0, z = 2.0 },
    }

    debugging = false
    RegisterCommand('get_extras', function()
        if (debugging) then
            debugging = false
            return
        end

        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        if (not vehicle) then return end

        -- Set window tint to stock to avoid blacked out windows in some cases
        SetVehicleWindowTint(vehicle, 4)

        local extras = {}
        local extraIndices = {}
        for i = 0, maxExtras do
            if (DoesExtraExist(vehicle, i)) then
                extras[i] = DeepCopyTable(extraData)
                local boneIndex = GetEntityBoneIndexByName(vehicle, 'extra_' .. i)
                local bonePosition = GetWorldPositionOfEntityBone(vehicle, boneIndex) or vector3(0.0, 0.0, 0.0)
                local offset = GetOffsetFromEntityGivenWorldCoords(vehicle, bonePosition.x, bonePosition.y, bonePosition.z)
                extras[i].Offset.x = math.floor(offset.x * 100) / 100
                extras[i].Offset.y = math.floor(offset.y * 100) / 100
                extras[i].Offset.z = math.floor(offset.z * 100) / 100
                table.insert(extraIndices, i)
            end
        end

        if (next(extras) == nil) then
            DebugPrint('This vehicle does not have any extras')
            ShowNotification('This vehicle does not have any extras')
            return
        end

        local extraIndex = 1
        local selectedExtra = extraIndices[extraIndex]
        local selectedColor = 'blue'

        local form = setupScaleform("instructional_buttons")
        SetUserRadioControlEnabled(false)
        debugging = true

        CreateThread(function()
            while debugging do
                for key, extra in pairs(extraIndices) do
                    SetVehicleExtra(vehicle, extra, true)
                end
                Wait(200)
                local onTime = GetGameTimer()
                SetVehicleExtra(vehicle, selectedExtra, false)
                local inGameHour = GetClockHours()
                local multiplier = GetIntensityMultiplier(inGameHour)
                local boneIndex = GetEntityBoneIndexByName(vehicle, 'extra_' .. selectedExtra)
                while GetGameTimer() - onTime < 200 do
                    local lightOriginCoords = GetWorldPositionOfEntityBone(vehicle, boneIndex)
                    local lightCoords = GetOffsetFromEntityInWorldCoords(vehicle, extras[selectedExtra].Offset.x, extras[selectedExtra].Offset.y, extras[selectedExtra].Offset.z)
                    local forwardVector = {
                        x = lightCoords.x - lightOriginCoords.x,
                        y = lightCoords.y - lightOriginCoords.y,
                        z = lightCoords.z - lightOriginCoords.z
                    }
                    local color = Config.Colors[extras[selectedExtra].Color]
                    DrawSpotLight(lightCoords.x, lightCoords.y, lightCoords.z,
                        forwardVector.x,
                        forwardVector.y,
                        forwardVector.z,
                        color.r,
                        color.g,
                        color.b,
                        extras[selectedExtra].Range,
                        extras[selectedExtra].Intensity * multiplier,
                        0.0, 180.0, extras[selectedExtra].Range / 2)

                    DrawLine(lightOriginCoords.x, lightOriginCoords.y, lightOriginCoords.z, lightCoords.x, lightCoords.y, lightCoords.z, 255, 255, 255, 25.0)
                    Wait(0)
                end
            end
        end)

        while debugging do
            Wait(0)
            DrawScaleformMovieFullscreen(form, 255, 255, 255, 255, 0)
            local coords = GetOffsetFromEntityInWorldCoords(vehicle, extras[selectedExtra].Offset.x, extras[selectedExtra].Offset.y, extras[selectedExtra].Offset.z)
            local color = Config.Colors[extras[selectedExtra].Color]
            DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.1, color.r, color.g, color.b, 255)

            local ped = PlayerPedId()
            local currentVehicle = GetVehiclePedIsIn(ped, false)
            if (vehicle ~= currentVehicle) then
                debugging = false
            end

            for key, value in pairs(controls) do
                DisableControlAction(0, value.key, true)
                if (IsDisabledControlJustPressed(0, value.key) or (value.canHold and IsDisabledControlPressed(0, value.key))) then
                    switch(key) {
                        ['cancel'] = function()
                            debugging = false
                        end,
                        ['save'] = function()
                            TriggerServerEvent('gs_els:debug:export_extras', extras)
                            ShowNotification('Extras saved to the export.lua file')
                            Wait(1000)
                        end,
                        ['cycle_right'] = function()
                            extraIndex = extraIndex + 1
                            if (extraIndex > #extraIndices) then
                                extraIndex = 1
                            end
                            selectedExtra = extraIndices[extraIndex]
                        end,
                        ['cycle_left'] = function()
                            extraIndex = extraIndex - 1
                            if (extraIndex < 1) then
                                extraIndex = #extraIndices
                            end
                            selectedExtra = extraIndices[extraIndex]
                        end,
                        ['cycle_color'] = function()
                            extras[selectedExtra].Color = GetNextKeyInTable(Config.Colors, extras[selectedExtra].Color)
                        end,
                        ['range_up'] = function()
                            extras[selectedExtra].Range = extras[selectedExtra].Range + 1
                        end,
                        ['range_down'] = function()
                            extras[selectedExtra].Range = extras[selectedExtra].Range - 1
                            if (extras[selectedExtra].Range < 0) then
                                extras[selectedExtra].Range = 0.0
                            end
                        end,
                        ['intensity_up'] = function()
                            extras[selectedExtra].Intensity = extras[selectedExtra].Intensity + 0.05
                        end,
                        ['intensity_down'] = function()
                            extras[selectedExtra].Intensity = extras[selectedExtra].Intensity - 0.05
                            if (extras[selectedExtra].Intensity < 0) then
                                extras[selectedExtra].Intensity = 0.0
                            end
                        end,
                        ['move_right'] = function()
                            extras[selectedExtra].Offset.x = extras[selectedExtra].Offset.x + 0.01
                        end,
                        ['move_backward'] = function()
                            extras[selectedExtra].Offset.y = extras[selectedExtra].Offset.y - 0.01
                        end,
                        ['move_left'] = function()
                            extras[selectedExtra].Offset.x = extras[selectedExtra].Offset.x - 0.01
                        end,
                        ['move_forward'] = function()
                            extras[selectedExtra].Offset.y = extras[selectedExtra].Offset.y + 0.01
                        end,
                        ['move_up'] = function()
                            extras[selectedExtra].Offset.z = extras[selectedExtra].Offset.z + 0.01
                        end,
                        ['move_down'] = function()
                            extras[selectedExtra].Offset.z = extras[selectedExtra].Offset.z - 0.01
                        end,
                        ['default'] = function()
                            -- Do nothing
                        end
                    }
                end
            end

            local vehicleCoords = GetEntityCoords(vehicle)
            local extraText = "Extra: " .. selectedExtra
            local colorText = "Color: " .. extras[selectedExtra].Color
            local rangeText = "Range: " .. extras[selectedExtra].Range
            local intensityText = "Intensity: " .. extras[selectedExtra].Intensity
            DrawText3D(vehicleCoords, extraText)
            DrawText3D(vehicleCoords - vector3(0.0, 0.0, 0.25), colorText, Config.Colors[extras[selectedExtra].Color].r, Config.Colors[extras[selectedExtra].Color].g, Config.Colors[extras[selectedExtra].Color].b)
            DrawText3D(vehicleCoords - vector3(0.0, 0.0, 0.5), rangeText)
            DrawText3D(vehicleCoords - vector3(0.0, 0.0, 0.75), intensityText)
        end

        Wait(500)
        for key, extra in pairs(extraIndices) do
            SetVehicleExtra(vehicle, extra, true)
        end

        SetUserRadioControlEnabled(true)
    end)
end)
