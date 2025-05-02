-- Anti AFK Script for Roblox
-- Place this LocalScript in StarterPlayerScripts to prevent auto kick due to inactivity

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer

-- Connect to the Idled event to simulate user input when the player is idle
player.Idled:Connect(function()
    -- Capture controller to prevent kick
    VirtualUser:CaptureController()
    -- Simulate button2 down and up (right mouse button click)
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Optional: You can add a loop to simulate other input periodically as an extra precaution
--[[
while true do
    wait(60) -- every 60 seconds
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end
--]]

