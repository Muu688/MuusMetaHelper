-------------------------------------------------
-- Owner of a Radiant Heart Tab Custom Content
-------------------------------------------------
local ownerOfARadientHeartFrame = contentFrames[9]

local oarfHeader = ownerOfARadientHeartFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
oarfHeader:SetPoint("TOP", 0, -100)
oarfHeader:SetText("Owner of a Radiant Flame")

-- Scroll frame container
local oarfScrollFrame = CreateFrame("ScrollFrame", nil, ownerOfARadientHeartFrame, "UIPanelScrollFrameTemplate")
oarfScrollFrame:SetPoint("TOPLEFT", 20, -125)
oarfScrollFrame:SetSize(400, 500)

-- Child frame for the text
local oarfTextFrame = CreateFrame("Frame", nil, oarfScrollFrame)
oarfTextFrame:SetSize(320, 1) -- width must match scroll frame
oarfScrollFrame:SetScrollChild(oarfTextFrame)

-- FontString for paragraph text
local paragraph = oarfTextFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
paragraph:SetPoint("TOPLEFT")
paragraph:SetWidth(300)
paragraph:SetJustifyH("LEFT")
paragraph:SetJustifyV("TOP")
paragraph:SetText("|cff00ff00Owner of a Radiant Flame|r: This can seem really daunting if you havn't touched the reputation yet, but it's not too bad. The jist of it is pretty simple. Get Renown 10 with Flames Radiance. These cats are located on the far left of Hallowfall where the 'Nightfall' thing is on the map.\n\n There are three ways to get rep:\n1: Scenario\nAt the top of the hour (every hour) the scenario starts which involves doing a bunch of tasks like freeing arathi dudes, unaliving spiders etc... The rep from here is gained each time you level the chest up. There are three levels. Most of the time (except for the Weekly Quest) you can simply just stop the scenario after hitting the third level of the chest, as thats when the rep is awarded. (33% Progress Bar = 150 Rep / 66% = 150 Rep / 100% 700 Rep (First clear weekly / 150 each repeat clear)) If it is your first time of the weekly reset completing the scenario, make sure you have the quest |cff00ff00[The Flame Burns Eternal]|r as it gives a significant amount of rep (plus a chance at a mount).\n\n2: Daily Quests:\n Daily quests such as Radiant Incursion, Sureki Incursion are picked up at the main Flames Radience hub in Western Hallowfall and take place in Hallowfall or Azj'Kahet. These quests typically require unaliving a bunch of things or destroying stuff to get 100% on a bar. Each quest gives 200 Rep and can be done once a day. \n\n3: Rares\nThere are four rares. 3 of which are in the top right of Azj-Kahet, one in the top left. (Click the Rares button to import the waypoints for the general areas) - These rares reward 150 Rep and can be farmed once per day for the rep reward.\n\n4: Weekly Quest: At the main Flames Radiance Hub take the quest |cff00ff00[The Flame Burns Eternal]|r and complete the Nightfall Scenario by unaliving the final boss of the Scenario (Anub'Ranax). This can only be completed once a week, so subsequent Nightfall Scenarios can be cut short as soon as the chest bar hits max and the last batch of rep is awarded.\n\n")

-- =========================
-- Button setup
-- =========================
local buttonWidth = 300
local buttonHeight = 30
local spacing = 10
local anchorX, anchorY = 500, -100

local buttonsData = {
    
    { text = "Flames Radiance Hub Waypoint", func = function()
        if not TomTom then
            print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
            return
        end

        local flamesRadianceHubWaypoint = {
            { map = 2215, x = 28.30, y = 56.05, title = "Flames Radiance Hub" },
        }

        local added = 0
        for _, wp in ipairs(flamesRadianceHubWaypoint) do
            if wp.x and wp.y then
                TomTom:AddWaypoint(wp.map, wp.x / 100, wp.y / 100, { title = wp.title })
                added = added + 1
            else
                print("|cffffff00[Muus Meta Helper]|r Skipped waypoint: " .. (wp.title or "Unknown") .. " (missing coordinates)")
            end
        end

        print("|cff00ff00[Muus Meta Helper]|r Added " .. added .. " 'Flames Radiance Hub' waypoint to TomTom!")
    end },

    
    { text = "Flames Radiance Rares", func = function()
        if not TomTom then
            print("|cffff0000[Muus Meta Helper]|r TomTom not found! Please enable the TomTom addon.")
            return
        end

        local flamesRadianceRaresWaypoint = {
            { map = 2256, x = 62.0, y = 29.6, title = "Kaheti Silk Hauler" },
            { map = 2256, x = 62.60, y = 6.61, title = "Umbraclaw Matra" },
            { map = 2256, x = 62.60, y = 6.62, title = "Deepcrawler Tx'kesh" },
            { map = 2256, x = 62.60, y = 6.63, title = "Skirmisher Sa'zryk" },
        }

        local added = 0
        for _, wp in ipairs(flamesRadianceRaresWaypoint) do
            if wp.x and wp.y then
                TomTom:AddWaypoint(wp.map, wp.x / 100, wp.y / 100, { title = wp.title })
                added = added + 1
            else
                print("|cffffff00[Muus Meta Helper]|r Skipped waypoint: " .. (wp.title or "Unknown") .. " (missing coordinates)")
            end
        end

        print("|cff00ff00[Muus Meta Helper]|r Added " .. added .. " 'Flames Radiance Rares' waypoint to TomTom!")
    end },
}

-- Dynamically create buttons
for i, data in ipairs(buttonsData) do
    local btn = CreateFrame("Button", nil, ownerOfARadientHeartFrame, "UIPanelButtonTemplate")
    btn:SetSize(buttonWidth, buttonHeight)
    btn:SetPoint("TOPLEFT", anchorX, anchorY - ((i - 1) * (buttonHeight + spacing)))
    btn:SetText(data.text)
    btn:SetScript("OnClick", data.func)
end