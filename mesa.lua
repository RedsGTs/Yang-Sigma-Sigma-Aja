-- Roblox Lua script for Delta Executor Mobile
-- Dynamically tries to find chat-related RemoteEvents to send a public chat message

local message = "Hello, this is a public chat message from Delta Executor!"

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer
if not localPlayer then
    error("LocalPlayer not found!")
end

-- Helper function to check if an Instance name or class suggests it might be chat related
local function isChatRelated(instance)
    local name = instance.Name:lower()
    if instance:IsA("RemoteEvent") or instance:IsA("RemoteFunction") then
        if string.find(name, "chat") or string.find(name, "message") or string.find(name, "say") or string.find(name, "talk") then
            return true
        end
    end
    return false
end

-- Try firing a RemoteEvent with message, return true if no error
local function tryFireRemoteEvent(event)
    local success, err = pcall(function()
        event:FireServer(message, "All")
    end)
    return success
end

-- Recursively search for chat-related RemoteEvents in a given parent
local function searchAndFireEvents(parent)
    for _, child in pairs(parent:GetChildren()) do
        if isChatRelated(child) then
            print("Trying RemoteEvent/Function: "..child:GetFullName())
            if child:IsA("RemoteEvent") then
                local fired = tryFireRemoteEvent(child)
                if fired then
                    print("Message sent using:", child:GetFullName())
                    return true
                end
            elseif child:IsA("RemoteFunction") then
                local success, res = pcall(function()
                    return child:InvokeServer(message, "All")
                end)
                if success then
                    print("Message sent using RemoteFunction:", child:GetFullName())
                    return true
                end
            end
        end

        -- Recursive search deeper
        local found = searchAndFireEvents(child)
        if found then
            return true
        end
    end
    return false
end

print("Starting dynamic chat event search...")
local sent = false

-- Search common places
sent = searchAndFireEvents(ReplicatedStorage) or false
if not sent then
    -- Sometimes chat events can be under PlayerScripts or PlayerGui of localPlayer
    if localPlayer:FindFirstChild("PlayerScripts") then
        sent = searchAndFireEvents(localPlayer.PlayerScripts) or false
    end
end

if not sent then
    if localPlayer:FindFirstChild("PlayerGui") then
        sent = searchAndFireEvents(localPlayer.PlayerGui) or false
    end
end

if not sent then
    print("No suitable chat event found or message could not be sent.")
else
    print("Public message sent successfully.")
end
