-- Services
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local CONFIG = {
    MESSAGE_TO_SEND_ON_BUTTON1 = "@purplelzys",
    HIGHLIGHT_COLOR = Color3.fromRGB(138, 43, 226),
    DEFAULT_PLAYER_NAME_COLOR = Color3.fromRGB(35, 35, 45),
    BUTTON_PRIMARY_COLOR = Color3.fromRGB(128, 0, 255),
    BUTTON_SECONDARY_COLOR = Color3.fromRGB(255, 0, 128),
    FRAME_BACKGROUND_COLOR = Color3.fromRGB(18, 18, 30),
    TEXT_COLOR_LIGHT = Color3.fromRGB(255, 255, 255),
    TEXT_COLOR_DARK = Color3.fromRGB(180, 180, 200),
    FONT_MAIN = Enum.Font.GothamSemibold,
    FONT_PLAYER_LIST = Enum.Font.Gotham,
    GUI_WIDTH = 280,
    GUI_HEIGHT = 320,
    FOOTER_TEXT = "Fruit Stealer © 2025 | Fearless | tiktok.com/@purplelzys",
    FOOTER_TEXT_COLOR = Color3.fromRGB(170, 170, 170),
    FOOTER_LINE_COLOR = Color3.fromRGB(0, 200, 180),
}

local function glow(obj)
    local glow = Instance.new("UIStroke")
    glow.Thickness = 2
    glow.Color = Color3.fromRGB(180, 0, 255)
    glow.Transparency = 0.4
    glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    glow.Parent = obj
end

local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "AdvancedControlGui"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, CONFIG.GUI_WIDTH, 0, CONFIG.GUI_HEIGHT)
mainFrame.Position = UDim2.new(0.5, -CONFIG.GUI_WIDTH / 2, 0.5, -CONFIG.GUI_HEIGHT / 2)
mainFrame.BackgroundColor3 = CONFIG.FRAME_BACKGROUND_COLOR
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
glow(mainFrame)

local padding = Instance.new("UIPadding", mainFrame)
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)

local layout = Instance.new("UIListLayout", mainFrame)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 10)

-- Removed gimmick label UI block

local function createStyledButton(name, text, color, order)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Name = name
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = CONFIG.TEXT_COLOR_LIGHT
    btn.Font = CONFIG.FONT_MAIN
    btn.TextSize = 16
    btn.LayoutOrder = order
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    glow(btn)
    return btn
end

local stealFruitsButton = createStyledButton("StealFruits", "Steal Fruits", CONFIG.BUTTON_PRIMARY_COLOR, 2)
local bypassSystemButton = createStyledButton("Bypass", "Bypass System", CONFIG.BUTTON_SECONDARY_COLOR, 3)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 18)
title.BackgroundTransparency = 1
title.Font = CONFIG.FONT_MAIN
title.Text = "Online Players:"
title.TextColor3 = CONFIG.TEXT_COLOR_DARK
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.LayoutOrder = 4

local scroll = Instance.new("ScrollingFrame", mainFrame)
scroll.Size = UDim2.new(1, 0, 0, 140)
scroll.BackgroundColor3 = CONFIG.FRAME_BACKGROUND_COLOR
scroll.BackgroundTransparency = 0.2
scroll.BorderSizePixel = 1
scroll.BorderColor3 = CONFIG.DEFAULT_PLAYER_NAME_COLOR
scroll.ScrollBarThickness = 6
scroll.ScrollBarImageColor3 = Color3.fromRGB(120, 0, 255)
scroll.LayoutOrder = 5
Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 8)
glow(scroll)

local scrollLayout = Instance.new("UIListLayout", scroll)
scrollLayout.SortOrder = Enum.SortOrder.Name
scrollLayout.Padding = UDim.new(0, 5)

local resizeHandle = Instance.new("Frame", mainFrame)
resizeHandle.Size = UDim2.new(1, 0, 0, 5)
resizeHandle.BackgroundTransparency = 1
resizeHandle.LayoutOrder = 6
resizeHandle.Active = true

local dragging = false
local startY, startSize

resizeHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		startY = input.Position.Y
		startSize = scroll.Size.Y.Offset
	end
end)

resizeHandle.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position.Y - startY
		scroll.Size = UDim2.new(1, 0, 0, math.clamp(startSize + delta, 100, CONFIG.GUI_HEIGHT - 160))
	end
end)

local footer = Instance.new("Frame", mainFrame)
footer.Size = UDim2.new(1, 0, 0, 22)
footer.BackgroundTransparency = 1
footer.LayoutOrder = 7

local footerLabel = Instance.new("TextLabel", footer)
footerLabel.Size = UDim2.new(1, 0, 1, -2)
footerLabel.BackgroundTransparency = 1
footerLabel.Text = CONFIG.FOOTER_TEXT
footerLabel.TextColor3 = CONFIG.FOOTER_TEXT_COLOR
footerLabel.TextSize = 12
footerLabel.Font = CONFIG.FONT_PLAYER_LIST
footerLabel.TextXAlignment = Enum.TextXAlignment.Center

local line = Instance.new("Frame", footer)
line.Size = UDim2.new(1, 0, 0, 2)
line.Position = UDim2.new(0, 0, 1, -2)
line.BackgroundColor3 = CONFIG.FOOTER_LINE_COLOR
line.BorderSizePixel = 0

local playerEntryButtons = {}
local currentlyHighlightedEntry

local function deselect()
    if currentlyHighlightedEntry then
        currentlyHighlightedEntry.BackgroundColor3 = CONFIG.DEFAULT_PLAYER_NAME_COLOR
        currentlyHighlightedEntry.TextColor3 = CONFIG.TEXT_COLOR_LIGHT
        currentlyHighlightedEntry = nil
    end
end

local function select(btn)
    deselect()
    btn.BackgroundColor3 = CONFIG.HIGHLIGHT_COLOR
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    currentlyHighlightedEntry = btn
end

local function addPlayer(player)
    local btn = Instance.new("TextButton", scroll)
    btn.Name = player.Name
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.BackgroundColor3 = CONFIG.DEFAULT_PLAYER_NAME_COLOR
    btn.Text = player.DisplayName .. " (@" .. player.Name .. ")"
    btn.TextColor3 = CONFIG.TEXT_COLOR_LIGHT
    btn.Font = CONFIG.FONT_PLAYER_LIST
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    glow(btn)
    btn.MouseButton1Click:Connect(function()
        select(btn)
    end)
    playerEntryButtons[player] = btn
end

local function removePlayer(player)
    if playerEntryButtons[player] then
        if currentlyHighlightedEntry == playerEntryButtons[player] then deselect() end
        playerEntryButtons[player]:Destroy()
        playerEntryButtons[player] = nil
    end
end

stealFruitsButton.MouseButton1Click:Connect(function()
    local general = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")
    if general then
        general:SendAsync(CONFIG.MESSAGE_TO_SEND_ON_BUTTON1)
    end
end)

bypassSystemButton.MouseButton1Click:Connect(function()
    game.StarterGui:SetCore("SendNotification", {
    Title = "Bypass Activated",
    Text = "System Bypass Active!",
    Duration = 4
})
end)

for _, p in ipairs(Players:GetPlayers()) do addPlayer(p) end
Players.PlayerAdded:Connect(addPlayer)
Players.PlayerRemoving:Connect(removePlayer)
