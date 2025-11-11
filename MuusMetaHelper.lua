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

local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5) -- adjust offsets

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
    if i == 3 or i == 5 then
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
scrollFrame:SetSize(500, 300)

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
paragraph:SetText("Welcome to the Overview tab!\n\nI\'m a new addon developer so things may be shonky/broken but I'm trying my best\n\nI would consider having a weekly chore-list so that you're not grinding things out late. If you don't have rep with the required base factions consider doing at least,\n- Theatre troop\n- Awakening the Machine\n- Azj-Kahet 4 WQ for pact quest weekly\n- Siren Isle 'Epic Quest' or whatever it is as that's on weekly rotation so you want to be eating those up.\n\n\nThe 'Check World Quests' button will check the world quests needed relating to the acheivments 'Worm Theory' and 'Children's Entertainer' as those are on rotation and may not always be up, it's a good idea to press it regularly and check on what you need.")

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

local content = CreateFrame("Frame", nil, overviewFrame)
content:SetSize(360, 220)
content:SetPoint("TOPLEFT", 20, -320)
local progressTextHeader = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
progressTextHeader:SetPoint("CENTER")
progressTextHeader:SetText("Remaining Acheivements")

-------------------------------------------------
-- Meta Achievement Progress Tracker
-------------------------------------------------
-- Place this section lower in the Overview tab
local metaFrame = CreateFrame("Frame", "MetaAchievementProgressFrame", overviewFrame)
metaFrame:SetSize(500, 300)
metaFrame:SetPoint("TOPLEFT", 20, -450)  -- move below intro scroll box

-- Scroll Frame
local scroll = CreateFrame("ScrollFrame", nil, metaFrame, "UIPanelScrollFrameTemplate")
scroll:SetPoint("TOPLEFT", 0, 0)
scroll:SetSize(650, 350)

-- Scroll Child Frame
local scrollChild = CreateFrame("Frame", nil, scroll)
scrollChild:SetSize(640, 1)
scroll:SetScrollChild(scrollChild)

-- FontString for output
local progressText = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
progressText:SetPoint("TOPLEFT")
progressText:SetWidth(620)
progressText:SetJustifyH("LEFT")
progressText:SetJustifyV("TOP")

-- ==========================================
-- ACHIEVEMENT HIERARCHY
-- ==========================================
local META_ACHIEVEMENTS = {
    { name = "You Xal Not Pass", id = 41201 },
    { name = "Nerub-ar Palace", id = 40244 },
    { name = "Manaforge Omega", id = 41598 },
    { name = "Rage Aside the Machine", id = 41187 },
    { name = "Slate of the Union", id = 41186 },
    { name = "Crystal Chronicled", id = 41188 },
    { name = "Azj the World Turns", id = 41189 },
    { name = "Isle Remember You", id = 41133 },
    { name = "Glory of the Delver", id = 40438 },
    { name = "Owner of a Radiant Heart", id = 41997 },
    { name = "Liberation of Undermine", id = 41222 },
    { name = "All That Khaz", id = 41555 },
    { name = "Unraveled and Persevering", id = 60889 },
    { name = "Going Goblin Mode", id = 41586 },
    { name = "The War Within Pathfinder", id = 40231 },
}

-- ==========================================
-- Recursive Check Function
-- ==========================================
local function CheckAchievementTree(achievements, indent)
    local lines = {}

    for _, ach in ipairs(achievements) do
        local _, _, _, completed = GetAchievementInfo(ach.id)
        if not completed then
            table.insert(lines, string.rep("  ", indent) .. "|cffffd100" .. ach.name .. "|r")

            local numCriteria = GetAchievementNumCriteria(ach.id)
            if numCriteria and numCriteria > 0 then
                for i = 1, numCriteria do
                    local critName, _, critCompleted = GetAchievementCriteriaInfo(ach.id, i)
                    if critName and not critCompleted then
                        table.insert(lines, string.rep("  ", indent + 1) .. "- " .. critName)
                    end
                end
            end

            if ach.sub then
                local subLines = CheckAchievementTree(ach.sub, indent + 1)
                for _, line in ipairs(subLines) do
                    table.insert(lines, line)
                end
            end
        end
    end

    return lines
end

-- ==========================================
-- Display Missing Achievements
-- ==========================================
local function ShowMissingAchievements()
    local lines = CheckAchievementTree(META_ACHIEVEMENTS, 0)

    if #lines == 0 then
        progressText:SetText("|cff00ff00All achievements complete!|r")
    else
        progressText:SetText(table.concat(lines, "\n"))
    end

    scrollChild:SetHeight(progressText:GetStringHeight())
end

ShowMissingAchievements()

-------------------------------------------------
-- Slate of the Union Tab Custom Content
-------------------------------------------------
local slateOfTheUnionFrame = contentFrames[2]  -- make sure index matches your tab

-- Scroll frame container
local scrollFrame = CreateFrame("ScrollFrame", nil, slateOfTheUnionFrame, "UIPanelScrollFrameTemplate")
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
paragraph:SetText("|cff00ff00Adventurer of the Isle of Dorn|r: Consider downloading the addon 'rarescanner' - Kill Heaps of Rares. You will probably get this during the Rep Grind and/or Loremaster of Khaz'algar acheivement. WM On however seems to be an efficient way to farm these.\n\n|cff00ff00Flat Earthen|r: Stand under the stamp press in Dornogol near the Teleporter to Undermine.\n\n|cff00ff00A Star of Dorn|r: Get 21 Renown with Council of Dorn before you care about this, Speak with the NPC's at /way 56.79 52.19\n\n|cff00ff00We're here all night|r: Complete each variation of the Theatre Troupe, they rotate hourly just keep an eye out at about 5m which one is next.\n\n|cff00ff00Rocked to Sleep|r: Click Button below to import waypoints, read the plaques\n\n|cff00ff00Treasures of the Isle of Dorn|r: Click below Button to import Tom Tom waypoints. For Tree's Treasure you will need to find the 6 crabs and bring them to the tree. For Magical treasure chest you will need to collect 5 plump snapcrabs and feel them to lionel. For Mushroom Cap you will need to get his hat at 53.07 68.33 and for Turtle's thanks you will need to give him 5 Dornish pike, 1 fish and chips and 1 Goldengill Trout.")

-- =========================
-- Add Rocked to Sleep Waypoints Button (Smart Version)
-- =========================
local ROCKED_TO_SLEEP_ID = 40504

local addWaypointsBtn = CreateFrame("Button", nil, slateOfTheUnionFrame, "UIPanelButtonTemplate")
addWaypointsBtn:SetSize(300, 30)
addWaypointsBtn:SetPoint("BOTTOMRIGHT", -20, -400)
addWaypointsBtn:SetText("Rocked to Sleep (Add Missing to TomTom)")

addWaypointsBtn:SetScript("OnClick", function()
    if not TomTom then
        print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
        return
    end

    local waypoints = {
        { map = 2214, x = 44.42, y = 31.75, title = "Venedaz" },
        { map = 2214, x = 40.20, y = 13.55, title = "Hathlaz" },
        { map = 2214, x = 50.89, y = 30.23, title = "Uisgaz" },
        { map = 2214, x = 58.70, y = 36.34, title = "Attwogaz" },
        { map = 2214, x = 59.91, y = 55.76, title = "Sathilga" },
        { map = 2214, x = 61.26, y = 83.78, title = "Gundrig" },
        { map = 2214, x = 55.04, y = 93.71, title = "Merunth" },
        { map = 2214, x = 44.38, y = 70.67, title = "Alfritha" },
        { map = 2214, x = 45.22, y = 49.03, title = "Varerko" },
        { map = 2214, x = 38.97, y = 40.87, title = "Krattdaz" },
    }

    local added = 0
    local missing = {}

    -- Iterate over achievement criteria and match to waypoint names
    local numCriteria = GetAchievementNumCriteria(ROCKED_TO_SLEEP_ID)
    for i = 1, numCriteria do
        local critName, _, completed = GetAchievementCriteriaInfo(ROCKED_TO_SLEEP_ID, i)
        if critName and not completed then
            -- Find matching waypoint by title
            for _, wp in ipairs(waypoints) do
                if string.find(string.lower(wp.title), string.lower(critName), 1, true) then
                    TomTom:AddWaypoint(wp.map, wp.x / 100, wp.y / 100, { title = wp.title })
                    added = added + 1
                    table.insert(missing, wp.title)
                    break
                end
            end
        end
    end

    if added > 0 then
        print("|cff00ff00[Muus Meta Helper]|r Added " .. added .. " missing Rocked to Sleep waypoints to TomTom!")
        print("|cffffff00Missing NPCs:|r " .. table.concat(missing, ", "))
    else
        print("|cff00ff00[Muus Meta Helper]|r You've completed Rocked to Sleep! No plaques.")
    end
end)

local addTreasureWaypointsBtn = CreateFrame("Button", nil, slateOfTheUnionFrame, "UIPanelButtonTemplate")
addTreasureWaypointsBtn:SetSize(250, 30)
addTreasureWaypointsBtn:SetPoint("BOTTOMRIGHT", -20, -450)
addTreasureWaypointsBtn:SetText("Treasures of the Isle of Dorn Waypoints")

addTreasureWaypointsBtn:SetScript("OnClick", function()
    if not TomTom then
        print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
        return
    end

    -- Map ID for this zone (replace 2214 if it's different)
    local mapID = 2214

    local waypoints = {
        { x = 48.59, y = 30.07, title = "Tree's Treasure NPC" },
        { x = 38.36, y = 41.94, title = "Tree's Treasure Crab 1 (on the tree)" },
        { x = 19.71, y = 58.44, title = "Tree's Treasure Crab 2 (at the tree)" },
        { x = 50.71, y = 70.55, title = "Tree's Treasure Crab 3 (at the tree)" },
        { x = 74.90, y = 49.69, title = "Tree's Treasure Crab 4 (at the tree)" },
        { x = 70.75, y = 20.01, title = "Tree's Treasure Crab 5 (on the rock)" },
        { x = 41.82, y = 27.04, title = "Tree's Treasure Crab 6 (at the tree)" },

        { x = 40.65, y = 59.88, title = "Magical Treasure Chest" },

        { x = 55.02, y = 65.62, title = "Mushroom Cap (NPC)" },
        { x = 53.07, y = 68.33, title = "Mushroom Cap (Hat at the tree)" },

        { title = "Mosswool Flower" },
        { x = 77.27, y = 24.48, title = "Jade Pearl" },
        { x = 56.17, y = 60.91, title = "Infused Cinderbrew" },
        { x = 40.89, y = 73.80, title = "Turtle's Thanks" },

        { x = 54.00, y = 19.14, title = "Mysterious Orb (NPC)" },
        { x = 53.05, y = 18.57, title = "Mysterious Orb (pearl at the bottom of waterfall)" },

        { x = 38.05, y = 43.54, title = "Thak's Treasure" },
        { x = 62.53, y = 43.20, title = "Kobold Pickaxe" },
        { x = 48.88, y = 60.92, title = "Shimmering Opal Lily (bottom of cave)" },
        { x = 59.11, y = 23.51, title = "Web-Wrapped Axe" },
    }

    local added = 0
    for _, wp in ipairs(waypoints) do
        if wp.x and wp.y then
            TomTom:AddWaypoint(mapID, wp.x / 100, wp.y / 100, { title = wp.title })
            added = added + 1
        else
            print("|cffffff00[Muus Meta Helper]|r Skipped waypoint: " .. wp.title .. " (missing coordinates)")
        end
    end

    print("|cff00ff00[Muus Meta Helper]|r Added " .. added .. " treasure waypoints to TomTom!")
end)

-------------------------------------------------
-- Crystal Chronicled Tab Custom Content
-------------------------------------------------
local crystalChronicled = contentFrames[4]  -- make sure index matches your tab

-- Scroll frame container
local scrollFrame = CreateFrame("ScrollFrame", nil, crystalChronicled, "UIPanelScrollFrameTemplate")
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
paragraph:SetText("|cff00ff00Adventurer of Hallowfall|r: Consider downloading the addon 'rarescanner' to help here. Rares are best farmed WM On. Most of these might be acquired while trying to get Loremaster of Khaz'algar or Khaz Algar Diplomat as they can be farmed for Rep.\n\n|cff00ff00The Missing Lynx|r: Several Lynx require a Keyflame or Lesser keyflame to be active. Simply go to the nearby Keyflame and spend the items until it lights up.\n\n|cff00ff00Biblo Archivist|r: You will need to go around and collect books. They are lootable items (i.e. on the ground) right click to loot them. Click the button below to import any remaining way points in Tom Tom.\n\n|cff00ff00Sharing the Light|r: Acheivement Guide here\n\n|cff00ff00Igniting the Keyflames|r: Simply loot these off the mobs near the keyflames. It is likely this will happen on its own, particularly as you complete the acheivement Beacon of Hope.\n\n|cff00ff00Treasures of Hallowfall|r: You will need to fly around and collect various treasures around Hallowfall, the button below will import all remaining waypoints into Tom Tom.\n\n|cff00ff00Mereldar Menace|r: Acheivement Guide here\n\n|cff00ff00Beacon of Hope|r: Acheivement Guide here\n\n|cff00ff00Lost and Found|r: Acheivement Guide here\n\n|cff00ff00Children's Entertainer|r: This is reliant on the world quest 'Work Hard, Play Hard' in Hallowfall. It can be completed in one sitting using multiple alts. Recommend using a Warlock to complete the Floor is Undersea challenge by putting a summon circle at the end post on the fence. Note: Never do 'Challenges' first as they count as multiple completions. Do as many regular versions before completing a single challenge version. For the hide and seek Challenge\n\n")

-- =========================
-- Add Missing Lynx Waypoints Button
-- =========================
local MISSING_LYNX_ID = 40625

local addWaypointsBtn = CreateFrame("Button", nil, crystalChronicled, "UIPanelButtonTemplate")
addWaypointsBtn:SetSize(300, 30)
addWaypointsBtn:SetPoint("BOTTOMRIGHT", -20, -400)
addWaypointsBtn:SetText("The Missing Lynx (Add Missing to TomTom)")

addWaypointsBtn:SetScript("OnClick", function()
    if not TomTom then
        print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
        return
    end

    local missingLynxWaypoints = {
        { map = 2215, x = 42.69, y = 53.84, title = "Evan and Emery" },
        { map = 2215, x = 42.30, y = 53.81, title = "Jinx and Gobbo" },
        { map = 2215, x = 69.27, y = 43.72, title = "Iggy and Moog" },
        { map = 2215, x = 64.44, y = 18.57, title = "Fuzzy and Furball" },
        { map = 2215, x = 61.92, y = 20.81, title = "Dander" },
        { map = 2215, x = 63.79, y = 29.32, title = "Purrlock (Available when Light's Blooming Keyflame is active)" },
        { map = 2215, x = 63.26, y = 28.11, title = "Shadowpounder (Available when Light's Blooming Keyflame is active)" },
        { map = 2215, x = 61.19, y = 30.54, title = "Miral Murder-Mittens" },
        { map = 2215, x = 63.31, y = 29.41, title = "Nightclaw (Available when Light's Blooming Keyflame is active)" },
        { map = 2215, x = 60.42, y = 60.22, title = "Magpie" },
    }

    local added = 0
    local missing = {}

    -- Iterate over achievement criteria and match to waypoint names
    local numCriteria = GetAchievementNumCriteria(MISSING_LYNX_ID)
    for i = 1, numCriteria do
        local critName, _, completed = GetAchievementCriteriaInfo(MISSING_LYNX_ID, i)
        if critName and not completed then
            -- Find matching waypoint by title
            for _, wp in ipairs(missingLynxWaypoints) do
                if string.find(string.lower(wp.title), string.lower(critName), 1, true) then
                    TomTom:AddWaypoint(wp.map, wp.x / 100, wp.y / 100, { title = wp.title })
                    added = added + 1
                    table.insert(missing, wp.title)
                    break
                end
            end
        end
    end

    if added > 0 then
        print("|cff00ff00[Muus Meta Helper]|r Added " .. added .. " missing 'Missing Lynx' waypoints to TomTom!")
        print("|cffffff00Missing NPCs:|r " .. table.concat(missing, ", "))
    else
        print("|cff00ff00[Muus Meta Helper]|r You've completed Missing Lynx! No lynx left to pat.")
    end
end)

-- =========================
-- Add Treasures of Hallowfall Waypoints Button
-- =========================
local addTreasureWaypointsBtn = CreateFrame("Button", nil, crystalChronicled, "UIPanelButtonTemplate")
addTreasureWaypointsBtn:SetSize(280, 30)
addTreasureWaypointsBtn:SetPoint("BOTTOMRIGHT", -20, -490)
addTreasureWaypointsBtn:SetText("Treasures of Hallowfall Waypoints")

addTreasureWaypointsBtn:SetScript("OnClick", function()
    if not TomTom then
        print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
        return
    end

    local mapID = 2215
    local achievementID = 40848 -- Treasures of Hallowfall

    -- Define all known treasures and their related criteria names
    local waypoints = {
        { x = 41.79, y = 58.27, title = "Caesper Lynx" },
        { x = 69.25, y = 43.97, title = "Torran Dellain (Buy Meaty Haunch)" },
        { x = 55.14, y = 51.85, title = "Smuggler's Treasure (Collect key from dead NPC below)" },
        { x = 59.71, y = 60.58, title = "Dark Ritual (In the cave)" },
        { x = 40.03, y = 51.12, title = "Arathi Loremaster (NPC)" },
        { x = 68.68, y = 41.59, title = "Palawltar's Codex of Dimensional Structure" },
        { x = 69.34, y = 43.94, title = "Care and Feeding of the Imperial Lynx" },
        { x = 64.18, y = 28.12, title = "Shadow Curfew Guidelines" },
        { x = 56.58, y = 65.18, title = "Beledar - The Emperor's Vision" },
        { x = 70.22, y = 56.84, title = "The Song of Renilash" },
        { x = 48.15, y = 39.59, title = "The Big Book of Arathi Idioms" },
        { x = 55.36, y = 27.20, title = "Kobyss Shadeshaper (Sunless Lure)" },
        { x = 47.61, y = 18.54, title = "Murkfin Depthstalker (Murkfin Lure)" },
        { x = 50.65, y = 50.37, title = "Hungering Shimmerfin" },
        { x = 34.96, y = 54.65, title = "Ragefin Necromancer (Ragefin Necrostaff)" },
        { x = 55.72, y = 69.60, title = "Jewel of the Cliffs" },
        { x = 30.23, y = 38.75, title = "Windswept Satchel" },
        { x = 50.07, y = 13.85, title = "Lost Memento" },
        { title = "Sky-Captain's Sunken Cache" },
        { x = 57.65, y = 27.44, title = "Illuminated Footlocker" },
        { x = 76.16, y = 53.99, title = "Spore-Covered Coffer" },
    }

    -- Track missing criteria
    local missing = {}

    local numCriteria = GetAchievementNumCriteria(achievementID)
    if numCriteria then
        for i = 1, numCriteria do
            local critName, _, critCompleted = GetAchievementCriteriaInfo(achievementID, i)
            if critName and not critCompleted then
                -- Match the criterion to a waypoint by fuzzy name match
                for _, wp in ipairs(waypoints) do
                    if string.find(string.lower(wp.title), string.lower(critName), 1, true) then
                        table.insert(missing, wp)
                        break
                    end
                end
            end
        end
    end

    -- If no missing treasures found
    if #missing == 0 then
        print("|cff00ff00[Muus Meta Helper]|r All 'Treasures of Hallowfall' found or already completed!")
        return
    end

    -- Add waypoints only for missing treasures
    for _, wp in ipairs(missing) do
        if wp.x and wp.y then
            TomTom:AddWaypoint(mapID, wp.x / 100, wp.y / 100, { title = wp.title })
        end
    end

    print("|cff00ff00[Muus Meta Helper]|r Added " .. #missing .. " missing 'Treasures of Hallowfall' waypoints to TomTom!")
end)

-- =========================
-- Add Biblo Archivist Waypoints Button
-- =========================
local BIBLO_ARCHIVIST_ACH_ID = 40622

local addWaypointsBtn = CreateFrame("Button", nil, crystalChronicled, "UIPanelButtonTemplate")
addWaypointsBtn:SetSize(300, 30)
addWaypointsBtn:SetPoint("BOTTOMRIGHT", -20, -450)
addWaypointsBtn:SetText("The Biblo Archivist (Add Missing to TomTom)")

addWaypointsBtn:SetScript("OnClick", function()
    if not TomTom then
        print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
        return
    end

    local booksWaypoints = {
        { map = 2215, x = 43.91, y = 49.95, title = "500 Dishes Using Cave Fish and Mushrooms" },
        { map = 2215, x = 48.11, y = 39.56, title = "The Big Book of Arathi Idioms" },
        { map = 2215, x = 48.75, y = 64.71, title = "Palawltar's Codex of Dimensional Structure" },
        { map = 2215, x = 52.64, y = 60.01, title = "Lightspark Grade Book" },
        { map = 2215, x = 56.56, y = 65.18, title = "Beledar - The Emperor's Vision" },
        { map = 2215, x = 57.79, y = 51.77, title = "From the Depths They Come" },
        { map = 2215, x = 59.81, y = 22.11, title = "Shadow Curfew Journal" },
        { map = 2215, x = 64.21, y = 28.09, title = "Shadow Curfew Guidelines" },
        { map = 2215, x = 68.69, y = 41.42, title = "Light's Gambit Playbook" },
        { map = 2215, x = 69.36, y = 43.98, title = "Care and Feeding of the Imperial Lynx" },
        { map = 2215, x = 70.21, y = 56.85, title = "The Song of Renilash" },
    }

    local added = 0
    local missing = {}

    -- Iterate over achievement criteria and match to waypoint names
    local numCriteria = GetAchievementNumCriteria(BIBLO_ARCHIVIST_ACH_ID)
    for i = 1, numCriteria do
        local critName, _, completed = GetAchievementCriteriaInfo(BIBLO_ARCHIVIST_ACH_ID, i)
        if critName and not completed then
            -- Find matching waypoint by title
            for _, wp in ipairs(missingLynxWaypoints) do
                if string.find(string.lower(wp.title), string.lower(critName), 1, true) then
                    TomTom:AddWaypoint(wp.map, wp.x / 100, wp.y / 100, { title = wp.title })
                    added = added + 1
                    table.insert(missing, wp.title)
                    break
                end
            end
        end
    end

    if added > 0 then
        print("|cff00ff00[Muus Meta Helper]|r Added " .. added .. " missing 'Biblo Archivist' waypoints to TomTom!")
        print("|cffffff00Missing NPCs:|r " .. table.concat(missing, ", "))
    else
        print("|cff00ff00[Muus Meta Helper]|r You've completed Biblo Archivist! You've collected all the books.")
    end
end)

-------------------------------------------------
-- Delve Loremaster Tab Custom Content
-------------------------------------------------
local delveLoremasterFrame = contentFrames[6]

local delveTitleContent = CreateFrame("Frame", nil, delveLoremasterFrame)
delveTitleContent:SetSize(360, 220)
delveTitleContent:SetPoint("TOPLEFT", 0, 70)
local delveLoremasterHeader = delveTitleContent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
delveLoremasterHeader:SetPoint("CENTER")
delveLoremasterHeader:SetText("Delve Loremaster Remaining Stories")

-- =========================
-- Scrollable Frame: Progress Output
-- =========================
local progressScroll = CreateFrame("ScrollFrame", nil, delveLoremasterFrame, "UIPanelScrollFrameTemplate")
progressScroll:SetPoint("TOPLEFT", 20, -50)
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
tipsScroll:SetPoint("TOPLEFT", 20, -270) -- below the progress frame
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
    ["Spiral Weave"] = "https://imgur.com/a/ZPZp0FE",
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
local startY = -500

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