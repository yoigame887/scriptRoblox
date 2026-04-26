-- 1. CLEANUP
if _G.AimbotLoop then _G.AimbotLoop:Disconnect() end
if _G.FOVCircle then _G.FOVCircle:Remove() end

for _, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v.Character then
        local oldEsp = v.Character:FindFirstChild("UniversalESP")
        if oldEsp then oldEsp:Destroy() end
    end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 2. CONFIGURATION
local Settings = {
    Aimbot = true,
    AimKey = Enum.UserInputType.MouseButton2,
    Smoothness = 0.1, 
    FovRadius = 100,
    ShowFOV = false, -- เปลี่ยนเป็น false เพื่อปิดการมองเห็นวงกลม
    -- ESP
    EspColor = Color3.fromRGB(255, 0, 0),
    EspTransparency = 0.5 
}

-- 3. DRAW FOV CIRCLE
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(655, 255, 255)
FOVCircle.Transparency = 1
FOVCircle.Filled = false
FOVCircle.Visible = Settings.ShowFOV -- ใช้ค่าจาก Settings
_G.FOVCircle = FOVCircle

-- 4. UNIVERSAL ESP FUNCTION
local function ApplyESP(p)
    if p == LocalPlayer then return end
    
    local function Create()
        local char = p.Character or p.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart", 10)
        
        if root then
            local old = char:FindFirstChild("UniversalESP")
            if old then old:Destroy() end

            local hl = Instance.new("Highlight")
            hl.Name = "UniversalESP"
            hl.Parent = char
            hl.FillColor = Settings.EspColor
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = Settings.EspTransparency
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        end
    end
    
    p.CharacterAdded:Connect(Create)
    if p.Character then task.spawn(Create) end
end

for _, v in pairs(Players:GetPlayers()) do ApplyESP(v) end
Players.PlayerAdded:Connect(ApplyESP)

-- 5. AIMBOT LOGIC
local function GetTarget()
    local target = nil
    local shortestDist = Settings.FovRadius
    local viewportCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local hum = v.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
                
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - viewportCenter).Magnitude
                    if dist < shortestDist then
                        target = v.Character.Head
                        shortestDist = dist
                    end
                end
            end
        end
    end
    return target
end

-- 6. MAIN RENDER LOOP
_G.AimbotLoop = RunService.RenderStepped:Connect(function()
    local viewportCenter = Vector2.new(Camera.ViewportSize.X / 1, Camera.ViewportSize.Y / 1)
    
    -- อัปเดตคุณสมบัติ FOV
    FOVCircle.Visible = Settings.ShowFOV
    FOVCircle.Radius = Settings.FovRadius
    FOVCircle.Position = viewportCenter

    -- ระบบล็อคเป้า
    if Settings.Aimbot and UserInputService:IsMouseButtonPressed(Settings.AimKey) then
        local target = GetTarget()
        if target then
            local lookAt = CFrame.new(Camera.CFrame.Position, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(lookAt, Settings.Smoothness)
        end
    end
end)

print("Universal Hack Loaded: FOV Hidden")
