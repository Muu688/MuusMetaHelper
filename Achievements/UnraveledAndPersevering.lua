-------------------------------------------------
-- Unraveled and Persevering Tab Custom Content
-------------------------------------------------
local unraveledFrame = contentFrames[8]

local unravHeader = unraveledFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
unravHeader:SetPoint("TOP", 0, -100)
unravHeader:SetText("Unraveled and Persevering")

-- Scroll frame container
local scrollFrame = CreateFrame("ScrollFrame", nil, unraveledFrame, "UIPanelScrollFrameTemplate")
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
|cff00ff00Remnants of a Shattered World|r: Consider downloading the addon 'rarescanner' to help here. Rares are best farmed WM On. Most of these might be acquired while trying to get Loremaster of Khaz'algar or Khaz Algar Diplomat as they can be farmed for Rep. Some of the rares spawn within Untethered Space. Rarescanner will tell you which ones. I may update this to track the spawns of the rares and which ones are untethered.

|cff00ff00Explore K'aresh|r: Fly around all of K'aresh to get this achiev, the only 'gotcha is Vanquisher's Wake which is /way #2372 53.06 13.66 Vanquisher's Wake (Island in North Part of Map)

|cff00ff00Dangerous Prowlers of K'aresh|r: Import the waypoints from the button on the right. To get this acheiv you need to /pat each of the cats. Little Ms. Phase is phasing in and out constantly, so you may need to wait a moment. K'aresh'ire is the same, visible for 15s / hidden for 20s. C.T patrols the area so use /tar. Empurror is up high and The King in Silver is in Untethered Space.

|cff00ff00Secrets of the K'areshi|r: Another acheivement where you need to collect a bunch of secrets around K'aresh. The waypoints are located on the button to the right. The following secrets require you to be in phase diving/untethered space:
- The Facets of K'aresh
- I Have Become Void
- Checklist of Minor Pleasures
- Multiversal Energy Dynamics and the Murmuration Paradox
- From Vengence to Void

|cff00ff00Treasures of K'aresh|r: First, consider obtaining some |cff1eff00[Untethered Xy'bucha]|r - I have a button which adds waypoints for where this might be found. I did not record where I got them myself, these are from WoWhead. (More to come on this achievement tomorrow, I thought I'd give everyone what I have today then adjust for tomorrow. Wowhead is a good resouce if you're stuck in the meantime...)

|cff00ff00Bounty Seeker|r: To get these quests you can follow the warrent quests which are issued in K'aresh from Constable Zo'ardaz at the waypoint below. The 6 quests are on a random 6 weekly rotation (1 per week) - Now, this is circumventable with a little bit of gold by purchasing a combination of the following items until you get the achievement. Completing all 6 will get you the |cffa335ee[Terror of the Night]|r mount.
- Waypoint for Warrent Quests: /way #2472 48.70 57.70
- Purple Peat Cell Key
- Xy'vox Refuge Dampener
- Grubber Lure
- Arcane Lure
- Shatterpusle Cell Key
- Hollowbane Portal Key

|cff00ff00Power of the Reshii|r: Fully Upgrade the Reshii wraps. You will need to first obtain the Reshii wraps by completing the intro quests for K'aresh. The upgrade items are dropped from Warrent quests in K'aresh. Chests at end of delves. Raid bosses in Manaforge Omega (Maybe Quickest?) and S3 pvp/m+.

]])

-- =========================
-- Button setup
-- =========================
local buttonWidth = 300
local buttonHeight = 30
local spacing = 10
local anchorX, anchorY = 500, -100

local buttonsData = {
    { text = "Dangerous Prowlers of K'aresh Waypoints", func = function()
    if not TomTom then
        print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
        return
    end

    local achievementID = 42729

    local waypoints = {
        { map = 2472, x = 61.00, y = 55.52, criteria = "Mar", notes = "" },
        { map = 2371, x = 50.35, y = 59.20, criteria = "Little Ms. Phaser", notes = "constantly phasing in & out" },
        { map = 2371, x = 48.00, y = 61.50, criteria = "C.T.", notes = "patrols in northern half of The Atrium eco-dome" },
        { map = 2371, x = 70.24, y = 54.26, criteria = "K'aresh'ire", notes = "visible for 15sec on tree then disappears for 20sec" },
        { map = 2371, x = 73.17, y = 23.74, criteria = "Empurror", notes = "fly up" },
        { map = 2371, x = 47.61, y = 37.38, criteria = "The King in Silver", notes = "in Untethered Space" },
    }

    local missing = {}
    local numCriteria = GetAchievementNumCriteria(achievementID)

    if numCriteria and numCriteria > 0 then
        for i = 1, numCriteria do
            local critName, _, critCompleted = GetAchievementCriteriaInfo(achievementID, i)
            if critName and not critCompleted then
                for _, wp in ipairs(waypoints) do
                    if string.find(string.lower(wp.criteria), string.lower(critName), 1, true) then
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
            local title = wp.criteria
            if wp.notes and wp.notes ~= "" then
                title = title .. " (" .. wp.notes .. ")"
            end
            TomTom:AddWaypoint(wp.map, wp.x / 100, wp.y / 100, { title = title })
        end
        print("|cff00ff00[Muus Meta Helper]|r Added " .. #missing .. " missing 'Dangerous Prowlers of K'aresh' waypoints to TomTom!")
    else
        print("|cff00ff00[Muus Meta Helper]|r All 'Dangerous Prowlers of K'aresh' waypoints already completed!")
    end
end },
{ text = "Secrets of the K'areshi", func = function()
    if not TomTom then
        print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
        return
    end

    local achievementID = 60890

    local waypoints = {
        { map = 2472, x = 36.79, y = 58.07, criteria = "I Have Become Void!", notes = "Phase Diving" },
        { map = 2371, x = 42.29, y = 20.93, criteria = "From Vengeance to Void", notes = "Phase Diving" },
        { map = 2472, x = 38.23, y = 45.62, criteria = "Checklist of Minor Pleasures", notes = "Phase Diving" },
        { map = 2472, x = 37.32, y = 25.72, criteria = "A Dog-eared Book", notes = "" },
        { map = 2472, x = 41.68, y = 39.82, criteria = "Coins: An Oath We Exchange", notes = "" },
        { map = 2371, x = 49.61, y = 26.71, criteria = "Multiversal Energy Dynamics and the Murmuration Paradox", notes = "Phase Diving" },
        { map = 2371, x = 72.12, y = 29.41, criteria = "The Facets of K'aresh", notes = "Phase Diving" },
        { map = 2472, x = 46.31, y = 18.69, criteria = "Ba'key's Aromatic Broker Cookies Recipes", notes = "" },
        { map = 2472, x = 58.45, y = 91.50, criteria = "Mysterious Notebook", notes = "" },
        { map = 2371, x = 48.92, y = 57.15, criteria = "Geologist Field Journal", notes = "" },
    }

    local missing = {}
    local numCriteria = GetAchievementNumCriteria(achievementID)

    if numCriteria and numCriteria > 0 then
        for i = 1, numCriteria do
            local critName, _, critCompleted = GetAchievementCriteriaInfo(achievementID, i)
            if critName and not critCompleted then
                for _, wp in ipairs(waypoints) do
                    if string.find(string.lower(wp.criteria), string.lower(critName), 1, true) then
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
            local title = wp.criteria
            if wp.notes and wp.notes ~= "" then
                title = title .. " (" .. wp.notes .. ")"
            end
            TomTom:AddWaypoint(wp.map, wp.x / 100, wp.y / 100, { title = title })
        end
        print("|cff00ff00[Muus Meta Helper]|r Added " .. #missing .. " missing 'Secrets of the K'areshi' waypoints to TomTom!")
    else
        print("|cff00ff00[Muus Meta Helper]|r All 'Secrets of the K'areshi' waypoints already completed!")
    end
end },

{
    text = "Untethered Xy'bucha Waypoints",
    func = function()
        if not TomTom then
            print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
            return
        end

        local xybuchaWaypoints = {
            { map = 2371, x = 49.67, y = 17.05, title = "Untethered Xy'bucha" },
            { map = 2371, x = 49.65, y = 26.65, title = "Untethered Xy'bucha" },
            { map = 2371, x = 50.74, y = 58.45, title = "Untethered Xy'bucha" },
            { map = 2371, x = 53.75, y = 45.37, title = "Untethered Xy'bucha" },
            { map = 2371, x = 54.81, y = 48.18, title = "Untethered Xy'bucha" },
            { map = 2371, x = 61.33, y = 39.11, title = "Untethered Xy'bucha" },
            { map = 2371, x = 80.35, y = 48.69, title = "Untethered Xy'bucha" },
        }

        local added = 0
        for _, wp in ipairs(xybuchaWaypoints) do
            if wp.x and wp.y then
                TomTom:AddWaypoint(wp.map, wp.x / 100, wp.y / 100, { title = wp.title })
                added = added + 1
            else
                print("|cffffff00[Muus Meta Helper]|r Skipped waypoint: " .. (wp.title or "Unknown") .. " (missing coordinates)")
            end
        end

        print("|cff00ff00[Muus Meta Helper]|r Added " .. added .. " 'Untethered Xy'bucha' waypoint(s) to TomTom!")
    end
},

{ text = "Treasures of K'aresh", func = function()
    if not TomTom then
        print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
        return
    end

    local achievementID = 42741

    -- Each entry here is ONE criteria (treasure)
    -- Each criteria has one or more WAYPOINTS
    local criteriaWaypoints = {
        ["Gift of the Brothers"] = {
            { map = 2371, x = 76.01, y = 45.21, notes = "Ihya & Flickering Lantern" },
            { map = 2371, x = 68.31, y = 45.31, notes = "Naji" },
            { map = 2371, x = 69.82, y = 60.52, notes = "M'alim" },
            { map = 2371, x = 75.51, y = 39.82, notes = "Sahra" },
        },

        ["Forlorn Wind Chime"] = {
            { map = 2371, x = 69.74, y = 52.31, notes = "" },
        },

        ["Ixthar's Favorite Crystal"] = {
            { map = 2371, x = 64.08, y = 43.96, notes = "" },
        },

        ["Shattered Crystals"] = {
            { map = 2371, x = 70.20, y = 47.73, notes = "" },
        },

        ["Rashaal's Vase"] = {
            { map = 2371, x = 70.20, y = 47.73, notes = "Cave Entrance" },
            { map = 2371, x = 70.20, y = 47.73, notes = "Inside Cave" },
        },

        ["Crudely Stitched Sack"] = {
            { map = 2371, x = 58.64, y = 34.31, notes = "" },
        },

        ["Abandoned Lockbox"] = {
            { map = 2371, x = 58.64, y = 34.31, notes = "Possible location" },
            { map = 2371, x = 53.95, y = 54.95, notes = "Possible location" },
            { map = 2371, x = 54.08, y = 59.31, notes = "Possible location" },
            { map = 2371, x = 60.00, y = 60.91, notes = "Possible location" },
            { map = 2371, x = 59.75, y = 53.71, notes = "Possible location" },
        },

        ["Lightly-Dented Luggage"] = {
            { map = 2371, x = 53.70, y = 64.04, notes = "Possible location" },
            { map = 2371, x = 54.95, y = 62.46, notes = "Possible location" },
            { map = 2371, x = 55.69, y = 64.15, notes = "Possible location" },
        },

        ["Ethereal Voidforged Container"] = {
            { map = 2371, x = 52.09, y = 68.33, notes = "Untethered Space" },
        },

        ["Spear of Fallen Memories"] = {
            { map = 2472, x = 23.69, y = 46.82, notes = "Untethered Space" },
        },

        ["Tulwar of the Golden Guard"] = {
            { map = 2371, x = 51.05, y = 65.09, notes = "Untethered Space" },
        },

        ["Shadowguard Crusher"] = {
            { map = 2371, x = 49.25, y = 17.89, notes = "Untethered Space" },
        },

        ["Korgorath's Talon"] = {
            { map = 2371, x = 64.43, y = 42.69, notes = "Untethered Space" },
        },

        ["P.O.S.T. Master's Prototype Parcel and Postage Presser"] = {
            { map = 2472, x = 47.47, y = 69.98, notes = "Untethered Space" },
        },

        ["Bladed Rifle of Unfettered Momentum"] = {
            { map = 2371, x = 70.35, y = 70.95, notes = "Untethered Space" },
        },

        ["Ancient Coffer"] = {
            { map = 2371, x = 66.55, y = 44.80, notes = "Battered Book" },
            { map = 2371, x = 76.20, y = 31.21, notes = "Submerged Bottle" },
            { map = 2371, x = 60.90, y = 38.35, notes = "" },
        },

        ["Mailroom Distribution"] = {
            { map = 2472, x = 47.89, y = 62.53, notes = "Mail Overflow" },
            { map = 2472, x = 46.54, y = 64.32, notes = "" },
            { map = 2472, x = 47.40, y = 69.49, notes = "" },
            { map = 2472, x = 48.91, y = 67.09, notes = "" },
            { map = 2472, x = 48.44, y = 65.52, notes = "" },
            { map = 2472, x = 47.97, y = 64.37, notes = "Treasure" },
        },

        ["Wastelander Stash"] = {
            { map = 2371, x = 60.54, y = 42.13, notes = "" },
        },

        ["Skeletal Tail Bones"] = {
            { map = 2371, x = 77.80, y = 28.10, notes = "" },
        },

        ["Sand-Worn Coffer"] = {
            { map = 2371, x = 54.46, y = 24.44, notes = "" },
        },

        ["Light-Soaked Cleaver"] = {
            { map = 2371, x = 52.50, y = 46.77, notes = "Untethered Space" },
        },

        ["Efrat's Forgotten Bulwark"] = {
            { map = 2371, x = 77.99, y = 48.71, notes = "Untethered Space" },
        },

        ["Petrified Branch of Janaa"] = {
            { map = 2371, x = 78.62, y = 61.62, notes = "Untethered Space" },
        },

        ["Sufaadi Skiff Lantern"] = {
            { map = 2371, x = 80.71, y = 52.70, notes = "Untethered Space" },
        },

        ["Warglaive of the Audacious Hunter"] = {
            { map = 2371, x = 56.82, y = 24.12, notes = "Cave Entrance - Untethered Space" },
            { map = 2371, x = 58.45, y = 22.78, notes = "Inside Cave - Untethered Space" },
        },

        ["Phaseblade of the Void Marches"] = {
            { map = 2371, x = 50.82, y = 35.34, notes = "Untethered Space" },
        },

        ["Tumbled Package"] = {
            { map = 2371, x = 65.43, y = 63.56, notes = "" },
        },
    }

    -- Build a flat list of missing waypoint entries
    local missingWaypoints = {}
    local numCriteria = GetAchievementNumCriteria(achievementID)

    if numCriteria and numCriteria > 0 then
        for i = 1, numCriteria do
            local critName, _, critCompleted = GetAchievementCriteriaInfo(achievementID, i)

            if critName and not critCompleted then
                for storedName, wpList in pairs(criteriaWaypoints) do
                    if string.find(string.lower(storedName), string.lower(critName), 1, true) then
                        for _, wp in ipairs(wpList) do
                            local entry = {
                                map = wp.map,
                                x = wp.x,
                                y = wp.y,
                                title = storedName .. (wp.notes ~= "" and " (" .. wp.notes .. ")" or "")
                            }
                            table.insert(missingWaypoints, entry)
                        end
                        break
                    end
                end
            end
        end
    else
        -- Fallback: add ALL points if the achievement can't be read
        for name, wpList in pairs(criteriaWaypoints) do
            for _, wp in ipairs(wpList) do
                table.insert(missingWaypoints, {
                    map = wp.map,
                    x = wp.x,
                    y = wp.y,
                    title = name .. (wp.notes ~= "" and " (" .. wp.notes .. ")" or "")
                })
            end
        end
    end

    -- Send missing points to TomTom
    if #missingWaypoints > 0 then
        for _, wp in ipairs(missingWaypoints) do
            TomTom:AddWaypoint(wp.map, wp.x / 100, wp.y / 100, { title = wp.title })
        end
        print("|cff00ff00[Muus Meta Helper]|r Added " .. #missingWaypoints .. " missing 'Treasures of K'aresh' waypoints to TomTom!")
    else
        print("|cff00ff00[Muus Meta Helper]|r All 'Treasures of K'aresh' waypoints already completed!")
    end
end },

}

-- Dynamically create buttons
for i, data in ipairs(buttonsData) do
    local btn = CreateFrame("Button", nil, unraveledFrame, "UIPanelButtonTemplate")
    btn:SetSize(buttonWidth, buttonHeight)
    btn:SetPoint("TOPLEFT", anchorX, anchorY - ((i - 1) * (buttonHeight + spacing)))
    btn:SetText(data.text)
    btn:SetScript("OnClick", data.func)
end