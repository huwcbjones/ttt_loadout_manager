--
-- Adds ULX Command integration to Loadout Manager
--
-- Author: Huw Jones
-- Date:   21/01/2016
--

local CATAGORY_NAME = "Loadout"

local loadout = ulx.command(CATAGORY_NAME, "ulx loadout", LoadoutMgr.manager, "!loadout", true)
loadout:defaultAccess(ULib.ACCESS_ADMIN)
loadout:addParam { type = ULib.cmds.StringArg, hint = "Command", ULib.cmds.optional }
loadout:addParam { type = ULib.cmds.StringArg, hint = "Argument", ULib.cmds.optional }
loadout:help("Manages the player's loadout.")

function ulx.loadouthelp(calling_ply)
    calling_ply:SendLua('gui.OpenURL("https://github.com/huwcbjones/ttt_loadout_manager/blob/master/help/index.md")')
end

local loadouthelp = ulx.command(CATAGORY_NAME, "ulx loadouthelp", ulx.loadouthelp, "!loadouthelp", true)
loadouthelp:defaultAccess(ULib.ACCESS_ADMIN)
loadouthelp:help("Provides help to the Loadout Manager.")