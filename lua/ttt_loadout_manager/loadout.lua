--
-- Manages Loadouts
--
-- Author: Huw Jones
-- Date:   21/01/2016
--

--- Loadout manager main function
-- @param calling_player Player
-- @param arg2 Arg2
-- @param arg3 Arg3
--
LoadoutMgr.manager = function(calling_player, arg2, arg3)
    if (not calling_player:query("ulx loadout", true)) then
        ULib.tsayError(calling_player, "You don't have permission to use the Loadout Manager!")
        return
    end
    -- If no arguements specified, display loadout
    if ((arg2 == nil or arg2 == "") and (arg3 == nil or arg3 == "")) then
        LoadoutMgr.printLoadout(calling_player)
        ULib.tsayError(calling_player, "For help, use !loadout help.")
        return
    end

    -- If invalid arguement supplied, notify user
    if (LoadoutMgr.validCommands[arg2] == nil) then
        ULib.tsayError(calling_player, "Use !loadout help for a list of commands")
        return
    end

    -- Display help
    if (arg2 == "help") then
        LoadoutMgr.displayHelp(calling_player, arg3)
        return
    end

    -- Reset loadout
    if (arg2 == "reset") then
        LoadoutMgr.setWeaponPrimary(calling_player, nil)
        LoadoutMgr.setWeaponSecondary(calling_player, nil)
        LoadoutMgr.setWeaponOverride(calling_player, nil)
        LoadoutMgr.printLoadout(calling_player)
        ULib.tsayColor(calling_player, false, Color(0, 255, 0), "Your loadout was reset.")
        return
    end

    -- Save primary weapon
    if (arg2 == "primary") then
        if (arg3 ~= "") then
            if (not LoadoutMgr.checkPrimaryWeapon(arg3)) then
                ULib.tsayError(calling_player, "Invalid primary weapon \"" .. arg3 .. "\"")
                return
            end
        end

        ULib.tsayColor(calling_player, false, Color(255, 0, 0), "== Loadout Manager ==")
        if arg3 == "" then
            arg3 = nil
        end
        LoadoutMgr.setWeaponPrimary(calling_player, arg3)
        ULib.tsayColor(calling_player, false, Color(0, 192, 255), "Primary Weapon: " .. LoadoutMgr.convertWeaponToString(arg3))
    end

    -- TODO: Add GUI (later revision)
    -- Save secondary weapon
    if (arg2 == "secondary") then
        if (arg3 ~= "") then
            if (not LoadoutMgr.checkSecondaryWeapon(arg3)) then
                ULib.tsayError(calling_player, "Invalid secondary weapon \"" .. arg3 .. "\"")
                return
            end
        end

        ULib.tsayColor(calling_player, false, Color(255, 0, 0), "== Loadout Manager ==")
        if arg3 == "" then
            arg3 = nil
        end
        LoadoutMgr.setWeaponSecondary(calling_player, arg3)
        ULib.tsayColor(calling_player, false, Color(0, 192, 255), "Secondary Weapon: " .. LoadoutMgr.convertWeaponToString(arg3))
    end

    -- Set weapon override status
    if (arg2 == "override") then
        if (not LoadoutMgr.checkOverride(arg3)) then
            ULib.tsayError(calling_player, "Invalid override setting \"" .. arg3 .. "\"")
            return
        end
        ULib.tsayColor(calling_player, false, Color(255, 0, 0), "== Loadout Manager ==")
        LoadoutMgr.setWeaponOverride(calling_player, arg3)

        local override_str = "Disabled"
        if (LoadoutMgr.getWeaponOverride(calling_player)) then
            override_str = "Enabled"
        end

        ULib.tsayColor(calling_player, false, Color(0, 128, 255), "Override: " .. override_str)
    end

    -- Display weapons
    if (arg2 == "weapons") then
        LoadoutMgr.printWeapons(calling_player, arg3)
    end
end

--- Displays the loadout help
-- @param calling_player Player
-- @param command Command for help
--
LoadoutMgr.displayHelp = function(calling_player, command)
    ULib.tsayColor(calling_player, false, Color(255, 0, 0), "== Loadout Manager Help:", Color(255, 192, 0), " " .. command, Color(255, 0, 0), " ==")

    if (command == "primary" or command == "secondary") then
        ULib.tsayColor(calling_player, false, Color(0, 192, 255), "!loadout " .. command .. " [weapon]")
        ULib.tsayColor(calling_player, false, Color(0, 192, 255), "If weapon is blank, your loadout slot for that weapon will be cleared.")
        return
    end

    if (command == "reset") then
        ULib.tsayColor(calling_player, false, Color(0, 192, 255), "!loadout reset, clears your loadout")
        return
    end

    if (command == "override") then
        ULib.tsayColor(calling_player, false, Color(0, 192, 255), "!loadout override [on/off], sets whether your current weapons will be replaced when your loadout is equipped")
        return
    end

    if (command == "weapons") then
        ULib.tsayColor(calling_player, false, Color(0, 192, 255), "!loadout weapons [primary/secondary], displays a list of available [primary/secondary] weapons")
        return
    end

    local cmds = ""
    local i = 1
    for _, v in pairs(LoadoutMgr.validCommands) do
        if i == 1 then
            cmds = cmds .. v
        else
            cmds = cmds .. ", " .. v
        end
        i = i + 1
    end
    ULib.tsayColor(calling_player, false, Color(0, 192, 255), "Available commands: " .. cmds)
    ULib.tsayColor(calling_player, false, Color(255, 0, 0), "For help with a command, use !loadout help [command].")
end

--- Prints a player's loadout
-- @param calling_player Player
--
LoadoutMgr.printLoadout = function(calling_player)
    local primary = LoadoutMgr.getWeaponPrimary(calling_player)
    local secondary = LoadoutMgr.getWeaponSecondary(calling_player)
    local override = LoadoutMgr.getWeaponOverride(calling_player)
    local override_str = "Disabled"

    if override then
        override_str = "Enabled"
    end

    primary = LoadoutMgr.convertWeaponToString(primary)
    secondary = LoadoutMgr.convertWeaponToString(secondary)

    ULib.tsayColor(calling_player, false, Color(255, 0, 0), "== Loadout Manager: ", Color(255, 192, 0), "Current Loadout", Color(255, 0, 0), " ==")
    ULib.tsayColor(calling_player, false,
        Color(0, 255, 255),
        "Primary: " .. primary .. "\n",
        Color(0, 192, 255),
        "Secondary: " .. secondary .. "\n",
        Color(0, 128, 255),
        "Override: " .. override_str)
end

--- Prints the list of weapons
-- @param calling_player
-- @param type
--
LoadoutMgr.printWeapons = function(calling_player, type)
    LoadoutMgr.getWeaponList()
    local weapon_table, type_str

    if (type == "primary") then
        type_str = "Primary"
        weapon_table = LoadoutMgr.Weapons.Primary
    elseif (type == "secondary") then
        type_str = "Secondary"
        weapon_table = LoadoutMgr.Weapons.Secondary
    else
        ULib.tsayError(calling_player, "Please specify a weapon type (primary/secondary)")
        return
    end

    if (weapon_table == nil) then
        return
    end
    local str = "\n\n== Loadout Manager: Available " .. type_str .. " weapons ==\n"
    str = str .. string.format("Name%s ID\n", str.rep(" ", 36))
    for weapon_key, _ in pairs(weapon_table) do
        local weapon_name = LoadoutMgr.convertWeaponToString(weapon_key)

        local weapon_str = str.rep(" ", 41) .. weapon_key

        if (weapon_name ~= nil) then
            weapon_str = weapon_name .. str.rep(" ", 41 - weapon_name:len()) .. weapon_key
        end

        str = str .. weapon_str .. "\n"
    end
    ULib.tsayColor(calling_player, false,
        Color(255, 0, 0),
        "== Loadout Manager: ",
        Color(255, 172, 0),
        "Available " .. type_str .. " Weapons",
        Color(255, 0, 0),
        " ==\n",
        Color(0, 192, 255),
        "Weapons list has been printed to console, press ` to view. (Make sure console is enabled in settings).")

    local lines = ULib.explode("\n", str)

    for _, line in ipairs(lines) do
        ULib.console(calling_ply, line)
    end
end

--- Gets the list of weapons available
--
LoadoutMgr.getWeaponList = function()
    local weaponList = weapons.GetList()
    local weapon
    for i = 1, #weaponList do
        weapon = weaponList[i]
        if (weapon.Kind == WEAPON_HEAVY) then
            if (LoadoutMgr.checkPrimaryWeaponFilter(weapon.ClassName)) then
                LoadoutMgr.Weapons.Primary[weapon.ClassName] = weapon
            end
        elseif (weapon.Kind == WEAPON_PISTOL) then
            if (LoadoutMgr.checkSecondaryWeaponFilter(weapon.ClassName)) then
                LoadoutMgr.Weapons.Secondary[weapon.ClassName] = weapon
            end
        end
    end

    Msg("\n\n==Available Primary Weapons ==\n")
    for wid, _ in pairs(LoadoutMgr.Weapons.Primary) do
        local wname = LoadoutMgr.convertWeaponToString(wid)
        if (wname == nil) then
            print(wid)
        else
            print(wname .. ": " .. wid)
        end
    end

    Msg("\n\n==Available Secondary Weapons ==\n")
    for wid, _ in pairs(LoadoutMgr.Weapons.Secondary) do
        local wname = LoadoutMgr.convertWeaponToString(wid)
        if (wname == nil) then
            print(wid)
        else
            print(wname .. ": " .. wid)
        end
    end
end

--- Checks is a primary weapon is allowed
--
-- @param weapon String, weapon ID string
-- @return boolean  True if the weapon is allowed, false if it is not
LoadoutMgr.checkPrimaryWeapon = function(weapon)
    return LoadoutMgr.Weapons.Primary[weapon] ~= nil
end

--- Checks the Primary weapon if it passes the filter
--
-- @param weapon String, weapon ID string
-- @return boolean  True if the weapon is allowed, false if it is not
LoadoutMgr.checkPrimaryWeaponFilter = function(weapon)
    if (LoadoutMgr.Weapons.Filter.Primary.Type == LoadoutMgr.FILTER_NONE) then
        return true
    end

    -- Work out whether the weapon is in the filter list
    local isInList = false
    for _, k in pairs(LoadoutMgr.Weapons.Filter.Primary.Table) do
        -- isInList ^= (weapon == k)
        isInList = isInList or (weapon == k)
    end

    return (isInList and LoadoutMgr.Weapons.Filter.Primary.Type == LoadoutMgr.FILTER_WHITELIST)
            or (not isInList and LoadoutMgr.Weapons.Filter.Primary.Type == LoadoutMgr.FILTER_BLACKLIST)
end

--- Checks is a secondary weapon is allowed
--
-- @param weapon String, weapon ID string
-- @return boolean  True if the weapon is allowed, false if it is not
LoadoutMgr.checkSecondaryWeapon = function(weapon)
    return LoadoutMgr.Weapons.Secondary[weapon] ~= nil
end


--- Checks the Secondary weapon if it passes the filter
--
-- @param weapon String, weapon ID string
-- @return boolean  True if the weapon is allowed, false if it is not
LoadoutMgr.checkSecondaryWeaponFilter = function(weapon)
    if (LoadoutMgr.Weapons.Filter.Secondary.Type == LoadoutMgr.FILTER_NONE) then
        return true
    end

    -- Work out whether the weapon is in the filter list
    local isInList = false
    for _, k in pairs(LoadoutMgr.Weapons.Filter.Secondary.Table) do
        -- isInList ^= (weapon == k)
        isInList = isInList or (weapon == k)
    end

    return (isInList and LoadoutMgr.Weapons.Filter.Secondary.Type == LoadoutMgr.FILTER_WHITELIST)
            or (not isInList and LoadoutMgr.Weapons.Filter.Secondary.Type == LoadoutMgr.FILTER_BLACKLIST)
end

--- Checks whether the override param meets the criteria
-- @param state On/off
--
LoadoutMgr.checkOverride = function(state)
    return (state == "on" or state == "off")
end

--- Converts a weapon className to the name string
-- @param weapon Weapon className
-- @return Weapon name, or nil if weapon not found
--
LoadoutMgr.convertWeaponToString = function(weapon)
    local SWEP = weapons.Get(weapon)
    if SWEP == nil then
        return "<None>"
    end
    if not SERVER then
        return SWEP:GetPrintName()
    end
    return LoadoutMgr.Weapons.NameMap[weapon]
end

--- Gets the player's primary weapon
-- @param player Player
--
LoadoutMgr.getWeaponPrimary = function(player)
    local weapon = player:GetPData("loadoutMgr_weapon_primary", nil)
    if (LoadoutMgr.checkPrimaryWeapon(weapon)) then
        return weapon
    else
        return nil
    end
end

--- Sets the player's primary weapon
-- @param player Player
-- @param weapon Weapon ClassName
--
LoadoutMgr.setWeaponPrimary = function(player, weapon)
    player:SetPData("loadoutMgr_weapon_primary", weapon)
end

--- Gets the player's secondary weapon
-- @param player Player
--
LoadoutMgr.getWeaponSecondary = function(player)
    local weapon = player:GetPData("loadoutMgr_weapon_secondary", nil)
    if (LoadoutMgr.checkSecondaryWeapon(weapon)) then
        return weapon
    else
        return nil
    end
end

--- Sets the player's secopndary weapon
-- @param player Player
-- @param weapon Weapon ClassName
--
LoadoutMgr.setWeaponSecondary = function(player, weapon)
    player:SetPData("loadoutMgr_weapon_secondary", weapon)
end

--- Gets whether or not the player's currently equipped weapons will be overriden on loadout loading
-- @param player Player
--
LoadoutMgr.getWeaponOverride = function(player)
    local override = player:GetPData("loadoutMgr_weapon_override", false)
    if (override == "off" or override == nil) then
        return false
    else
        return true
    end
end

--- Gets whether or not the player's currently equipped weapons will be overriden on loadout loading
-- @param player Player
-- @param state true/false
--
LoadoutMgr.setWeaponOverride = function(player, state)
    player:SetPData("loadoutMgr_weapon_override", state)
end

if SERVER then

    --- Manages the equipping of a players loadout
    -- @param player Player
    -- @param type Slot to equip
    -- @param shouldOverride Whether or not the current weapon in slot `type` should be override
    -- @param loadoutWeapon Weapon ClassName to equip
    --
    local function processEquipWeapon(player, type, shouldOverride, loadoutWeapon)
        local shouldEquip = true
        local playerWeapons = player:GetWeapons()

        -- Loop through player's weapons
        local activeSlot = player:GetActiveWeapon().Kind

        for _, weapon in pairs(playerWeapons) do
            -- If the player's weapon is in the slot we are looking at, handle accordingly
            if weapon.Kind == type then
                Msg(weapon.ClassName)
                if shouldOverride then
                    player:StripWeapon(weapon.ClassName)
                else
                    -- We don't want to override the existing weapon
                    shouldEquip = false
                end
            end
        end

        if shouldEquip then
            player:Give(loadoutWeapon)
        end
        if (activeSlot == type) then
            player:SelectWeapon(loadoutWeapon)
        end
    end

    --- Server hook for managing loadouts on round start
    --
    local function onRoundStart()
        for _, player in pairs(player.GetAll()) do
            -- Check if player has access
            if (not player:query("ulx loadout", true)) then
                return
            end
            -- Check if player is in spectate mode
            if (player:GetObserverMode() ~= OBS_MODE_NONE) then
                Msg("[LOADOUT MGR] Ignoring loadout for " .. player:Nick() .. "(" .. player:SteamID() .. ") as they are in spectate mode!\n")
                return
            end
            ULib.tsayColor(player, false, Color(255, 0, 0), "[LOADOUT MGR] Loading your loadout...")
            LoadoutMgr.printLoadout(player)
            Msg("[LOADOUT MGR] Loading loadout for " .. player:Nick() .. "(" .. player:SteamID() .. ")!\n")

            -- Load weapons
            local wep_primary = LoadoutMgr.getWeaponPrimary(player)
            local wep_secondary = LoadoutMgr.getWeaponSecondary(player)
            local shouldOverride = LoadoutMgr.getWeaponOverride(player)

            -- Check primary weapon against filter
            if (wep_primary ~= nil) then
                if LoadoutMgr.checkPrimaryWeapon(wep_primary) then
                    processEquipWeapon(player, LoadoutMgr.WEAPON_PRIMARY, shouldOverride, wep_primary)
                end
            end

            -- Check secondary weapon against filter
            if (wep_secondary ~= nil) then
                if LoadoutMgr.checkSecondaryWeapon(wep_secondary) then
                    processEquipWeapon(player, LoadoutMgr.WEAPON_SECONDARY, shouldOverride, wep_secondary)
                end
            end
        end
    end

    --- Refresh weapon list on preparing
    --
    local function onPreparing()
        LoadoutMgr.getWeaponList()
    end

    --- Let player know they have access to Loadout Manager
    -- @param player Joining player
    --
    local function onPlayerJoin(player)
        -- Check player has access to loadout, if not, return
        if (not player:query("ulx loadout", true)) then
            return
        end
        -- Inform player that they can use loadout
        ULib.tsayColor(player, false, Color(255, 0, 0), "== Loadout Manager ==\nThis server use TTT Loadout Manager. To get started, use !loadout. For help, use !loadout help.")
    end

    hook.Add("TTTBeginRound", "LoadoutMgr_roundStart", onRoundStart)
    hook.Add("TTTPrepareRound", "LoadoutMgr_prepareRound", onPreparing)
    hook.Add("PlayerInitialSpawn", "LoadoutMgr_playerJoin", onPlayerJoin)
end