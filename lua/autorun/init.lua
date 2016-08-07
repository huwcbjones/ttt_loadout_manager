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
    -- Load weapon name map from file
    if (not file.Exists("data/ttt_loadout_manager/weapon_map.txt", "GAME")) then
        Msg("[LOADOUT MGR] ERROR! Weapon name map not found, copying default map.\n")
        file.CreateDir("ttt_loadout_manager")
        default_map = file.Read("addons/ttt_loadout_manager/data/weapon_map.txt", "GAME")
        file.Write("ttt_loadout_manager/weapon_map.txt", default_map)
    end

    local map = file.Read("ttt_loadout_manager/weapon_map.txt", "DATA")
    local table = util.JSONToTable(map)
    if table ~= nil then
        LoadoutMgr.Weapons.NameMap = table
    end
    Msg("[LOADOUT MGR] Loaded weapon name map!\n")
end

if not LoadoutMgr then
    LoadoutMgr = {}
    include ( "ttt_loadout_manager/defines.lua" )
    if not CLIENT then
        loadDefaultConfig()
        loadConfig()
        loadWeaponNameMap()
    end

    Msg("[LOADOUT MGR] Loaded Loadout Manager\n")

    include("ttt_loadout_manager/loadout.lua")
end