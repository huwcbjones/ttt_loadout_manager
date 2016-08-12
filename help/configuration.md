# TTT Loadout Manager Help #

The following is a user manual for the TTT Loadout Manager Addon.

## Contents ##
1. [Requirements](index.md#requirements)
2. [Quick Start](index.md#quick-start)
3. [Installation](index.md#installation)
4. [Configuration](configuration.md#configuration)
    1. [Configuration File](configuration.md#configuration-file)
    2. [Access Control (ACL)](configuration.md#access-control-acl)
    3. [Filtering](configuration.md#filtering)
        1. [Whitelist Use Case](configuration.md#whitelist-use-case)
        2. [Blacklist Use Case](configuration.md#blacklist-use-case)
    4. [Weapon Name Map](configuration.md#weapon-name-map)
5. [Usage](usage.md#usage)
    1. [Default Loadout](usage.md#default-loadout)
    2. [Getting Help](usage.md#help)
    3. [Weapons List](usage.md#weapons)
    4. [Setting Weapons](usage.md#setting-weapons)
    5. [WTF is "override"?](usage.md#override)

## Configuration ##
### Configuration File ###
The configuration file is found in `/addons/ttt_loadout_manager/lua/ttt_loadout_manager/config.lua`.
The default provided configuration file is available [here](../lua/ttt_loadout_manager/config.lua).

### Access Control (ACL) ###
Access to the loadout manager is granted through ULib/ulx access controls.
By granting a player/group access to the `ulx loadout` command, this allows them full access to all loadout features.
If you would like to use this addon and have more granular ACL, feel free to [create a new request](/huwcbjones/ttt_loadout_manager/issues/new)!

### Filtering ###
The addon provides granular control over what weapons can be used.
This is provided in the form of filters.
There are separate filters, one for each weapon slot (currently just primary/secondary weapons).
There are three filter modes.

* `FILTER_NONE`: No filter will be applied.
* `FILTER_BLACKLIST`: Weapons specified in the filter will be removed.
* `FILTER_WHITELIST`: Only the weapons specified will be available.

To change the filter mode, open `config.lua`, then find the weapon type you'd like to filter (primary/secondary). 
Then, set the `LoadoutMgr.Weapons.Filter.$weapon_type.Type = LoadoutMgr.$filter_type`, where `$weapon_type` is the weapon type (e.g.: Primary), and `$filter_type` is the filter setting (e.g.: `FILTER_BLACKLIST`).

Once a filter is set, the filter value can then be set.
Obviously, if the filter is disabled, this setting is not required!

The filter `Value` (setting) is a Comma Separated Value string (CSV).
Separate the weapons you'd like the filter to contain with commas (`,`).
For more help, refer to the example use cases below.

#### Whitelist Use Case ####
Server admin would like to only allow 3 primary weapons: Rifle, M16, and MAC10.

First, set the filter to whitelist mode. Then, set the allowed weapons to the Weapon IDs of the Rifle, M16, and MAC10.

```lua
LoadoutMgr.Weapons.Filter.Primary.Type = LoadoutMgr.FILTER_WHITELIST
LoadoutMgr.Weapons.Filter.Primary.Value = "weapon_zm_rifle,weapon_ttt_m16,weapon_zm_mac10"
```

#### Blacklist Use Case ####
Server admin would like to prevent users from equipping the deagle.

First, set the filter to blacklist mode. Then, set the weapon filter to the Weapon ID of the Deagle.

```lua
LoadoutMgr.Weapons.Filter.Primary.Type = LoadoutMgr.FILTER_BLACKLIST
LoadoutMgr.Weapons.Filter.Primary.Value = "weapon_zm_revolver"
```

### Weapon Name Map
The addon requires a `/date/ttt_loadout_manager/weapon_map.txt` file to name the Weapon IDs to the Weapon Name (e.g.: `weapon_zm_revolver => Deagle`).
On first run, the addon creates this file if it is not found, otherwise it is automatically loaded.

If some weapons are not loading their names, run `!loadout weapons`, and cross reference this list with the `weapon_map.txt`.
If there are then blanks, it's up to you (the server admin) to add these entries in.

If (for any reason), there is an error in the `weapon_map.txt`, the addon will log this to the server console on map start, and provide a dump of the `weapon_map.txt` to aid debugging purposes.