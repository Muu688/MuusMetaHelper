-------------------------------------------------
-- Delve Loremaster Tab Custom Content
-------------------------------------------------
local delveLoremasterFrame = contentFrames[6]

local delveTitleContent = CreateFrame("Frame", nil, delveLoremasterFrame)
delveTitleContent:SetSize(360, 220)
delveTitleContent:SetPoint("TOPLEFT", 0, -10)
local delveLoremasterHeader = delveLoremasterFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
delveLoremasterHeader:SetPoint("TOPLEFT", 20, -60)
delveLoremasterHeader:SetText("Delve Loremaster Remaining Stories")

-- =========================
-- Scrollable Frame: Progress Output
-- =========================
local progressScroll = CreateFrame("ScrollFrame", nil, delveLoremasterFrame, "UIPanelScrollFrameTemplate")
progressScroll:SetPoint("TOPLEFT", 20, -100)
progressScroll:SetSize(700, 200)

local progressFrame = CreateFrame("Frame", nil, progressScroll)
progressFrame:SetSize(580, 1)
progressScroll:SetScrollChild(progressFrame)

local progressText = progressFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
progressText:SetPoint("TOPLEFT")
progressText:SetWidth(560)
progressText:SetJustifyH("LEFT")
progressText:SetJustifyV("TOP")
progressText:SetText("")  -- initially empty

-- =========================
-- Scrollable Frame: Tips / Notes
-- =========================
local tipsScroll = CreateFrame("ScrollFrame", nil, delveLoremasterFrame, "UIPanelScrollFrameTemplate")
tipsScroll:SetPoint("TOPLEFT", 20, -330)
tipsScroll:SetSize(700, 300)

local tipsFrame = CreateFrame("Frame", nil, tipsScroll)
tipsFrame:SetSize(580, 1)
tipsScroll:SetScrollChild(tipsFrame)

local delveTipText = "|cff00ff00Sporesweeper|r: Complete a Fungarian Delve Tier 8 or higher without getting hit by Sporebit (Spore bomb circle things) - going close causes them to grow and after 5s they explore. Best way to tackle this is to just take your time through the delve.\n\n|cff00ff00Spider Senses|r: Complete a Nerubian Delve (Earthcrawl Mines, The Dread Pit, The Spiral Weave, The Underkeep) without spawning ambushers from Nerubian Webs, or taking damage from Nerubian Eggs on Tier 8 or Higher. Don't step on any nerubian webs or standing near them. Pretty much take your time and avoid things.\n\n|cff00ff00Daystormer|r: Complete an Order of the Night Delve (Nightfall Sanctum) on Tier 8 without being targeted by Artillery fire (Don't stand in purple circles)\n\n|cff00ff00Brann Development|r: For the most part ignore this, it will probably complete as you complete the other parts of Glory of the Delver, but Brann needs to be level 25.\n\n|cff00ff00My Stab Happy Nemesis|r: Defeat Nexus Princess Ky'vesa in her Delve (/way Tazavesh 38.91 51.82)\n\n|cff00ff00Leave No Treasure Unfound|r: Click the buttons to get links to where to find the chests. They are not always available and may require a specific story varient(s) to obtain all treasure chests for a single delve. (Thanks Wowhead user Wiciregord for creating these maps)"
local tipsText = tipsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
tipsText:SetPoint("TOPLEFT")
tipsText:SetWidth(560)
tipsText:SetJustifyH("LEFT")
tipsText:SetJustifyV("TOP")
tipsText:SetText(delveTipText)

-- Function to append new tips dynamically
local function AddTip(newTip)
    tipsText:SetText(tipsText:GetText() .. "\n\n" .. newTip)
    tipsFrame:SetHeight(tipsText:GetStringHeight())
end

-- =========================
-- Delve & Variant Data
-- =========================
local DELVES = {
    {name = "Fungal Folly", id = 40525},
    {name = "Earthcrawl Mines", id = 40527},
    {name = "The Dread Pit", id = 40529},
    {name = "Mycomancer Cavern", id = 40531},
    {name = "Skittering Breach", id = 40533},
    {name = "Tak-Rethan Abyss", id = 40535},
    {name = "Excavation Site 9", id = 41098},
    {name = "Archival Assault", id = 42771},
    {name = "Kriegval's Rest", id = 40526},
    {name = "The Waterworks", id = 40528},
    {name = "Nightfall Sanctum", id = 40530},
    {name = "The Sinkhole", id = 40532},
    {name = "The Underkeep", id = 40534},
    {name = "The Spiral Weave", id = 40536},
    {name = "Sidestreet Sluice", id = 41099},
}

local DELVE_VARIANTS = {
    [40525] = {1,2,3,4},
    [40527] = {1,2,3,4,5},
    [40529] = {1,2,3,4},
    [40531] = {1,2,3},
    [40533] = {1,2,3,4},
    [40535] = {1,2,3,4},
    [41098] = {1,2,3},
    [42771] = {1,2,3,4},
    [40526] = {1,2,3,4},
    [40528] = {1,2,3,4},
    [40530] = {1,2,3,4},
    [40532] = {1,2,3,4},
    [40534] = {1,2,3,4,5},
    [40536] = {1,2,3,4},
    [41099] = {1,2,3},
}

-- =========================
-- Function: Check Delve Variants
-- =========================
local function CheckDelveVariants()
    local outputLines = {}

    for _, delve in ipairs(DELVES) do
        local _, _, _, completed = GetAchievementInfo(delve.id)
        if not completed then
            local variantIndices = DELVE_VARIANTS[delve.id] or {}
            local missingVariants = {}

            for _, critIndex in ipairs(variantIndices) do
                local critName, _, critCompleted = GetAchievementCriteriaInfo(delve.id, critIndex)
                if critName and not critCompleted then
                    table.insert(missingVariants, critName)
                end
            end

            if #missingVariants > 0 then
                local coloredName = "|cff00ff00" .. delve.name .. "|r"  -- bright green
                table.insert(outputLines, coloredName .. " missing variants: " .. table.concat(missingVariants, ", "))
            end
        end
    end

    if #outputLines == 0 then
        progressText:SetText("All delve objectives complete!")
    else
        progressText:SetText(table.concat(outputLines, "\n"))
    end

    -- Resize progress frame to fit text
    progressFrame:SetHeight(progressText:GetStringHeight())
end

-- Connect button to function
-- delveButton:SetScript("OnClick", CheckDelveVariants)
CheckDelveVariants()

-- URLs for each delve
local DELVE_URLS = {
    ["Fungal Folly"] = "https://imgur.com/LTo0kWw",
    ["Earthcrawl Mines"] = "https://imgur.com/oobJCjT",
    ["Kriegval's Rest"] = "https://imgur.com/c3DmZn2",
    ["Excavation Site 9"] = "https://www.wowhead.com/maps?data=15836:730400570470500610330580",
    ["The Waterworks"] = "https://imgur.com/eycJIpa",
    ["The Dread Pit"] = "https://imgur.com/CIQtt1k",
    ["Mycomancer Cavern"] = "https://imgur.com/6Tj9g8u",
    ["Skittering Breach"] = "https://imgur.com/L7Bj29x",
    ["The Sinkhole"] = "https://imgur.com/685MraM",
    ["Nightfall Sanctum"] = "https://imgur.com/hmQHWYz",
    ["Tak-Rethan Abyss"] = "https://imgur.com/l90VdUn",
    ["The Spiral Weave"] = "https://imgur.com/a/ZPZp0FE",
    ["The Underkeep"] = "https://www.youtube.com/watch?v=sjQxlqxfrls",
    ["Sidestreet Sluice"] = "https://www.youtube.com/watch?v=k2MCkCll880",
    ["Archival Assault"] = "https://www.youtube.com/watch?v=YCbHyzWQ570",
}
-- =========================
-- Delve Discovery Buttons (Grid Layout)
-- =========================
local buttonsPerRow = 4  -- change to 3 or 5 depending on spacing
local buttonWidth = 200
local buttonHeight = 25
local buttonSpacingX = 10
local buttonSpacingY = 10

-- Starting point anchored to bottom-left of the tab
local startX = 20
local startY = -550

for i = 1, 15 do
    local delve = DELVES[i]
    if delve then
        local row = math.floor((i-1) / buttonsPerRow)
        local col = (i-1) % buttonsPerRow

        local btn = CreateFrame("Button", nil, delveLoremasterFrame, "UIPanelButtonTemplate")
        btn:SetSize(buttonWidth, buttonHeight)
        btn:SetPoint("BOTTOMLEFT", delveLoremasterFrame, "BOTTOMLEFT", startX + (buttonWidth + buttonSpacingX) * col, startY + (buttonHeight + buttonSpacingY) * row)
        btn:SetText(delve.name .. " Discoveries")

        btn:SetScript("OnClick", function()
            local url = DELVE_URLS[delve.name]
            if url then
                ChatEdit_ActivateChat(ChatEdit_GetActiveWindow() or DEFAULT_CHAT_FRAME.editBox)
                ChatEdit_InsertLink(url)
                print("|cff00ff00[Muus Meta Helper]|r URL for " .. delve.name .. " copied to chat!")
            else
                print("|cffff0000[Muus Meta Helper]|r No URL assigned for " .. delve.name)
            end
        end)
    end
end