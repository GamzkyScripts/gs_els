CreateThread(function()
    local previousLightsOn, previousHighBeamOn = false, false
    while true do
        Wait(100)
        -- Do all the required checks first in CanPlayerInteract
        local vehicle, vehicleModel, canHaveSirensOrLights = CanPlayerInteract()
        if (vehicle == nil) then
            Wait(500)
            goto continue
        end

        -- Menu updates are only needed for vehicles that use the overlay
        if (not canHaveSirensOrLights) then
            Wait(500)
            goto continue
        end

        -- Update the UI when the lights change
        local retval, lightsOn, highBeamsOn = GetVehicleLightsState(vehicle)
        if (previousLightsOn ~= lightsOn or previousHighBeamOn ~= highBeamsOn) then
            UpdateHeadLightStateNui(lightsOn, highBeamsOn)
            previousLightsOn = lightsOn
            previousHighBeamOn = highBeamsOn
        end

        ::continue::
    end
end)
