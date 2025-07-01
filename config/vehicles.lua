Config.Vehicles = {
    -- This is an example of a vehicle configuration, you can use this as a template to create your own
    -- `example` should be replaced with the vehicle model name, be sure to use `` and not '' or "" here
    [`example`] = {
        -- Next we define the available sirens for the vehicle
        -- audioName: is the name of the audio that should be played.
        -- audioRef: is only used for custom sirens, if you do not use it you can keep it at 0. If you do use custom sirens, be sure to also define the used audioBanks in Config.AudioBanks
        Sirens = {
            [1] = { audioName = 'VEHICLES_HORNS_SIREN_1', audioRef = 0 },
            [2] = { audioName = 'VEHICLES_HORNS_SIREN_2', audioRef = 0 },
            -- More sirens can be defined, with a maximum of 5 sirens
        },
        -- Next we define the available lights for the vehicle
        -- Pattern: is the name of the pattern that should be used, you can find the available patterns in gs_els/config/patterns.lua
        -- button: This defines the layout of the button, which are defined in Config.OverlayButtons
        -- group: This is optional and defines the group that the light is in, lights in the same group cannot be active at the same time.
        Lights = {
            [1] = { Pattern = 'example-main', button = 'blue', group = 'main' },
            [2] = { Pattern = 'example-secondary', button = 'amber', group = 'main' },
            -- More lights can be defined, with a maximum of 8 lights
        },
        -- Finally we define the extras for the vehicle, this can easily be done using the Config.DebugMode located at the bottom of gs_els/config/config.lua
        -- Color: This defines the color of the light source, which are defined in Config.Colors
        -- Offset: This defines the offset of the extra, where the light source will be created
        -- Range: This defines the range of the light source
        -- Intensity: This defines the intensity of the light source
        Extras = {
            [1] = { Color = 'blue', Offset = { x = 1.08, y = 0.26, z = 0.94 }, Range = 20.0, Intensity = 0.1 },
            [2] = { Color = 'blue', Offset = { x = -1.08, y = 0.26, z = 0.92 }, Range = 20.0, Intensity = 0.1 },
            [3] = { Color = 'amber', Offset = { x = 1.05, y = 0.23, z = 0.94 }, Range = 20.0, Intensity = 0.1 },
            [4] = { Color = 'amber', Offset = { x = -0.97, y = 0.2, z = 0.95 }, Range = 20.0, Intensity = 0.1 },
            [5] = { Color = 'red', Offset = { x = -0.62, y = -3.33, z = 0.51 }, Range = 1.0, Intensity = 0.05 },
            -- More extras can be defined, depending on the vehicle
        }
    },

    -- This is the configuration used for the Dutch police vehicle in the showcase video 
    [`polsandstorm`] = {
        Sirens = {
            [1] = { audioName = 'VEHICLES_HORNS_SIREN_1', audioRef = 0 },
            [2] = { audioName = 'VEHICLES_HORNS_SIREN_2', audioRef = 0 },
            [3] = { audioName = 'VEHICLES_HORNS_POLICE_WARNING', audioRef = 0 },
            [4] = { audioName = 'RESIDENT_VEHICLES_SIREN_FIRETRUCK_WAIL_01', audioRef = 0 },
            [5] = { audioName = 'RESIDENT_VEHICLES_SIREN_FIRETRUCK_QUICK_01', audioRef = 0 },
        },
        Lights = {
            [1] = { Pattern = '1-2-9-11-pattern', button = 'blue', group = 'main' },
            [2] = { Pattern = 'polsandstorm-second', button = 'amber', group = 'main' },
            [3] = { Pattern = 'polsandstorm-stop1', button = 'red' },
            [4] = { Pattern = 'polsandstorm-stop2', button = 'red' },
            [5] = { Pattern = 'polsandstorm-white', button = 'white' },
        },
        Extras = {
            [1] = { Color = 'blue', Offset = { x = 1.08, y = 0.26, z = 0.94 }, Range = 20.0, Intensity = 0.1 },
            [2] = { Color = 'blue', Offset = { x = -1.08, y = 0.26, z = 0.92 }, Range = 20.0, Intensity = 0.1 },
            [3] = { Color = 'amber', Offset = { x = 1.05, y = 0.23, z = 0.94 }, Range = 20.0, Intensity = 0.1 },
            [4] = { Color = 'amber', Offset = { x = -0.97, y = 0.2, z = 0.95 }, Range = 20.0, Intensity = 0.1 },
            [5] = { Color = 'red', Offset = { x = -0.62, y = -3.33, z = 0.51 }, Range = 1.0, Intensity = 0.05 },
            [6] = { Color = 'red', Offset = { x = 0.41, y = 1.39, z = 1.15 }, Range = 1.0, Intensity = 0.05 },
            [7] = { Color = 'red', Offset = { x = 0.45, y = 1.39, z = 1.11 }, Range = 1.0, Intensity = 0.05 },
            [8] = { Color = 'white', Offset = { x = 0.01, y = 0.53, z = 1.22 }, Range = 20.0, Intensity = 0.35 },
            [9] = { Color = 'blue', Offset = { x = -0.02, y = 3.47, z = 0.34 }, Range = 10.0, Intensity = 0.1 },
            [10] = { Color = 'red', Offset = { x = -0.63, y = -3.26, z = 0.5 }, Range = 1.0, Intensity = 0.05 },
            [11] = { Color = 'blue', Offset = { x = -0.02, y = 3.51, z = 0.16 }, Range = 10.0, Intensity = 0.1 },
        }
    },
    
    -- This is the configuration used for the U.S. police vehicle in the showcase video
    [`police2`] = {
        Sirens = {
            [1] = { audioName = 'VEHICLES_HORNS_SIREN_1', audioRef = 0 },
            [2] = { audioName = 'VEHICLES_HORNS_SIREN_2', audioRef = 0 },
            [3] = { audioName = 'VEHICLES_HORNS_POLICE_WARNING', audioRef = 0 },
            [4] = { audioName = 'RESIDENT_VEHICLES_SIREN_FIRETRUCK_WAIL_01', audioRef = 0 },
            [5] = { audioName = 'RESIDENT_VEHICLES_SIREN_FIRETRUCK_QUICK_01', audioRef = 0 },
        },
        Lights = {
            [1] = { Pattern = 'police-main', button = 'blue', group = 'main' },
            [2] = { Pattern = 'police-second', button = 'amber', group = 'main' },
            [3] = { Pattern = 'police-white', button = 'white' },
        },
        Extras = {
            [1] = { Color = 'red', Offset = { x = -0.78, y = -0.38, z = 1.35 }, Range = 20.0, Intensity = 0.1 },
            [2] = { Color = 'red', Offset = { x = -0.75, y = -0.38, z = 1.35 }, Range = 20.0, Intensity = 0.1 },
            [3] = { Color = 'blue', Offset = { x = 0.8, y = -0.38, z = 1.35 }, Range = 20.0, Intensity = 0.1 },
            [4] = { Color = 'blue', Offset = { x = 0.82, y = -0.38, z = 1.35 }, Range = 20.0, Intensity = 0.1 },
            [5] = { Color = 'red', Offset = { x = -1.0, y = 0.71, z = 0.9 }, Range = 5.0, Intensity = 0.05 },
            [6] = { Color = 'blue', Offset = { x = 1.0, y = 0.71, z = 0.92 }, Range = 5.0, Intensity = 0.05 },
            [7] = { Color = 'amber', Offset = { x = -0.32, y = -0.65, z = 1.4 }, Range = 20.0, Intensity = 0.1 },
            [8] = { Color = 'amber', Offset = { x = -0.01, y = -0.67, z = 1.35 }, Range = 20.0, Intensity = 0.1 },
            [9] = { Color = 'amber', Offset = { x = 0.3, y = -0.63, z = 1.35 }, Range = 20.0, Intensity = 0.1 },
            [11] = { Color = 'white', Offset = { x = 0.07, y = -0.12, z = 1.35 }, Range = 20.0, Intensity = 0.1 },
        }
    },

    -- This is the configuration used for the U.S. police vehicle in the showcase video
    [`police3`] = {
        Sirens = {
            [1] = { audioName = 'VEHICLES_HORNS_SIREN_1', audioRef = 0 },
            [2] = { audioName = 'VEHICLES_HORNS_SIREN_2', audioRef = 0 },
            [3] = { audioName = 'VEHICLES_HORNS_POLICE_WARNING', audioRef = 0 },
            [4] = { audioName = 'RESIDENT_VEHICLES_SIREN_FIRETRUCK_WAIL_01', audioRef = 0 },
            [5] = { audioName = 'RESIDENT_VEHICLES_SIREN_FIRETRUCK_QUICK_01', audioRef = 0 },
        },
        Lights = {
            [1] = { Pattern = 'police-main', button = 'blue', group = 'main' },
            [2] = { Pattern = 'police-second', button = 'amber', group = 'main' },
            [3] = { Pattern = 'police-white', button = 'white' },
        },
        Extras = {
            [1] = { Color = 'red', Offset = { x = -0.74, y = -0.41, z = 1.08 }, Range = 20.0, Intensity = 0.1 },
            [2] = { Color = 'red', Offset = { x = -0.77, y = -0.41, z = 1.08 }, Range = 20.0, Intensity = 0.1 },
            [3] = { Color = 'blue', Offset = { x = 0.77, y = -0.41, z = 1.08 }, Range = 20.0, Intensity = 0.1 },
            [4] = { Color = 'blue', Offset = { x = 0.79, y = -0.41, z = 1.08 }, Range = 20.0, Intensity = 0.1 },
            [5] = { Color = 'red', Offset = { x = -1.06, y = 0.77, z = 0.58 }, Range = 3.0, Intensity = 0.05 },
            [6] = { Color = 'blue', Offset = { x = 1.04, y = 0.73, z = 0.58 }, Range = 3.0, Intensity = 0.05 },
            [7] = { Color = 'amber', Offset = { x = -0.31, y = -0.67, z = 1.14 }, Range = 20.0, Intensity = 0.1 },
            [8] = { Color = 'amber', Offset = { x = 0.0, y = -0.67, z = 1.13 }, Range = 20.0, Intensity = 0.1 },
            [9] = { Color = 'amber', Offset = { x = 0.32, y = -0.68, z = 1.13 }, Range = 20.0, Intensity = 0.1 },
            [11] = { Color = 'white', Offset = { x = 0.07, y = -0.15, z = 1.09 }, Range = 20.0, Intensity = 0.1 },
        }
    },

    -- This is the configuration used for the U.S. police vehicle in the showcase video
    [`police4`] = {
        Sirens = {
            [1] = { audioName = 'VEHICLES_HORNS_SIREN_1', audioRef = 0 },
            [2] = { audioName = 'VEHICLES_HORNS_SIREN_2', audioRef = 0 },
            [3] = { audioName = 'VEHICLES_HORNS_POLICE_WARNING', audioRef = 0 },
            [4] = { audioName = 'RESIDENT_VEHICLES_SIREN_FIRETRUCK_WAIL_01', audioRef = 0 },
            [5] = { audioName = 'RESIDENT_VEHICLES_SIREN_FIRETRUCK_QUICK_01', audioRef = 0 },
        },
        Lights = {
            [1] = { Pattern = 'police-main', button = 'blue', group = 'main' },
            [2] = { Pattern = 'police-second', button = 'amber', group = 'main' },
            [3] = { Pattern = 'police-white', button = 'white' },
        },
        Extras = {
            [1] = { Color = 'red', Offset = { x = -0.31, y = -1.74, z = 0.96 }, Range = 20.0, Intensity = 0.1 },
            [2] = { Color = 'blue', Offset = { x = 0.4, y = 0.71, z = 0.81 }, Range = 20.0, Intensity = 0.1 },
            [3] = { Color = 'red', Offset = { x = -0.4, y = 0.69, z = 0.81 }, Range = 20.0, Intensity = 0.1 },
            [4] = { Color = 'blue', Offset = { x = 0.35, y = -1.77, z = 0.97 }, Range = 20.0, Intensity = 0.1 },
            [5] = { Color = 'red', Offset = { x = -1.0, y = 0.84, z = 0.55 }, Range = 3.0, Intensity = 0.05 },
            [6] = { Color = 'blue', Offset = { x = 0.99, y = 0.82, z = 0.55 }, Range = 3.0, Intensity = 0.05 },
            [7] = { Color = 'amber', Offset = { x = -0.24, y = -1.72, z = 0.83 }, Range = 20.0, Intensity = 0.1 },
            [8] = { Color = 'amber', Offset = { x = -0.01, y = -1.74, z = 0.84 }, Range = 20.0, Intensity = 0.1 },
            [9] = { Color = 'amber', Offset = { x = 0.23, y = -1.78, z = 0.75 }, Range = 20.0, Intensity = 0.1 },
            [11] = { Color = 'white', Offset = { x = 0.25, y = 0.75, z = 0.81 }, Range = 20.0, Intensity = 0.1 },
        }
    },

    -- This is the configuration that was created at the end of the showcase video
    [`sheriff2`] = {
        Sirens = {
            [1] = { audioName = 'VEHICLES_HORNS_SIREN_1', audioRef = 0 },
            [2] = { audioName = 'VEHICLES_HORNS_SIREN_2', audioRef = 0 },
        },
        Lights = {
            [1] = { Pattern = 'sheriff2-main', button = 'blue', group = 'main' },
        },
        Extras = {
            [1] = { Color = 'pastel-red', Offset = { x = -0.87, y = -0.45, z = 1.31 }, Range = 20.0, Intensity = 0.1 },
            [4] = { Color = 'blue', Offset = { x = 0.81, y = -0.46, z = 1.31 }, Range = 20.0, Intensity = 0.1 },
            [5] = { Color = 'pastel-red', Offset = { x = -0.86, y = -0.46, z = 1.31 }, Range = 20.0, Intensity = 0.1 },
            [6] = { Color = 'blue', Offset = { x = 0.86, y = -0.46, z = 1.31 }, Range = 20.0, Intensity = 0.1 },
        }
    },
}
