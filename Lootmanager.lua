Lootmanager = LibStub("AceAddon-3.0"):NewAddon("Lootmanager", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")

local options = {
    name = "Lootmanager",
    handler = Lootmanager,
    type = "group",
    args = {
        masterLooter = {
            type = "input",
            name = "Master Looter",
            desc = "The name of the master looter in the raid",
            usage = "<player name>",
            get = "GetMasterLooter",
            set = "SetMasterLooter",
        },
        showInChat = {
            type = "toggle",
            name = "Show in Chat",
            desc = "Toggles the display of the message in the chat window.",
            get = "IsShowInChat",
            set = "ToggleShowInChat",
        },
        showOnScreen = {
            type = "toggle",
            name = "Show on Screen",
            desc = "Toggles the display of the message on the screen.",
            get = "IsShowOnScreen",
            set = "ToggleShowOnScreen",
        },
    },
}

local defaults = {
    profile =  {
        masterLooter = UnitName("player"),
        showInChat = true,
        showOnScreen = true,
    },
}

function Lootmanager:OnInitialize()
    self.Print("Lootmanager Loading...")
    self.db = LibStub("AceDB-3.0"):New("LootmanagerDB", defaults, true)

    LibStub("AceConfig-3.0"):RegisterOptionsTable("Lootmanager", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Lootmanager", "Lootmanager")
    self:RegisterChatCommand("lm", "ChatCommand")
    self:RegisterChatCommand("Lootmanager", "ChatCommand")
    self:RegisterChatCommand("st", "StartTimer")
    self:RegisterChatCommand("boss", "StartBoss")
        
    self.Print("Lootmanager Registering Events")
    -- list found here: https://wowwiki.fandom.com/wiki/Events/Loot
    self:RegisterEvent("PLAYER_REGEN_DISABLED", "CombatStart")
    self:RegisterEvent("PLAYER_REGEN_ENABLED", "CombatStop")
    self.Print("Lootmanager Loaded")
end

function Lootmanager:CombatStart()
    -- placeholder for starting combat
end

function Lootmanager:CombatStop()
    if GetLootMethod() ~= "group" then
        SendChatMessage("Switching back to group loot", "RAID_WARNING", nil, nil)
        SetLootMethod("group");
    end
end

function Lootmanager:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    else
        LibStub("AceConfigCmd-3.0"):HandleCommand("lm", "Lootmanager", input)
    end
end

function Lootmanager:StartBoss()
    if GetLootMethod() ~= "master" then
        SetLootMethod("master", self.db.profile.masterLooter);
        SendChatMessage("Switching to master loot, starting Boss in 10 seconds", "RAID_WARNING", nil, nil)
        self:StartTimer(10)    
    end
end

function Lootmanager:GetMasterLooter(info)
    return self.db.profile.masterLooter
end

function Lootmanager:SetMasterLooter(info, newValue)
    self.db.profile.masterLooter = newValue
end

function Lootmanager:IsShowInChat(info)
    return self.db.profile.showInChat
end

function Lootmanager:ToggleShowInChat(info, value)
    self.db.profile.showInChat = value
end

function Lootmanager:IsShowOnScreen(info)
    return self.db.profile.showOnScreen
end

function Lootmanager:ToggleShowOnScreen(info, value)
    self.db.profile.showOnScreen = value
end

function Lootmanager:StartTimer(timerLength)
    self.timerCount = timerLength
    self.testTimer = self:ScheduleRepeatingTimer("TimerTick", 1)
end

function Lootmanager:TimerTick()
    self.timerCount = self.timerCount - 1

    local message = self.timerCount
    SendChatMessage(message, "RAID_WARNING", nil, nil)
    
    if self.timerCount == 0 then
        self:CancelTimer(self.testTimer)
    end
end
