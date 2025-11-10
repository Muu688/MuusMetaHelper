local ADDON_NAME = ...

-- Tab definitions
local TAB_NAMES = { "Overview", "Slate of the Union", "Rage Aside the Machine", "Crystal Chronicled", "Azj the World Turns", "Glory of the Delver" }
local contentFrames = {}

-- Create the main window
local frame = CreateFrame("Frame", "MyTabsFrame", UIParent, "BackdropTemplate")
frame:SetSize(900, 900)
frame:SetPoint("CENTER")
frame:SetBackdrop({
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 16,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
frame:Hide()
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

-- Title text
local title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
title:SetPoint("TOP", 0, -10)
title:SetText("Muu's Meta Helper (Worldsoul Searching)")

-- Function to show the selected tab
local function ShowTab(tabIndex)
    for i, tabName in ipairs(TAB_NAMES) do
        contentFrames[i]:SetShown(i == tabIndex)
        frame.tabs[i]:SetNormalFontObject(i == tabIndex and "GameFontHighlight" or "GameFontNormal")
    end
end

-- Create tab buttons
frame.tabs = {}
for i, tabName in ipairs(TAB_NAMES) do
    local tab = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    tab:SetSize(130, 24)
    if i == 1 then
        tab:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -40)
    else
        tab:SetPoint("LEFT", frame.tabs[i-1], "RIGHT", 10, 0)
    end
    tab:SetText(tabName)
    tab:SetScript("OnClick", function() ShowTab(i) end)
    frame.tabs[i] = tab
end

-- Create content frames for each tab
for i, tabName in ipairs(TAB_NAMES) do
    local content = CreateFrame("Frame", nil, frame)
    content:SetSize(360, 220)
    content:SetPoint("TOPLEFT", 20, -80)

    local text = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    text:SetPoint("CENTER")
    if i == 2 or i == 3 or i == 4 or i == 5 then
        text:SetText(tabName .. " is in Development")
    end

    contentFrames[i] = content
end

-------------------------------------------------
-- Overview Tab Custom Content
-------------------------------------------------
-- Reference the overview tab frame
local overviewFrame = contentFrames[1]

-- Scroll frame container
local scrollFrame = CreateFrame("ScrollFrame", nil, overviewFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 20, -80)
scrollFrame:SetSize(500, 500)

-- Child frame for the text
local textFrame = CreateFrame("Frame", nil, scrollFrame)
textFrame:SetSize(320, 1) -- width must match scroll frame
scrollFrame:SetScrollChild(textFrame)

-- FontString for paragraph text
local paragraph = textFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
paragraph:SetPoint("TOPLEFT")
paragraph:SetWidth(300)
paragraph:SetJustifyH("LEFT")
paragraph:SetJustifyV("TOP")
paragraph:SetText("Welcome to the Overview tab!\n\nI\'m a new addon developer so things may be shonky/broken but i'm trying my best\n\nI would consider having a weekly chore-list so that you're not grinding things out late. If you don't have rep with the required base factions consider doing at least,\n- Theatre troop\n- Awakening the Machine\n- Azj-Kahet 4 WQ for pact quest weekly\n- Siren Isle 'Epic Quest' or whatever it is as that's on weekly rotation so you want to be eating those up.\n\n\nThe 'Check World Quests' button will check the world quests needed relating to the acheivments 'Worm Theory' and 'Children's Entertainer' as those are on rotation and may not always be up, it's a good idea to press it regularly and check on what you need.")

-- Make sure frame resizes based on text height
textFrame:SetHeight(paragraph:GetStringHeight())


-- Create a "Check World Quests" button
local checkButton = CreateFrame("Button", nil, overviewFrame, "UIPanelButtonTemplate")
checkButton:SetSize(160, 30)
checkButton:SetPoint("TOP", 0, -40)
checkButton:SetText("Check World Quests")

local questIDs = {79958, 79959, 82324, 82288}
local function CheckWorldQuests()
    local foundActive = false

    for _, questID in ipairs(questIDs) do
        local title = C_QuestLog.GetTitleForQuestID(questID) or "Unknown Quest"

        if C_QuestLog.IsWorldQuest(questID) and C_TaskQuest.IsActive(questID) then
            print("|cff00ff00[Muus Meta Helper]|r Quest " .. questID .. ": " .. title .. " is ACTIVE!")
            foundActive = true
        end
    end

    if not foundActive then
        print("|cffffcc00[Muus Meta Helper]|r No relevant world quests are active.")
    end
end

-- Connect the button click to the function
checkButton:SetScript("OnClick", CheckWorldQuests)
-------------------------------------------------
-- Delve Loremaster Tab Custom Content
-------------------------------------------------
local delveLoremasterFrame = contentFrames[6]  -- make sure index matches your tab

-- =========================
-- Check Delve Progress Button
-- =========================
local delveButton = CreateFrame("Button", nil, delveLoremasterFrame, "UIPanelButtonTemplate")
delveButton:SetSize(300, 30)
delveButton:SetPoint("TOP", 0, -10)
delveButton:SetText("Check Delve Loremaster Progress")

-- =========================
-- Scrollable Frame: Progress Output
-- =========================
local progressScroll = CreateFrame("ScrollFrame", nil, delveLoremasterFrame, "UIPanelScrollFrameTemplate")
progressScroll:SetPoint("TOPLEFT", 20, -50)
progressScroll:SetSize(600, 200)

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
tipsScroll:SetPoint("TOPLEFT", 20, -270) -- below the progress frame
tipsScroll:SetSize(600, 200)

local tipsFrame = CreateFrame("Frame", nil, tipsScroll)
tipsFrame:SetSize(580, 1)
tipsScroll:SetScrollChild(tipsFrame)


local delveTipText = "Sporesweeper: Complete a Fungarian Delve Tier 8 or higher without getting hit by Sporebit (Spore bomb circle things) - going close causes them to grow and after 5s they explore. Best way to tackle this is to just take your time through the delve.\n\nSpider Senses: Complete a Nerubian Delve (Earthcrawl Mines, The Dread Pit, The Spiral Weave, The Underkeep) without spawning ambushers from Nerubian Webs, or taking damage from Nerubian Eggs on Tier 8 or Higher. Don't step on any nerubian webs or standing near them. Pretty much take your time and avoid things.\n\nDaystormer: Complete an Order of the Night Delve (Nightfall Sanctum) on Tier 8 without being targeted by Artillery fire (Don't stand in purple circles)\n\nBrann Development: For the most part ignore this, it will probably complete as you complete the other parts of Glory of the Delver, but Brann needs to be level 25.\n\nMy Stab Happy Nemesis: Defeat Nexus Princess Ky'vesa in her Delve (/way Tazavesh 38.91 51.82)\n\nLeave No Treasure Unfound: Click the buttons to get links to where to find the chests. They are not always available and may require a specific story varient(s) to obtain all treasure chests for a single delve. (Thanks Wowhead user Wiciregord for creating these maps)"
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
                table.insert(outputLines, delve.name .. " missing variants: " .. table.concat(missingVariants, ", "))
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
delveButton:SetScript("OnClick", CheckDelveVariants)

-- URLs for each delve
local DELVE_URLS = {
    ["Fungal Folly"] = "https://imgur.com/LTo0kWw",
    ["Earthcrawl Mines"] = "https://imgur.com/oobJCjT",
    ["The Dread Pit"] = "https://imgur.com/CIQtt1k",
    ["Mycomancer Cavern"] = "https://imgur.com/6Tj9g8u",
    ["Skittering Breach"] = "https://imgur.com/L7Bj29x",
    ["Tak-Rethan Abyss"] = "https://imgur.com/l90VdUn",
    ["Excavation Site 9"] = "https://imgur.com/XXXXX",
    ["Archival Assault"] = "https://imgur.com/XXXXX",
    ["Kriegval's Rest"] = "https://imgur.com/c3DmZn2",
    ["The Waterworks"] = "https://imgur.com/eycJIpa",
    ["Nightfall Sanctum"] = "https://imgur.com/hmQHWYz",
    ["Sidestreet Sluice"] = "https://www.youtube.com/watch?v=k2MCkCll880",
    ["The Underkeep"] = "https://www.youtube.com/watch?v=sjQxlqxfrls",
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
local startY = -500

for i = 1, 11 do
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

-- Slash command to toggle the window
SLASH_MYTABS1 = "/mmh"
SlashCmdList["MYTABS"] = function()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
        ShowTab(1)
    end
end

-- Print load message
print("Muu's Meta Helper loaded! Type /mmh to open.")