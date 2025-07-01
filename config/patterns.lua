-- In this file, you can define the patterns that can be used for the lights of a vehicle.
-- The patterns are defined as a table, where the key is the name of the pattern and the values are the used extras in the pattern.
-- These values are defined as a string, where the 1's represent an active extra and the 0's represent an inactive extra.

Config.Patterns = {
    -- -- A brief example on how to define a pattern:
    ['example-pattern'] = {
        -- [1] corresponds to extra 1
        -- This extra is turned on for 4 'ticks', and then turned off for 4 'ticks'
        [1] = '11110000',

        -- [4] corresponds to extra 4
        -- This extra is turned off for 4 'ticks', and then turned on for 4 'ticks'
        [4] = '00001111',
    },

    -- The patterns used for the Dutch police vehicle in the showcase video
    ['polsandstorm-main'] = {
        [1] = '010111010111',
        [2] = '111010111010',
        [9] = '000111000111',
        [11] = '111000111000',
    },
    ['polsandstorm-second'] = {
        [3] = '110011011000000000000110110011011000000000000',
        [4] = '000000000110110011011000000000000110110011011',
    },
    ['polsandstorm-stop1'] = {
        [6] = '00000000001111111111',
        [7] = '11111111110000000000',
    },
    ['polsandstorm-stop2'] = {
        [5] = '00000000001111111111',
        [10] = '11111111110000000000',
    },
    ['polsandstorm-white'] = {
        [8] = '111111111111111111111',
    },

    -- The patterns used for the police vehicles in the showcase video
    ['police-main'] = {
        [1] = '110000110000',
        [2] = '000110000110',
        [3] = '110000110000',
        [4] = '000110000110',
        [5] = '110011001100',
        [6] = '001100110011',
    },
    ['police-second'] = {
        [7] = '111000111000',
        [8] = '010010010010',
        [9] = '000111000111',
    },
    ['police-white'] = {
        [11] = '1111111111',
    },

    -- The pattern used for the sheriff vehicle in the showcase video
    ['sheriff2-main'] = {
        [1] = '11001100101001100',
        [4] = '00110011010110011',
        [5] = '11001100101001100',
        [6] = '00110011010110011',
    },
}
