SLASH_LOOTM1 = "/lootm"

local function Loothandler()
    message("Loot Manager is here " .. UnitName("player") .. "!");
end

SlashCmdList["LOOTM"] = Loothandler