-- Services
local player = game.Players.LocalPlayer

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "ScriptXGui"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.3
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = frame

local title = Instance.new("TextLabel")
title.Text = "Item Duper"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0.4, 0)
title.Parent = frame

local button = Instance.new("TextButton")
button.Text = "DUPLICATE"
button.Font = Enum.Font.SourceSans
button.TextSize = 20
button.TextColor3 = Color3.new(1, 1, 1)
button.Size = UDim2.new(0.8, 0, 0.4, 0)
button.Position = UDim2.new(0.1, 0, 0.5, 0)
button.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- soft red
button.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = button

-- Tool duplication logic
button.MouseButton1Click:Connect(function()
	local character = player.Character
	if not character then return end

	local tool = character:FindFirstChildOfClass("Tool")
	if tool then
		local clone = tool:Clone()
		clone.Parent = player.Backpack
		button.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- turn green
	end
end)