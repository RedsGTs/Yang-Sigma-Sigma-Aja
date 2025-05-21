-- Create the main GUI
local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create a folder to store spawnable items if it doesn't exist
local ItemsFolder
if not ReplicatedStorage:FindFirstChild("SpawnableItems") then
    ItemsFolder = Instance.new("Folder")
    ItemsFolder.Name = "SpawnableItems"
    ItemsFolder.Parent = ReplicatedStorage
else
    ItemsFolder = ReplicatedStorage:FindFirstChild("SpawnableItems")
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ItemSpawnerGui"
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 180)
Frame.Position = UDim2.new(0.5, -125, 0.5, -90)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Text = "Garden Item Spawner"
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local ItemNameLabel = Instance.new("TextLabel")
ItemNameLabel.Text = "Item Name:"
ItemNameLabel.Size = UDim2.new(0.8, 0, 0, 20)
ItemNameLabel.Position = UDim2.new(0.1, 0, 0.25, 0)
ItemNameLabel.BackgroundTransparency = 1
ItemNameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ItemNameLabel.Font = Enum.Font.Gotham
ItemNameLabel.TextXAlignment = Enum.TextXAlignment.Left
ItemNameLabel.Parent = Frame

local ItemTextBox = Instance.new("TextBox")
ItemTextBox.PlaceholderText = "e.g. RedFox, FlowerPot, Shovel"
ItemTextBox.Size = UDim2.new(0.8, 0, 0, 30)
ItemTextBox.Position = UDim2.new(0.1, 0, 0.35, 0)
ItemTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ItemTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ItemTextBox.Font = Enum.Font.Gotham
ItemTextBox.ClearTextOnFocus = false
ItemTextBox.Parent = Frame

local SpawnButton = Instance.new("TextButton")
SpawnButton.Text = "Spawn Item"
SpawnButton.Size = UDim2.new(0.6, 0, 0, 35)
SpawnButton.Position = UDim2.new(0.2, 0, 0.6, 0)
SpawnButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
SpawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnButton.Font = Enum.Font.GothamBold
SpawnButton.Parent = Frame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Text = ""
StatusLabel.Size = UDim2.new(0.8, 0, 0, 20)
StatusLabel.Position = UDim2.new(0.1, 0, 0.8, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = Frame

-- Function to find and spawn actual game assets
local function spawnRealItem(itemName)
    -- Check if item name is empty
    if itemName == nil or itemName == "" then
        StatusLabel.Text = "Please enter an item name!"
        task.wait(2)
        StatusLabel.Text = ""
        return
    end
    
    -- First check the SpawnableItems folder
    local item = ItemsFolder:FindFirstChild(itemName, true)
    
    -- If not found there, search the entire game (this might be performance intensive)
    if not item then
        item = game:GetService("ServerStorage"):FindFirstChild(itemName, true) or
               game:GetService("Workspace"):FindFirstChild(itemName, true) or
               game:GetService("ReplicatedStorage"):FindFirstChild(itemName, true)
    end
    
    if item then
        -- If it's a model or tool, clone it to the backpack
        if item:IsA("Tool") or item:IsA("Model") then
            local clone = item:Clone()
            clone.Parent = Player.Backpack
            StatusLabel.Text = itemName.." spawned!"
            task.wait(2)
            StatusLabel.Text = ""
        else
            StatusLabel.Text = "Found item but it's not spawnable!"
            task.wait(2)
            StatusLabel.Text = ""
        end
    else
        StatusLabel.Text = "Item '"..itemName.."' not found!"
        task.wait(2)
        StatusLabel.Text = ""
    end
end

-- Connect the button click event
SpawnButton.MouseButton1Click:Connect(function()
    spawnRealItem(ItemTextBox.Text)
end)

-- Optional: Add autocomplete suggestions
local function updateSuggestions()
    -- This would show suggestions based on items in the SpawnableItems folder
    -- Implementation depends on how you want the UI to work
end

ItemTextBox:GetPropertyChangedSignal("Text"):Connect(updateSuggestions)