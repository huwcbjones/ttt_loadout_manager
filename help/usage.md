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

## Usage ##
The commands are entered in the chat box.

| Command  | Function  |
| -------- | --------- |
| `!loadout` | Displays current loadout. |
| `!loadout help` | Displays the loadout manager help. |
| `!loadout help $cmd` | Displays the help for the `$cmd` command. |
| `!loadout weapons` | Prints a list of available weapons to the console. |
| `!loadout primary $weapon` | Sets your primary weapon to `$weapon`. |
| `!loadout secondary $weapon` | Sets your secondary weapon to `$weapon`. |
| `!loadout override $state` | Sets override to `$state` (see [WTF is "override"?](usage.md#override)). |
| `!loadout reset` | Resets your loadout to default (see [Default Loadout](usage.md#default-loadout)). |

### Default Loadout ###
To see your loadout, type `!loadout` into chat.
By default, it will display the following:
```
== Loadout Manager: Current Loadout ==
Primary: <None>
Secondary: <None>
Override: Disabled
For help, use !loadout help
```

### Help ###
To get more help with using the loadout manager, type `!loadout help` into chat.

As of [v0.4b](https://github.com/huwcbjones/ttt_loadout_manager/releases/v0.4b), you should see the following:
```
== Loadout Manager Help: ==
Available commands: reset, primary, secondary, help, override, weapons
For help with a command, use !loadout help [command].
```

For help with a command (e.g.: override), type `!loadout help override` into chat and you will be given more help with that command.
In our example, you should see the following:
```
== Loadout Manager Help: reset ==
!loadout override [on/off], sets whether your current weapons will be replaced when your loadout is equipped
```

### Weapons ###
Weapons are referenced by their Weapon ID (classname).
For example, the Deagle's Weapon ID is `weapon_zm_revolver`.

To display a list of all available weapons, type `!loadout weapons` into chat, then check console for the table of weapons.
If the server admin has correctly configured the admin, there should be two columns, the weapon name (Deagle) and its ID (`weapon_zm_revolver`).

To limit the type of weapon you are shown, you can specify `primary`, or `secondary` after `weapons` to filter the list to that type of weapon.
To show all secondary weapons, type `!loadout weapons secondary` into chat and check console (for primary weapons, change secondary to primary).

### Setting Weapons ###
Once you have your preferred weapon's ID, you can start to create your loadout.

To set your primary weapon, type `!loadout weapon primary $weapon_id` into chat, where `$weapon_id` is the Weapon's ID (e.g.: `weapon_zm_rifle`).
For secondaries, swap primary for secondary.

#### Examples ####
Rifle as the primary weapon, type `!loadout weapon primary weapon_zm_rifle` into chat.

Deagle as the secondary weapon, type `!loadout weapon primary weapon_zm_revolver` into chat.

### Override ###
Now, you may be asking WTF is the override setting?
It's quite simple, but first a quick explanation.

Your loadout is equipped at the **_start of the round_**.
No, not preparing. The **_start of the round_**.

This means that you could have picked up weapons between spawning (in preparing), and starting the round.

Now, back to override.

If you want the weapons you **picked up** to be **replaced** with the weapons in your loadout, go ahead, enable override.
What you will notice when the round starts is that any primary/secondary weapon you pick up will disappear and your loadout will miraculously appeared.

However, if you **do not** want the weapons you **picked up** to be replaced when the round starts, leave this option off.

To set override on, type `!loadout override on` into chat.
To turn it off, it's simple as typing `!loadout override off` into chat.