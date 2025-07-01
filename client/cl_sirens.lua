CreateThread(function()
    if (not Config.AudioBanks) then return end
    for _, audioBank in pairs(Config.AudioBanks) do
        RequestScriptAudioBank(audioBank, false)
    end
end)

function ToggleSiren(vehicle, index)
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
    local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)
    TriggerServerEvent('gs_els:toggleSiren', vehicleNetId, index)
    -- DebugPrint('Siren ' .. index .. ' toggled for vehicle ' .. vehicleNetId)
end

AddStateBagChangeHandler('siren', nil, function(bagName, key, sirenIndex)
    -- We first make sure the vehicle is correctly loaded
    local startTime = GetGameTimer()
    local vehicle = 0
    while (vehicle == 0 and GetGameTimer() - startTime < 1000) do
        vehicle = GetEntityFromStateBagName(bagName)
        Wait(0)
    end
    if vehicle == 0 then return end

    -- If the siren is turned off, we only update the menu and return
    if (sirenIndex == nil) then
        if (DoesPlayerHavePanelControl(vehicle)) then
            UpdateSirenStateNui('OFF', true)
        end
        return
    end

    -- Get the vehicle model and check if it is in the config
    local vehicleModel = GetEntityModel(vehicle)
    if (not Config.Vehicles[vehicleModel]) then
        DebugPrint('Vehicle ' .. vehicleModel .. ' is not defined in the config')
        return
    end

    -- Check if the siren is in the config
    local siren = Config.Vehicles[vehicleModel].Sirens[sirenIndex]
    if (not siren) then
        DebugPrint('Siren ' .. sirenIndex .. ' is not defined in the config')
        return
    end

    -- Make sure the audio is defined
    local audioName = siren.audioName
    local audioRef = siren.audioRef or 0
    if (not audioName) then
        DebugPrint('Siren ' .. sirenIndex .. ' has no audioName defined')
        return
    end

    -- Check if we are driving or co-driving the vehicle, if so we update the menu
    if (DoesPlayerHavePanelControl(vehicle)) then
        UpdateSirenStateNui(sirenIndex, true)
    end

    -- Play the siren
    local soundId = GetSoundId()
    PlaySoundFromEntity(soundId, audioName, vehicle, 0, 0, 0)

    -- Wait until the siren is turned off
    while (CanVehicleHaveLightsOrSirens(vehicle) and Entity(vehicle).state.siren == sirenIndex) do
        Wait(250)
    end

    -- Stop the siren
    StopSound(soundId)
    ReleaseSoundId(soundId)

    -- If the vehicle does not exist anymore we are done
    if (not DoesEntityExist(vehicle)) then
        return
    end

    -- If the same siren is no longer active, we are done
    if (Entity(vehicle).state.siren ~= sirenIndex) then
        return
    end

    -- If the vehicle is not owned by the player, we are done
    local entityOwner = NetworkGetEntityOwner(vehicle)
    if (entityOwner ~= PlayerId()) then
        return
    end

    -- We also turn off the siren
    local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)
    TriggerServerEvent('gs_els:toggleSiren', vehicleNetId, sirenIndex)
end)
