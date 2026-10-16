-- Set Speed tab for a Roblox experience you own.
-- Place this LocalScript in StarterPlayer > StarterPlayerScripts.
-- This standalone UI does not modify or depend on Invisible Hub.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local MIN_SPEED, MAX_SPEED = 50, 1000

local gui = Instance.new("ScreenGui")
gui.Name = "SetSpeedGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local openButton = Instance.new("TextButton")
openButton.Name = "SetSpeedTab"
openButton.Size = UDim2.fromOffset(120, 36)
openButton.Position = UDim2.new(0, 16, 0.5, -18)
openButton.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
openButton.TextColor3 = Color3.new(1, 1, 1)
openButton.Text = "Set Speed"
openButton.TextSize = 14
openButton.Font = Enum.Font.GothamSemibold
openButton.Parent = gui
Instance.new("UICorner", openButton).CornerRadius = UDim.new(0, 8)

local panel = Instance.new("Frame")
panel.Name = "SpeedPanel"
panel.Size = UDim2.fromOffset(230, 140)
panel.Position = UDim2.new(0, 16, 0.5, 26)
panel.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
panel.Visible = false
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 26)
title.Position = UDim2.fromOffset(10, 8)
title.BackgroundTransparency = 1
title.Text = "Movement Speed (50–1000)"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 13
title.Font = Enum.Font.GothamSemibold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local input = Instance.new("TextBox")
input.Name = "SpeedInput"
input.Size = UDim2.new(1, -20, 0, 32)
input.Position = UDim2.fromOffset(10, 42)
input.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
input.TextColor3 = Color3.new(1, 1, 1)
input.PlaceholderColor3 = Color3.fromRGB(175, 175, 185)
input.PlaceholderText = "Enter speed (e.g. 600)"
input.Text = "16"
input.ClearTextOnFocus = false
input.TextSize = 14
input.Font = Enum.Font.Gotham
input.Parent = panel
Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)

local apply = Instance.new("TextButton")
apply.Name = "ApplySpeed"
apply.Size = UDim2.new(1, -20, 0, 30)
apply.Position = UDim2.fromOffset(10, 82)
apply.BackgroundColor3 = Color3.fromRGB(35, 110, 190)
apply.TextColor3 = Color3.new(1, 1, 1)
apply.Text = "Apply"
apply.TextSize = 14
apply.Font = Enum.Font.GothamSemibold
apply.Parent = panel
Instance.new("UICorner", apply).CornerRadius = UDim.new(0, 6)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 18)
status.Position = UDim2.fromOffset(10, 114)
status.BackgroundTransparency = 1
status.Text = ""
status.TextColor3 = Color3.fromRGB(255, 125, 125)
status.TextSize = 11
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = panel

openButton.Activated:Connect(function()
    panel.Visible = not panel.Visible
end)

local function applySpeed()
    local value = tonumber(input.Text)
    if not value or value ~= math.floor(value) then
        status.Text = "Enter a whole number."
        return
    end
    if value < MIN_SPEED or value > MAX_SPEED then
        status.Text = "Speed must be 50–1000."
        return
    end
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        status.Text = "Character is not ready."
        return
    end
    humanoid.WalkSpeed = value
    status.TextColor3 = Color3.fromRGB(125, 235, 150)
    status.Text = "Speed set to " .. value .. "."
end

apply.Activated:Connect(applySpeed)
input.FocusLost:Connect(function(enterPressed)
    if enterPressed then applySpeed() end
end)

player.CharacterAdded:Connect(function(character)
    -- Roblox's default movement speed is restored on respawn; reapply the last valid choice.
    task.wait(0.2)
    local value = tonumber(input.Text)
    if value and value == math.floor(value) and value >= MIN_SPEED and value <= MAX_SPEED then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = value end
    end
end)
