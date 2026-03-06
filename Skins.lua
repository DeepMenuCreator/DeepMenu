--[[
    Sky Skin Selector v4.0
    Полностью переделанный интерфейс
    С плавающей кнопкой и перетаскиванием
]]

-- Защита от повтора
if _G.SkySkin then return end
_G.SkySkin = true

-- Переменные
local Player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Создаем основной GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SkySkinSelector"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- =============================================
-- ПЛАВАЮЩАЯ КНОПКА (открыть/закрыть)
-- =============================================
local FloatButton = Instance.new("ImageButton")
FloatButton.Name = "FloatButton"
FloatButton.Parent = ScreenGui
FloatButton.Size = UDim2.new(0, 60, 0, 60)
FloatButton.Position = UDim2.new(0.5, -30, 0.9, -30)
FloatButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
FloatButton.BackgroundTransparency = 0.3
FloatButton.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
FloatButton.ImageColor3 = Color3.new(0.3, 0.6, 1)
FloatButton.ImageTransparency = 0.2
FloatButton.Draggable = true -- КНОПКУ МОЖНО ДВИГАТЬ!
FloatButton.Active = true
FloatButton.Selectable = true

-- Эффект свечения
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 30)
UICorner.Parent = FloatButton

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.new(0.3, 0.6, 1)
UIStroke.Parent = FloatButton

local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Parent = FloatButton
ImageLabel.Size = UDim2.new(0.7, 0, 0.7, 0)
ImageLabel.Position = UDim2.new(0.15, 0, 0.15, 0)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Image = "rbxasset://textures/ui/ImagePicker/Checkmark.png" -- Иконка
ImageLabel.ImageColor3 = Color3.new(1, 1, 1)

-- Текст под кнопкой (опционально)
local ButtonText = Instance.new("TextLabel")
ButtonText.Parent = FloatButton
ButtonText.Size = UDim2.new(1, 0, 0, 20)
ButtonText.Position = UDim2.new(0, 0, 1, 5)
ButtonText.BackgroundTransparency = 1
ButtonText.Text = "МЕНЮ"
ButtonText.TextColor3 = Color3.new(1, 1, 1)
ButtonText.TextScaled = true
ButtonText.Font = Enum.Font.GothamBold

-- =============================================
-- ОСНОВНОЕ МЕНЮ (Изначально скрыто)
-- =============================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Visible = false -- Скрыто, пока не нажмут кнопку
MainFrame.Active = true
MainFrame.Draggable = true -- МОЖНО ДВИГАТЬ!

-- Скругление
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
TitleBar.BackgroundTransparency = 0.2
TitleBar.ZIndex = 2

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.Size = UDim2.new(0.8, 0, 1, 0)
TitleText.Position = UDim2.new(0.1, 0, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "✨ SKIN SELECTOR PRO"
TitleText.TextColor3 = Color3.new(1, 1, 1)
TitleText.TextScaled = true
TitleText.Font = Enum.Font.GothamBold

-- Кнопка закрытия внутри меню
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TitleBar
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
CloseButton.BackgroundColor3 = Color3.new(1, 0.3, 0.3)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.GothamBold

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- =============================================
-- ВКЛАДКИ
-- =============================================
local TabFrame = Instance.new("Frame")
TabFrame.Parent = MainFrame
TabFrame.Size = UDim2.new(1, 0, 0, 50)
TabFrame.Position = UDim2.new(0, 0, 0, 40)
TabFrame.BackgroundTransparency = 1

-- Контейнер для контента
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Parent = MainFrame
ContentFrame.Size = UDim2.new(0.9, 0, 1, -100)
ContentFrame.Position = UDim2.new(0.05, 0, 0, 90)
ContentFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
ContentFrame.BackgroundTransparency = 0.2
ContentFrame.ScrollBarThickness = 5
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = ContentFrame

-- Переменная для текущей вкладки
local currentTab = "girl"

-- Функция создания кнопок вкладок
local function createTabButton(name, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = TabFrame
    btn.Size = UDim2.new(0, 100, 0, 35)
    btn.Position = UDim2.new(pos, 0, 0.5, -17.5)
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        -- Подсветка активной кнопки
        for _, v in pairs(TabFrame:GetChildren()) do
            if v:IsA("TextButton") then
                v.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            end
        end
        btn.BackgroundColor3 = Color3.new(0.3, 0.6, 1)
        callback()
    end)
    
    return btn
end

-- =============================================
-- ФУНКЦИИ ДЛЯ КОНТЕНТА
-- =============================================

-- Очистка контента
local function clearContent()
    for _, v in pairs(ContentFrame:GetChildren()) do
        if v:IsA("TextButton") or v:IsA("TextLabel") then
            v:Destroy()
        end
    end
end

-- Функция создания кнопки скина
local function createSkinButton(name, color, callback)
    local yPos = #ContentFrame:GetChildren() * 55
    
    local btn = Instance.new("TextButton")
    btn.Parent = ContentFrame
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Position = UDim2.new(0.05, 0, 0, yPos + 5)
    btn.BackgroundColor3 = color or Color3.new(0.3, 0.3, 0.3)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    -- Обновляем размер Canvas
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 60)
end

-- Функция уведомлений
local function notify(msg)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Sky Skin",
        Text = msg,
        Duration = 2
    })
end

-- Функция применения скина
local function applySkin(name, headColor, bodyColor)
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    local desc = Instance.new("HumanoidDescription")
    
    desc.HeadColor = headColor
    desc.TorsoColor = bodyColor
    desc.LeftArmColor = bodyColor
    desc.RightArmColor = bodyColor
    desc.LeftLegColor = bodyColor
    desc.RightLegColor = bodyColor
    
    Humanoid:ApplyDescription(desc)
    notify("Скин '" .. name .. "' надет!")
end

-- =============================================
-- ВКЛАДКА: ДЕВЧАЧЬИ
-- =============================================
local girlBtn = createTabButton("👧 Девчачьи", 0.05, function()
    clearContent()
    currentTab = "girl"
    
    createSkinButton("🤍 Белый жемчуг", Color3.new(1, 0.9, 0.9), function()
        applySkin("Белый жемчуг", Color3.new(1, 0.95, 0.95), Color3.new(1, 0.9, 0.9))
    end)
    
    createSkinButton("🖤 Черный бархат", Color3.new(0.2, 0.2, 0.2), function()
        applySkin("Черный бархат", Color3.new(0.2, 0.2, 0.2), Color3.new(0.15, 0.15, 0.15))
    end)
    
    createSkinButton("🌸 Розовая мечта", Color3.new(1, 0.6, 0.7), function()
        applySkin("Розовая мечта", Color3.new(1, 0.7, 0.8), Color3.new(1, 0.6, 0.7))
    end)
    
    createSkinButton("💜 Фиолетовый туман", Color3.new(0.7, 0.5, 0.9), function()
        applySkin("Фиолетовый туман", Color3.new(0.8, 0.6, 1), Color3.new(0.7, 0.5, 0.9))
    end)
end)

-- =============================================
-- ВКЛАДКА: МАЛЬЧИШЕСКИЕ
-- =============================================
local boyBtn = createTabButton("👦 Мальчишеские", 0.35, function()
    clearContent()
    currentTab = "boy"
    
    createSkinButton("⚪ Белый металл", Color3.new(0.8, 0.8, 0.8), function()
        applySkin("Белый металл", Color3.new(0.9, 0.9, 0.9), Color3.new(0.8, 0.8, 0.8))
    end)
    
    createSkinButton("⚫ Черный уголь", Color3.new(0.15, 0.15, 0.15), function()
        applySkin("Черный уголь", Color3.new(0.15, 0.15, 0.15), Color3.new(0.12, 0.12, 0.12))
    end)
    
    createSkinButton("💙 Синий лед", Color3.new(0.5, 0.7, 0.9), function()
        applySkin("Синий лед", Color3.new(0.6, 0.8, 1), Color3.new(0.5, 0.7, 0.9))
    end)
    
    createSkinButton("❤️ Красный драйв", Color3.new(0.9, 0.3, 0.3), function()
        applySkin("Красный драйв", Color3.new(1, 0.4, 0.4), Color3.new(0.9, 0.3, 0.3))
    end)
end)

-- =============================================
-- ВКЛАДКА: АКСЕССУАРЫ
-- =============================================
local accBtn = createTabButton("👑 Аксессуары", 0.65, function()
    clearContent()
    currentTab = "accessories"
    
    local yPos = 5
    local accessories = {"👑 Корделиус", "👟 Кроссовки белые", "👞 Туфли черные", "✨ Убрать всё"}
    
    for _, name in ipairs(accessories) do
        local btn = Instance.new("TextButton")
        btn.Parent = ContentFrame
        btn.Size = UDim2.new(0.9, 0, 0, 45)
        btn.Position = UDim2.new(0.05, 0, 0, yPos)
        btn.BackgroundColor3 = Color3.new(0.3, 0.4, 0.6)
        btn.Text = name
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextScaled = true
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            notify("✨ " .. name .. " (функция в разработке)")
        end)
        
        yPos = yPos + 55
    end
    
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)
end)

-- =============================================
-- УПРАВЛЕНИЕ МЕНЮ
-- =============================================

-- Открыть/закрыть по кнопке
FloatButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    -- Анимация кнопки
    FloatButton:TweenSize(UDim2.new(0, 50, 0, 50), "Out", "Quad", 0.1, true)
    wait(0.1)
    FloatButton:TweenSize(UDim2.new(0, 60, 0, 60), "Out", "Quad", 0.1, true)
end)

-- Закрыть по кнопке X
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Горячая клавиша (P)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.P then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Активируем первую вкладку
wait(0.1)
girlBtn.MouseButton1Click:Fire()

-- Уведомление
notify("✨ Sky Skin Selector загружен! Нажми на синюю кнопку")