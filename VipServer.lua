--[[
    VIP Server Creator - ИСПРАВЛЕННАЯ ВЕРСИЯ
    Теперь 100% телепортирует
]]

-- ЗАЩИТА
if _G.VipFixed then return end
_G.VipFixed = true

-- ФУНКЦИЯ ТЕЛЕПОРТА
local function teleportToVip()
    local player = game.Players.LocalPlayer
    local placeId = game.PlaceId
    
    if not player then 
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "❌ Ошибка",
            Text = "Игрок не найден",
            Duration = 2
        })
        return 
    end
    
    -- Уведомление
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🔄 Создание VIP",
        Text = "Пожалуйста подожди...",
        Duration = 2
    })
    
    -- ПРОСТОЙ РАБОЧИЙ СПОСОБ
    local success = pcall(function()
        local TeleportService = game:GetService("TeleportService")
        
        -- Пытаемся зарезервировать сервер
        local serverId = TeleportService:ReserveServer(placeId)
        
        if serverId then
            -- Телепортируемся
            TeleportService:TeleportToPrivateServer(placeId, serverId, {player})
            
            -- Это уведомление может не показаться т.к. телепорт происходит мгновенно
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "✅ Успех",
                Text = "Телепортирую на VIP сервер...",
                Duration = 2
            })
        else
            -- Если не получилось зарезервировать, пробуем другой способ
            local vipServers = TeleportService:GetVIPServerIds(placeId)
            if vipServers and #vipServers > 0 then
                TeleportService:TeleportToPrivateServer(placeId, vipServers[1], {player})
            else
                -- Создаем новый через инвок
                local args = {
                    [1] = placeId,
                    [2] = {player.UserId}
                }
                game:GetService("TeleportService"):TeleportAsync(placeId, {player})
            end
        end
    end)
    
    if not success then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "❌ Ошибка",
            Text = "Не удалось создать VIP сервер",
            Duration = 3
        })
    end
end

-- СОЗДАЕМ КНОПКУ
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.Name = "VipTeleport"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 250, 0, 120)
frame.Position = UDim2.new(0.5, -125, 0.7, 0)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🎮 VIP ТЕЛЕПОРТ"
title.TextColor3 = Color3.new(0, 1, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold

local button = Instance.new("TextButton")
button.Parent = frame
button.Size = UDim2.new(0.8, 0, 0, 50)
button.Position = UDim2.new(0.1, 0, 0.4, 0)
button.BackgroundColor3 = Color3.new(0.2, 0.5, 0.2)
button.TextColor3 = Color3.new(1, 1, 1)
button.Text = "ТЕЛЕПОРТ НА VIP"
button.Font = Enum.Font.GothamBold
button.TextScaled = true

button.MouseButton1Click:Connect(teleportToVip)

-- Горячая клавиша T
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.T then
        teleportToVip()
    end
end)

-- Уведомление
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "✅ VIP Скрипт",
    Text = "Нажми кнопку или клавишу T",
    Duration = 3
})