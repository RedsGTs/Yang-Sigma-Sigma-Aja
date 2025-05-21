local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "SpawnerGUI"

-- Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
frame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Grow a Garden Spawner"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

-- Input TextBox
local inputBox = Instance.new("TextBox")
inputBox.Position = UDim2.new(0, 10, 0, 50)
inputBox.Size = UDim2.new(1, -20, 0, 40)
inputBox.Text = "Red fox"
inputBox.Font = Enum.Font.SourceSans
inputBox.TextSize = 20
inputBox.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
inputBox.TextColor3 = Color3.fromRGB(0, 0, 0)
inputBox.ClearTextOnFocus = false
inputBox.Parent = frame

-- Spawn Button
local spawnButton = Instance.new("TextButton")
spawnButton.Position = UDim2.new(0, 10, 0, 100)
spawnButton.Size = UDim2.new(1, -20, 0, 40)
spawnButton.Text = "Spawn"
spawnButton.Font = Enum.Font.SourceSansBold
spawnButton.TextSize = 22
spawnButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
spawnButton.TextColor3 = Color3.fromRGB(0, 0, 0)
spawnButton.Parent = frame

-- Status
local status = Instance.new("TextLabel")
status.Position = UDim2.new(0, 10, 0, 150)
status.Size = UDim2.new(1, -20, 0, 30)
status.Text = ""
status.Font = Enum.Font.SourceSans
status.TextSize = 18
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(0, 255, 0)
status.Parent = frame

-- On Spawn Click
spawnButton.MouseButton1Click:Connect(function()
    local itemName = inputBox.Text
    if itemName ~= "" then
        game.ReplicatedStorage:WaitForChild("SpawnItem"):FireServer(itemName)
        status.Text = "✔ " .. itemName .. " spawned!"
        status.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        status.Text = "Please enter an item name."
        status.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)