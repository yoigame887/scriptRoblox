-- [[ STEMTV X SCRIPTS-RBX | ANIME POWER LEAGUE - AIO ULTIMATE VERSION ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

-- ===================== INITIALIZE =====================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

-- Remote Events & Folders
local Events = RS:WaitForChild("Events")
local TrainSignal = Events:WaitForChild("TrainSignal")
local TriggerMobility = Events:WaitForChild("TriggerMobility")
local AbilityEvent = Events:WaitForChild("AbilityEvent")
local enemiesFolder = workspace:WaitForChild("ActiveEnemies")

-- Global States
_G.AutoStatsMaster = false
_G.SelectedStats = {
    [1] = false, -- Strength
    [2] = false, -- Health
    [3] = false, -- Psychic
    [5] = false, -- Defense
    [6] = false, -- Magic
    [7] = false, -- Melee
    [8] = false  -- Aura
}
_G.AutoMonster = false
_G.AutoInteract = false
_G.SelectedZone = "1"
_G.Height = 15

-- ===================== FUNCTIONS =====================
local function getChar()
    local char = player.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if hrp and hum and hum.Health > 0 then
        return char, hrp, hum
    end
    return nil
end

local function getTarget(zoneName)
    local zone = enemiesFolder:FindFirstChild(tostring(zoneName))
    if not zone then return nil end
    
    for _, enemy in ipairs(zone:GetChildren()) do
        local hum = enemy:FindFirstChild("Humanoid")
        local e_hrp = enemy:FindFirstChild("HumanoidRootPart")
        if hum and hum.Health > 0 and e_hrp then
            return enemy, e_hrp
        end
    end
    return nil
end

-- ===================== UI SETUP =====================
local Window = Rayfield:CreateWindow({
    Name = "STEMTVx1 | Anime Power League",
    LoadingTitle = "STEMTV Digital Brand",
    LoadingSubtitle = "by ScriptsRBX",
    ConfigurationSaving = { Enabled = true, FolderName = "STEMTV_Configs", FileName = "APL_Ultimate" },
    ToggleUIKeybind = "K",
    Theme = "DarkBlue",
})

-- ===================== TABS =====================
local Tab1 = Window:CreateTab("Auto Farm", "zap")
local Tab2 = Window:CreateTab("Auto Combat", "swords")
local Tab3 = Window:CreateTab("Quest & NPC", "map-pin")

-- --- TAB 1: AUTO STATS (Individual Selection) ---
Tab1:CreateSection("Master Control")

Tab1:CreateToggle({
    Name = "🚀 Start Farming Selected Stats",
    CurrentValue = _G.AutoStatsMaster,
    Callback = function(v)
        _G.AutoStatsMaster = v
        if v then
            task.spawn(function()
                while _G.AutoStatsMaster do
                    pcall(function()
                        for id, enabled in pairs(_G.SelectedStats) do
                            if not _G.AutoStatsMaster then break end
                            if enabled then
                                TrainSignal:FireServer(id)
                            end
                        end
                        TriggerMobility:FireServer()
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

Tab1:CreateSection("Select Stats to Farm")

local function AddStatToggle(name, id)
    Tab1:CreateToggle({
        Name = "Train " .. name,
        CurrentValue = _G.SelectedStats[id],
        Callback = function(v)
            _G.SelectedStats[id] = v
        end
    })
end

AddStatToggle("Strength", 1)
AddStatToggle("Health", 2)
AddStatToggle("Psychic", 3)
AddStatToggle("Defense", 5)
AddStatToggle("Magic", 6)
AddStatToggle("Melee", 7)
AddStatToggle("Aura", 8)

-- --- TAB 2: AUTO COMBAT (ZONE SELECTOR) ---
Tab2:CreateSection("Zone Settings")

Tab2:CreateDropdown({
    Name = "📍 Select Farming Zone",
    Options = {"1","2","3","4","5","6","7","8","9","10","11","12"},
    CurrentOption = {"1"},
    MultipleOptions = false,
    Callback = function(Option)
        _G.SelectedZone = Option[1]
    end,
})

Tab2:CreateSlider({
    Name = "God Mode Height",
    Range = {5, 50},
    Increment = 1,
    CurrentValue = _G.Height,
    Callback = function(v) _G.Height = v end,
})

Tab2:CreateToggle({
    Name = "⚔️ Auto Farm Selected Zone",
    CurrentValue = _G.AutoMonster,
    Callback = function(v)
        _G.AutoMonster = v
        if v then
            task.spawn(function()
                while _G.AutoMonster do
                    local char, hrp, hum = getChar()
                    if char then
                        local target, t_hrp = getTarget(_G.SelectedZone)
                        if target then
                            while _G.AutoMonster and target.Parent and target.Humanoid.Health > 0 and hum.Health > 0 do
                                pcall(function()
                                    hrp.CFrame = t_hrp.CFrame * CFrame.new(0, _G.Height, 0)
                                    AbilityEvent:FireServer("Punch", hrp.Position, 2, target)
                                end)
                                task.wait(0.1)
                            end
                        else
                            task.wait(1)
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- --- TAB 3: AUTO INTERACT ---
Tab3:CreateSection("Interaction Tools")

Tab3:CreateToggle({
    Name = "🔘 Auto Interact (NPC & E)",
    CurrentValue = _G.AutoInteract,
    Callback = function(v)
        _G.AutoInteract = v
        if v then
            task.spawn(function()
                while _G.AutoInteract do
                    pcall(function()
                        for _, prompt in ipairs(game:GetDescendants()) do
                            if prompt:IsA("ProximityPrompt") then
                                fireproximityprompt(prompt)
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

-- ===================== ANTI-AFK =====================
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

Rayfield:Notify({
    Title = "STEMTV AIO Loaded",
    Content = "รวบรวมระบบเรียบร้อยแล้ว ฟาร์มให้สนุกครับ!",
    Duration = 5,
    Image = 4483362458,
})
