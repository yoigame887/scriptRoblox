-- [[ STEMTV | ANIME POWER LEAGUE ALL-IN-ONE ]] --
if not game:IsLoaded() then game.Loaded:Wait() end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "STEMTV | Anime Power League ??",
    LoadingTitle = "STEMTVx1 Script Hub",
    LoadingSubtitle = "The Perfect Edition",
    ConfigurationSaving = { Enabled = true, FolderName = "STEMTV_APL", FileName = "MainConfig" },
    ToggleUIKeybind = "K",
    Theme = "DarkBlue",
})

-- ===================== Services & Variables =====================
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

local AbilityEvent = RS:WaitForChild("Events"):WaitForChild("AbilityEvent")
local TrainSignal = RS:WaitForChild("Events"):WaitForChild("TrainSignal")
local TriggerMobility = RS:WaitForChild("Events"):WaitForChild("TriggerMobility")
local enemiesFolder = workspace:WaitForChild("ActiveEnemies")

_G.Height = 15
_G.AutoStats = true

-- ===================== Helper Functions =====================
local function getChar()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
        return char, char.HumanoidRootPart, char.Humanoid
    end
    return nil
end

-- ===================== TAB 1: AUTO FARM (STATS) =====================
local Tab1 = Window:CreateTab("Auto Farm", "zap")

Tab1:CreateToggle({
    Name = "?? Auto Farm ALL Stats (One Click)",
    CurrentValue = _G.AutoStats,
    Callback = function(v)
        _G.AutoStats = v
        if v then
            task.spawn(function()
                while _G.AutoStats do
                    pcall(function()
                        for i = 1, 8 do TrainSignal:FireServer(i) end
                        TriggerMobility:FireServer()
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

local function addStat(name, id)
    local state = false
    Tab1:CreateToggle({
        Name = name,
        Callback = function(v)
            state = v
            task.spawn(function()
                while state do pcall(function() TrainSignal:FireServer(id) end) task.wait() end
            end)
        end
    })
end

addStat("Strength", 1)
addStat("Health", 2)
addStat("Psychic", 3)
addStat("Defense", 5)
addStat("Magic", 6)
addStat("Melee", 7)
addStat("Aura", 8)

-- ===================== TAB 2: REMOTE SHOP (WIKI DATA) =====================
local Tab2 = Window:CreateTab("Remote Shop", "shopping-cart")

-- รายการร้านค้าและไอเทมแนะนำจาก Wiki (อ้างอิงรายชื่อร้าน 20 แห่ง)
local shopsData = {
    {Store = "Starter Store", Item = "Dumbbell", Price = "Free/Low"},
    {Store = "Lifting Store", Item = "Heavy Weight", Price = "500 Tokens"},
    {Store = "Rocks Store", Item = "Strange Matter", Price = "10M Tokens"}, -- Best Health
    {Store = "Church Store", Item = "Devil Skull", Price = "50M Tokens"},   -- Best Psychic
    {Store = "Technology Store", Item = "Ultimate Booster", Price = "500M Tokens"},
    {Store = "Exotic Weights Store", Item = "Exotic Matter", Price = "5B Tokens"}
}

Tab2:CreateSection("?? Best Buy (Wiki Recommended Items)")

for _, data in ipairs(shopsData) do
    Tab2:CreateButton({
        Name = "Buy: " .. data.Item .. " (" .. data.Price .. ")",
        Callback = function()
            -- ค้นหาจุดขายทั่วแมพและจำลองการกดซื้อ
            local found = false
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and (string.find(obj.Parent.Name, data.Item) or string.find(obj.ObjectText, data.Item)) then
                    fireproximityprompt(obj)
                    found = true
                    break
                end
            end
            
            if not found then
                Rayfield:Notify({
                    Title = "Notice",
                    Content = "หาร้านค้าไม่พบในโซนปัจจุบัน หรือไอเทมไม่อยู่ในระยะ",
                    Duration = 3,
                })
            end
        end
    })
end

-- ===================== TAB 3: AUTO COMBAT =====================
local Tab3 = Window:CreateTab("Combat", "swords")

Tab3:CreateSlider({
    Name = "God Mode Height",
    Range = {5, 50},
    Increment = 1,
    CurrentValue = _G.Height,
    Callback = function(v) _G.Height = v end,
})

Tab3:CreateToggle({
    Name = "?? Auto Farm Zones (1-9)",
    Callback = function(v)
        _G.AutoMonster = v
        task.spawn(function()
            while _G.AutoMonster do
                local char, hrp, hum = getChar()
                if char then
                    for i = 1, 9 do
                        if not _G.AutoMonster or hum.Health <= 0 then break end
                        local zone = enemiesFolder:FindFirstChild(tostring(i))
                        if zone then
                            for _, enemy in pairs(zone:GetChildren()) do
                                if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                    while _G.AutoMonster and enemy.Parent and enemy.Humanoid.Health > 0 and hum.Health > 0 do
                                        pcall(function() 
                                             hrp.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, _G.Height, 0)
                                            AbilityEvent:FireServer("Punch", hrp.Position, 2, enemy)
                                        end)
                                        task.wait(0.1)
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
})

-- ===================== TAB 4: SETTINGS =====================
local Tab4 = Window:CreateTab("Settings", "shield")

Tab4:CreateToggle({
    Name = "?? Hide Player Name",
    Callback = function(v)
        _G.HideName = v
        task.spawn(function()
            while _G.HideName do
                local _, _, hum = getChar()
                if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
                task.wait(2)
            end
        end)
    end
})

-- ===================== ANTI-AFK =====================
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

Rayfield:Notify({Title = "STEMTV SYSTEM", Content = "Script is Ready!", Duration = 5})