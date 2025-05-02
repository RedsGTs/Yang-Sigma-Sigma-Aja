-- Anti-AFK Script with Notification
local VirtualUser = game:service("VirtualUser")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

-- Show notification
StarterGui:SetCore("SendNotification", {
    Title = "Anti-AFK Aktif";
    Text = "Script berhasil dijalankan. Kamu tidak akan di-kick karena AFK.";
    Duration = 5;
})

-- Anti-AFK behavior
Players.LocalPlayer.Idled:connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)