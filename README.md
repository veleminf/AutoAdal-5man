# AutoAdal - Automated Buff Helper

**Designed specifically for [TBC5MAN](https://tbc5man.com/) - A Unique WoW TBC Private Server**

AutoAdal is a World of Warcraft addon that automates buff application and quest handling when interacting with specific NPCs like A'dal and buff bots on the TBC5MAN server.

## 🎯 What Does This Addon Do?

### **Automatic Buff Application**
- **Shift + Right-Click** on buff NPCs to automatically get your buffs
- Intelligently checks what buffs you need and applies them in the right order
- Monitors buff duration and reapplies when they're about to expire

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

## 🏛️ Compatible NPCs

The addon works with these NPCs:
- **A'dal** (Shattrath City)
- **Minutulus Naaru Guardian** (Summoned buff bot)
- **Naaru Guardian** (Located at dungeon/raid entrances)
- **Alera** (Shattrath City - quest buffs only)

## 🔧 Installation

1. [Download](https://github.com/veleminf/AutoAdal-5man/releases) the addon files
2. Place the `AutoAdal` folder in your `Interface/AddOns/` folder
3. Configure with `/aa config`

## ⚡ How to Use

### **Getting Buffs**
1. **Hold Shift + Right-Click** on any compatible buff NPC
2. The addon will automatically:
   - Apply missing class buffs (Prayer of Fortitude, Greater Blessing of Kings, Gift of the Wild, and more...)
   - Apply your configured shout buff (Battle Shout or Commanding Shout)
   - Apply Blood Pact
   - Reset Bloodlust/Heroism cooldown if it's on cooldown

### **Quest Automation**
When you Shift + Right-Click on buff NPCs, the addon can also automatically handle these quests:
- **World Buff Blessing** - Grants Songflower Serenade buff (requires Token of Achievement)
- **Slip'kik's Savvy** - DM tribute buff (requires Badge of Justice)
- **Fengus' Ferocity** - DM tribute buff (requires Badge of Justice)  
- **Mol'dar's Moxie** - DM tribute buff (requires Badge of Justice)

> **Note:** Quest automation is disabled by default. Enable specific quests with `/aa quest` commands or through the configuration interface.


## 🖥️ Configuration Options

AutoAdal provides multiple ways to configure your settings:

### **Graphical Configuration Interface**

Access the standalone configuration window with:
```
/aa config
```

Or find AutoAdal in your Interface Options menu:
```
Escape → Interface → AddOns → AutoAdal
```

![AutoAdal Configuration Interface](https://github.com/user-attachments/assets/cfc3865a-40d7-4587-bb39-2a72b67c6178)

The configuration interface allows you to:
- **Enable/Disable** the addon with a simple checkbox
- **Select Shout Type** from a dropdown menu (Commanding or Battle)
- **Toggle Quest Buffs** individually with checkboxes
- All changes take effect immediately

This provides a more intuitive way to configure the addon compared to using slash commands.

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

## 📋 Buff Priority System

When you Shift + Right-Click, buffs are applied in this order:

1. **Class Buffs First** - If you're missing any class buff (Prayer of Fortitude, Greater Blessing of Kings, Gift of the Wild, and more...)
2. **Shout Buffs Second** - If you're missing your configured shout buff
3. **Blood Pact Third** - If you're missing Blood Pact
4. **Quest Handling Last** - Processes any enabled quest buffs

## 💬 Smart Tooltips

When you hover over buff NPCs, AutoAdal displays intelligent tooltips that show:
- **Exact buff count** - See how many buffs that specific NPC can apply (e.g., "3 remaining")
- **NPC-specific counts** - Each NPC shows only the buffs it can provide
- **Real-time updates** - Tooltip refreshes automatically after each Shift + Right-Click
- **Completion status** - Shows "All buffs already applied" when fully buffed

![AutoAdal Tooltip](https://github.com/user-attachments/assets/d1574923-a06c-4930-bec7-49dfd3e121f5)

## 💡 Example Usage

**Basic Setup:**
```
/aa shout commanding
/aa quest wb savvy
```

**Full Buff Session:**
1. Target Minutulus Naaru Guardian
2. Shift + Right-Click repeatedly until the addon says "AutoAdal: All buffs already present."
3. Each Shift + Right-Click applies one buff or quest at a time

**Check Your Settings:**
```
/aa
```
Shows something like:
```
AutoAdal Current Settings:
  Addon: ENABLED
  Shout Type: commanding
  Auto Quest buffs: World Buff, Slip'kik's Savvy (2 enabled)
```

## ❓ Troubleshooting

**Addon not working?**
- Make sure it's enabled: `/aa enable`
- Check if you're targeting a compatible NPC
- Remember to hold Shift while right-clicking

**Buffs not applying?**
- Ensure you have the required currencies (Badge of Justice or Token of Achievement) for quests
- Check that the NPC has the buffs you're trying to get
- Verify your quest settings: `/aa quest`

**Quest automation not working?**
- Enable the quests you want: `/aa quest wb savvy ferocity moxie`
- Make sure you don't already have the corresponding buffs
- Verify you have the required currencies (Badge of Justice or Token of Achievement)

---

*AutoAdal makes buff management effortless - just Shift + Right-Click and let the addon handle the rest!*

**Made for the [TBC5MAN](https://tbc5man.com/) community** 🏛️
