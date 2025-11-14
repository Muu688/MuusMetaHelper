-------------------------------------------------
-- Going Goblin Mode Tab Custom Content
-------------------------------------------------
local goingGoblinModeFrame = contentFrames[7]  -- make sure index matches your tab

local ggmHeader = goingGoblinModeFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
ggmHeader:SetPoint("TOP", 0, -100)
ggmHeader:SetText("Going Goblin Mode")

-- Scroll frame container
local scrollFrame = CreateFrame("ScrollFrame", nil, goingGoblinModeFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 20, -125)
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
paragraph:SetText([[
|cff00ff00Adventurer of Undermine|r: Consider downloading the addon 'rarescanner' to help here. Rares are best farmed WM On. Most of these might be acquired while trying to get Loremaster of Khaz'algar or Khaz Algar Diplomat as they can be farmed for Rep.

|cff00ff00Nine-Tenths of the Law|r: Need to travel around Undermine and collect 5 Mega-Mecha parts. The button on the right will import the waypoints. Then combline them by right clicking one of them. Optionally, hand the subsequent quest in for a battle pet.

|cff00ff00That Can-Do Attitude|r: Head over to the Top Right of Undermine (The Beach) /way 60.81, 24.04 and look for small Discarded Cans on the ground. Right click them to kick them. Each can, can be kicked multiple times. Repeat 25 times!

|cff00ff00Treasures of Undermine|r: Go around Undermine and collect various treasures hidden around the place. The button on the right will dynamically import all remaining treasures waypoints.

|cff00ff00Read Between the Lines|r: Another go around and read some books achievement. Great. Click the Add Waypoints button, wander around. Read some books. Profit!

|cff00ff00You're My Friend now|r: For this achievement you will need to grab 5 Rats. I've set the locations up on a button to the right. They can be tricky to spot, so making a macro with the below text will help make them visible!
/tar Grabbable Rat 
/ping [@target]
]])

-- =========================
-- Button setup
-- =========================
local buttonWidth = 300
local buttonHeight = 30
local spacing = 10
local anchorX, anchorY = 500, -100

local buttonsData = {
    { text = "Mega-Mecha Parts (Add Missing to TomTom)", func = function()
    if not TomTom then
        print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
        return
    end

    -- Mega-Mecha hidden quest flags
    local megaMechaParts = {
        { quest = 85072, map = 2346, x = 23.81, y = 45.39, title = "Mega-Mecha Fork" },
        { quest = 85114, map = 2346, x = 71.46, y = 85.88, title = "Mega-Mecha Grease" },
        { quest = 85115, map = 2346, x = 75.14, y = 22.95, title = "Mega-Mecha Gorilla Batteries" },
        { quest = 85116, map = 2346, x = 56.66, y = 55.47, title = "Mega-Mecha Engine" },
        { quest = 85117, map = 2346, x = 34.31, y = 82.86, title = "Mega-Mecha Chassis" },
    }

    local added = 0
    local missing = {}

    -- Check each quest flag
    for _, part in ipairs(megaMechaParts) do
        local completed = C_QuestLog.IsQuestFlaggedCompleted(part.quest)

        if not completed then
            TomTom:AddWaypoint(part.map, part.x / 100, part.y / 100, { title = part.title })
            table.insert(missing, part.title)
            added = added + 1
        end
    end

    -- Output messages
    if added > 0 then
        print("|cff00ff00[Muus Meta Helper]|r Added " .. added .. " missing Mega-Mecha part waypoints!")
        print("|cffffff00Missing parts:|r " .. table.concat(missing, ", "))
    else
        print("|cff00ff00[Muus Meta Helper]|r Mega-Mecha complete! No missing parts.")
    end
end },

{ text = "Treasures of Undermine Waypoints", func = function()
    if not TomTom then
        print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
        return
    end

    local mapID = 2346
    local achievementID = 41217

    local waypoints = {
        { x = 48.45, y = 42.93, title = "Unexploded Fireworks" },
        { x = 57.84, y = 52.69, title = "Fireworks Hat" },
        { x = 38.96, y = 59.63, title = "Blackened Dice" },
        { x = 69.65, y = 21.64, title = "Potent Potable" },
        { x = 74.65, y = 80.12, title = "Papa's Prized Putter" },
        { x = 39.38, y = 61.07, title = "Particularly Nice Lamp" },
        { x = 63.81, y = 32.20, title = "Marooned Floatmingo" },
        { x = 42.28, y = 82.31, title = "Crumpled Schematics" },
        { x = 49.88, y = 66.18, title = "Suspicious Book" },
        { x = 49.70, y = 90.27, title = "Exploded Plunger" },
        { x = 59.25, y = 18.87, title = "Lonely Tub" },
        { x = 40.84, y = 21.27, title = "Abandoned Toolbox" },
        { x = 26.69, y = 42.88, title = "Unsupervised Takeout" },
        { x = 53.41, y = 52.74, title = "Uncracked Cold Ones" },
        { x = 43.64, y = 51.55, title = "Trick Deck of Cards" },
    }

    local missing = {}
    local numCriteria = GetAchievementNumCriteria(achievementID)

    if numCriteria and numCriteria > 0 then
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
    else
        -- If achievementID is missing or unknown, fallback: add ALL waypoints
        missing = waypoints
    end

    if #missing > 0 then
        for _, wp in ipairs(missing) do
            TomTom:AddWaypoint(mapID, wp.x / 100, wp.y / 100, { title = wp.title })
        end
        print("|cff00ff00[Muus Meta Helper]|r Added " .. #missing .. " missing 'Treasures of Undermine' waypoints to TomTom!")
    else
        print("|cff00ff00[Muus Meta Helper]|r All 'Treasures of Undermine' treasures already completed!")
    end
end },
{ text = "Read Between the Lines Waypoints", func = function()
    if not TomTom then
        print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
        return
    end

    local achievementID = 41588

    local waypoints = {
        { map = 2214, x = 72.91, y = 73.14, title = "Rocket Drill Safety Manual" },
        { map = 2346, x = 40.40, y = 28.51, title = "First Half of Noggenfogger's Journal" },
        { map = 2214, x = 68.02, y = 96.50, title = "Extractor Drill X-78 Safety Guide" },
        { map = 2346, x = 65.62, y = 14.21, title = "Misplaced Work Order" },
        { map = 2346, x = 27.31, y = 70.85, title = "A Threatening Letter" },
        { map = 2346, x = 32.91, y = 58.80, title = "Second Half of Noggenfogger's Journal" },
        { map = 2346, x = 58.58, y = 59.32, title = "Gallywix's Notes" },
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
        print("|cff00ff00[Muus Meta Helper]|r Added " .. #missing .. " missing Read Between the Lines waypoints to TomTom!")
    else
        print("|cff00ff00[Muus Meta Helper]|r All Read Between the Lines waypoints already completed!")
    end
end },

    { text = "You're My Friend now", func = function()
        if not TomTom then
            print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
            return
        end

        local grabbleRatsWaypoints = {
            { map = 2346, x = 43.59, y = 11.31, title = "Rat #1 (Under Stands)" },
            { map = 2346, x = 28.48, y = 55.79, title = "Rat #2 (Second Floor)" },
            { map = 2346, x = 35.95, y = 85.63, title = "Rat #3 (On the Railing)" },
            { map = 2346, x = 65.26, y = 88.26, title = "Rat #4 (In a Burrow)" },
            { map = 2346, x = 65.86, y = 43.95, title = "Rat #5 (Fake Palm Tree)" },
        }

        local added = 0
        for _, wp in ipairs(grabbleRatsWaypoints) do
            if wp.x and wp.y then
                TomTom:AddWaypoint(wp.map, wp.x / 100, wp.y / 100, { title = wp.title })
                added = added + 1
            else
                print("|cffffff00[Muus Meta Helper]|r Skipped waypoint: " .. (wp.title or "Unknown") .. " (missing coordinates)")
            end
        end

        print("|cff00ff00[Muus Meta Helper]|r Added " .. added .. " 'You're My Friend now' waypoints to TomTom!")
    end },

}

-- Dynamically create buttons
for i, data in ipairs(buttonsData) do
    local btn = CreateFrame("Button", nil, goingGoblinModeFrame, "UIPanelButtonTemplate")
    btn:SetSize(buttonWidth, buttonHeight)
    btn:SetPoint("TOPLEFT", anchorX, anchorY - ((i - 1) * (buttonHeight + spacing)))
    btn:SetText(data.text)
    btn:SetScript("OnClick", data.func)
end