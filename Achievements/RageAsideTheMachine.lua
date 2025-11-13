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