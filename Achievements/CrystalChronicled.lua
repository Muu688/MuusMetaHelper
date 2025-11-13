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