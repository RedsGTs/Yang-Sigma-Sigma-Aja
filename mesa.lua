-- AutoChatButton.local.lua
-- LocalScript dengan GUI tombol kirim chat

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ChatEvent = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Buat GUI
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "ChatButtonGui"

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.8, 0)
button.Text = "Kirim Pesan!"
button.Parent = screenGui

-- Fungsi kirim pesan
button.MouseButton1Click:Connect(function()
	ChatEvent:FireServer("Ini pesan dari tombol GUI!", "All")
end)