-- [[ STEMTV | ANIME POWER LEAGUE ALL-IN-ONE + KEY SYSTEM ]] --

-- ตรวจสอบการโหลดเกม
if not game:IsLoaded() then game.Loaded:Wait() end

-- ===================== CONFIGURATION =====================
local KeySettings = {
    RawKeyURL = "https://raw.githubusercontent.com/yoigame887/scriptRoblox/main/key.txt",
    LinkvertiseURL = "https://link-target.net/5260763/CEhU5viLVRiu"
}

-- โหลด UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ฟังก์ชันดึงคีย์ปัจจุบัน
local function GetKey()
    local success, key = pcall(function()
        return game:HttpGet(KeySettings.RawKeyURL):gsub("%s+", "")
    end)
    return success and key or "ERROR"
end

local ActualKey = GetKey()

-- ===================== KEY SYSTEM UI =====================
local KeyWindow = Rayfield:CreateWindow({
    Name = "STEMTV SYSTEM | Key Verification",
    LoadingTitle = "Checking Access...",
    LoadingSubtitle = "by STEMTVx1",
    ConfigurationSaving = { Enabled = false }
})

local KeyTab = KeyWindow:CreateTab("Key System", "key")

KeyTab:CreateInput({
    Name = "Enter Key",
    PlaceholderText = "Paste key here...",
    Callback = function(Value)
        if Value == ActualKey then
            Rayfield:Notify({Title = "Success!", Content = "Key Correct! Loading Main Script...", Duration = 3})
            task.wait(1)
            KeyWindow:Destroy()
            StartMainScript() -- เรียกสคริปต์หลักเมื่อคีย์ถูกต้อง
        else
            Rayfield:Notify({Title = "Error", Content = "Invalid Key! Please get a new one.", Duration = 3})
        end
    end,
})

KeyTab:CreateButton({
    Name = "Get Key (Copy Link)",
    Callback = function()
        setclipboard(KeySettings.LinkvertiseURL)
        Rayfield:Notify({Title = "Copied!", Content = "Link copied to clipboard! Paste in browser.", Duration = 5})
    end,
})

-- ===================== MAIN SCRIPT FUNCTION =====================
function StartMainScript()
    local Window = Rayfield:CreateWindow({
        Name = "STEMTV | Anime Power League ⚡",
        LoadingTitle = "STEMTVx1 Script Hub",
        LoadingSubtitle = "The Perfect Edition",
        ConfigurationSaving = { Enabled = true, FolderName = "STEMTV_APL", FileName = "MainConfig" },
        ToggleUIKeybind = "K",
        Theme = "DarkBlue",
    })

    -- Services & Variables
    local RS = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local VirtualUser = game:GetService("VirtualUser")
    local player = Players.LocalPlayer

    local AbilityEvent = RS:WaitForChild("Events"):WaitForChild("AbilityEvent")
    local TrainSignal = RS:WaitForChild("Events"):WaitForChild("TrainSignal")
    local TriggerMobility = RS:WaitForChild("Events"):WaitForChild("TriggerMobility")
    local enemiesFolder = workspace:WaitForChild("ActiveEnemies")

    _G.Height = 15
    _G.AutoStats = false

    local function getChar()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            return char, char.HumanoidRootPart, char.Humanoid
        end
        return nil
    end

    -- TAB 1: AUTO FARM
    local Tab1 = Window:CreateTab("Auto Farm", "zap")
    Tab1:CreateToggle({
        Name = "🔥 Auto Farm ALL Stats",
        CurrentValue = _G.AutoStats,
        Callback = function(v)
            _G.AutoStats = v
            if v then
                task.spawn(function()
                    while _G.AutoStats do
                        pcall(function()
                            for i = 1, 8 do 
                                if not _G.AutoStats then break end
                                TrainSignal:FireServer(i) 
                            end
                            TriggerMobility:FireServer()
                        end)
                        task.wait(0.15)
                    end
                end)
            end
        end
    })

    -- TAB 2: REMOTE SHOP
    local Tab2 = Window:CreateTab("Remote Shop", "shopping-cart")
    local shopsData = {
        {Store = "Starter Store", Item = "Dumbbell"},
        {Store = "Rocks Store", Item = "Strange Matter"},
        {Store = "Church Store", Item = "Devil Skull"},
        {Store = "Technology Store", Item = "Ultimate Booster"}
    }
    Tab2:CreateSection("🛒 Quick Purchase")
    for _, data in ipairs(shopsData) do
        Tab2:CreateButton({
            Name = "Buy: " .. data.Item,
            Callback = function()
                local found = false
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and (string.find(obj.Parent.Name, data.Item) or string.find(obj.ObjectText, data.Item)) then
                        fireproximityprompt(obj)
                        found = true; break
                    end
                end
                if not found then
                    Rayfield:Notify({Title = "Error", Content = "Item not found!", Duration = 2})
                end
            end
        })
    end

    -- TAB 3: COMBAT
    local Tab3 = Window:CreateTab("Combat", "swords")
    Tab3:CreateToggle({
        Name = "⚔️ Auto Farm Zones (1-9)",
        Callback = function(v)
            _G.AutoMonster = v
            task.spawn(function()
                while _G.AutoMonster do
                    local char, hrp, hum = getChar()
                    if char then
                        for i = 1, 9 do
                            if not _G.AutoMonster then break end
                            local zone = enemiesFolder:FindFirstChild(tostring(i))
                            if zone then
                                for _, enemy in pairs(zone:GetChildren()) do
                                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
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

    -- Anti-AFK
    player.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)

    Rayfield:Notify({Title = "STEMTV SYSTEM", Content = "Script Started! Welcome คุณ STEMTV", Duration = 5})
end
