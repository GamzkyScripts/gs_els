Config = {}

-- The seats that are allowed to control the els, if set to false only the driver has control
Config.AllowControlFromPassengerSeat = true

-- If set to true, players will be able to change the keybindings to their liking in the FiveM keybind settings
Config.EnableKeyMapping = false

-- Below are the default keybindings for the sirens, lights, indicators and the UI menu
-- You can find info on the 'key' variable here: https://docs.fivem.net/docs/game-references/controls/
-- You can find info on the 'label' variable here: https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
Config.Keys = {
    -- The keys for the 1-5 sirens
    Sirens = {
        [1] = { key = 36, label = 'LCONTROL', info = 'Siren 1' }, -- L-CTRL
        [2] = { key = 21, label = 'LSHIFT', info = 'Siren 2' },   -- L-SHIFT
        [3] = { key = 137, label = 'CAPITAL', info = 'Siren 3' }, -- CAPSLOCK
        [4] = { key = 349, label = 'TAB', info = 'Siren 4' },     -- TAB
        [5] = { key = 243, label = 'GRAVE', info = 'Siren 5' },   -- `
    },
    -- The keys for the 1-5 lights
    Lights = {
        [1] = { key = 157, label = '1', info = 'Light 1' }, -- 1
        [2] = { key = 158, label = '2', info = 'Light 2' }, -- 2
        [3] = { key = 160, label = '3', info = 'Light 3' }, -- 3
        [4] = { key = 164, label = '4', info = 'Light 4' }, -- 4
        [5] = { key = 165, label = '5', info = 'Light 5' }, -- 5
    },
    -- The keys for the left/right/both indicators
    Indicators = {
        [1] = { key = 174, label = 'LEFT', info = 'Indicator left' },   -- LEFT-ARROW
        [2] = { key = 175, label = 'RIGHT', info = 'Indicator right' }, -- RIGHT-ARROW
        [3] = { key = 173, label = 'DOWN', info = 'Indicator both' },   -- DOWN-ARROW
    },
    Menu = {
        [1] = { key = 48, label = 'Z', info = 'Toggle menu' }, -- Z
    },
}

-- Classes which cannot use the indicators are defined below
Config.IndicatorBlacklistClasses = { 13, 14, 15, 16, 21 } -- Cycles, Boats, Helicopters, Planes, Trains

-- The colors that can be used in the vehicles.lua configuration, feel free to change or add colors
Config.Colors = {
    ['blue'] = { r = 0, g = 10, b = 255 },
    ['red'] = { r = 255, g = 0, b = 0 },
    ['pastel-red'] = { r = 194, g = 59, b = 34 },
    ['amber'] = { r = 255, g = 194, b = 0 },
    ['green'] = { r = 0, g = 255, b = 0 },
    ['white'] = { r = 255, g = 255, b = 255 },
}

-- The intensity multiplier for the lights during the day
Config.DayTimeIntensityMultiplier = 100.0

-- The intensity multiplier for the lights during the night
Config.NightTimeIntensityMultiplier = 5.0

-- If you use custom sirens, you need to add all the audio banks you use to this table
Config.AudioBanks = {
    -- 'DLC_WMSIRENS\\SIRENPACK_ONE',
}

-- If true, the engine will be kept running when the player exits a vehicle with active lights
-- Changing vehicle extras will not work correctly if the engine is not running so you should probably leave this to true
Config.KeepEngineRunning = true

-- The minimum engine health for the lights and sirens to stay enabled, if the engine health drops below this value the lights/sirens are disabled
Config.MinimumEngineHealth = 200

-- The maximum amount of vehicles that will actually draw lights on the surrounding areas at the same time
-- Lower values increases the performance of the script when a lot of vehicles are closeby with active lights.
-- If you do not want this limit, and always want to draw all lights, simply set this equal to nil (or a large number)
Config.MaximumAmountOfVehiclesWithLights = 5

-- The buttons in the overlay, that are defined in the vehicles.lua configuration, can be changed here.
Config.OverlayButtons = {
    ['fallback'] = { -- This is a fallback, no need to edit this variable
        text = 'FALL',
        color = { r = 128, g = 128, b = 128 },
    },
    ['blue'] = {                              -- This is the blue light button
        text = 'light-icon.svg',              -- You can define either plain text, or a .svg icon (if it is located in gs_els/html/images)
        color = { r = 30, g = 144, b = 255 }, -- The RGB collor of the button
    },
    ['red'] = {
        text = 'sign-stop-icon.svg',
        color = { r = 220, g = 20, b = 60 },
    },
    ['yellow'] = {
        text = 'sign-stop-icon.svg',
        color = { r = 228, g = 208, b = 10 },
    },
    ['amber'] = {
        text = 'warning-icon.svg',
        color = { r = 255, g = 165, b = 0 },
    },
    ['pastel-red'] = {
        text = 'warning-icon.svg',
        color = { r = 194, g = 59, b = 34 },
    },
    ['green'] = {
        text = 'GREEN',
        color = { r = 50, g = 205, b = 50 },
    },
    ['white'] = {
        text = 'area-light-icon.svg',
        color = { r = 71, g = 71, b = 71 },
    },
}

-- If true, some debug prints will be shown in the console
-- You will also be able to use the /get_extras command to configure the extras of a vehicle (see the end of youtube showcase video for a small tutorial)
Config.DebugMode = false
