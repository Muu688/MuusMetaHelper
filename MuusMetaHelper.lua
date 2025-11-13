local ADDON_NAME = ...

-- Tab definitions
local TAB_NAMES = { "Overview", "Slate of the Union", "Rage Aside the Machine", "Crystal Chronicled", "Azj the World Turns", "Glory of the Delver", "Going Goblin Mode", "Unravaled and Persevering", "Owner of a Radiant Heart" }
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
local tabsPerRow = 4
local tabWidth, tabHeight = 175, 24
local tabSpacingX, tabSpacingY = 50, 8
local startX, startY = 20, -40

for i, tabName in ipairs(TAB_NAMES) do
    local tab = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    tab:SetSize(tabWidth, tabHeight)

    local row = math.floor((i - 1) / tabsPerRow)
    local col = (i - 1) % tabsPerRow

    -- Position tabs based on row/column
    local offsetX = startX + (col * (tabWidth + tabSpacingX))
    local offsetY = startY - (row * (tabHeight + tabSpacingY))
    tab:SetPoint("TOPLEFT", frame, "TOPLEFT", offsetX, offsetY)

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
    if i == 7 or i == 8 or i == 9 then
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
scrollFrame:SetSize(450, 300)

-- Child frame for the text
local textFrame = CreateFrame("Frame", nil, scrollFrame)
textFrame:SetSize(320, 1) -- width must match scroll frame
scrollFrame:SetScrollChild(textFrame)

-- FontString for paragraph text
local paragraph = textFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
paragraph:SetPoint("TOPLEFT")
paragraph:SetWidth(450)
paragraph:SetJustifyH("LEFT")
paragraph:SetJustifyV("TOP")
paragraph:SetText("Welcome to the Overview tab!\n\nI\'m a new addon developer so things may be shonky/broken but I'm trying my best\n\n|cffff0000Where to start|r: I would start with the Siren Isle (Specifically working towards Siren-ity now) and Khaz Algar Diplomat. Both of those quests are significantly time-gated either requiring specific weekly quests to spawn or, requiring you to get max renown with each faction of which only a certain amount of rep can be obtained each week. While doing those two keep an eye out for any Delve stories you may need for the acheivement |cffffd100[Delve Loremaster]|r\n\nI would consider having a weekly chore-list so that you're not grinding things out late. If you don't have rep with the required base factions consider doing at least,\n- Theatre troop\n- Awakening the Machine\n- Azj-Kahet 4 WQ for pact quest weekly\n- Siren Isle 'Epic Quest' or whatever it is as that's on weekly rotation so you want to be eating those up.\n\n\nThe 'Check World Quests' button will check the world quests needed relating to the acheivments 'Worm Theory' and 'Children's Entertainer' as those are on rotation and may not always be up, it's a good idea to press it regularly and check on what you need. Reach out to me on Discord 'muu0688' for feedback/bug reports.")

-- Make sure frame resizes based on text height
textFrame:SetHeight(paragraph:GetStringHeight())

-- Create a "Check World Quests" button
local checkButton = CreateFrame("Button", nil, overviewFrame, "UIPanelButtonTemplate")
checkButton:SetSize(160, 30)
checkButton:SetPoint("TOP", 500, -450)
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
-- === Right-side "Reset Cadence" Section (aligned with overview scroll box) ===
local rcContainer = CreateFrame("Frame", nil, overviewFrame)
rcContainer:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", 40, 0)  -- anchor to right of overview text
rcContainer:SetSize(350, 400)  -- adjust as needed for spacing

-- Section title
local rcHeader = rcContainer:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
rcHeader:SetPoint("TOP", 0, -10)
rcHeader:SetText("Reset Cadence")

-- Scroll frame for reset cadence content
local rcScroll = CreateFrame("ScrollFrame", nil, rcContainer, "UIPanelScrollFrameTemplate")
rcScroll:SetPoint("TOPLEFT", 10, -40)
rcScroll:SetSize(330, 330)

-- Child frame for scroll content
local rcScrollChild = CreateFrame("Frame", nil, rcScroll)
rcScrollChild:SetSize(330, 1)
rcScroll:SetScrollChild(rcScrollChild)

-- Output text
local rcText = rcScrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
rcText:SetPoint("TOPLEFT")
rcText:SetWidth(310)
rcText:SetJustifyH("LEFT")
rcText:SetJustifyV("TOP")
rcText:SetText("|cffffd100Theatre Troop|r: Available hourly (to farm the varients of for |cffffd100[We're here all night]|r acheivement), however reputation is a Weekly Reset (Council of Dorn Rep)\n\n|cffffd100Awakening the Machine|r: Weekly Reset (Assembly of the Deeps Rep)\n\n|cffffd100Forge A Pact|r: Weekly (Severed Threads Rep)\n\n|cffffd100Weekly Dungeon Quest|r: Weekly (Complete a specific dungeon for Rep of your choice!)\n\n|cffffd100Spreading The Light:|rWeekly variety of quests activated by activating the Keyflames in Hallowfall (This is for |cffffd100[Beacon of Hope])|r\n\n|cffffd100Siren Isle|r: Weekly reset of the varient (Pirate/Vrykul/Naga) for |cffffd100[Clean Up on Isle Siren]|r and a Weekly Reset on Siren Isle Weekly Quest for |cffffd100[Siren-ity Now]|r\n\n|cffffd100Rares|r: Weekly (150 Rep to Faction of the zone the rare spawns in)\n\n")

rcScrollChild:SetHeight(rcText:GetStringHeight())

-------------------------------------------------
-- Meta Achievement Progress Tracker
-------------------------------------------------
-- Place this section lower in the Overview tab
local metaFrame = CreateFrame("Frame", "MetaAchievementProgressFrame", overviewFrame)
metaFrame:SetSize(300, 300)
metaFrame:SetPoint("TOPLEFT", 20, -450)  -- move below intro scroll box

-- Scroll Frame
local scroll = CreateFrame("ScrollFrame", nil, metaFrame, "UIPanelScrollFrameTemplate")
scroll:SetPoint("TOPLEFT", 0, 0)
scroll:SetSize(350, 350)

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
-- Rage Aside The Machine Tab Custom Content
-------------------------------------------------
local rageAsideTheMachineFrame = contentFrames[3]

-- Scroll frame container
local RATMScrollFrame = CreateFrame("ScrollFrame", nil, rageAsideTheMachineFrame, "UIPanelScrollFrameTemplate")
RATMScrollFrame:SetPoint("TOPLEFT", 20, -80)
RATMScrollFrame:SetSize(400, 500)

-- Child frame for the text
local RATMTextFrame = CreateFrame("Frame", nil, RATMScrollFrame)
RATMTextFrame:SetSize(320, 1) -- width must match scroll frame
RATMScrollFrame:SetScrollChild(RATMTextFrame)

-- FontString for paragraph text
local RATMParagraph = RATMTextFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
RATMParagraph:SetPoint("TOPLEFT")
RATMParagraph:SetWidth(300)
RATMParagraph:SetJustifyH("LEFT")
RATMParagraph:SetJustifyV("TOP")
RATMParagraph:SetText("|cff00ff00Adventurer of The Ringing Deeps|r: Consider downloading the addon 'rarescanner' to help here. Rares are best farmed WM On. Most of these might be acquired while trying to get Loremaster of Khaz'algar or Khaz Algar Diplomat as they can be farmed for Rep.\n\n|cff00ff00It's Not Much, But It's Honest Work|r: This acheivement has to be super easy, especially for anyone with some gear. Just do the Awakening the Machine is Gundargaz. Punch through all 20 waves yee-yaw lets go.\n\n|cff00ff00Notable Machines|r: Read all 6 notes on the machine speakers. Click the button to import the waypoints!\n\n|cff00ff00To All The Slimes I Love|r: Travel around The ringing deeps and /love each of the critters mentioned in the acheivement. Click the button on the right to import all remaining waypoints for the acheivment.\n\n|cff00ff00Treasures of the Ringing Deeps|r: You will need to fly around and collect various treasures around The Ringing Deeps, the button below will import all remaining waypoints into Tom Tom.\n\n|cff00ff00Super Size Snuffling|r: Fly around The Ringing Deeps looking for globs of wax on the ground/disturbed earth. They have a purple outline. Right click on it and complete the event to gain the wax. Repeat until finished.\n\n|cff00ff00Not So Quick Fix|r: Travel around the ringing deeps and repair 6 of the broken consoles. There is a button on the right to import all the remaining console waypoints!\n\n")

-- =========================
-- Button setup
-- =========================
local buttonWidth = 300
local buttonHeight = 30
local spacing = 10
local anchorX, anchorY = 500, -100

local buttonsData = {
    { text = "Notable Machines (Add Missing to TomTom)", func = function()
        if not TomTom then
            print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
            return
        end

        local NOTABLE_MACHINES_ID = 40628
        local missingMachinesWaypoints = {
            { map = 2214, x = 41.70, y = 28.80, title = "Notes on the Machine Speakers: Fragment I" },
            { map = 2214, x = 44.70, y = 25.90, title = "Notes on the Machine Speakers: Fragment II" },
            { map = 2214, x = 46.90, y = 14.50, title = "Notes on the Machine Speakers: Fragment III" },
            { map = 2214, x = 35.70, y = 21.00, title = "Notes on the Machine Speakers: Fragment IV" },
            { map = 2214, x = 59.50, y = 58.80, title = "Notes on the Machine Speakers: Fragment V" },
            { map = 2214, x = 60.90, y = 79.60, title = "Notes on the Machine Speakers: Fragment VI" },
        }

        local added = 0
        local missing = {}

        local numCriteria = GetAchievementNumCriteria(NOTABLE_MACHINES_ID)
        for i = 1, numCriteria do
            local critName, _, completed = GetAchievementCriteriaInfo(NOTABLE_MACHINES_ID, i)
            if critName and not completed then
                for _, wp in ipairs(missingMachinesWaypoints) do
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
            print("|cff00ff00[Muus Meta Helper]|r Added " .. added .. " missing 'Notable Machines' waypoints to TomTom!")
            print("|cffffff00Missing NPCs:|r " .. table.concat(missing, ", "))
        else
            print("|cff00ff00[Muus Meta Helper]|r You've completed Notable Machines!")
        end
    end },
    { text = "To All The Slimes I Love (Add Missing to TomTom)", func = function()
        if not TomTom then
            print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
            return
        end

        local TO_ALL_THE_SLIMES_I_LOVE_ID = 40475
        local missingRingingDeepsBugsWaypoints = {
            { map = 2214, x = 44.50, y = 12.57, title = "Lava Slug" },
            { map = 2214, x = 41.78, y = 13.52, title = "Earthenwork Stoneskitterer" },
            { map = 2214, x = 38.42, y = 14.37, title = "Rock Snail" },
            { map = 2214, x = 47.28, y = 15.43, title = "Snake" },
            { map = 2214, x = 38.01, y = 16.38, title = "Dustcrawler Beetle" },
            { map = 2214, x = 38.01, y = 16.38, title = "Cavern Mote" },
            { map = 2214, x = 50.67, y = 29.92, title = "Crackcreeper" },
            { map = 2214, x = 57.96, y = 30.27, title = "Stumblegrub" },
            { map = 2214, x = 60.53, y = 32.38, title = "Lightdarter" },
            { map = 2214, x = 50.41, y = 34.73, title = "Darkgrotto Hopper" },
            { map = 2214, x = 60.84, y = 41.43, title = "Oozeling (Cave Entrance, go in)" },
            { map = 2214, x = 69.26, y = 41.66, title = "Cavern Skiplet (Around that area)" },
            { map = 2214, x = 55.40, y = 45.92, title = "Pebble Scarab" },
            { map = 2214, x = 48.85, y = 54.73, title = "Tiny Sporbit" },
            { map = 2214, x = 53.30, y = 65.74, title = "Moss Sludglet" },
            { map = 2214, x = 53.48, y = 67.64, title = "Spring Mole" },
            { map = 2214, x = 54.79, y = 68.61, title = "Grottoscale Hatchling" },
            { map = 2214, x = 56.31, y = 92.21, title = "Mass of Worms" },
        }
        local added = 0
        local missing = {}

        local numCriteria = GetAchievementNumCriteria(TO_ALL_THE_SLIMES_I_LOVE_ID)
        for i = 1, numCriteria do
            local critName, _, completed = GetAchievementCriteriaInfo(TO_ALL_THE_SLIMES_I_LOVE_ID, i)
            if critName and not completed then
                for _, wp in ipairs(missingRingingDeepsBugsWaypoints) do
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
            print("|cff00ff00[Muus Meta Helper]|r Added " .. added .. " missing 'To All The Slimes I Love' waypoints to TomTom!")
            print("|cffffff00Missing NPCs:|r " .. table.concat(missing, ", "))
        else
            print("|cff00ff00[Muus Meta Helper]|r You've completed To All The Slimes I Love!")
        end
    end },
    
    { text = "Treasures of The Ringing Deeps Waypoints", func = function()
        if not TomTom then
            print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
            return
        end

        local mapID = 2214
        local achievementID = 40724
        local treasuresOfHallowfallWaypoints = {
            { map = 2214, x = 64.86, y = 38.83, title = "Webbed Knapsack" },
            { map = 2214, x = 51.40, y = 13.85, title = "Munderut's Forgotten Stash" },
            { map = 2214, x = 62.20, y = 33.42, title = "Waterlogged Refuse" },
            { map = 2214, x = 55.01, y = 64.37, title = "Kaja'Cola Machine (ORDER: Bluesberry Blast > Orange O-pocalypse > Oyster Outburst > Mangoro Mania)" },
            { map = 2214, x = 44.90, y = 31.60, title = "Dusty Prospector's Chest" },
            { map = 2214, x = 53.20, y = 21.80, title = "Dusty Chest Gem (Amethyst)" },
            { map = 2214, x = 55.00, y = 38.00, title = "Dusty Chest Gem (Emerald)" },
            { map = 2214, x = 64.10, y = 53.10, title = "Dusty Chest Gem (Diamond)" },
            { map = 2214, x = 53.40, y = 49.40, title = "Dusty Chest Gem (Ruby)" },
            { map = 2214, x = 58.50, y = 63.00, title = "Dusty Chest Gem (Topaz)" },
            { map = 2214, x = 59.10, y = 63.11, title = "Cursed Pickaxe" },
            { map = 2214, x = 41.51, y = 17.45, title = "Discarded Toolbox" },
            { map = 2214, x = 54.94, y = 30.31, title = "Scary Dark Chest" },
            { map = 2214, x = 44.25, y = 48.96, title = "Dislodged Blockage" },
            { map = 2214, x = 48.31, y = 53.20, title = "Forgotten Treasure" },
        }

        local missing = {}
        local numCriteria = GetAchievementNumCriteria(achievementID)
        if numCriteria then
            for i = 1, numCriteria do
                local critName, _, critCompleted = GetAchievementCriteriaInfo(achievementID, i)
                if critName and not critCompleted then
                    for _, wp in ipairs(treasuresOfHallowfallWaypoints) do
                        if string.find(string.lower(wp.title), string.lower(critName), 1, true) then
                            table.insert(missing, wp)
                            break
                        end
                    end
                end
            end
        end
        
        if #missing > 0 then
            for _, wp in ipairs(missing) do
                TomTom:AddWaypoint(mapID, wp.x / 100, wp.y / 100, { title = wp.title })
            end
            print("|cff00ff00[Muus Meta Helper]|r Added " .. #missing .. " missing 'Treasures of The Ringing Deeps' waypoints to TomTom!")
        else
            print("|cff00ff00[Muus Meta Helper]|r All 'Treasures of The Ringing Deeps' waypoints already completed!")
        end
    end },

    { text = "Not So Quick Fix (Add Missing to TomTom)", func = function()
        if not TomTom then
            print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
            return
        end

        local NOT_SO_QUICK_FIX_ID = 40473
        local missingConsolesWaypoints = {
            { map = 2214, x = 42.12, y = 14.12, title = "Earthen Console" },
            { map = 2214, x = 52.22, y = 22.54, title = "Lost Console" },
            { map = 2214, x = 41.16, y = 46.40, title = "Water Console" },
            { map = 2214, x = 64.90, y = 48.79, title = "Obsidian Console" },
            { map = 2214, x = 59.54, y = 61.14, title = "Taelloch Console" },
            { map = 2214, x = 54.86, y = 93.37, title = "Abyssal Console" },
        }

        local added = 0
        local missing = {}

        local numCriteria = GetAchievementNumCriteria(NOT_SO_QUICK_FIX_ID)
        for i = 1, numCriteria do
            local critName, _, completed = GetAchievementCriteriaInfo(NOT_SO_QUICK_FIX_ID, i)
            if critName and not completed then
                for _, wp in ipairs(missingConsolesWaypoints) do
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
            print("|cff00ff00[Muus Meta Helper]|r Added " .. added .. " missing 'Not So Quick Fix' waypoints to TomTom!")
            print("|cffffff00Missing NPCs:|r " .. table.concat(missing, ", "))
        else
            print("|cff00ff00[Muus Meta Helper]|r You've completed Not So Quick Fix!")
        end
    end },
}

-- Dynamically create buttons
for i, data in ipairs(buttonsData) do
    local btn = CreateFrame("Button", nil, rageAsideTheMachineFrame, "UIPanelButtonTemplate")
    btn:SetSize(buttonWidth, buttonHeight)
    btn:SetPoint("TOPLEFT", anchorX, anchorY - ((i - 1) * (buttonHeight + spacing)))
    btn:SetText(data.text)
    btn:SetScript("OnClick", data.func)
end

-------------------------------------------------
-- Crystal Chronicled Tab Custom Content
-------------------------------------------------
local crystalChronicled = contentFrames[4]  -- make sure index matches your tab

-- Scroll frame container
local scrollFrame = CreateFrame("ScrollFrame", nil, crystalChronicled, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 20, -80)
scrollFrame:SetSize(400, 500)

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
paragraph:SetText("|cff00ff00Adventurer of Hallowfall|r: Consider downloading the addon 'rarescanner' to help here. Rares are best farmed WM On. Most of these might be acquired while trying to get Loremaster of Khaz'algar or Khaz Algar Diplomat as they can be farmed for Rep.\n\n|cff00ff00The Missing Lynx|r: Several Lynx require a Keyflame or Lesser keyflame to be active. Simply go to the nearby Keyflame and spend the items until it lights up.\n\n|cff00ff00Biblo Archivist|r: You will need to go around and collect books. They are lootable items (i.e. on the ground) right click to loot them. Click the button below to import any remaining way points in Tom Tom.\n\n|cff00ff00Sharing the Light|r: Click the below button to import remaining waypoints for Keyflame events you have NOT completed.\n\n|cff00ff00Igniting the Keyflames|r: Simply loot these off the mobs near the keyflames. It is likely this will happen on its own, particularly as you complete the acheivement Beacon of Hope.\n\n|cff00ff00Treasures of Hallowfall|r: You will need to fly around and collect various treasures around Hallowfall, the button below will import all remaining waypoints into Tom Tom.\n\n|cff00ff00Mereldar Menace|r: This one was a bit finicky, but not very complex. There are Three stones:\n1. /way #2215 41/89 55.52 Orphanage\n2: /way #2215 42.26 52.54 Training Ground\n3: /way #2215 44.24 51.23 Steelstrike Residence\n You will need to go to each of these locations and click the little stone on the ground and throw it at the various places/buildings the acheivement mentions. \n\n|cff00ff00Beacon of Hope|r: You will need to travel around the keyflame area in Hallowfall. There is a lesser keyflame button below to add waypoints to Tom Tom which shows where these keyflames are. Once you've spent 3 shards on the keyflame, an NPC will come out and offer the quest.\n\n|cff00ff00Lost and Found|r: This acheivement is time-gated to a minimum of three weeks. You will need to unlock and complete the quest 'Time Lost' wait til Weekly reset then complete Time Found, wait again til Weekly Reset then complete Time Borrowed. Each quest gives you two items\n\n|cff00ff00Children's Entertainer|r: This is reliant on the world quest 'Work Hard, Play Hard' in Hallowfall. It can be completed in one sitting using multiple alts. Recommend using a Warlock to complete the Floor is Undersea challenge by putting a summon circle at the end post on the fence. Note: Never do 'Challenges' first as they count as multiple completions. Do as many regular versions before completing a single challenge version. For the hide and seek Challenge\n\n")

-- =========================
-- Button setup
-- =========================
local buttonWidth = 300
local buttonHeight = 30
local spacing = 10
local anchorX, anchorY = 500, -100

local buttonsData = {
    { text = "The Missing Lynx (Add Missing to TomTom)", func = function()
        if not TomTom then
            print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
            return
        end

        local MISSING_LYNX_ID = 40625
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

        local numCriteria = GetAchievementNumCriteria(MISSING_LYNX_ID)
        for i = 1, numCriteria do
            local critName, _, completed = GetAchievementCriteriaInfo(MISSING_LYNX_ID, i)
            if critName and not completed then
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
    end },

    { text = "The Biblo Archivist (Add Missing to TomTom)", func = function()
        if not TomTom then
            print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
            return
        end

        local BIBLO_ARCHIVIST_ACH_ID = 40622
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

        local numCriteria = GetAchievementNumCriteria(BIBLO_ARCHIVIST_ACH_ID)
        for i = 1, numCriteria do
            local critName, _, completed = GetAchievementCriteriaInfo(BIBLO_ARCHIVIST_ACH_ID, i)
            if critName and not completed then
                for _, wp in ipairs(booksWaypoints) do
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
    end },

    { text = "Sharing the Light (Add Missing to TomTom)", func = function()
        if not TomTom then
            print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
            return
        end

        local SHARING_THE_LIGHT_ACH_ID = 40311
        local waypoints = {
            { map = 2215, x = 61.97, y = 12.71, title = "Bleak Sand" },
            { map = 2215, x = 61.90, y = 16.96, title = "Waters of War" },
            { map = 2215, x = 61.83, y = 32.05, title = "Lurking Below" },
            { map = 2215, x = 66.56, y = 23.94, title = "Bog Beast Banishment" },
            { map = 2215, x = 63.48, y = 28.40, title = "Glowing Harvest" },
            { map = 2215, x = 63.90, y = 19.70, title = "The Midnight Sentry" },
            { map = 2215, x = 63.84, y = 32.04, title = "Cutting Edge" },
            { map = 2215, x = 65.01, y = 29.34, title = "A Better Cabbage Smacker" },
        }

        local added = 0
        local missing = {}

        local numCriteria = GetAchievementNumCriteria(SHARING_THE_LIGHT_ACH_ID)
        for i = 1, numCriteria do
            local critName, _, completed = GetAchievementCriteriaInfo(SHARING_THE_LIGHT_ACH_ID, i)
            if critName and not completed then
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
            print("|cff00ff00[Muus Meta Helper]|r Added " .. added .. " missing 'Sharing the Light' waypoints to TomTom!")
            print("|cffffff00Missing NPCs:|r " .. table.concat(missing, ", "))
        else
            print("|cff00ff00[Muus Meta Helper]|r You've completed Sharing the Light!")
        end
    end },

    { text = "Mereldar Menace (Add All to TomTom)", func = function()
        if not TomTom then
            print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
            return
        end

        local stonesWaypoints = {
            { map = 2215, x = 41.89, y = 55.52, title = "Orphanage (Window, Fountain, Spice Stall, Food Stall, Notice board)" },
            { map = 2215, x = 42.33, y = 54.92, title = "Training Ground (Barracks Doorway, Light and Flame, Lamplighters Doorway)" },
            { map = 2215, x = 42.28, y = 54.38, title = "Steelstrike Residence (Holy Oil, Airship Drafting Board)" },
        }

        local added = 0
        for _, wp in ipairs(stonesWaypoints) do
            if wp.x and wp.y then
                TomTom:AddWaypoint(wp.map, wp.x / 100, wp.y / 100, { title = wp.title })
                added = added + 1
            else
                print("|cffffff00[Muus Meta Helper]|r Skipped waypoint: " .. (wp.title or "Unknown") .. " (missing coordinates)")
            end
        end

        print("|cff00ff00[Muus Meta Helper]|r Added " .. added .. " 'Mereldar Menace' waypoints to TomTom!")
    end },

    { text = "Treasures of Hallowfall Waypoints", func = function()
        if not TomTom then
            print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
            return
        end

        local mapID = 2215
        local achievementID = 40848
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
            { x = 57.65, y = 27.44, title = "Illuminated Footlocker" },
            { x = 76.16, y = 53.99, title = "Spore-Covered Coffer" },
        }

        local missing = {}
        local numCriteria = GetAchievementNumCriteria(achievementID)
        if numCriteria then
            for i = 1, numCriteria do
                local critName, _, critCompleted = GetAchievementCriteriaInfo(achievementID, i)
                if critName and not critCompleted then
                    for _, wp in ipairs(waypoints) do
                        if string.find(string.lower(wp.title), string.lower(critName), 1, true) then
                            table.insert(missing, wp)
                            break
                        end
                    end
                end
            end
        end
        
        if #missing > 0 then
            for _, wp in ipairs(missing) do
                TomTom:AddWaypoint(mapID, wp.x / 100, wp.y / 100, { title = wp.title })
            end
            print("|cff00ff00[Muus Meta Helper]|r Added " .. #missing .. " missing 'Treasures of Hallowfall' waypoints to TomTom!")
        else
            print("|cff00ff00[Muus Meta Helper]|r All 'Treasures of Hallowfall' waypoints already completed!")
        end
    end },

    { text = "Add Lesser Keyflames (Beacon of Hope) Waypoints", func = function()
        if not TomTom then
            print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
            return
        end

        local keyflameWaypoints = {
            { map = 2215, x = 65.4, y = 28.1, title = "Lesser Keyflame (Right Between the Gyro-Optics; Seeds of Salvation; Tater Trawl)" },
            { map = 2215, x = 63.3, y = 29.4, title = "Lesser Keyflame (Web of Manipulation; Supply the Effort)" },
            { map = 2215, x = 64.6, y = 30.6, title = "Lesser Keyflame (Lost in Shadows; Sporadic Growth)" },
            { map = 2215, x = 63.6, y = 33.6, title = "Lesser Keyflame (Harvest Havoc; Squashing the Threat)" },
            { map = 2215, x = 64.4, y = 30.9, title = "Lesser Keyflame (The Sweet Eclipse; Shadows of Flavor; Blossoming Delight)" },
            { map = 2215, x = 65.8, y = 24.4, title = "Lesser Keyflame (Hose It Down; Chew On That)" },
            { map = 2215, x = 64.4, y = 18.7, title = "Lesser Keyflame (Lizard Looters; Glow in the Dark)" },
            { map = 2215, x = 61.5, y = 17.5, title = "Lesser Keyflame (Crab Grab)" },
        }

        for _, wp in ipairs(keyflameWaypoints) do
            TomTom:AddWaypoint(wp.map, wp.x / 100, wp.y / 100, { title = wp.title })
        end

        print("|cff00ff00[Muus Meta Helper]|r Added " .. #keyflameWaypoints .. " Lesser Keyflame waypoints to TomTom!")
    end },
}

-- Dynamically create buttons
for i, data in ipairs(buttonsData) do
    local btn = CreateFrame("Button", nil, crystalChronicled, "UIPanelButtonTemplate")
    btn:SetSize(buttonWidth, buttonHeight)
    btn:SetPoint("TOPLEFT", anchorX, anchorY - ((i - 1) * (buttonHeight + spacing)))
    btn:SetText(data.text)
    btn:SetScript("OnClick", data.func)
end

-------------------------------------------------
-- Azj the world Turns Tab Custom Content
-------------------------------------------------
local azjTheWorldTurns = contentFrames[5]  -- make sure index matches your tab

-- Scroll frame container
local azjScrollFrame = CreateFrame("ScrollFrame", nil, azjTheWorldTurns, "UIPanelScrollFrameTemplate")
azjScrollFrame:SetPoint("TOPLEFT", 20, -80)
azjScrollFrame:SetSize(400, 500)

-- Child frame for the text
local azjTextFrame = CreateFrame("Frame", nil, azjScrollFrame)
azjTextFrame:SetSize(320, 1) -- width must match scroll frame
azjScrollFrame:SetScrollChild(azjTextFrame)

-- FontString for paragraph text
local azjParagraph = azjTextFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
azjParagraph:SetPoint("TOPLEFT")
azjParagraph:SetWidth(300)
azjParagraph:SetJustifyH("LEFT")
azjParagraph:SetJustifyV("TOP")
azjParagraph:SetText("|cff00ff00Adventurer of Azj-Kahet|r: Consider downloading the addon 'rarescanner' to help here. Rares are best farmed WM On. Most of these might be acquired while trying to get Loremaster of Khaz'algar or Khaz Algar Diplomat as they can be farmed for Rep.\n\n|cff00ff00You Can't Hang With Us|r: Attack a Sentry at /way 60.79 25.85 until an Eradicator spawns, let his debuff go off on your until you're expelled from the city.\n\n|cff00ff00Worm Theory|r: There are three world quests in the Rak-ush area of Azj-Kahet (Bottom Right). They are not always up. Consider using the Worm Theory button to check if any of the world quests are up, or check the map yourself! :)\n\n|cff00ff00Smelling History|r: You must buy a |cffffd100[Potion of Polymorphic Translaton: Nerubian]|r from Siesbarg at /way 45.10 13. It gives you a 10m buff in which you can read these. This acheivement should be done alongside |cffffd100[Bookworm]|r. Click the button on the right to import all the waypoints of the things to read/interact with.\n\n|cff00ff00Treasures of Azj-Kahet|r: Click the button on the right to import all the waypoints to collect all the treasures. For Corrupted Memory and Memory Cache you will need Unseeming Shift stacks (Click the unseeming waypoint and stand in one of the pools to get these stacks)\n\n|cff00ff00The Unseeming|r: Click the button on the right and find a pool of black blood. Stand in it til the stacks hit 100. You may need some health pots or a healer if you're not geared.\n\n|cff00ff00Itsy Bitsy Spider|r: You will need to wave at several weave rats, the button on the right will import the co-ords into Tom Tom. You must have an active pact and a bundle of rumours/rumour map active to see Ru'murh nad Thimble. To see spindle you must have completed the quest |cffffd100[!Saving Private Spindle]|r.\n\n|cff00ff00Bookworm|r: Refer to [Smelling History guide a few lines up to get this acheivement. They should be done together. If you've already done Smelling History, the button to the right will still only import the waypoints you need.\n\n")

local buttonWidth = 300
local buttonHeight = 30
local spacing = 10
local anchorX, anchorY = 500, -100

local buttonsData = {
    { text = "The Unseeming waypoint", func = function()
        if not TomTom then
            print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
            return
        end

        local theUnseemingWaypoints = {
            { map = 2256, x = 63.40, y = 82.87, title = "The Unseeming" },
        }

        local added = 0
        for _, wp in ipairs(theUnseemingWaypoints) do
            if wp.x and wp.y then
                TomTom:AddWaypoint(wp.map, wp.x / 100, wp.y / 100, { title = wp.title })
                added = added + 1
            else
                print("|cffffff00[Muus Meta Helper]|r Skipped waypoint: " .. (wp.title or "Unknown") .. " (missing coordinates)")
            end
        end

        print("|cff00ff00[Muus Meta Helper]|r Added " .. added .. " 'The Unseeming' waypoints to TomTom!")
    end },
    { text = "Smelling History & Bookworm waypoints", func = function()
        if not TomTom then
            print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
            return
        end

        local achievementIDs = {40542, 40629}

        local theUnseemingWaypoints = {
            { map = 2256, x = 40.10, y = 39.80, title = "Entomological Essay on Grubs, Volume 1" },
            { map = 2256, x = 39.79, y = 40.50, title = "Entomological Essay on Grubs, Volume 1" },
            { map = 2256, x = 39.10, y = 42.59, title = "Entomological Essay on Grubs, Volume 1" },
            { map = 2256, x = 27.71, y = 54.60, title = "Strands of Memory" },
            { map = 2256, x = 38.54, y = 37.74, title = "Treatise on Forms: Skitterlings" },
            { map = 2256, x = 38.22, y = 39.02, title = "Treatise on Forms: Sages" },
            { map = 2256, x = 77.98, y = 41.03, title = "Treatise on Forms: Ascended" },
            { map = 2256, x = 23.64, y = 51.07, title = "Treatise on Forms: Lords" },
            { map = 2256, x = 62.96, y = 31.17, title = "Ethos of War, Part 1" },
            { map = 2256, x = 66.69, y = 31.28, title = "Ethos of War, Part 2" },
            { map = 2256, x = 48.85, y = 24.00, title = "Ethos of War, Part 3" },
            { map = 2256, x = 43.25, y = 25.55, title = "Ethos of War, Part 4" },
            { map = 2256, x = 37.10, y = 32.75, title = "Queen Anub'izek" },
            { map = 2256, x = 38.26, y = 35.55, title = "Queen Xekatha" },
            { map = 2256, x = 38.42, y = 32.27, title = "Queen Zaltra" },
        }
        local missing = {}

        for _, achievementID in ipairs(achievementIDs) do
            local numCriteria = GetAchievementNumCriteria(achievementID)
            if numCriteria then
                for i = 1, numCriteria do
                    local critName, _, critCompleted = GetAchievementCriteriaInfo(achievementID, i)
                    if critName and not critCompleted then
                        for _, wp in ipairs(waypoints) do
                            if string.find(string.lower(wp.title), string.lower(critName), 1, true) then
                                -- avoid duplicates
                                local alreadyAdded = false
                                for _, m in ipairs(missing) do
                                    if m.title == wp.title then
                                        alreadyAdded = true
                                        break
                                    end
                                end
                                if not alreadyAdded then
                                    table.insert(missing, wp)
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
        
        if #missing > 0 then
            for _, wp in ipairs(missing) do
                TomTom:AddWaypoint(mapID, wp.x / 100, wp.y / 100, { title = wp.title })
            end
            print("|cff00ff00[Muus Meta Helper]|r Added " .. #missing .. " missing 'Smelling History & Bookworm' waypoints from all tracked achievements!")
        else
            print("|cff00ff00[Muus Meta Helper]|r All 'Smelling History & Bookworm' waypoints already completed!")
        end 
    end },
    
    { text = "Treasures of Azj-Kahet Waypoints", func = function()
        if not TomTom then
            print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
            return
        end

        local achievementID = 40828
        local waypoints = {
            { map = 2255, x = 62.73, y = 87.90, title = "Corrupted Memory" },
            { map = 2255, x = 74.80, y = 42.83, title = "Weaving Supplies" },
            { map = 2255, x = 49.56, y = 43.70, title = "Nest Egg" },
            { map = 2255, x = 64.33, y = 29.52, title = "Silk-Spun Supplies" },
            { map = 2255, x = 54.45, y = 50.80, title = "Niffen Stash" },
            { map = 2255, x = 62.73, y = 87.90, title = "Memory Cache" },
            { map = 2213, x = 67.39, y = 74.41, title = "Trapped Trove" },
            { map = 2255, x = 67.44, y = 90.72, title = "Disturbed soil" },
            { map = 2255, x = 42.37, y = 72.28, title = "Nerubian Offerings" },
            { map = 2255, x = 38.78, y = 37.22, title = "Missing Scout's Pack" },
        }

        local missing = {}
        local numCriteria = GetAchievementNumCriteria(achievementID)
        if numCriteria then
            for i = 1, numCriteria do
                local critName, _, critCompleted = GetAchievementCriteriaInfo(achievementID, i)
                if critName and not critCompleted then
                    for _, wp in ipairs(waypoints) do
                        if string.find(string.lower(wp.title), string.lower(critName), 1, true) then
                            table.insert(missing, wp)
                            break
                        end
                    end
                end
            end
        end
        
        if #missing > 0 then
            for _, wp in ipairs(missing) do
                TomTom:AddWaypoint(wp.map, wp.x / 100, wp.y / 100, { title = wp.title })
            end
            print("|cff00ff00[Muus Meta Helper]|r Added " .. #missing .. " missing 'Treasures of Azj-Kahet' waypoints to TomTom!")
        else
            print("|cff00ff00[Muus Meta Helper]|r All 'Treasures of Azj-Kahet' waypoints already completed!")
        end
    end },

    { text = "Itsy Bitsy Spider Waypoints", func = function()
        if not TomTom then
            print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
            return
        end

        local achievementID = 40624
        local waypoints = {
            { map = 2255, x = 56.38, y = 42.29, title = "Bobbin" },
            { map = 2255, x = 57.06, y = 41.74, title = "Webster" },
            { map = 2255, x = 55.65, y = 43.93, title = "Spindle" },
            { map = 2255, x = 69.89, y = 82.75, title = "Thimble" },
            { map = 2255, x = 79.60, y = 56.80, title = "Ru'murh" },
            { map = 2255, x = 49.20, y = 15.70, title = "Scampering Weaver-rat" },
        }

        local missing = {}
        local numCriteria = GetAchievementNumCriteria(achievementID)
        if numCriteria then
            for i = 1, numCriteria do
                local critName, _, critCompleted = GetAchievementCriteriaInfo(achievementID, i)
                if critName and not critCompleted then
                    for _, wp in ipairs(waypoints) do
                        if string.find(string.lower(wp.title), string.lower(critName), 1, true) then
                            table.insert(missing, wp)
                            break
                        end
                    end
                end
            end
        end
        
        if #missing > 0 then
            for _, wp in ipairs(missing) do
                TomTom:AddWaypoint(wp.map, wp.x / 100, wp.y / 100, { title = wp.title })
            end
            print("|cff00ff00[Muus Meta Helper]|r Added " .. #missing .. " missing 'Itsy Bitsy Spider' waypoints to TomTom!")
        else
            print("|cff00ff00[Muus Meta Helper]|r All 'Itsy Bitsy Spider' waypoints already completed!")
        end
    end },

}

-- Dynamically create buttons
for i, data in ipairs(buttonsData) do
    local btn = CreateFrame("Button", nil, azjTheWorldTurns, "UIPanelButtonTemplate")
    btn:SetSize(buttonWidth, buttonHeight)
    btn:SetPoint("TOPLEFT", anchorX, anchorY - ((i - 1) * (buttonHeight + spacing)))
    btn:SetText(data.text)
    btn:SetScript("OnClick", data.func)
end
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