--
-- Initialises Loadout Manager
--
-- Author: Huw Jones
-- Date:   21/01/2016
--

--
-- Loads default config
--
local function loadDefaultConfig()
    LoadoutMgr.Weapons = {}
    LoadoutMgr.Weapons.Primary = {}
    LoadoutMgr.Weapons.Secondary = {}

    LoadoutMgr.Weapons.Filter = {}
    LoadoutMgr.Weapons.Filter.Primary = {}
    LoadoutMgr.Weapons.Filter.Primary.Type = LoadoutMgr.FILTER_NONE
    LoadoutMgr.Weapons.Filter.Primary.Value = ""

    LoadoutMgr.Weapons.Filter.Secondary = {}
    LoadoutMgr.Weapons.Filter.Secondary.Type = LoadoutMgr.FILTER_NONE
    LoadoutMgr.Weapons.Filter.Secondary.Value = ""
end

--
-- Loads config
--
local function loadConfig()
    if not file.Exists("config.lua", "LUA") then return end
    include("config.lua")
end

local function loadPrimaryWeapons()
    local weaponList = weapons.GetList()
    for i = 1, #weaponList do
        Msg("[LOADOUT MGR] - " .. LoadoutMgr.Weapons.Primary[i] .. "\n")
    end
    for i = 1, #weaponList do
        local w = weaponList[i]
        if not w.Kind == WEAPON_HEAVY then return end
        table.insert(LoadoutMgr.Weapons.Primary, w)
    end
end

if not LoadoutMgr then
    LoadoutMgr = {}
    include ( "defines.lua" )
    loadDefaultConfig()
    loadConfig()
    loadPrimaryWeapons()

    Msg("[LOADOUT MGR] Loaded Loadout Manager\n")
    Msg("[LOADOUT MGR] Available Primary Weapons: \n")
    PrintTable(LoadoutMgr.Weapons.Primary)
    for i = 1, #LoadoutMgr.Weapons.Primary do
        Msg("[LOADOUT MGR] - " .. LoadoutMgr.Weapons.Primary[i] .. "\n")
    end

    include("loadout.lua")
end