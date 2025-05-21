-- LocalScript in StarterPlayer > StarterPlayerScripts

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "VisualClonePrankGui"

-- UI Button
local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0.5, -75, 0.9, -25)
button.BackgroundColor3 = Color3.fromRGB(60, 180, 75)
button.Text = "Clone Item"
button.Font = Enum.Font.SourceSansBold
button.TextSize = 24
button.TextColor3 = Color3.new(1, 1, 1)

-- Fake item to clone
local fakeItem = Instance.new("Part")
fakeItem.Size = Vector3.new(2, 2, 2)
fakeItem.BrickColor = BrickColor.Random()
fakeItem.Anchored = true
fakeItem.CanCollide = false
fakeItem.Material = Enum.Material.Neon

-- Workspace folder to keep things clean
local folder = Instance.new("Folder", workspace)
folder.Name = "VisualClones"

-- On button click, clone the visual item
local cloneCount = 0
button.MouseButton1Click:Connect(function()
	local clone = fakeItem:Clone()
	clone.Parent = folder
	clone.Position = player.Character and player.Character.HumanoidRootPart.Position + Vector3.new(math.random(-10, 10), 5, math.random(-10, 10)) or Vector3.new(0, 5, 0)
	clone.BrickColor = BrickColor.Random()
	clone.Name = "Clone_" .. tostring(cloneCount)
	cloneCount += 1
end)