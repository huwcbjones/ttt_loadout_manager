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
    LoadoutMgr.Weapons.NameMap = {}
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
    if not file.Exists("ttt_loadout_manager/config.lua", "LUA") then return end
    include("ttt_loadout_manager/config.lua")
end

local function loadWeaponNameMap()
    if (not file.Exists("data/weapon_map.json")) then
        Msg("[LOADOUT MGR] ERROR! Weapon name map not found!")
    end
    local map = file.Open("weapon_map.json", "r", "DATA")
    local table = util.JSONToTable(map)
    if table ~= nil then
        LoadoutMgr.Weapons.NameMap = table
    end
end

if not LoadoutMgr then
    LoadoutMgr = {}
    include ( "ttt_loadout_manager/defines.lua" )
    loadDefaultConfig()
    loadConfig()

    Msg("[LOADOUT MGR] Loaded Loadout Manager\n")

    include("ttt_loadout_manager/loadout.lua")
end