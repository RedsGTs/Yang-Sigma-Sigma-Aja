-- LocalScript in StarterPlayer > StarterPlayerScripts

local player = game.Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

-- Create GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "FakeToolDupeGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(1, -20, 0, 50)
button.Position = UDim2.new(0, 10, 0.5, -25)
button.Text = "Item Duper"
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20
button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
button.TextColor3 = Color3.new(1, 1, 1)

-- Clone tool (local visual only)
button.MouseButton1Click:Connect(function()
	local character = player.Character
	if character then
		local tool = character:FindFirstChildOfClass("Tool")
		if tool then
			local clone = tool:Clone()
			clone.Parent = backpack
			print("Cloned tool:", clone.Name)
		else
			print("No tool equipped!")
		end
	end
end)