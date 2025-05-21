-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "ScriptXGui"
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Text = "SCRIPT X"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0.4, 0)
title.Parent = frame

local button = Instance.new("TextButton")
button.Text = "Duplicate"
button.Font = Enum.Font.SourceSans
button.TextSize = 20
button.TextColor3 = Color3.new(1, 1, 1)
button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
button.Size = UDim2.new(0.8, 0, 0.4, 0)
button.Position = UDim2.new(0.1, 0, 0.5, 0)
button.Parent = frame

-- Duplication functionality
button.MouseButton1Click:Connect(function()
	local character = game.Players.LocalPlayer.Character
	if not character then return end

	local tool = character:FindFirstChildOfClass("Tool")
	if tool then
		local clone = tool:Clone()
		clone.Parent = character -- or game.Players.LocalPlayer.Backpack to duplicate to backpack
	end
end)