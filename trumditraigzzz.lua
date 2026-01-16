--[[
    ╔══════════════════════════════════════════════════════════╗
    ║        GZ HUB SUPREME - DEVELOPED BY TRUMDITRAIGZ        ║
    ║        TIKTOK: trumditraigz | VERSION: 5.0 (FINAL)       ║
    ╚══════════════════════════════════════════════════════════╝
]]

-- [ HỆ THỐNG CORE ] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- [ BIẾN CẤU HÌNH ] --
_G.GZ_Config = {
    AimActive = false,
    AimPart = "Head",
    AimSmoothness = 0.05,
    AimFOV = 150,
    ShowFOV = true,
    SpeedActive = false,
    WalkSpeed = 16,
    FastAttack = false,
    AttackDelay = 0.01,
    ESP_Enabled = false
}

-- [ KHỞI TẠO FOV CIRCLE ] --
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(255, 215, 0) -- Màu Vàng GZ
FOVCircle.Filled = false
FOVCircle.Transparency = 0.7

-- [ KHỞI TẠO UI ORION ] --
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "GZ HUB SUPREME | trumditraigz", 
    HidePremium = false, 
    SaveConfig = true, 
    IntroText = "GZ TIKTOK - LOADING SUPREME..."
})

-- [ TAB COMBAT - CHUYÊN AIM & ATTACK ] --
local CombatTab = Window:MakeTab({
    Name = "Combat (GZ)",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

CombatTab:AddToggle({
    Name = "Bật Aimlock (Khóa Đầu)",
    Default = false,
    Callback = function(v) _G.GZ_Config.AimActive = v end
})

CombatTab:AddSlider({
    Name = "Vòng FOV (Phạm vi ngắm)",
    Min = 50, Max = 800, Default = 150,
    Color = Color3.fromRGB(255, 215, 0),
    Increment = 1,
    Callback = function(v) _G.GZ_Config.AimFOV = v end
})

CombatTab:AddToggle({
    Name = "Fast Attack (Siêu Tốc Độ Đánh)",
    Default = false,
    Callback = function(v)
        _G.GZ_Config.FastAttack = v
        task.spawn(function()
            while _G.GZ_Config.FastAttack do
                pcall(function()
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0,0,0,true,game,0)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0,0,0,false,game,0)
                end)
                task.wait(_G.GZ_Config.AttackDelay)
            end
        end)
    end
})

-- [ TAB MOVEMENT - DI CHUYỂN ] --
local MoveTab = Window:MakeTab({
    Name = "Movement (Xanh)",
    Icon = "rbxassetid://4483345998"
})

MoveTab:AddSlider({
    Name = "God Speed (Tốc độ chạy)",
    Min = 16, Max = 500, Default = 16,
    Color = Color3.fromRGB(0, 191, 255),
    Increment = 1,
    Callback = function(v) _G.GZ_Config.WalkSpeed = v end
})

-- [ TAB VISUAL - ESP ] --
local VisualTab = Window:MakeTab({
    Name = "Visual (ESP)",
    Icon = "rbxassetid://4483345998"
})

VisualTab:AddToggle({
    Name = "ESP Nhìn Xuyên Tường (Đỏ)",
    Default = false,
    Callback = function(v)
        _G.GZ_Config.ESP_Enabled = v
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                if v then
                    local highlight = Instance.new("Highlight", player.Character)
                    highlight.Name = "GZ_Highlight"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                else
                    if player.Character:FindFirstChild("GZ_Highlight") then
                        player.Character.GZ_Highlight:Destroy()
                    end
                end
            end
        end
    end
})

-- [ LOGIC XỬ LÝ NGẦM CHÍNH ] --
RunService.RenderStepped:Connect(function()
    -- Cập nhật vòng FOV
    FOVCircle.Radius = _G.GZ_Config.AimFOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Visible = _G.GZ_Config.AimActive
    
    -- Xử lý Speed
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = _G.GZ_Config.WalkSpeed
    end
    
    -- Xử lý Aimlock Chính Xác
    if _G.GZ_Config.AimActive then
        local Target = nil
        local MaxDistance = _G.GZ_Config.AimFOV
        
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(_G.GZ_Config.AimPart) then
                local Pos, OnScreen = Camera:WorldToViewportPoint(v.Character[_G.GZ_Config.AimPart].Position)
                if OnScreen then
                    local Magnitude = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                    if Magnitude < MaxDistance then
                        Target = v
                        MaxDistance = Magnitude
                    end
                end
            end
        end
        
        if Target then
            local TargetPos = Target.Character[_G.GZ_Config.AimPart].Position
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, TargetPos), _G.GZ_Config.AimSmoothness)
        end
    end
end)

-- [ THÔNG BÁO KHỞI TẠO ] --
OrionLib:MakeNotification({
    Name = "GZ HUB SUPREME",
    Content = "Chào mừng trùm trumditraigz trở lại!",
    Image = "rbxassetid://4483345998",
    Time = 5
})

OrionLib:Init()
