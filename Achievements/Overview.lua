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

-- Section title
local wqHeader = overviewFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
wqHeader:SetPoint("TOP", 475, -475)
wqHeader:SetText("Active World Quests")

local checkWQTextFrame = CreateFrame("Frame", nil, overviewFrame)
checkWQTextFrame:SetPoint("TOPLEFT", 500, -500)
checkWQTextFrame:SetSize(400, 500)

-- FontString for paragraph text
local checkWQParagraph = checkWQTextFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
checkWQParagraph:SetPoint("TOPLEFT")
checkWQParagraph:SetWidth(300)
checkWQParagraph:SetJustifyH("LEFT")
checkWQParagraph:SetJustifyV("TOP")
-- Achievements and related world quests
local achievementData = {
    {
        id = 40869, -- Worm Theory
        name = "Worm Theory",
        quests = {79958, 79959, 82324}
    },
    {
        id = 40150, -- Children's Entertainer
        name = "Children's Entertainer",
        quests = {82288}
    }
}

-- Function to check active world quests for missing achievement criteria
local function CheckWorldQuests()
    local outputLines = {}

    for _, achievement in ipairs(achievementData) do
        local achID = achievement.id
        local achName = achievement.name
        local achCompleted = select(4, GetAchievementInfo(achID))

        -- Entire achievement completed
        if achCompleted then
            table.insert(outputLines, "|cff999999[" .. achName .. "]|r is |cff00ff00Completed|r. Quests are no longer being tracked.\n")
        else
            local numCriteria = GetAchievementNumCriteria(achID)
            local missingCriteria = {}
            local completedCriteria = {}

            -- Determine which criteria are still missing
            for i = 1, numCriteria do
                local critName, _, critCompleted = GetAchievementCriteriaInfo(achID, i)
                if critName then
                    if not critCompleted then
                        table.insert(missingCriteria, critName)
                    else
                        table.insert(completedCriteria, critName)
                    end
                end
            end

            -- Handle missing criteria
            for _, critName in ipairs(missingCriteria) do
                local foundQuest = false

                for _, questID in ipairs(achievement.quests) do
                    local questTitle = C_QuestLog.GetTitleForQuestID(questID)
                    if questTitle and string.find(string.lower(questTitle), string.lower(critName), 1, true) then
                        foundQuest = true
                        if C_TaskQuest.IsActive(questID) then
                            table.insert(outputLines, "|cffffd100[" .. achName .. "]|r " .. questTitle .. " |cff00ff00is ACTIVE!|r")
                        else
                            table.insert(outputLines, "|cffffd100[" .. achName .. "]|r " .. questTitle .. " |cffff0000is NOT active.|r")
                        end
                        break
                    end
                end

                -- Fallback if criteria doesn’t directly map to a quest name
                if not foundQuest then
                    table.insert(outputLines, "|cffffd100[" .. achName .. "]|r " .. critName .. " |cffff0000is NOT active.|r")
                end
            end

            -- Handle completed criteria
            if #completedCriteria > 0 then
                table.insert(outputLines,
                    "|cff999999[" .. achName .. "]|r " ..
                    table.concat(completedCriteria, ", ") ..
                    " are complete and are not being tracked.|r"
                )
            end
        end
    end

    local resultText = table.concat(outputLines, "\n\n")
    checkWQParagraph:SetText(resultText)
    checkWQTextFrame:SetHeight(checkWQParagraph:GetStringHeight())
end

-- Automatically run when the frame is shown
overviewFrame:HookScript("OnShow", CheckWorldQuests)

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