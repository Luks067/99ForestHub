--====================================
-- 99 NOITES NA FLORESTA | HUB CORE
-- DELTA MOBILE FIX (Activated + gethui)
--====================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local cfg = {
    god = false,
    pull = false,
    heal = false
}

-- CHARACTER
local char, hrp, hum
local function loadChar(c)
    char = c
    hrp = char:WaitForChild("HumanoidRootPart")
    hum = char:WaitForChild("Humanoid")
end

if player.Character then
    loadChar(player.Character)
end
player.CharacterAdded:Connect(loadChar)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ForestHub"
gui.ResetOnSpawn = false
pcall(function()
    gui.Parent = gethui()
end)

-- FRAME
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 220, 0, 190)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true

-- BUTTON FUNCTION (MOBILE SAFE)
local function button(text, y, callback)
    local b = Instance.new("TextButton")
    b.Parent = frame
    b.Size = UDim2.new(1, -20, 0, 36)
    b.Position = UDim2.new(0, 10, 0, y)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(45,45,45)
    b.AutoButtonColor = true
    b.Active = true
    b.ZIndex = 10

    -- EVENTO CERTO PRA MOBILE
    b.Activated:Connect(callback)
end

-- BUTTONS
button("GOD MODE", 10, function()
    cfg.god = not cfg.god
end)

button("PUXAR ITENS", 55, function()
    cfg.pull = not cfg.pull
end)

button("AUTO BANDAGEM", 100, function()
    cfg.heal = not cfg.heal
end)

button("FECHAR", 145, function()
    gui:Destroy()
end)

-- GOD MODE
task.spawn(function()
    while task.wait(0.3) do
        if cfg.god and hum then
            hum.MaxHealth = math.huge
            hum.Health = hum.MaxHealth
        end
    end
end)

-- PUXAR ITENS
task.spawn(function()
    while task.wait(0.6) do
        if cfg.pull and hrp then
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("Tool") and v:FindFirstChild("Handle") then
                    v.Handle.CFrame = hrp.CFrame
                end
            end
        end
    end
end)

-- AUTO BANDAGEM
task.spawn(function()
    while task.wait(1) do
        if cfg.heal and hum and hum.Health < hum.MaxHealth * 0.7 then
            for _,t in pairs(player.Backpack:GetChildren()) do
                if t:IsA("Tool") and t.Name:lower():find("band") then
                    hum:EquipTool(t)
                    task.wait(0.15)
                    t:Activate()
                end
            end
        end
    end
end)
