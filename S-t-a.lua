--[[
    Survive the Apocalypse - Delta Script
    Основные функции: ESP, авто-лут, бесконечные патроны/здоровье
]]

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- === НАСТРОЙКИ (можно менять) ===
local settings = {
    ESP = true,                -- Включить ESP
    AutoLoot = true,           -- Автоматически подбирать лут
    InfiniteAmmo = true,       -- Бесконечные патроны (если есть оружие)
    NoClip = false,            -- Проходить сквозь стены
    Speed = 16,                -- Скорость бега (по умолчанию 16)
}

-- === ESP (подсветка игроков и лута) ===
local function createESP()
    if not settings.ESP then return end
    
    local function addESP(obj, color)
        if obj:FindFirstChild("HighlightESP") then return end
        local highlight = Instance.new("Highlight")
        highlight.Name = "HighlightESP"
        highlight.FillColor = color or Color3.new(1, 0, 0)
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.Parent = obj
    end
    
    -- Подсветка игроков
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            addESP(plr.Character, Color3.new(1, 0, 0))
        end
    end
    
    -- Подсветка лута (пример: ищем части с именем "Loot")
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("loot") and obj:IsA("BasePart") then
            addESP(obj, Color3.new(0, 1, 0))
        end
    end
    
    -- Отслеживание новых объектов
    workspace.DescendantAdded:Connect(function(obj)
        if obj.Name:lower():find("loot") and obj:IsA("BasePart") then
            addESP(obj, Color3.new(0, 1, 0))
        end
    end)
    
    -- Отслеживание новых игроков
    game.Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function(char)
            task.wait(1)
            addESP(char, Color3.new(1, 0, 0))
        end)
    end)
end

-- === АВТО-ЛУТ ===
local function autoLoot()
    if not settings.AutoLoot then return end
    
    RunService.Heartbeat:Connect(function()
        if not player.Character then return end
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        -- Ищем лут в радиусе 20 блоков
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name:lower():find("loot") and obj:IsA("BasePart") then
                local distance = (root.Position - obj.Position).Magnitude
                if distance < 20 then
                    root.CFrame = obj.CFrame * CFrame.new(0, 2, 0)
                    task.wait(0.2)
                    -- Симулируем сбор (firetouchinterest)
                    firetouchinterest(root, obj, 0)
                    task.wait(0.1)
                    firetouchinterest(root, obj, 1)
                end
            end
        end
    end)
end

-- === БЕСКОНЕЧНЫЕ ПАТРОНЫ / ЗДОРОВЬЕ ===
local function infiniteStats()
    if not settings.InfiniteAmmo then return end
    
    RunService.Heartbeat:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            humanoid.Health = humanoid.MaxHealth
        end
        
        -- Для патронов нужно найти объект оружия
        -- Это пример для одного типа оружия
        local backpack = player.Backpack
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Ammo") then
                tool.Ammo.Value = 999
            end
        end
    end)
end

-- === NO CLIP (проход сквозь стены) ===
local function noclip()
    if not settings.NoClip then return end
    
    RunService.Stepped:Connect(function()
        if player.Character then
            for _, part in ipairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

-- === УПРАВЛЕНИЕ С КЛАВИАТУРЫ ===
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
        -- Включить/выключить ESP
        settings.ESP = not settings.ESP
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Survive Script",
            Text = "ESP: " .. (settings.ESP and "ВКЛ" or "ВЫКЛ"),
            Duration = 1
        })
    elseif input.KeyCode == Enum.KeyCode.F2 then
        -- Телепорт к курсору мыши (или в точку)
        local mouse = player:GetMouse()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.x, mouse.Hit.y + 3, mouse.Hit.z)
        end
    elseif input.KeyCode == Enum.KeyCode.F3 then
        -- Включить/выключить NoClip
        settings.NoClip = not settings.NoClip
        noclip()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Survive Script",
            Text = "NoClip: " .. (settings.NoClip and "ВКЛ" or "ВЫКЛ"),
            Duration = 1
        })
    end
end)

-- === ЗАПУСК ===
createESP()
autoLoot()
infiniteStats()

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Survive Script",
    Text = "Загружен! F1 - ESP, F2 - телепорт, F3 - NoClip",
    Duration = 3
})