--[[
    GZ HUB - PREMIUM EDITION
    AUTHOR: trumditraigz
    FEATURES: Aimlock, Speed, Fast Attack, ESP
    COLORS: Blue, Gold, Red
]]

-- 1. KHỞI TẠO THƯ VIỆN (Viết đúng loadstring viết thường)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "GZ HUB SUPREME | trumditraigz", 
    HidePremium = false, 
    SaveConfig = true, 
    IntroText = "GZ TIKTOK - TRUMDITRAIGZ"
})

-- 2. BIẾN CẤU HÌNH
_G.AimActive = false
_G.FastAttack = false
_G.ESP_Enabled = false
_G.WalkSpeed = 16

-- 3. LOGIC LOGO GZ CHẤT (Console)
print([[
    ██████╗ ███████╗    ██╗  ██╗██╗   ██╗██████╗ 
    ██╔════╝ ██╔════╝    ██║  ██║██║   ██║██╔══██╗
    ██║  ███╗███████╗    ███████║██║   ██║██████╔╝
    ██║   ██║╚════██║    ██╔══██║██║   ██║██╔══██╗
    ╚██████╔╝███████║    ██║  ██║╚██████╔╝██████╔╝
     ╚═════╝ ╚══════╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
    >> TRUMDITRAIGZ - GZ HUB IS ACTIVE <<
]])

-- 4. TAB COMBAT (AIM & FAST ATTACK) - MÀU VÀNG
local CombatTab = Window:MakeTab({
    Name = "Combat (GZ)",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

CombatTab:AddToggle({
    Name = "Aimlock (Khóa Tâm Chính Xác)",
    Default = false,
    Callback = function(Value)
        _G.AimActive = Value
    end    
})

CombatTab:AddToggle({
    Name = "Fast Attack (Siêu Tốc)",
    Default = false,
    Callback = function(Value)
        _G.FastAttack = Value
        task.spawn(function()
            while _G.FastAttack do
                pcall(function()
                    -- Logic tấn công nhanh giả lập click
                    local vim = game:GetService("VirtualInputManager")
                    vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end)
                task.wait(0.01)
            end
        end)
    end    
})

-- 5. TAB MOVEMENT & ESP - MÀU XANH
local MoveTab = Window:MakeTab({
    Name = "Tiện Ích (ESP/Speed)",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MoveTab:AddSlider({
    Name = "Tốc độ (Speed)",
    Min = 16, Max = 500, Default = 16,
    Color = Color3.fromRGB(255, 215, 0),
    Increment = 1,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end    
})

MoveTab:AddToggle({
    Name = "Bật ESP (Nhìn xuyên tường)",
    Default = false,
    Callback = function(Value)
        _G.ESP_Enabled = Value
        -- Đơn giản hóa ESP bằng Highlight rbx
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                if Value then
                    local h = Instance.new("Highlight", player.Character)
                    h.FillColor = Color3.fromRGB(255, 0, 0) -- Màu Đỏ
                    h.Name = "GZ_ESP"
                else
                    if player.Character:FindFirstChild("GZ_ESP") then
                        player.Character.GZ_ESP:Destroy()
                    end
                end
            end
        end
    end
})

-- 6. HỆ THỐNG XỬ LÝ NGẦM (RENDER)
game:GetService("RunService").RenderStepped:Connect(function()
    -- Aimlock mượt mà (Lerp)
    if _G.AimActive then
        local target = nil
        local dist = 200 -- FOV ngắm
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                local pos = game.Workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
                local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X/2, game.Workspace.CurrentCamera.ViewportSize.Y/2)).Magnitude
                if magnitude < dist then
                    target = v
                    dist = magnitude
                end
            end
        end
        if target then
            game.Workspace.CurrentCamera.CFrame = CFrame.new(game.Workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

OrionLib:Init()
