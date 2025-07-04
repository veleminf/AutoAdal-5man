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
![doubleclick](https://github.com/user-attachments/assets/258807d7-11db-45c2-9efc-9362642537ce)
![resetcd](https://github.com/user-attachments/assets/776a92b7-7cac-42aa-b224-114f44012c95)


## How Double Click Works
The double-click functionality is implemented by tracking the last two mouseover events on the NPC. Clicking on NPC fires the UPDATE_MOUSEOVER_UNIT event, which is used to track the last two mouseover events. If the last two mouseover events are the same NPC and withing configured distance, it counts as a double-click.
