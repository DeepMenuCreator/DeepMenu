--[[
    DeepMenu ULTIMATE
    Собрано с лучших скриптов: KaitoHub, Sirius Hub, Owl Hub
    Для Delta Executor
]]

-- Функция проверки загрузки игры
repeat wait() until game:IsLoaded()

-- Защита от повторного запуска
if _G.DeepMenuLoaded then 
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DeepMenu", Text = "Уже запущен!", Duration = 2
    })
    return 
end
_G.DeepMenuLoaded = true

-- Используем Kavo UI (самая популярная библиотека)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("DeepMenu - Escape Tsunami", "DarkTheme")

-- Переменные
local Player = game.Players.LocalPlayer
local Character = Player.Character
local Humanoid = Character and Character:FindFirstChild("Humanoid")
local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

-- Обновление персонажа
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
end)

-- Функция поиска объектов (оптимизированная)
local function FindFirstObject(name)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == name then
            return obj
        end
    end
    return nil
end

local function GetAllObjects(name)
    local objects = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == name then
            table.insert(objects, obj)
        end
    end
    return objects
end

-- Уведомления
local function Notify(text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DeepMenu", Text = text, Duration = 2
    })
end

-- =============================================
-- TAB: HOME (ВЗЯТО ИЗ KAITOHUB)
-- =============================================
local HomeTab = Window:NewTab("🏠 Home")
local HomeSection = HomeTab:NewSection("Основные функции")

-- Удаление стен (из KaitoHub)
HomeSection:NewButton("Delete VIP Walls", "Убирает стены VIP зоны", function()
    local walls = GetAllObjects("VipWall")
    for _, wall in ipairs(walls) do
        pcall(function() wall:Destroy() end)
    end
    Notify("Удалено стен: " .. #walls)
end)

-- Автосбор монет (из Sirius Hub)
local Collect = false
HomeSection:NewToggle("Auto Collect Money", "Автоматически собирает монеты", function(state)
    Collect = state
    Notify("Автосбор: " .. (state and "ВКЛ" or "ВЫКЛ"))
    
    while Collect do
        pcall(function()
            for _, coin in pairs(workspace:GetDescendants()) do
                if coin.Name == "Coin" and coin:IsA("BasePart") then
                    firetouchinterest(RootPart, coin, 0)
                    wait(0.05)
                end
            end
        end)
        wait(0.3)
    end
end)

-- Прокачка скорости (из Owl Hub)
HomeSection:NewTextBox("Speed", "Установить скорость (16-120)", function(value)
    local speed = tonumber(value)
    if speed and Humanoid then
        Humanoid.WalkSpeed = speed
        Notify("Скорость: " .. speed)
    end
end)

-- Авто Rebirth (из KaitoHub)
local Rebirth = false
HomeSection:NewToggle("Auto Rebirth", "Автоматическое перерождение", function(state)
    Rebirth = state
    while Rebirth do
        pcall(function()
            local args = { [1] = "Rebirth" }
            game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):FindFirstChild("Rebirth"):InvokeServer(unpack(args))
        end)
        wait(30)
    end
end)

-- =============================================
-- TAB: TOWER (ВЗЯТО ИЗ SIRIUS HUB)
-- =============================================
local TowerTab = Window:NewTab("🗼 Tower")
local TowerSection = TowerTab:NewSection("Испытание башни")

-- Запуск башни
TowerSection:NewButton("Start Tower Trial", "Начинает испытание", function()
    pcall(function()
        local args = { [1] = "StartTrial" }
        game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):FindFirstChild("StartTower"):FireServer(unpack(args))
    end)
    Notify("Башня запущена")
end)

-- Авто сбор в башне
local TowerCollect = false
TowerSection:NewToggle("Auto Collect in Tower", "Собирает бреинротов", function(state)
    TowerCollect = state
    while TowerCollect do
        pcall(function()
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Part") and (obj.Name:find("Brainrot") or obj.Name:find("Pet") or obj.Name:find("Egg")) then
                    local dist = (RootPart.Position - obj.Position).Magnitude
                    if dist < 30 then
                        RootPart.CFrame = obj.CFrame * CFrame.new(0, 2, 0)
                        wait(0.2)
                        firetouchinterest(RootPart, obj, 0)
                    end
                end
            end
        end)
        wait(0.5)
    end
end)

-- Авто сдача
local Deliver = false
TowerSection:NewToggle("Auto Deliver", "Сдает бреинротов", function(state)
    Deliver = state
    while Deliver do
        pcall(function()
            local point = FindFirstObject("DeliveryPoint") or 
                         FindFirstObject("Altar") or 
                         FindFirstObject("TowerGoal") or
                         FindFirstObject("Submit")
            
            if point then
                RootPart.CFrame = point.CFrame * CFrame.new(0, 3, 0)
                wait(0.5)
                
                local args = { [1] = "Deliver" }
                game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):FindFirstChild("Deliver"):FireServer(unpack(args))
            end
        end)
        wait(1)
    end
end)

-- =============================================
-- TAB: PLAYER (ВЗЯТО ИЗ INFINITE YIELD)
-- =============================================
local PlayerTab = Window:NewTab("👤 Player")
local PlayerSection = PlayerTab:NewSection("Настройки игрока")

-- Бог режим
local God = false
PlayerSection:NewToggle("God Mode", "Бессмертие", function(state)
    God = state
    while God do
        pcall(function()
            if Humanoid then
                Humanoid.Health = Humanoid.MaxHealth
            end
        end)
        wait(0.5)
    end
end)

-- Удаление волн
local NoWaves = false
PlayerSection:NewToggle("Delete Waves", "Убирает цунами", function(state)
    NoWaves = state
    while NoWaves do
        pcall(function()
            for _, wave in pairs(workspace:GetDescendants()) do
                if wave.Name == "Tsunami" or wave.Name == "Wave" or wave.Name == "Water" then
                    wave:Destroy()
                end
            end
        end)
        wait(0.5)
    end
end)

-- Прыжок
PlayerSection:NewTextBox("Jump Power", "Сила прыжка (50-200)", function(value)
    local power = tonumber(value)
    if power and Humanoid then
        Humanoid.JumpPower = power
        Notify("Jump: " .. power)
    end
end)

-- =============================================
-- TAB: VISUAL (ВИЗУАЛ)
-- =============================================
local VisualTab = Window:NewTab("👁️ Visual")
local VisualSection = VisualTab:NewSection("Визуальные эффекты")

-- ESP
local ESP = false
local ESPObjects = {}
VisualSection:NewToggle("ESP Players", "Подсветка игроков", function(state)
    ESP = state
    
    if ESP then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= Player and plr.Character then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.new(1, 0, 0)
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.Parent = plr.Character
                table.insert(ESPObjects, highlight)
            end
        end
    else
        for _, obj in pairs(ESPObjects) do
            pcall(function() obj:Destroy() end)
        end
        ESPObjects = {}
    end
end)

-- Визуальные деньги (из KaitoHub)
VisualSection:NewButton("Visual Money", "Показывает 9999999 монет", function()
    pcall(function()
        for _, v in pairs(Player.PlayerGui:GetDescendants()) do
            if v:IsA("TextLabel") and v.Text:find("%d+") then
                v.Text = "9999999"
            end
        end
    end)
    Notify("Визуал денег применен")
end)

-- Дюп (из Sirius Hub)
VisualSection:NewButton("Dupe Brainrot", "Копирует бреинрота", function()
    pcall(function()
        local tool = Character:FindFirstChildOfClass("Tool")
        if tool then
            local clone = tool:Clone()
            clone.Parent = workspace
            if clone:FindFirstChild("Handle") then
                clone.Handle.Position = RootPart.Position + Vector3.new(3, 2, 0)
            end
            Notify("Бреинрот скопирован!")
        else
            Notify("Возьми бреинрота в руки!")
        end
    end)
end)

-- =============================================
-- ТЕЛЕПОРТЫ (ИЗ KAITOHUB)
-- =============================================
local TeleportTab = Window:NewTab("📡 Teleport")
local TeleportSection = TeleportTab:NewSection("Быстрые телепорты")

TeleportSection:NewButton("Teleport to Center", "В центр карты", function()
    pcall(function()
        RootPart.CFrame = CFrame.new(0, 50, 0)
    end)
end)

TeleportSection:NewButton("Teleport to Tower", "К башне", function()
    pcall(function()
        local tower = FindFirstObject("Tower") or FindFirstObject("TrialTower")
        if tower then
            RootPart.CFrame = tower.CFrame * CFrame.new(0, 10, 0)
        end
    end)
end)

-- Приветствие
Notify("✅ DeepMenu ULTIMATE загружен!")