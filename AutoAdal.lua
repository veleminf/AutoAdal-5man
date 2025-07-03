AA_CONFIG = {
  enabled = true,
  buffBotMarker = 2,
  shoutType = "commanding"
}

local AA_DefaultConfig = {
  enabled = true,
  buffBotMarker = 2,
  shoutType = "commanding"
}

local function InitConfig()
  for key, value in pairs (AA_DefaultConfig) do
    if (AA_CONFIG[key] == nil) then
      AA_CONFIG[key] = value
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
  
  -- Use multiple methods to ensure message displays
  DEFAULT_CHAT_FRAME:AddMessage(color .. message);
  -- Also print to system message frame
  UIErrorsFrame:AddMessage(message, r/255, g/255, b/255, 1.0, 3);
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
  -- Check the message content
  if (arguments[1] == "botmark") then
    if (arguments[2] == nil) then
      print("aa debug. Bot Marker = " .. AA_CONFIG["buffBotMarker"]);
    else
      local marker = tonumber(arguments[2]);
      if (marker == nil or marker < 0 or marker > 8) then
        print("Invalid marker value.");
        print("/aa botmark <0-8> | Default: 2");
        print("/aa botmark 0 | Disable");
      else
        AA_CONFIG["buffBotMarker"] = marker;
        print("aa debug. Bot Marker = " .. AA_CONFIG["buffBotMarker"]);
      end
    end
  elseif (arguments[1] == "enable") then
    AA_CONFIG["enabled"] = true;
    print("aa debug. Enabled = " .. tostring(AA_CONFIG["enabled"]));
  elseif (arguments[1] == "disable") then
    AA_CONFIG["enabled"] = false;
    print("aa debug. Enabled = " .. tostring(AA_CONFIG["enabled"]));
  elseif (arguments[1] == "shout") then
    if (arguments[2] == nil) then
      print("aa debug. Shout Type = " .. AA_CONFIG["shoutType"]);
    else
      local shoutType = arguments[2]:lower();
      if (shoutType == "commanding" or shoutType == "battle") then
        AA_CONFIG["shoutType"] = shoutType;
        print("aa debug. Shout Type = " .. AA_CONFIG["shoutType"]);
      else
        print("Invalid shout type.");
        print("/aa shout <commanding|battle> | Default: commanding");
      end
    end
  elseif (arguments[1] == "test") then
    print("aa debug. nothing to test");
  else
    print("Invalid command. /aa for help.");
    print("/aa botmark <0-8> | Default: 2");
    print("/aa shout <commanding|battle> | Default: commanding");
    print("/aa enable");
    print("/aa disable");
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
aaframe:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
aaframe:RegisterEvent("ADDON_LOADED")
aaframe:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
aaframe:RegisterEvent("GOSSIP_CLOSED")

local buffNPCs = { "A'dal", "Minutulus Naaru Guardian", "Naaru Guardian" }

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

local function OnMouseOver(self, event, ...)
  if (not AA_CONFIG["enabled"]) then
    return
  end

  local npcName = UnitName("mouseover")
  if (npcName == nil) then return end

  if (AA_CONFIG["buffBotMarker"] ~= 0 and npcName == "Minutulus Naaru Guardian") then
    if (GetRaidTargetIndex("mouseover") == nil) then
      SetRaidTarget("mouseover", AA_CONFIG["buffBotMarker"])
    end
  end

  if (npcName == "Naaru Guardian" and IsHeroCD()) then
    GameTooltip:AddLine("AutoAdal: Shift+Right-Click to reset Bloodlust/Heroism CD")
    GameTooltip:Show()
    return
  end

  if (ArrIncludes(buffNPCs, npcName)) then
    GameTooltip:AddLine("AutoAdal: Shift+Right-Click to get group buffs")
    GameTooltip:Show()
  end
end

local function OnCombatLogEvent(self, event, ...)
  if (not AA_CONFIG["enabled"]) then
    return
  end

  local subevent = select(2, ...)
  local destname = select(7, ...)

  if (subevent == "SPELL_SUMMON" and destname == "Minutulus Naaru Guardian") then
    print("AutoAdal: Minutulus Naaru Guardian summoned")
    -- this doesnt work because of the space in the name
    if (AA_CONFIG["buffBotMarker"] ~= 0) then
      SetRaidTarget("Minutulus Naaru Guardian", AA_CONFIG["buffBotMarker"])
    end
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
local function OnGossipShow(self, event, ...)
  if (not AA_CONFIG["enabled"]) then
    return
  end

  local npcName = UnitName("target")

  -- Check if shift is held down when gossip opens for buff NPCs
  if (IsShiftKeyDown() and ArrIncludes(buffNPCs, npcName)) then
    autoAcceptingBuffs = true
    -- print("AutoAdal: Shift+Right-Click detected on " .. npcName .. ". Getting buffs...")
  end

  -- Always reset Bloodlust/Heroism CD
  if (npcName == "Naaru Guardian" and IsHeroCD()) then
    -- Click "I wish to reset Bloodlust or Heroism" if its on CD
    if (FindAndSelectGossipOption("I wish to reset Bloodlust or Heroism")) then
      print("AutoAdal: Bloodlust/Heroism CD reset.")
      return
    end
  end

  if (ArrIncludes(buffNPCs, npcName)) then
    if (autoAcceptingBuffs) then
      -- Check for buffs on player
      local hasPrayerOfFortitude = false
      local hasShout = false
      local hasBloodPact = false
      
      -- Determine which shout to check for
      local shoutBuffName = ""
      local shoutGossipOption = ""
      local shoutDisplayName = ""
      
      if (AA_CONFIG["shoutType"] == "battle") then
        shoutBuffName = "Battle Shout"
        shoutGossipOption = "Empower my group with Battle Shout"
        shoutDisplayName = "Battle Shout"
      else
        shoutBuffName = "Commanding Shout"
        shoutGossipOption = "Empower my group with Commanding Shout"
        shoutDisplayName = "Commanding Shout"
      end
      
      local i = 1
      while UnitBuff("player", i) do
        local buffName = UnitBuff("player", i)
        if (buffName == "Prayer of Fortitude") then
          hasPrayerOfFortitude = true
        elseif (buffName == shoutBuffName) then
          hasShout = true
        elseif (buffName == "Blood Pact") then
          hasBloodPact = true
        end
        i = i + 1
      end
      
      -- Select option based on missing buffs (priority order)
      if (not hasPrayerOfFortitude) then
        if (FindAndSelectGossipOption("Empower my group with all the class buffs")) then
          print("AutoAdal: Applied class buffs to group.")
        end
      elseif (not hasShout) then
        if (FindAndSelectGossipOption(shoutGossipOption)) then
          print("AutoAdal: Applied " .. shoutDisplayName .. " to group.")
        end
      elseif (not hasBloodPact) then
        if (FindAndSelectGossipOption("Empower me with Blood Pact")) then
          print("AutoAdal: Applied Blood Pact.")
        end
      else
        print("AutoAdal: All buffs already present.")
      end
      autoAcceptingBuffs = false
    end
  end
end

local function OnEvent(self, event, ...)
  if (event == "GOSSIP_SHOW") then
    OnGossipShow(self, event, ...)
  elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") then
    OnCombatLogEvent(self, event, ...)
  elseif (event == "ADDON_LOADED") then
    InitConfig()
  elseif (event == "UPDATE_MOUSEOVER_UNIT") then
    OnMouseOver(self, event, ...)
  elseif (event == "GOSSIP_CLOSED") then
    -- Reset auto accepting state
    autoAcceptingBuffs = false
  end
end

aaframe:SetScript("OnEvent", OnEvent) 
