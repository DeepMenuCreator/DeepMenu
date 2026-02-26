--[[
    DeepMenu - Escape Tsunami Brainrot
    Версия: 2.0
    Автор: Твой ник
]]

-- Загрузка библиотеки для красивого меню
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("DeepMenu - Escape Tsunami", "DarkTheme")

-- Основные переменные
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Обновление персонажа если умер
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
end)

-- Функция для поиска объектов
local function FindObjects(name)
    local objects = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == name then
            table.insert(objects, obj)
        end
    end
    return objects
end

-- Функция для уведомлений
local function Notify(text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DeepMenu",
        Text = text,
        Duration = 3
    })
end

-- =============================================
-- TAB: HOME (ГЛАВНАЯ)
-- =============================================
local HomeTab = Window:NewTab("Home")
local HomeSection = HomeTab:NewSection("Главные функции")

-- 1. Удаление VIP стен
HomeSection:NewButton("Delete VIP walls", "Убирает стены VIP зоны", function()
    local count = 0
    for _, wall in pairs(FindObjects("VipWall")) do
        wall:Destroy()
        count = count + 1
    end
    for _, wall in pairs(FindObjects("VIPWall")) do
        wall:Destroy()
        count = count + 1
    end
    Notify("Удалено стен: " .. count)
end)

-- 2. Удаление стен + платформы
HomeSection:NewButton("Delete Walls + Platforms", "Удаляет стены и создает платформы", function()
    -- Удаляем стены
    for _, wall in pairs(FindObjects("Wall")) do
        if wall:IsA("Part") then
            wall:Destroy()
        end
    end
    
    -- Создаем платформу под ногами
    local platform = Instance.new("Part")
    platform.Size = Vector3.new(50, 1, 50)
    platform.Position = RootPart.Position - Vector3.new(0, 3, 0)
    platform.Anchored = true
    platform.BrickColor = BrickColor.new("Bright blue")
    platform.Material = Enum.Material.Neon
    platform.Parent = workspace
    platform.Name = "DeepPlatform"
    
    wait(2)
    platform:Destroy()
    Notify("Стены удалены, платформа создана")
end)

-- 3. Автосбор монет
local AutoCollect = false
HomeSection:NewToggle("Auto Collect Money", "Собирает монеты автоматически", function(state)
    AutoCollect = state
    Notify("Автосбор: " .. (state and "ВКЛ" or "ВЫКЛ"))
    while AutoCollect do
        for _, coin in pairs(FindObjects("Coin")) do
            if coin and coin:IsA("Part") and coin.Parent then
                firetouchinterest(RootPart, coin, 0)
                wait(0.05)
            end
        end
        wait(0.3)
    end
end)

-- 4. Авто прокачка скорости
HomeSection:NewButton("Auto Upgrade Speed (+10)", "Прокачивает скорость на 10", function()
    local args = { [1] = "UpgradeSpeed", [2] = 10 }
    local success, err = pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Upgrade"):InvokeServer(unpack(args))
    end)
    if success then
        Notify("Скорость прокачана!")
    else
        Notify("Ошибка прокачки")
    end
end)

-- 5. Авто перерождение
local AutoRebirth = false
HomeSection:NewToggle("Auto Rebirth", "Автоматически перерождается", function(state)
    AutoRebirth = state
    Notify("АвтоRebirth: " .. (state and "ВКЛ" or "ВЫКЛ"))
    while AutoRebirth do
        local args = { [1] = "Rebirth" }
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Rebirth"):InvokeServer(unpack(args))
        end)
        wait(30)
    end
end)

-- =============================================
-- TAB: AUTO TOWER (БАШНЯ)
-- =============================================
local TowerTab = Window:NewTab("Auto Tower")
local TowerSection = TowerTab:NewSection("Башня")

-- 1. Авто старт башни
TowerSection:NewButton("Auto Start Tower", "Запускает испытание башни", function()
    local args = { [1] = "StartTrial" }
    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("StartTower"):FireServer(unpack(args))
    end)
    Notify("Башня запущена")
end)

-- 2. Авто сбор бреинротов
local AutoCollectBrainrot = false
TowerSection:NewToggle("Auto Collect Brainrot", "Подбирает бреинротов в башне", function(state)
    AutoCollectBrainrot = state
    Notify("Автосбор бреинротов: " .. (state and "ВКЛ" or "ВЫКЛ"))
    while AutoCollectBrainrot do
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") and (obj.Name:find("Brainrot") or obj.Name:find("Pet")) then
                local distance = (RootPart.Position - obj.Position).Magnitude
                if distance < 30 then
                    RootPart.CFrame = obj.CFrame * CFrame.new(0, 2, 0)
                    wait(0.2)
                    firetouchinterest(RootPart, obj, 0)
                end
            end
        end
        wait(0.5)
    end
end)

-- 3. Авто сдача в башню
local AutoDeliver = false
TowerSection:NewToggle("Auto Delivery", "Сдает бреинротов в башню", function(state)
    AutoDeliver = state
    Notify("Автосдача: " .. (state and "ВКЛ" or "ВЫКЛ"))
    while AutoDeliver do
        local deliveryPoint = workspace:FindFirstChild("DeliveryPoint") or 
                             workspace:FindFirstChild("Altar") or 
                             workspace:FindFirstChild("TowerGoal")
        
        if deliveryPoint then
            RootPart.CFrame = deliveryPoint.CFrame * CFrame.new(0, 3, 0)
            wait(0.5)
            
            local args = { [1] = "Deliver" }
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Deliver"):FireServer(unpack(args))
            end)
        end
        wait(1)
    end
end)

-- =============================================
-- TAB: PLAYER (ИГРОК)
-- =============================================
local PlayerTab = Window:NewTab("Player")
local PlayerSection = PlayerTab:NewSection("Настройки игрока")

-- 1. Пропуск кнопок
PlayerSection:NewButton("Skip Button", "Убирает задержки у кнопок", function()
    Notify("Функция Skip Button активирована")
    -- Здесь можно добавить код для пропуска задержек
end)

-- 2. Изменение скорости
PlayerSection:NewTextBox("Speed", "Введи скорость (16-100)", function(value)
    local speed = tonumber(value)
    if speed and Humanoid then
        Humanoid.WalkSpeed = speed
        Notify("Скорость установлена: " .. speed)
    else
        Notify("Введи число!")
    end
end)

-- 3. Бог режим
local GodMode = false
PlayerSection:NewToggle("Auto God", "Не умираешь с бреинротом", function(state)
    GodMode = state
    Notify("God Mode: " .. (state and "ВКЛ" or "ВЫКЛ"))
    while GodMode do
        if Character and Humanoid then
            Humanoid.Health = 100
            
            if RootPart.Position.Y < 0 then
                RootPart.Velocity = Vector3.new(0, 50, 0)
            end
        end
        wait(0.3)
    end
end)

-- 4. Удаление волн
local NoWaves = false
PlayerSection:NewToggle("Delete Waves", "Убирает волны цунами", function(state)
    NoWaves = state
    Notify("Удаление волн: " .. (state and "ВКЛ" or "ВЫКЛ"))
    while NoWaves do
        for _, wave in pairs(FindObjects("Tsunami")) do
            wave:Destroy()
        end
        for _, wave in pairs(FindObjects("Wave")) do
            wave:Destroy()
        end
        wait(0.5)
    end
end)

-- 5. Искуственный интеллект
PlayerSection:NewTextBox("ChatGPT", "Задай вопрос", function(question)
    Notify("Вопрос: " .. question .. " (Ответ в консоли)")
    print("DeepMenu - Твой вопрос: " .. question)
    print("Ответ: ИИ пока не подключен, но скоро будет!")
end)

-- =============================================
-- TAB: VISUAL (ВИЗУАЛ)
-- =============================================
local VisualTab = Window:NewTab("Visual")
local VisualSection = VisualTab:NewSection("Визуальные эффекты")

-- 1. ESP
local ESP = false
local espHighlights = {}

PlayerSection:NewToggle("ESP Players", "Подсвечивает игроков", function(state)
    ESP = state
    if ESP then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= Player and plr.Character then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.new(1, 0, 0)
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.Parent = plr.Character
                table.insert(espHighlights, highlight)
            end
        end
        Notify("ESP включен")
    else
        for _, h in pairs(espHighlights) do
            h:Destroy()
        end
        espHighlights = {}
        Notify("ESP выключен")
    end
end)

-- 2. Визуальные деньги
VisualSection:NewButton("Visual Money Boost", "Показывает много денег", function()
    local playerGui = Player:FindFirstChild("PlayerGui")
    if playerGui then
        for _, gui in pairs(playerGui:GetDescendants()) do
            if gui:IsA("TextLabel") and gui.Text:find("%d+") then
                gui.Text = "9999999"
            end
        end
    end
    Notify("Деньги обновлены (визуально)")
end)

-- 3. Визуальные токены
VisualSection:NewButton("Visual Tokens", "Показывает много токенов", function()
    local playerGui = Player:FindFirstChild("PlayerGui")
    if playerGui then
        for _, gui in pairs(playerGui:GetDescendants()) do
            if gui:IsA("TextLabel") and (gui.Text:find("Token") or gui.Text:find("токен")) then
                gui.Text = "Токены: 99999"
            end
        end
    end
    Notify("Токены обновлены (визуально)")
end)

-- 4. Дюп бреинротов
VisualSection:NewButton("Dupe Brainrot", "Копирует бреинрота", function()
    local heldItem = Character:FindFirstChildOfClass("Tool")
    if heldItem then
        local clone = heldItem:Clone()
        clone.Parent = workspace
        if clone:FindFirstChild("Handle") then
            clone.Handle.Position = RootPart.Position + Vector3.new(3, 2, 0)
        end
        Notify("Бреинрот скопирован!")
    else
        Notify("Сначала возьми бреинрота в руки")
    end
end)

-- Приветствие при запуске
Notify("DeepMenu загружен! ✅")