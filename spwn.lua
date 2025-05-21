-- LocalScript inside the ScreenGui
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local spawnableItems = ReplicatedStorage:WaitForChild("SpawnableItems")
local player = Players.LocalPlayer

local gui = script.Parent
local itemInput = gui:WaitForChild("ItemInput")
local spawnButton = gui:WaitForChild("SpawnButton")

spawnButton.MouseButton1Click:Connect(function()
	local itemName = itemInput.Text
	local itemTemplate = spawnableItems:FindFirstChild(itemName)

	if itemTemplate then
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

		local clonedItem = itemTemplate:Clone()
		clonedItem.Parent = workspace
		clonedItem:SetPrimaryPartCFrame(humanoidRootPart.CFrame * CFrame.new(0, 0, -5))
	else
		warn("Item not found: " .. itemName)
	end
end)