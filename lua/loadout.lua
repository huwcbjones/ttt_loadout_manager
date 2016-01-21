--
-- Manages Loadouts
--
-- Author: Huw Jones
-- Date:   21/01/2016
--

LoadoutMgr.manager = function(calling_player, arg2, arg3)
    if ((arg2 == nil or arg2 == "") and (arg3 == nil or arg3 == "")) then
        LoadoutMgr.printLoadout(calling_player)
        return
    end

    if (LoadoutMgr.validCommands[arg2] == nil) then
        ULib.tsayError(calling_player, "Use !loadout help for a list of commands")
        return
    end

    if (arg2 == "help") then
        LoadoutMgr.displayHelp(calling_player, arg3)
        return
    end

    if (arg2 == "reset") then
        LoadoutMgr.setWeaponPrimary(player, nil)
        LoadoutMgr.setWeaponSecondary(player, nil)
        LoadoutMgr.setOverride(player, nill)
        ULib.tsayColor(calling_player, false, Color(255, 0, 0), "== Loadout Reset ==")
        return
    end

    if (arg2 == "primary") then
        if (not LoadoutMgr.checkPrimaryWeapon(arg3) or arg3 == "") then
            ULib.tsayError(calling_player, "Invalid primary weapon \"" .. arg3 .. "\"")
            return
        end
        if arg3 == "" then arg3 = nil end
        LoadoutMgr.setWeaponPrimary(calling_player, arg3)
    end

    -- TODO: Fix saving
    -- TODO: Add GUI (later revision)
    if (arg2 == "secondary") then
        if (not LoadoutMgr.checkSecondaryWeapon(arg3) or arg3 == "") then
            ULib.tsayError(calling_player, "Invalid secondary weapon \"" .. arg3 .. "\"")
            return
        end
        if arg3 == "" then arg3 = nil end
        LoadoutMgr.setWeaponSecondary(calling_player, arg3)
    end

    if (arg2 == "override") then
        if (not LoadoutMgr.checkOverride(arg3)) then
            ULib.tsayError(calling_player, "Invalid override weapon \"" .. arg3 .. "\"")
            return
        end
        if arg3 == "" then arg3 = nil end
        LoadoutMgr.setWeaponOverride(calling_player, arg3)
    end
end

LoadoutMgr.displayHelp = function(calling_player, command)
    ULib.tsayColor(calling_player, false, Color(255, 0, 0), "Loadout Manager Help: ", Color(255, 192, 0), command)

    if (command == "primary" or command == "secondary") then
        ULib.tsayColor(calling_player, false, "!loadout [primary/secondary] [weapon]")
        ULib.tsayColor(calling_player, false, "If weapon is blank, your loadout slot for that weapon will be cleared.")
        return
    end

    if (command == "reset") then
        ULib.tsayColor(calling_player, false, "!loadout reset, clears your loadout")
        return
    end

    if (command == "override") then
        ULib.tsayColor(calling_player, false, "!loadout override [true/false], sets whether your current weapons will be replaced when your loadout is equipped")
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
    Msg(table.concat(LoadoutMgr.validCommands, " "))
    ULib.tsayColor(calling_player, false, Color(0, 192, 255), "Available commands: " .. cmds)
end

LoadoutMgr.printLoadout = function(calling_player)
    local primary = LoadoutMgr.getWeaponPrimary(calling_player)
    local secondary = LoadoutMgr.getWeaponSecondary(calling_player)
    local override = LoadoutMgr.getWeaponOverride(calling_player)

    primary = LoadoutMgr.convertWeaponToString(primary)
    secondary = LoadoutMgr.convertWeaponToString(secondary)

    ULib.tsayColor(calling_player, false, Color(255, 0, 0), "== Current Loadout ==")
    ULib.tsayColor(calling_player, false, Color(0, 255, 255), "Primary: " .. primary)
    ULib.tsayColor(calling_player, false, Color(0, 192, 255), "Secondary: " .. secondary)
end

LoadoutMgr.checkPrimaryWeapon = function(weapon)
    --TODO: Add weapon filtering
    return true
end

LoadoutMgr.checkSecondaryWeapon = function(weapon)
    --TODO: Add weapon filtering
    return true
end

LoadoutMgr.checkOverride = function(state)
    return (state ~= "true" or state ~= false or state ~= "")
end

LoadoutMgr.convertWeaponToString = function(weapon)
    local SWEP = weapons.Get(weapon)
    if SWEP == nil then return "<None>" end
    return SWEP:GetPrintName()
end

LoadoutMgr.getWeaponPrimary = function(player)
    return player:GetPData("loadoutMgr_weapon_primary", nil)
end

LoadoutMgr.setWeaponPrimary = function(player, weapon)
    player:SetPData("loadoutMgr_weapon_primary", weapon)
end

LoadoutMgr.getWeaponSecondary = function(player)
    return player:GetPData("loadoutMgr_weapon_primary", nil)
end

LoadoutMgr.setWeaponSecondary = function(player, weapon)
    player:SetPData("loadoutMgr_weapon_secondary", weapon)
end

LoadoutMgr.getWeaponOverride = function(player)
    return player:GetPData("loadoutMgr_weapon_override", false)
end

LoadoutMgr.setWeaponOverride = function(player, state)
    player:SetPData("loadoutMgr_weapon_override", state)
end

local function shouldEquipWeapon(player, type, shouldOverride)
    local hasWeapon = false
    local playerWeapons = player:GetWeapons()

    -- Loop through player's weapons
    for i = 1, #playerWeapons do
        local weapon = playerWeapons[i]

        -- If the player's weapon is in the slot we are looking at, handle accordingly
        if weapon:GetSlot() == type then
            if shouldOverride then

                -- If the player wants their current weapons overrode, then strip the weapon
                player:StripWeapon(weapon)
            else

                -- We don't want to override the existing weapon
                hasWeapon = true
            end
        end
    end

    -- Return not hasWeapon
    return not hasWeapon
end

local function onRoundStart()
    for _, player in pairs(player.GetAll()) do
        Msg("[LOADOUT MGR] Loading loadout for " .. player:Nick() .. "(" .. player:SteamID() .. ")!\n")

        -- Load weapons
        local wep_primary = LoadoutMgr.getWeaponPrimary(player)
        local wep_secondary = LoadoutMgr.getWeaponSecondary(player)
        local shouldOverride = LoadoutMgr.getWeaponOverride(player)

        -- Check primary weapon against filter
        if (wep_primary ~= nil) then
            --TODO: Refactor to equipWeapon that does the checks
            if LoadoutMgr.checkPrimaryWeapon(wep_primary) and shouldEquipWeapon(player, LoadoutMgr.WEAPON_PRIMARY, shouldOverride) then
                player:Give(wep_primary)
            end
        end

        -- Check secondary weapon against filter
        if (wep_secondary ~= nil) then
            if LoadoutMgr.checkSecondaryWeapon(wep_secondary) and shouldEquipWeapon(player, LoadoutMgr.WEAPON_SECONDARY, shouldOverride) then
                player:Give(wep_secondary)
            end
        end
    end
end

hook.Add("TTTBeginRound", "LoadoutMgr_roundStart", onRoundStart)