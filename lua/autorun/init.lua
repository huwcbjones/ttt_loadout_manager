--
-- Initialises Loadout Manager
--
-- Author: Huw Jones
-- Date:   21/01/2016
--

AddCSLuaFile('ttt_loadout_manager/defines.lua')
AddCSLuaFile('ttt_loadout_manager/loadout.lua')

--- Loads default config
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
    LoadoutMgr.Weapons.Filter.Primary.Table = {}

    LoadoutMgr.Weapons.Filter.Secondary = {}
    LoadoutMgr.Weapons.Filter.Secondary.Type = LoadoutMgr.FILTER_NONE
    LoadoutMgr.Weapons.Filter.Secondary.Value = ""
    LoadoutMgr.Weapons.Filter.Secondary.Table = {}
end

--- Loads config
--
local function loadConfig()
    if not file.Exists("ttt_loadout_manager/config.lua", "LUA") then return end
    include("ttt_loadout_manager/config.lua")
    include("csvutils.lua")
    LoadoutMgr.Weapons.Filter.Primary.Table = fromCSV(LoadoutMgr.Weapons.Filter.Primary.Value)
    LoadoutMgr.Weapons.Filter.Secondary.Table = fromCSV(LoadoutMgr.Weapons.Filter.Secondary.Value)
end

--- Loads the Weapon Name map
--
local function loadWeaponNameMap()
    -- Load weapon name map from file
    if (not file.Exists("data/ttt_loadout_manager/weapon_map.txt", "GAME")) then
        Msg("[LOADOUT MGR] ERROR! Weapon name map not found, copying default map.\n")
        file.CreateDir("ttt_loadout_manager")
        local default_map = file.Read("addons/ttt_loadout_manager/data/weapon_map.txt", "GAME")
        file.Write("ttt_loadout_manager/weapon_map.txt", default_map)
    end

    local map = file.Read("ttt_loadout_manager/weapon_map.txt", "DATA")
    local weapon_table = util.JSONToTable(map)

    if weapon_table ~= nil then
        LoadoutMgr.Weapons.NameMap = weapon_table
        Msg("[LOADOUT MGR] Loaded weapon name map!\n")
    else
        Msg("[LOADOUT MGR] Failed to load weapon name map! Dumping weapon_map.txt:\n")
        print(map)
    end
end

if not LoadoutMgr then
    LoadoutMgr = {}
    include ( "ttt_loadout_manager/defines.lua" )
    if SERVER then
    loadDefaultConfig()
    loadConfig()
    loadWeaponNameMap()
    end

    include("ttt_loadout_manager/loadout.lua")
    Msg("[LOADOUT MGR] Loaded Loadout Manager\n")
end