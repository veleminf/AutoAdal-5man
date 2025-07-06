# AutoAdal - Automated Buff Helper

**Designed specifically for [TBC5MAN](https://tbc5man.com/) - A Unique WoW TBC Private Server**

AutoAdal is a World of Warcraft addon that automates buff application and quest handling when interacting with specific NPCs like A'dal and buff bots on the TBC5MAN server.

## 🎯 What Does This Addon Do?

### **Automatic Buff Application**
- **Shift + Right-Click** on buff NPCs to automatically get your buffs
- Intelligently checks what buffs you need and applies them in the right order
- Intelligently reapplies buffs only if they are close to expiring, saving you time.

### **Smart Quest Automation**
- Automatically accepts and completes specific buff-related quests (requires Badge of Justice or Token of Achievement)
- Only processes quests you've enabled in the configuration
- Skips quests if you already have the corresponding buff

### **Bloodlust/Heroism Reset**
- Automatically resets your Bloodlust or Heroism cooldown when available

## ⚡ Why Use AutoAdal?

- **Reduces 12+ manual clicks to get you fully buffed**
- **Perfect for combat situations** - essential when you die and get revived during a fight
- **Combat-ready buffing** - get fully buffed quickly during active combat or between pulls
- **Never miss a buff** - ensures you get all available buffs, preventing manual oversight

## 🔧 Quick Start

1. [Download](https://github.com/veleminf/AutoAdal-5man/releases) the addon files.
2. Place the `AutoAdal` folder into your `Interface/AddOns/` folder.
3. Log in and configure your preferences with `/aa config`.
4. Target a compatible buff NPC (like A'dal) and **hold Shift while repeatedly Right-Clicking** until the addon tells you all buffs are applied.

## ⚡ How to Use
The core of this addon is simple: **Hold Shift and Right-Click** on a buff NPC.

Each time you do this, the addon performs one action in a specific order. You may need to click several times to get all your buffs. The addon will tell you when you have everything.

**What happens when you Shift + Right-Click?**

The addon checks for and applies missing buffs in this priority:
1.  **Class Buffs First**: Applies buffs like Prayer of Fortitude, Gift of the Wild, etc.
2.  **Shout Buffs Second**: Applies your configured shout (Battle or Commanding).
3.  **Blood Pact Third**: Applies the Blood Pact buff.
4.  **Bloodlust/Heroism Reset**: Resets your cooldown if available.
5.  **Quest Buffs (Optional)**: If you've enabled them, it will automatically accept and complete quests for powerful buffs like Songflower Serenade and Dire Maul tributes. (See configuration below).


### **Quest Buffs Automation (Optional)**
When you Shift + Right-Click on buff NPCs, the addon can also automatically handle these quests:
- **World Buff Blessing** - Grants Songflower Serenade buff (requires `Token of Achievement`)
- **Slip'kik's Savvy** - DM tribute buff (requires `Badge of Justice`)
- **Fengus' Ferocity** - DM tribute buff (requires `Badge of Justice`)  
- **Mol'dar's Moxie** - DM tribute buff (requires `Badge of Justice`)

> **Note:** Quest automation is disabled by default. Enable specific quests with `/aa quest` commands or through the configuration interface.


## 🖥️ Configuration

AutoAdal provides multiple ways to configure your settings:

### **Graphical Interface**

```
/aa config
```

Or find AutoAdal in your Interface Options menu:
```
Escape → Interface → AddOns → AutoAdal
```

![AutoAdal Configuration Interface](https://github.com/user-attachments/assets/cfc3865a-40d7-4587-bb39-2a72b67c6178)

### **Configuration Commands**

Alternatively, use `/aa` followed by these commands:

**View Settings**
```
/aa                     - Show all current settings
/aa help                - Show help menu
```

**Basic Controls**
```
/aa enable              - Enable the addon
/aa disable             - Disable the addon
```

**Shout Configuration**
```
/aa shout commanding    - Use Commanding Shout (default)
/aa shout battle        - Use Battle Shout
/aa shout               - Show current shout setting
```

**Quest Configuration**
```
/aa quest               - Show enabled quest buffs
/aa quest wb savvy      - Enable World Buff and Slip'kik's Savvy
/aa quest moxie         - Enable only Mol'dar's Moxie
/aa quest none          - Disable all quest buffs
/aa quest help          - Show available quest names
```

**Available Quest Names:**
- `wb` - World Buff Blessing (Songflower Serenade)
- `savvy` - Slip'kik's Savvy
- `ferocity` - Fengus' Ferocity
- `moxie` - Mol'dar's Moxie

## 🕒 Smart Duration Checking

The addon monitors your buff durations and will reapply buffs when they're about to expire:

- **Class Buffs**: Reapplied when less than 50 minutes remaining
- **Shout Buffs**: Reapplied when less than 9 minutes remaining
- **Quest Buffs**: Reapplied when less than 15 minutes remaining

## 💬 Smart Tooltips

When you hover over buff NPCs, AutoAdal displays intelligent tooltips that show:
- **Exact buff count** - See how many buffs that specific NPC can apply (e.g., "3 remaining")
- **NPC-specific counts** - Each NPC shows only the buffs it can provide
- **Completion status** - Shows "All buffs already applied" when fully buffed

![AutoAdal Tooltip](https://github.com/user-attachments/assets/d1574923-a06c-4930-bec7-49dfd3e121f5)

## 🏛️ Compatible NPCs

The addon works with these NPCs:
- **A'dal** (Shattrath City)
- **Minutulus Naaru Guardian** (Summoned buff bot)
- **Naaru Guardian** (Located at dungeon/raid entrances)
- **Alera** (Shattrath City - quest buffs only)

## 💡 Example: Getting All Buffs

1.  **First, set your preferences:**
    ```
    /aa shout commanding
    /aa quest wb savvy ferocity moxie
    ```
2.  **Next, get your buffs:**
    - Target a buff NPC (e.g., Minutulus Naaru Guardian).
    - Hold **Shift** and **Right-Click** repeatedly. Each click will apply one buff or complete one quest.
    - Continue clicking until the addon message says: "AutoAdal: All buffs already present".

## ❓ Troubleshooting

**Addon not working?**
- Make sure it's enabled: `/aa enable`
- Check if you're targeting a compatible NPC
- Remember to hold Shift while right-clicking

**Buffs not applying?**
- Ensure you have the required currencies (Badge of Justice or Token of Achievement) for quests
- Check that the NPC has the buffs you're trying to get
- Make sure you don't already have the corresponding buffs
- Verify your quest settings: `/aa quest`

---

*AutoAdal makes buff management effortless - just Shift + Right-Click and let the addon handle the rest!*

**Made for the [TBC5MAN](https://tbc5man.com/) community** 🏛️
