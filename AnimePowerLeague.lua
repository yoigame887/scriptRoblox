-- [[ STEMTV X SCRIPTS-RBX | ANIME POWER LEAGUE ]] --
-- รอจนกว่าเกมจะโหลดเสร็จสมบูรณ์ป้องกันการรันพลาด
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- ===================== INITIALIZE =====================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

-- Global States (ตั้งค่าเริ่มต้นเป็น true เพื่อให้ Auto Run)
_G.AutoStats = true
_G.AutoMonster = true
_G.AutoQuest = true
_G.AutoInteract = true
_G.Height = 15

local AbilityEvent = RS:WaitForChild("Events"):WaitForChild("AbilityEvent")
local enemiesFolder = workspace:WaitForChild("ActiveEnemies")

-- ===================== UI SETUP =====================
local Window = Rayfield:CreateWindow({
    Name = "STEMTVx1 | Anime Power League",
    LoadingTitle = "STEMTV Digital Brand",
    LoadingSubtitle = "by ScriptsRBX",
    ConfigurationSaving = { Enabled = true, FolderName = "STEMTV_Configs", FileName = "APL_Main" },
    ToggleUIKeybind = "K",
    Theme = "DarkBlue",
})

-- ===================== FUNCTIONS =====================
-- ฟังก์ชันเช็คสถานะตัวละครแบบ Real-time
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

-- ฟังก์ชันหามอนสเตอร์ที่มีชีวิต
local function getTarget(zone)
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

-- ===================== TABS =====================
local Tab1 = Window:CreateTab("Auto Farm", "zap")
local Tab2 = Window:CreateTab("Auto Combat", "swords")
local Tab3 = Window:CreateTab("Quest & NPC", "map-pin")

-- --- AUTO STATS ---
Tab1:CreateToggle({
    Name = "🔥 Auto Farm All Stats",
    CurrentValue = _G.AutoStats,
    Callback = function(v)
        _G.AutoStats = v
        if v then
            task.spawn(function()
                while _G.AutoStats do
                    pcall(function()
                        local stats = {1, 2, 3, 5, 6, 7, 8}
                        for _, id in ipairs(stats) do
                            RS.Events.TrainSignal:FireServer(id)
                        end
                        RS.Events.TriggerMobility:FireServer()
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- ===================== แท็บที่ 1: AUTO FARM (สเตตัส) =====================
local Tab = Window:CreateTab("Auto Farm", "zap")

-- ฟาร์มรวบยอด
local autoAllStats = false
Tab:CreateToggle({
    Name = "🔥 Auto Farm ALL Stats (One Click)",
    CurrentValue = false,
    Callback = function(v)
        autoAllStats = v
        if v then
            task.spawn(function()
                while autoAllStats do
                    pcall(function()
                        local stats = {1, 2, 3, 5, 6, 7, 8}
                        for _, id in ipairs(stats) do
                            TrainSignal:FireServer(id)
                        end
                        TriggerMobility:FireServer()
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

Tab:CreateSection("Individual Stats")

-- ฟังก์ชันสร้างปุ่มสเตตัสแยกตามรูปภาพ
local function createStatToggle(name, id)
    local state = false
    Tab:CreateToggle({
        Name = name,
        CurrentValue = false,
        Callback = function(v)
            state = v
            if v then
                task.spawn(function()
                    while state do
                        pcall(function() TrainSignal:FireServer(id) end)
                        task.wait()
                    end
                end)
            end
        end
    })
end

createStatToggle("Strength", 1)
createStatToggle("Health", 2)
createStatToggle("Psychic", 3)
createStatToggle("Defense", 5)
createStatToggle("Magic", 6)
createStatToggle("Melee", 7)
createStatToggle("Aura", 8)

-- Mobility แยกต่างหากเพราะใช้ Event ไม่เหมือนชาวบ้าน
local mobilityState = false
Tab:CreateToggle({
    Name = "Mobility",
    CurrentValue = false,
    Callback = function(v)
        mobilityState = v
        if v then
            task.spawn(function()
                while mobilityState do
                    pcall(function() TriggerMobility:FireServer() end)
                    task.wait()
                end
            end)
        end
    end
})

-- --- AUTO MONSTER (1-10) ---
Tab2:CreateSlider({
    Name = "God Mode Height",
    Range = {5, 50},
    Increment = 1,
    CurrentValue = _G.Height,
    Callback = function(v) _G.Height = v end,
})

Tab2:CreateToggle({
    Name = "⚔️ Auto Farm Monsters (1-10)",
    CurrentValue = _G.AutoMonster,
    Callback = function(v)
        _G.AutoMonster = v
        if v then
            task.spawn(function()
                while _G.AutoMonster do
                    local char, hrp, hum = getChar()
                    if char then
                        for i = 1, 10 do
                            if not _G.AutoMonster or hum.Health <= 0 then break end
                            local zone = enemiesFolder:FindFirstChild(tostring(i))
                            local target, t_hrp = getTarget(zone)
                            
                            if target then
                                while _G.AutoMonster and target.Parent and target.Humanoid.Health > 0 and hum.Health > 0 do
                                    pcall(function()
                                        hrp.CFrame = t_hrp.CFrame * CFrame.new(0, _G.Height, 0)
                                        AbilityEvent:FireServer("Punch", hrp.Position, 2, target)
                                    end)
                                    task.wait(0.1)
                                end
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

-- --- AUTO QUEST & INTERACT ---
Tab3:CreateToggle({
    Name = "🚶 Smart Auto Quest (Follow Arrows)",
    CurrentValue = _G.AutoQuest,
    Callback = function(v)
        _G.AutoQuest = v
        if v then
            task.spawn(function()
                while _G.AutoQuest do
                    local char, hrp, hum = getChar()
                    if char then
                        local found = false
                        for _, zone in ipairs(enemiesFolder:GetChildren()) do
                            local target, t_hrp = getTarget(zone)
                            if target then
                                found = true
                                while _G.AutoQuest and target.Parent and target.Humanoid.Health > 0 and hum.Health > 0 do
                                    pcall(function()
                                        hrp.CFrame = t_hrp.CFrame * CFrame.new(0, _G.Height, 0)
                                        AbilityEvent:FireServer("Punch", hrp.Position, 2, target)
                                    end)
                                    task.wait(0.1)
                                end
                            end
                            if found or not _G.AutoQuest then break end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

Tab3:CreateToggle({
    Name = "🔘 Auto Interact (NPC & E)",
    CurrentValue = _G.AutoInteract,
    Callback = function(v)
        _G.AutoInteract = v
        if v then
            task.spawn(function()
                while _G.AutoInteract do
                    pcall(function()
                        -- แตะ NPC
                        local npcs = workspace:FindFirstChild("NPCs") or workspace:FindFirstChild("QuestPoints")
                        local _, hrp = getChar()
                        if hrp and npcs then
                            for _, npc in ipairs(npcs:GetChildren()) do
                                local touch = npc:FindFirstChild("HumanoidRootPart") or (npc:IsA("BasePart") and npc)
                                if touch then
                                    firetouchinterest(hrp, touch, 0)
                                    task.wait()
                                    firetouchinterest(hrp, touch, 1)
                                end
                            end
                        end
                        -- กด E
                        for _, prompt in ipairs(game:GetDescendants()) do
                            if prompt:IsA("ProximityPrompt") then
                                fireproximityprompt(prompt)
                            end
                        end
                    end)
                    task.wait(2)
                end
            end)
        end
    end
})

-- ตัวอย่างการเพิ่มปุ่ม Redeem Codes ใน SettingTab
SettingTab:CreateButton({
    Name = "🎁 Redeem All Active Codes",
    Callback = function()
        local codes = {"RELEASE", "UPDATE1", "1MVISITS", "POWERUP"} -- เอาโค้ดจาก Wiki มาใส่ตรงนี้
        for _, code in pairs(codes) do
            RS.Events.CodeEvent:FireServer(code) -- ตรวจสอบชื่อ Remote Event ในเกมอีกครั้ง
        end
    end,
})

-- ===================== ANTI-AFK =====================
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

Rayfield:Notify({
    Title = "STEMTV Script Loaded",
    Content = "สคริปต์เริ่มทำงานอัตโนมัติแล้ว ขอให้สนุกกับการฟาร์มครับ!",
    Duration = 5,
    Image = 4483362458,
})
