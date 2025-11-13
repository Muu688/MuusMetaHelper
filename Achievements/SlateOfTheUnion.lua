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