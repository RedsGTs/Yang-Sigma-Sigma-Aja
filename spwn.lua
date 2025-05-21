-- Create the main GUI
local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ItemSpawnerGui"
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0.5, -100, 0.5, -75)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Text = "Grow a Garden Spawner"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local ItemNameLabel = Instance.new("TextLabel")
ItemNameLabel.Text = "Item Name:"
ItemNameLabel.Size = UDim2.new(0.8, 0, 0, 20)
ItemNameLabel.Position = UDim2.new(0.1, 0, 0.3, 0)
ItemNameLabel.BackgroundTransparency = 1
ItemNameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ItemNameLabel.Font = Enum.Font.Gotham
ItemNameLabel.TextXAlignment = Enum.TextXAlignment.Left
ItemNameLabel.Parent = Frame

local ItemTextBox = Instance.new("TextBox")
ItemTextBox.PlaceholderText = "Enter item name..."
ItemTextBox.Size = UDim2.new(0.8, 0, 0, 30)
ItemTextBox.Position = UDim2.new(0.1, 0, 0.4, 0)
ItemTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ItemTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ItemTextBox.Font = Enum.Font.Gotham
ItemTextBox.ClearTextOnFocus = false
ItemTextBox.Parent = Frame

local SpawnButton = Instance.new("TextButton")
SpawnButton.Text = "Spawn"
SpawnButton.Size = UDim2.new(0.6, 0, 0, 30)
SpawnButton.Position = UDim2.new(0.2, 0, 0.7, 0)
SpawnButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
SpawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnButton.Font = Enum.Font.GothamBold
SpawnButton.Parent = Frame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Text = ""
StatusLabel.Size = UDim2.new(0.8, 0, 0, 20)
StatusLabel.Position = UDim2.new(0.1, 0, 0.85, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = Frame

-- Spawn function
local function spawnItem(itemName)
    -- Check if item name is not empty
    if itemName == nil or itemName == "" then
        StatusLabel.Text = "Please enter an item name!"
        task.wait(2)
        StatusLabel.Text = ""
        return
    end
    
    -- Create a visual item (this is just a placeholder - you'd replace with your actual item)
    local item = Instance.new("Part")
    item.Name = itemName
    item.Size = Vector3.new(1, 1, 1)
    item.Anchored = false
    item.CanCollide = false
    
    -- Create a special mesh (you can customize this based on your actual items)
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Head
    mesh.Scale = Vector3.new(0.5, 0.5, 0.5)
    mesh.Parent = item
    
    -- Create a tool to put in the backpack
    local tool = Instance.new("Tool")
    tool.Name = itemName
    tool.Parent = Player.Backpack
    
    -- Attach the visual item to the tool
    item.Parent = tool
    item.Position = Vector3.new(0, 0, 0)
    
    -- Show status message
    StatusLabel.Text = itemName.." spawned!"
    task.wait(2)
    StatusLabel.Text = ""
end

-- Connect the button click event
SpawnButton.MouseButton1Click:Connect(function()
    spawnItem(ItemTextBox.Text)
end)