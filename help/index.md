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

## Requirements ##
* ULib (available from [TeamUlysses/ulib](/TeamUlysses/ulib).
* ulx (available from [TeamUlysses/ulx](/TeamUlysses/ulx).

## Quick Start ##

1. Install the addon in the `/addons` directory.
2. Configure the addon (`config.lua`). 
3. Restart the server (required to reload addons)
4. Join the server and grant users access to the `ulx loadout` command.
5. `!loadout help` in chat, or `ulx loadout help` in console.

## Installation ##

1. Download the [latest release](/releases/latest).
2. Upload/Unzip addon.
    * If your server supports unzipping:
        1. Upload the zip to `/addons`.
        2. Extract the zip.
    * Otherwise:
        1. Extract the zip.
        2. Upload the zip contents to `/addons/ttt_loadout_mananger` (you might have to create this directory).
3. Configure the addon (see [Configuration](configuration.md#configuration)).
4. Restart the server
5. Configure the weapon name map (see [Configuration -> Weapon Name Map](configuration.md#weapon-name-map)).
6. Learn how to use the addon (see [Usage](usage.md#useage)).