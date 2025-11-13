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
azjTextFrame:SetSize(320, 1)
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