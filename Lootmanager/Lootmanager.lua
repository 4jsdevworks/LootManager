Lootmanager = LibStub("AceAddon-3.0"):NewAddon("Lootmanager", "AceConsole-3.0", "AceEvent-3.0")


local options = {
    name = "Lootmanager",
    handler = Lootmanager,
    type = "group",
    args = {
        msg = {
            type = "input",
            name = "Message",
            desc = "The message to be displayed when you get home.",
            usage = "<Your message>",
            get = "GetMessage",
            set = "SetMessage",
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
        message = "Welcome Home!",
        showInChat = true,
        showOnScreen = true,
    },
}

function Lootmanager:OnInitialize()
    self.Print("Lootmanager Loading...")
    self.db = LibStub("AceDB-3.0"):New("LootmanagerDB", defaults, true)

    LibStub("AceConfig-3.0"):RegisterOptionsTable("Lootmanager", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Lootmanager", "Lootmanager")
    self:RegisterChatCommand("wh", "ChatCommand")
    self:RegisterChatCommand("Lootmanager", "ChatCommand")
    
    self.Print("Lootmanager Registering Events")
    -- list found here: https://wowwiki.fandom.com/wiki/Events/Loot
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "ZoneChange")
    self:RegisterEvent("PLAYER_REGEN_DISABLED", "CombatStart")
    self:RegisterEvent("PLAYER_REGEN_ENABLED", "CombatStop")
   
    self.Print("Lootmanager Loaded")
end

function Lootmanager:CombatStart()
    self.Print("Combat Start")
end

function Lootmanager:CombatStop()
    self.Print("Combat Stop")
end

function Lootmanager:ZoneChange()
    if GetBindLocation() == GetZoneText() then
        if self.db.profile.showInChat then
            self:Print(self.db.profile.message)
        end

        if self.db.profile.showOnScreen then
            UIErrorsFrame:AddMessage(self.db.profile.message, 1.0, 1.0, 1.0, 5.0)
        end
    end
end

function Lootmanager:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    else
        LibStub("AceConfigCmd-3.0"):HandleCommand("wh", "Lootmanager", input)
    end
end

function Lootmanager:GetMessage(info)
    return self.db.profile.message
end

function Lootmanager:SetMessage(info, newValue)
    self.db.profile.message = newValue
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