# AutoAdal
## Description
Addon that automates interactions with buff NPCs. Provides the following functionalities:
- Double-clicking buff NPCs to receive buffs.
- Automatically selecting the option to reset Heroism/Bloodlust cooldown if it's on cooldown.
- Marking the buffbot on mouseover.

## Installation Instructions
1. Download the addon as a zip file.
2. Unzip the file.
3. Rename the folder to "AutoAdal" (the same name as the .toc file).
4. Move the folder to the `/Interface/AddOns` directory.

## Images
![Double-click to buff](images/double_click_to_buff.png)
![Click to reset hero CD](images/click_to_reset_hero_cd.png)

## How Double Click Works
The double-click functionality is implemented by tracking the last two mouseover events on the NPC. Clicking on NPC fires the UPDATE_MOUSEOVER_UNIT event, which is used to track the last two mouseover events. If the last two mouseover events are the same NPC and withing configured distance, it counts as a double-click.
