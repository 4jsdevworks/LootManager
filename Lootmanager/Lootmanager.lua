SLASH_LOOTM1 = "/lootm"

local function Loothandler()
    --local playerName = UnitName("player")
    message("Loot Manager is here " .. UnitName("player") .. "!");
end

SlashCmdList["LOOTM"] = Loothandler