AA_CONFIG = {
  enabled = true,
  shoutType = "commanding",
  autoQuests = {
    ["World Buff Blessing - 10 Token of Achievement Donation"] = false,
    ["Slip'kik's Savvy"] = false,
    ["Fengus' Ferocity"] = false,
    ["Mol'dar's Moxie"] = false
  }
}

local AA_DefaultConfig = {
  enabled = true,
  shoutType = "commanding",
  autoQuests = {
    ["World Buff Blessing - 10 Token of Achievement Donation"] = false,
    ["Slip'kik's Savvy"] = false,
    ["Fengus' Ferocity"] = false,
    ["Mol'dar's Moxie"] = false
  }
}

-- Quest name abbreviations mapping
local questAbbreviations = {
  ["wb"] = "World Buff Blessing - 10 Token of Achievement Donation",
  ["worldbuff"] = "World Buff Blessing - 10 Token of Achievement Donation",
  ["savvy"] = "Slip'kik's Savvy",
  ["ferocity"] = "Fengus' Ferocity",
  ["moxie"] = "Mol'dar's Moxie"
}

-- For display purposes, map full names back to short names
local questDisplayNames = {
  ["World Buff Blessing - 10 Token of Achievement Donation"] = "World Buff Blessing (Songflower Serenade)",
  ["Slip'kik's Savvy"] = "Slip'kik's Savvy",
  ["Fengus' Ferocity"] = "Fengus' Ferocity",
  ["Mol'dar's Moxie"] = "Mol'dar's Moxie"
}

local function InitConfig()
  for key, value in pairs (AA_DefaultConfig) do
    if (AA_CONFIG[key] == nil) then
      AA_CONFIG[key] = value
    elseif (key == "autoQuests" and type(value) == "table") then
      -- Ensure all quest settings exist
      for questName, questDefault in pairs(value) do
        if (AA_CONFIG[key][questName] == nil) then
          AA_CONFIG[key][questName] = questDefault
        end
      end
    end
  end
end

-- Print args with color
local function print(...)
  local args = { ... }
  local message = ""
  for i, v in ipairs(args) do
    message = message .. tostring(v)
    if i < #args then
      message = message .. ", "
    end
  end
  local r = 142;
  local g = 211;
  local b = 196;
  local color = string.format("|cff%02x%02x%02x", r, g, b);
  
  DEFAULT_CHAT_FRAME:AddMessage(color .. message);
end

local function tokenize(str)
  local tokens = {}
  for token in string.gmatch(str, '%S+') do tinsert(tokens, token) end
  return tokens
end

-- Create a frame to register and handle events
local aaframe = CreateFrame("Frame", "AAEventFrame", UIParent);

-- Create a slash command handler function
local function SlashCmdHandler(msg)
  -- Convert the message to lowercase
  msg = msg:lower();
  local arguments = tokenize(msg);
  
  -- Show all current settings if no arguments
  if (#arguments == 0) then
    print("AutoAdal Current Settings:")
    local addonStatus = AA_CONFIG["enabled"] and "ENABLED" or "DISABLED"
    print("  Addon: " .. addonStatus)
    print("  Shout Type: " .. AA_CONFIG["shoutType"])
    
    local enabledQuests = {}
    for questName, enabled in pairs(AA_CONFIG["autoQuests"]) do
      if enabled then
        local displayName = questDisplayNames[questName] or questName
        tinsert(enabledQuests, displayName)
      end
    end
    if #enabledQuests > 0 then
      print("  Auto Quest buffs: " .. table.concat(enabledQuests, ", ") .. " (" .. #enabledQuests .. " enabled)")
    else
      print("  Auto Quest buffs: disabled")
    end
    return
  end
  
  -- Check the message content
  if (arguments[1] == "help") then
    print("AutoAdal Commands:")
    print("  /aa                     - Show all current settings")
    print("  /aa help                - Show this help")
    print("")
    print("Control:")
    print("  /aa enable              - Enable addon")
    print("  /aa disable             - Disable addon")
    print("")
    print("Configuration:")
    print("  /aa shout <type>        - Set shout type (commanding, battle)")
    print("  /aa shout               - Show current shout type")
    print("  /aa quest <names>       - Enable quest buffs (wb, savvy, moxie, ferocity)")
    print("  /aa quest               - Show enabled quest buffs")
    print("  /aa quest none          - Disable all quest buffs")
    print("  /aa quest help          - Show quest buffs options")
  elseif (arguments[1] == "enable") then
    AA_CONFIG["enabled"] = true;
    print("AutoAdal: Addon ENABLED");
  elseif (arguments[1] == "disable") then
    AA_CONFIG["enabled"] = false;
    print("AutoAdal: Addon DISABLED");
  elseif (arguments[1] == "shout") then
    if (arguments[2] == nil) then
      print("AutoAdal: Shout Type = " .. AA_CONFIG["shoutType"]);
    else
      local shoutType = arguments[2]:lower();
      if (shoutType == "commanding" or shoutType == "battle") then
        AA_CONFIG["shoutType"] = shoutType;
        print("AutoAdal: Shout Type = " .. AA_CONFIG["shoutType"]);
      else
        print("AutoAdal: Invalid shout type. Available: commanding, battle");
      end
    end
  elseif (arguments[1] == "quest") then
    if (arguments[2] == nil) then
      -- Show current quest settings
      local enabledQuests = {}
      for questName, enabled in pairs(AA_CONFIG["autoQuests"]) do
        if enabled then
          local displayName = questDisplayNames[questName] or questName
          tinsert(enabledQuests, displayName)
        end
      end
      if #enabledQuests > 0 then
        print("AutoAdal: Enabled quest buffs: " .. table.concat(enabledQuests, ", "))
      else
        print("AutoAdal: No quest buffs enabled")
      end
    elseif (arguments[2]:lower() == "help") then
      -- Show help
      print("AutoAdal Quest Commands:")
      print("  /aa quest               - Show enabled quests")
      print("  /aa quest none          - Disable all quests")
      print("  /aa quest <names>       - Enable specific quests")
      print("Available quest names: wb (worldbuff), savvy, ferocity, moxie")
    elseif (arguments[2]:lower() == "none") then
      -- Disable all quests
      for questName, _ in pairs(AA_CONFIG["autoQuests"]) do
        AA_CONFIG["autoQuests"][questName] = false
      end
      print("AutoAdal: All quest buffs disabled")
    else
      -- Handle quest list (enable specific quests)
      -- First validate ALL quest names before making any changes
      local validQuests = {}
      local hasInvalidQuest = false
      
      for i = 2, #arguments do
        local questArg = arguments[i]:lower()
        local questName = questAbbreviations[questArg]
        if questName and AA_CONFIG["autoQuests"][questName] ~= nil then
          tinsert(validQuests, questName)
        else
          print("AutoAdal: Unknown quest buff'" .. questArg .. "'. Use /aa quest help for available names.")
          hasInvalidQuest = true
        end
      end
      
      -- Only proceed if ALL quest names are valid
      if not hasInvalidQuest then
        -- Disable all quests first
        for questName, _ in pairs(AA_CONFIG["autoQuests"]) do
          AA_CONFIG["autoQuests"][questName] = false
        end
        
        -- Then enable the valid ones
        local enabledQuests = {}
        for _, questName in ipairs(validQuests) do
          AA_CONFIG["autoQuests"][questName] = true
          local displayName = questDisplayNames[questName] or questName
          tinsert(enabledQuests, displayName)
        end
        
        if #enabledQuests > 0 then
          print("AutoAdal: Enabled quest buffs: " .. table.concat(enabledQuests, ", "))
        else
          print("AutoAdal: No valid quest buffs specified")
        end
      else
        print("AutoAdal: No changes made due to invalid quest buff names.")
      end
    end
  else
    print("AutoAdal: Unknown command. Use /aa help for available commands.")
  end
end

-- Register the slash command and set the handler function
SLASH_AUTOADAL1 = "/aa";
SlashCmdList["AUTOADAL"] = SlashCmdHandler;

local function ArrIncludes(array, find)
  for _, value in ipairs(array) do
    if value == find then
      return true
    end
  end
  return false
end

aaframe:RegisterEvent("GOSSIP_SHOW")
aaframe:RegisterEvent("ADDON_LOADED")
aaframe:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
aaframe:RegisterEvent("GOSSIP_CLOSED")
aaframe:RegisterEvent("QUEST_DETAIL")
aaframe:RegisterEvent("QUEST_COMPLETE")
aaframe:RegisterEvent("QUEST_PROGRESS")

local buffNPCs = { "A'dal", "Minutulus Naaru Guardian", "Naaru Guardian", "Alera" }

-- Auto-quest specific quest names (full names as they appear in game)
local autoQuestNames = {
  "World Buff Blessing - 10 Token of Achievement Donation",
  "Slip'kik's Savvy", 
  "Fengus' Ferocity",
  "Mol'dar's Moxie"
}

-- for shift+right-click activation
local autoAcceptingBuffs = false

-- Checks if the Heroism or Bloodlust spell is on cooldown.
-- @return boolean - Returns true if either spell is on cooldown, false otherwise.
local function IsHeroCD()
  local _, heroismCD = GetSpellCooldown("Heroism")
  local _, bloodlustCD = GetSpellCooldown("Bloodlust")

  -- TODO: change to account for GCD > 2s for example
  if ((heroismCD and heroismCD > 0) or (bloodlustCD and bloodlustCD > 0)) then
    return true
  end
  return false
end

-- Quest helper functions needed for buff counting
local function stripQuestText(text)
  if not text then return end
  text = text:gsub('|c%x%x%x%x%x%x%x%x(.-)|r','%1')
  text = text:gsub('%[.*%]%s*','')
  text = text:gsub('(.+) %(.+%)', '%1')
  if text.trim then
    text = text:trim()
  end
  return text
end

-- Get the buff name corresponding to a quest
local function getBuffNameForQuest(questName)
  if not questName then return nil end
  local cleanName = stripQuestText(questName)
  
  -- Handle both the full quest name and the shortened one
  if cleanName == "World Buff Blessing" or cleanName == "World Buff Blessing - 10 Token of Achievement Donation" then
    return "Songflower Serenade"
  else
    -- For other quests, the buff name is the same as quest name
    return cleanName
  end
end

-- Check if player has the buff corresponding to a quest with sufficient duration
local function hasQuestBuff(questName)
  local buffName = getBuffNameForQuest(questName)
  if not buffName then return false end
  local i = 1
  while UnitBuff("player", i) do
    local playerBuffName, _, _, _, _, expirationTime = UnitBuff("player", i)
    if playerBuffName == buffName then
      -- Quest buffs: reapply if less than 15 minutes (900 seconds) remaining
      if expirationTime == nil or expirationTime > 900 then
        return true
      end
    end
    i = i + 1
  end
  return false
end

-- Check if player has all class buffs with sufficient duration
local function hasClassBuffs()
  local hasPrayerOfFortitude = false
  local hasGreaterBlessingOfKings = false
  local hasGiftOfTheWild = false
  
  local i = 1
  while UnitBuff("player", i) do
    local buffName, _, _, _, _, expirationTime = UnitBuff("player", i)
    if buffName == "Prayer of Fortitude" then
      if expirationTime == nil or expirationTime > 3000 then
        hasPrayerOfFortitude = true
      end
    elseif buffName == "Greater Blessing of Kings" then
      if expirationTime == nil or expirationTime > 3000 then
        hasGreaterBlessingOfKings = true
      end
    elseif buffName == "Gift of the Wild" then
      if expirationTime == nil or expirationTime > 3000 then
        hasGiftOfTheWild = true
      end
    end
    i = i + 1
  end
  
  return hasPrayerOfFortitude and hasGreaterBlessingOfKings and hasGiftOfTheWild
end

-- Check if player has the configured shout buff with sufficient duration
local function hasShoutBuff()
  local shoutBuffName = ""
  if (AA_CONFIG["shoutType"] == "battle") then
    shoutBuffName = "Battle Shout"
  else
    shoutBuffName = "Commanding Shout"
  end
  
  local i = 1
  while UnitBuff("player", i) do
    local buffName, _, _, _, _, expirationTime = UnitBuff("player", i)
    if buffName == shoutBuffName then
      -- Shout buff: valid if more than 9 minutes remaining
      if expirationTime == nil or expirationTime > 540 then
        return true
      end
    end
    i = i + 1
  end
  return false
end

-- Check if player has Blood Pact
local function hasBloodPactBuff()
  local i = 1
  while UnitBuff("player", i) do
    local buffName, _, _, _, _, expirationTime = UnitBuff("player", i)
    if buffName == "Blood Pact" then
      return true
    end
    i = i + 1
  end
  return false
end

-- Count remaining buffs that need to be applied based on specific NPC capabilities
local function countRemainingBuffs(npcName)
  local buffCount = 0
  
  -- All NPCs except Alera provide class buffs
  if npcName ~= "Alera" then
    if not hasClassBuffs() then
      buffCount = buffCount + 1 -- Class buffs count as one action
    end
  end
  
  -- Alera and Minutulus Naaru Guardian provide quest buffs
  if npcName == "Alera" or npcName == "Minutulus Naaru Guardian" then
    for questName, enabled in pairs(AA_CONFIG["autoQuests"]) do
      if enabled and not hasQuestBuff(questName) then
        buffCount = buffCount + 1
      end
    end
  end
  
  -- Only Minutulus Naaru Guardian provides shout and blood pact buffs
  if npcName == "Minutulus Naaru Guardian" then
    if not hasShoutBuff() then
      buffCount = buffCount + 1
    end
    
    if not hasBloodPactBuff() then
      buffCount = buffCount + 1
    end
  end
  
  return buffCount
end



-- Refresh tooltip if it's showing for a buff NPC
local function refreshTooltip()
  if GameTooltip:IsVisible() then
    local npcName = UnitName("mouseover")
    if npcName and ArrIncludes(buffNPCs, npcName) then
      local remainingBuffs = countRemainingBuffs(npcName)
      local heroResetNeeded = ((npcName == "Naaru Guardian" or npcName == "A'dal") and IsHeroCD())
      
      if heroResetNeeded then
        remainingBuffs = remainingBuffs + 1
      end
      
      -- Clear existing tooltip lines and add the updated one
      GameTooltip:ClearLines()
      GameTooltip:SetUnit("mouseover")
      
      if remainingBuffs > 0 then
        GameTooltip:AddLine("AutoAdal: Shift+Right-Click to automatically get buffs (" .. remainingBuffs .. " remaining)")
      else
        GameTooltip:AddLine("AutoAdal: All buffs already applied")
      end
      GameTooltip:Show()
    end
  end
end

local function OnMouseOver(self, event, ...)
  if (not AA_CONFIG["enabled"]) then
    return
  end

  local npcName = UnitName("mouseover")
  if (npcName == nil) then return end

  if (ArrIncludes(buffNPCs, npcName)) then
    local remainingBuffs = countRemainingBuffs(npcName)
    local heroResetNeeded = ((npcName == "Naaru Guardian" or npcName == "A'dal") and IsHeroCD())
    
    if heroResetNeeded then
      remainingBuffs = remainingBuffs + 1
    end
    
    if remainingBuffs > 0 then
      GameTooltip:AddLine("AutoAdal: Shift+Right-Click to automatically get buffs (" .. remainingBuffs .. " remaining)")
    else
      GameTooltip:AddLine("AutoAdal: All buffs already applied")
    end
    GameTooltip:Show()
  end
end

-- Returns:
--   - pairedGossipOptions (table): A table of gossip options with the text and index.
--   - Example: { { text = "Option 1", index = 1 }, { text = "Option 2", index = 2 } }
local function GetPairedGossipOptions()
  local t_gossipOptions = { GetGossipOptions() }
  local pairedGossipOptions = {}
  for i = 1, #t_gossipOptions, 2 do -- Structure the gossip options so the indices match to avoid mistakes
    tinsert(pairedGossipOptions, { text = t_gossipOptions[i], index = (i+1)/2 })
  end
  return pairedGossipOptions
end

-- Returns:
--   - success (boolean): True if the gossip option was found and selected, false otherwise.
local function FindAndSelectGossipOption(optionStr)
  pairedGossipOptions = GetPairedGossipOptions()
  for _, gossipOption in ipairs(pairedGossipOptions) do
    if (gossipOption.text == optionStr) then
      SelectGossipOption(gossipOption.index)
      return true
    end
  end
  return false
end

local nextBuffTime = 0
-- Handle buffs and return true if buffs were applied, false otherwise
local function handleBuffs(self, event, ...)
  if (not AA_CONFIG["enabled"]) then
    return false
  end

  local npcName = UnitName("target")

  -- Check if shift is held down when gossip opens for buff NPCs
  if (IsShiftKeyDown() and ArrIncludes(buffNPCs, npcName)) then
    autoAcceptingBuffs = true
    -- print("AutoAdal: Shift+Right-Click detected on " .. npcName .. ". Getting buffs...")
  end

  -- Always reset Bloodlust/Heroism CD
  if ((npcName == "Naaru Guardian" or npcName == "A'dal") and IsHeroCD()) then
    -- Click "I wish to reset Bloodlust or Heroism" if its on CD
    if (FindAndSelectGossipOption("I wish to reset Bloodlust or Heroism")) then
      print("AutoAdal: Bloodlust/Heroism CD reset.")
      return true -- Buff action was taken
    end
  end

  if (ArrIncludes(buffNPCs, npcName)) then
    if (autoAcceptingBuffs) then
      -- Determine shout configuration for messages
      local shoutGossipOption = ""
      local shoutDisplayName = ""
      
      if (AA_CONFIG["shoutType"] == "battle") then
        shoutGossipOption = "Empower my group with Battle Shout"
        shoutDisplayName = "Battle Shout"
      else
        shoutGossipOption = "Empower my group with Commanding Shout"
        shoutDisplayName = "Commanding Shout"
      end
      
      -- Select option based on missing buffs (priority order)
      if not hasClassBuffs() then
        if (FindAndSelectGossipOption("Empower my group with all the class buffs")) then
          print("AutoAdal: Applied class buffs to group.")
          autoAcceptingBuffs = false
          return true -- Buff was applied
        end
      elseif not hasShoutBuff() then
        if (FindAndSelectGossipOption(shoutGossipOption)) then
          print("AutoAdal: Applied " .. shoutDisplayName .. " to group.")
          autoAcceptingBuffs = false
          return true -- Buff was applied
        end
      elseif not hasBloodPactBuff() then
        if (FindAndSelectGossipOption("Empower me with Blood Pact")) then
          print("AutoAdal: Applied Blood Pact.")
          autoAcceptingBuffs = false
          return true -- Buff was applied
        end
      end
      autoAcceptingBuffs = false
    end
  end
  
  return false -- No buffs were applied
end

-- Quest handling functions (adapted from other addon)
local function canAutoQuest(questName)
  -- Only auto-quest if addon is enabled and specific quest is enabled
  if not AA_CONFIG["enabled"] then
    return false
  end
  
  if questName then
    -- Check if this specific quest is enabled
    local cleanName = stripQuestText(questName)
    return AA_CONFIG["autoQuests"][cleanName] == true
  else
    -- Check if any quest is enabled (for general checks)
    for _, enabled in pairs(AA_CONFIG["autoQuests"]) do
      if enabled then
        return true
      end
    end
    return false
  end
end

local function isAutoQuest(questName)
  if not questName then return false end
  local cleanName = stripQuestText(questName)
  return ArrIncludes(autoQuestNames, cleanName)
end



-- Handle quests and return true if any quest action was taken, false otherwise
local function handleQuests(self, event, ...)
  if (not AA_CONFIG["enabled"] or not canAutoQuest()) then
    return false
  end
  
  local button
  local text
  
  for i = 1, 32 do
    button = _G['GossipTitleButton' .. i]
    if button and button:IsVisible() then
      text = stripQuestText(button:GetText())
      if button.type == 'Active' and IsShiftKeyDown() and isAutoQuest(text) and canAutoQuest(text) and not hasQuestBuff(text) then
        button:Click()
        print("AutoAdal: Auto-selecting active quest from gossip: " .. text)
        return true -- Quest action was taken
      end
    end
  end
  
  return false -- No quest action was taken
end

local function OnQuestDetail(self, event, ...)
  if (not AA_CONFIG["enabled"]) then
    return
  end
  
  local npcName = UnitName("target")
  if (not ArrIncludes(buffNPCs, npcName)) then
    return
  end
  
  local questTitle = GetTitleText()
  if (isAutoQuest(questTitle) and canAutoQuest(questTitle)) then
    -- Only auto-accept if player doesn't already have the buff
    if not hasQuestBuff(questTitle) then
      AcceptQuest()
      print("AutoAdal: Auto-accepted quest: " .. questTitle)
    else
      print("AutoAdal: Skipping quest " .. questTitle .. " - already have buff")
    end
  end
end

local function OnQuestComplete(self, event, ...)
  if (not AA_CONFIG["enabled"]) then
    return
  end
  
  local npcName = UnitName("target")
  if (not ArrIncludes(buffNPCs, npcName)) then
    return
  end
  
  local questTitle = GetTitleText()
  if (isAutoQuest(questTitle) and canAutoQuest(questTitle)) then
    if GetNumQuestChoices() <= 1 then
      QuestFrameCompleteQuestButton:Click()
      print("AutoAdal: Auto-completed quest: " .. questTitle)
    end
  end
end

local function OnQuestProgress(self, event, ...)
  if (not AA_CONFIG["enabled"]) then
    return
  end
  
  local npcName = UnitName("target")
  if (not ArrIncludes(buffNPCs, npcName)) then
    return
  end
  
  if IsQuestCompletable() then
    local questTitle = GetTitleText()
    if (isAutoQuest(questTitle) and canAutoQuest(questTitle)) then
      CompleteQuest()
      print("AutoAdal: Auto-progressed quest: " .. questTitle)
    end
  end
end

-- Enhanced gossip handling to prioritize buffs over quests
local function OnGossipShowEnhanced(self, event, ...)
  if (not AA_CONFIG["enabled"]) then
    return
  end
  
  local npcName = UnitName("target")
  if (not IsShiftKeyDown() or not ArrIncludes(buffNPCs, npcName)) then
    return
  end
  
  -- Handle buffs first and check if any were applied
  local buffsApplied = handleBuffs(self, event, ...)
  local questsHandled = false
  
  -- Only handle quest selection if no buffs were applied
  if (not buffsApplied) then
    questsHandled = handleQuests(self, event, ...)
    -- If no quests were handled and we're in a buff NPC context, show the completion message
    if (not questsHandled) then
      print("AutoAdal: All buffs already present.")
    end
  end
  
  -- Refresh tooltip if buffs or quests were applied (with delay to allow server to apply buffs)
  if buffsApplied or questsHandled then
    -- Use different delays: 0.3s for buffs, 0.6s for quests (quest completion takes longer)
    local delay = buffsApplied and 0.3 or 1
    
    -- Use TBC-compatible timer approach
    local delayFrame = CreateFrame("Frame")
    local startTime = GetTime()
    delayFrame:SetScript("OnUpdate", function()
      if GetTime() - startTime >= delay then
        refreshTooltip()
        delayFrame:SetScript("OnUpdate", nil)
      end
    end)
  end
  
end

local function OnEvent(self, event, ...)
  if (event == "GOSSIP_SHOW") then
    OnGossipShowEnhanced(self, event, ...)
  elseif (event == "ADDON_LOADED") then
    InitConfig()
  elseif (event == "UPDATE_MOUSEOVER_UNIT") then
    OnMouseOver(self, event, ...)
  elseif (event == "GOSSIP_CLOSED") then
    -- Reset auto accepting state
    autoAcceptingBuffs = false
  elseif (event == "QUEST_DETAIL") then
    OnQuestDetail(self, event, ...)
  elseif (event == "QUEST_COMPLETE") then
    OnQuestComplete(self, event, ...)
  elseif (event == "QUEST_PROGRESS") then
    OnQuestProgress(self, event, ...)
  end
end

aaframe:SetScript("OnEvent", OnEvent) 
