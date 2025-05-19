-- LocalScript executed via Delta Executor

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Wait for RemoteEvent and LocalPlayer
local RequestVersionInfo = ReplicatedStorage:WaitForChild("RequestVersionInfo")
local player = Players.LocalPlayer

-- Create GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "VersionGui"

local versionLabel = Instance.new("TextLabel", screenGui)
versionLabel.Name = "VersionLabel"
versionLabel.Size = UDim2.new(0, 300, 0, 50)
versionLabel.Position = UDim2.new(0, 10, 0, 10)
versionLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
versionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
versionLabel.TextScaled = true
versionLabel.Text = "Version: Loading..."

-- Request version from the server
RequestVersionInfo:FireServer()

-- Listen for response from the server
RequestVersionInfo.OnClientEvent:Connect(function(version)
    versionLabel.Text = "Version: " .. tostring(version)
end)