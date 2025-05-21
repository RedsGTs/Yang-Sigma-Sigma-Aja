-- Fake Dupe Script (For Pranks/Visuals Only)
-- Does NOT duplicate anything – visual effect only

local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "FakeDupeGui"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0.3, 0)
title.Text = "Duping Item..."
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24

local status = Instance.new("TextLabel", frame)
status.Position = UDim2.new(0, 0, 0.4, 0)
status.Size = UDim2.new(1, 0, 0.6, 0)
status.Text = "0 items duped"
status.TextColor3 = Color3.fromRGB(255, 255, 255)
status.BackgroundTransparency = 1
status.Font = Enum.Font.SourceSans
status.TextSize = 20

-- Fake counter animation
local dupes = 0
spawn(function()
	while dupes < 9999 do
		dupes += math.random(1, 5)
		status.Text = dupes .. " items duped"
		wait(0.05)
	end
	status.Text = "Dupe Complete!"
end)