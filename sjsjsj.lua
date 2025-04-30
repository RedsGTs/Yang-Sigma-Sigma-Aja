-- Job ID Hub V3 (Draggable + Toggle Icon + Minimize Button)

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local placeId = game.PlaceId
local joinTime = tick()

-- Destroy existing GUI
if game.CoreGui:FindFirstChild("JobIDHub") then
    game.CoreGui.JobIDHub:Destroy()
end

-- Create GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "JobIDHub"
gui.ResetOnSpawn = false

-- Toggle Icon
local toggleIcon = Instance.new("ImageButton", gui)
toggleIcon.Name = "ToggleIcon"
toggleIcon.Size = UDim2.new(0, 40, 0, 40)
toggleIcon.Position = UDim2.new(0, 10, 0, 10)
toggleIcon.BackgroundTransparency = 1
toggleIcon.Image = "rbxassetid://1049060234" -- Your icon ID

-- Main Frame
local mainFrame = Instance.new("Frame", gui)
mainFrame.Name = "MainFrame"
mainFrame.Position = UDim2.new(0, 60, 0, 60)
mainFrame.Size = UDim2.new(0, 350, 0, 260)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false

-- Make MainFrame draggable
local dragging = false
local dragInput, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Minimize Button
local minimizeBtn = Instance.new("TextButton", mainFrame)
minimizeBtn.Name = "MinimizeButton"
minimizeBtn.Size = UDim2.new(0, 24, 0, 24)
minimizeBtn.Position = UDim2.new(1, -28, 0, 4)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 20
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)

-- UI Elements inside MainFrame
local function createLabel(parent, position, text)
    local label = Instance.new("TextLabel", parent)
    label.Size = UDim2.new(1, -20, 0, 30)
    label.Position = position
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = text
    return label
end

local uptimeLabel = createLabel(mainFrame, UDim2.new(0, 10, 0, 10), "Uptime: 0s")
local jobIdLabel = createLabel(mainFrame, UDim2.new(0, 10, 0, 45), "Job ID: " .. (game.JobId ~= "" and game.JobId or "Unavailable"))

local jobIdInput = Instance.new("TextBox", mainFrame)
jobIdInput.Size = UDim2.new(1, -20, 0, 30)
jobIdInput.Position = UDim2.new(0, 10, 0, 85)
jobIdInput.PlaceholderText = "Enter Job ID..."
jobIdInput.Font = Enum.Font.SourceSans
jobIdInput.TextSize = 16
jobIdInput.TextColor3 = Color3.new(1, 1, 1)
jobIdInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local function createButton(name, position, text, bgColor)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Name = name
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = position
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = bgColor
    return btn
end

local teleportBtn = createButton("TeleportButton", UDim2.new(0, 10, 0, 125), "Join Server by Job ID", Color3.fromRGB(60, 100, 60))
local copyBtn = createButton("CopyButton", UDim2.new(0, 10, 0, 165), "Copy My Job ID", Color3.fromRGB(80, 80, 100))
local randomBtn = createButton("RandomButton", UDim2.new(0, 10, 0, 205), "Join Random Server", Color3.fromRGB(100, 80, 60))

-- Logic
copyBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(game.JobId) end
end)

teleportBtn.MouseButton1Click:Connect(function()
    local inputJob = jobIdInput.Text
    if inputJob and inputJob ~= "" then
        TeleportService:TeleportToPlaceInstance(placeId, inputJob, player)
    end
end)

randomBtn.MouseButton1Click:Connect(function()
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if success and result and result.data then
        for _, server in pairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(placeId, server.id, player)
                break
            end
        end
    end
end)

-- Toggle MainFrame visibility
toggleIcon.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Minimize/Expand content inside MainFrame
local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    for _, child in ipairs(mainFrame:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("TextBox") or child:IsA("TextButton") then
            if child.Name ~= "MinimizeButton" then
                child.Visible = not isMinimized
            end
        end
    end
end)

-- Uptime updater
task.spawn(function()
    while true do
        local seconds = math.floor(tick() - joinTime)
        local mins = math.floor(seconds / 60)
        local secs = seconds % 60
        uptimeLabel.Text = string.format("Uptime: %02d:%02d", mins, secs)
        task.wait(1)
    end
end)