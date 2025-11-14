local ADDON_NAME = ...

-- Tab definitions
TAB_NAMES = { "Overview", "Slate of the Union", "Rage Aside the Machine", "Crystal Chronicled", "Azj the World Turns", "Glory of the Delver", "Going Goblin Mode", "Unravaled and Persevering", "Owner of a Radiant Heart" }
contentFrames = {}

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
    if i > 9 then
        text:SetText(tabName .. " is in Development")
    end

    contentFrames[i] = content
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