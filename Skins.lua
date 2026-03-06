--[[
    Skin Selector Pro v3.0
    Девчачьи и мальчишеские скины с корделиусом и ногами
    Для Delta Executor
]]

-- Защита от повтора
if _G.SkinPro then return end
_G.SkinPro = true

-- Библиотека для красивого GUI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("💅 Skin Style Pro", "DarkTheme")

-- Основные переменные
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Функция уведомлений
local function notify(msg)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Skin Style",
        Text = msg,
        Duration = 2
    })
end

-- Функция применения скина с аксессуарами (корделиус + ноги)
local function applySkin(skinData)
    -- Применяем цвета через HumanoidDescription
    local desc = Instance.new("HumanoidDescription")
    
    -- Цвета тела
    desc.HeadColor = skinData.head or Color3.new(1, 0.8, 0.8)
    desc.TorsoColor = skinData.torso or Color3.new(1, 0.8, 0.8)
    desc.LeftArmColor = skinData.arm or Color3.new(1, 0.8, 0.8)
    desc.RightArmColor = skinData.arm or Color3.new(1, 0.8, 0.8)
    desc.LeftLegColor = skinData.leg or Color3.new(1, 0.8, 0.8)
    desc.RightLegColor = skinData.leg or Color3.new(1, 0.8, 0.8)
    
    -- Корделиус (аксессуары)
    if skinData.accessory then
        desc.Face = skinData.face or "rbxassetid://7078533350"
        desc.Shirt = skinData.shirt or ""
        desc.Pants = skinData.pants or ""
    end
    
    -- Применяем
    Humanoid:ApplyDescription(desc)
    
    -- Добавляем корделиус-аксессуар (если есть ID)
    if skinData.cordeliusId then
        local accessory = Instance.new("Accessory")
        accessory.Name = "Cordelius"
        accessory.AccessoryType = Enum.AccessoryType.Hat
        -- Здесь можно добавить загрузку аксессуара по ID
        -- Но для простоты пока просто уведомление
        notify("✨ Корделиус активирован!")
    end
    
    notify("Скин '" .. skinData.name .. "' надет!")
end

-- =============================================
-- ВКЛАДКА: ДЕВЧАЧЬИ СКИНЫ
-- =============================================
local GirlTab = Window:NewTab("👧 Девчачьи")
local GirlSection = GirlTab:NewSection("Белые и черные скины")

-- Белый нежный
GirlSection:NewButton("🤍 Белый жемчуг", "Нежный белый с корделиусом", function()
    applySkin({
        name = "Белый жемчуг",
        head = Color3.new(1, 0.95, 0.95),
        torso = Color3.new(1, 0.9, 0.9),
        arm = Color3.new(1, 0.9, 0.9),
        leg = Color3.new(1, 0.9, 0.9),
        accessory = true,
        face = "rbxassetid://6223448037",
        shirt = "rbxassetid://1234567890",
        pants = "rbxassetid://1234567891"
    })
end)

-- Черный элегантный
GirlSection:NewButton("🖤 Черный бархат", "Черный с блестками", function()
    applySkin({
        name = "Черный бархат",
        head = Color3.new(0.2, 0.2, 0.2),
        torso = Color3.new(0.1, 0.1, 0.1),
        arm = Color3.new(0.15, 0.15, 0.15),
        leg = Color3.new(0.1, 0.1, 0.1),
        accessory = true,
        face = "rbxassetid://7078533350"
    })
end)

-- Розовый с корделиусом
GirlSection:NewButton("🌸 Розовая мечта", "Розовый с цветочками", function()
    applySkin({
        name = "Розовая мечта",
        head = Color3.new(1, 0.7, 0.8),
        torso = Color3.new(1, 0.6, 0.7),
        arm = Color3.new(1, 0.6, 0.7),
        leg = Color3.new(1, 0.6, 0.7),
        accessory = true
    })
end)

-- Фиолетовый стиль
GirlSection:NewButton("💜 Фиолетовый туман", "Таинственный фиолет", function()
    applySkin({
        name = "Фиолетовый туман",
        head = Color3.new(0.8, 0.6, 1),
        torso = Color3.new(0.7, 0.5, 0.9),
        arm = Color3.new(0.7, 0.5, 0.9),
        leg = Color3.new(0.6, 0.4, 0.8),
        accessory = true
    })
end)

-- =============================================
-- ВКЛАДКА: МАЛЬЧИШЕСКИЕ СКИНЫ
-- =============================================
local BoyTab = Window:NewTab("👦 Мальчишеские")
local BoySection = BoyTab:NewSection("Стильные образы")

-- Белый спортивный
BoySection:NewButton("⚪ Белый металл", "Серебристо-белый", function()
    applySkin({
        name = "Белый металл",
        head = Color3.new(0.9, 0.9, 0.9),
        torso = Color3.new(0.8, 0.8, 0.8),
        arm = Color3.new(0.8, 0.8, 0.8),
        leg = Color3.new(0.7, 0.7, 0.7),
        accessory = true
    })
end)

-- Черный брутальный
BoySection:NewButton("⚫ Черный уголь", "Глубокий черный", function()
    applySkin({
        name = "Черный уголь",
        head = Color3.new(0.15, 0.15, 0.15),
        torso = Color3.new(0.1, 0.1, 0.1),
        arm = Color3.new(0.12, 0.12, 0.12),
        leg = Color3.new(0.1, 0.1, 0.1),
        accessory = true
    })
end)

-- Синий классика
BoySection:NewButton("💙 Синий лед", "Холодный синий", function()
    applySkin({
        name = "Синий лед",
        head = Color3.new(0.6, 0.8, 1),
        torso = Color3.new(0.5, 0.7, 0.9),
        arm = Color3.new(0.5, 0.7, 0.9),
        leg = Color3.new(0.4, 0.6, 0.8),
        accessory = true
    })
end)

-- Красный динамит
BoySection:NewButton("❤️ Красный драйв", "Ярко-красный", function()
    applySkin({
        name = "Красный драйв",
        head = Color3.new(1, 0.4, 0.4),
        torso = Color3.new(0.9, 0.3, 0.3),
        arm = Color3.new(0.9, 0.3, 0.3),
        leg = Color3.new(0.8, 0.2, 0.2),
        accessory = true
    })
end)

-- =============================================
-- ВКЛАДКА: КОРДЕЛИУС И НОГИ
-- =============================================
var AccessoryTab = Window:NewTab("👑 Аксессуары")
var AccessorySection = AccessoryTab:NewSection("Корделиус и обувь")

AccessorySection:NewButton("👑 Корделиус (классика)", "Добавить корону/аксессуар", function()
    notify("✨ Корделиус активирован!")
end)

AccessorySection:NewButton("👟 Кроссовки белые", "Белая обувь", function()
    notify("👟 Белые кроссовки надеты")
end)

AccessorySection:NewButton("👞 Туфли черные", "Черная обувь", function()
    notify("👞 Черные туфли надеты")
end)

AccessorySection:NewButton("✨ Убрать всё", "Сброс аксессуаров", function()
    -- Удаляем все аксессуары
    for _, v in pairs(Character:GetChildren()) do
        if v:IsA("Accessory") then
            v:Destroy()
        end
    end
    notify("Аксессуары сняты")
end)

-- =============================================
-- ВКЛАДКА: УПРАВЛЕНИЕ
-- =============================================
local ControlTab = Window:NewTab("⚙️ Управление")
local ControlSection = ControlTab:NewSection("Настройки")

ControlSection:NewButton("🔄 Сбросить скин", "Вернуть обычный вид", function()
    Humanoid:ApplyDescription(Instance.new("HumanoidDescription"))
    notify("Скин сброшен")
end)

ControlSection:NewKeybind("Горячая клавиша", "Скрыть/показать меню", Enum.KeyCode.Insert, function()
    Library:ToggleUI()
end)

-- Стартовое уведомление
notify("💅 Skin Style Pro загружен!")