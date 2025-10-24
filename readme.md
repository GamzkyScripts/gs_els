# Emergency Lights & Sirens (ELS)

#### ⭐ Check out our other resources on [gamzkystore.com](https://gamzkystore.com/) or in our [Discord](https://discord.com/invite/sjFP3HrWc3).
#### 📼 Preview video: [Youtube](https://www.youtube.com/watch?v=IhzVGswUauM)

There are quite a lot of ELS-variants available these days, mostly paid versions; which are often overpriced, lacking in features, badly optimized and don't bring an immersive feeling to the drawn lights. This scripts looks to tackle these problems, in a compact and comprehensive way, offering a free open-source alternative for your server to handle vehicle lights and sirens.

## Features
- Vehicle lights and sirens are fully synchronized between players and optimized for performance.
- Immersive lightning, the emitted lights are drawn in the direction of the light source, creating a realistic feeling.
- A comprehensive and compact user-interface, indicating the current status of the lights/sirens.
- Players seated in the front can simultaneously control the vehicle lights/sirens (can also be restricted to only the driver in the configuration).
- Many configurable options, even if you lack programming knowledge, you are still able to change the most important settings of the script.
- Fully standalone, can be integrated into any server. Because it is open-source, you always have full control and can add or remove any feature.
- A debug-mode, which allows you to configure the emergency lights of a vehicle whilst in-game. No need to notoriously configure the positions and directions of a light in the configuration file. The end of the showcase video shows how to fully configure a vehicle.
- Optimized, the script only physically draws the lights of the closest vehicles (amount can be configured) maintaining low resmon. If ~15 vehicles are closeby, the resmon will only be around 0.23 ms whilst still drawing the lights of the closest 5 vehicles (idle is 0.0 ms).
- The light intensity (optionally) adapts to the time, increasing emitted light intensity during daytime to make them more noticeable.
- Hazard and indicator lights are also included and fully synchronized.
- Supports custom (server-sided) sirens.
- Supports key-mapping, allowing individual players to customize keybindings.


## How to use custom sirens?
You will need a script to stream custom sirens first. I will walk through the configuration of gs_els for two scripts.

### [Walsheyy WMServerSirens](https://github.com/Walsheyy/WMServerSirens)
1. First be sure the script is installed to your server and running.
2. In `gs_els/config.lua`, configure the following AudioBank:
```lua
Config.AudioBanks = {
  'DLC_WMSIRENS\\SIRENPACK_ONE',
}
```
3. A custom siren can then be configure in `vehicles.lua` by:
```lua
Sirens = {
  [1] = { audioName = 'siren_alpha', audioRef = 'DLC_WMSIRENS_SOUNDSET' },
},
```

### [fk-1997 Server-Sided-Sounds-and-Sirens](https://github.com/fk-1997/Server-Sided-Sounds-and-Sirens)
1. First be sure the script is installed to your server and running.
2. In `gs_els/config.lua`, configure the following AudioBank:
```lua
Config.AudioBanks = {
  'DLC_SERVERSIDEAUDIO\\OISS_SSA_VEHAUD_BCSO_NEW',
}
```
3. A custom siren can then be configure in `vehicles.lua` by:
```lua
Sirens = {
  [1] = { audioName = 'oiss_ssa_vehaud_lssd_new_siren_adam', audioRef = 'oiss_ssa_vehaud_lssd_new_soundset' },
},
```
4. Other sirens in this script use different settings which can be found [here](https://github.com/fk-1997/Server-Sided-Sounds-and-Sirens/blob/main/IDTABLE.md#table-with-soundbank-soundset-and-audiostring). The naming in this document is slightly different, `SoundBank` is the same as `AudioBank`, `SoundSet` is the same as `audioRef` & `AudioString` is the same as `audioName`.