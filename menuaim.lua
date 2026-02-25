local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

if CoreGui:FindFirstChild("WaiSlideMenu") then CoreGui.WaiSlideMenu:Destroy() end

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "WaiSlideMenu"
gui.IgnoreGuiInset = true

local function ShowAlert(callback)
    local alertBg = Instance.new("Frame", gui)
    alertBg.Size = UDim2.fromScale(1, 1)
    alertBg.BackgroundColor3 = Color3.new(0,0,0)
    alertBg.BackgroundTransparency = 1
    alertBg.Active = true
    local board = Instance.new("Frame", alertBg)
    board.Size = UDim2.fromOffset(300, 160)
    board.Position = UDim2.new(0.5, -150, 0.5, -80)
    board.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    board.BorderSizePixel = 0
    Instance.new("UICorner", board).CornerRadius = UDim.new(0, 15)
    local s = Instance.new("UIStroke", board)
    s.Color = Color3.fromRGB(255, 50, 50); s.Thickness = 2
    local titleAlert = Instance.new("TextLabel", board)
    titleAlert.Size = UDim2.new(1, 0, 0, 45); titleAlert.Text = "CẢNH BÁO ⚠️"; titleAlert.TextColor3 = Color3.fromRGB(255, 50, 50); titleAlert.Font = Enum.Font.GothamBlack; titleAlert.TextSize = 20; titleAlert.BackgroundTransparency = 1
    local content = Instance.new("TextLabel", board)
    content.Size = UDim2.new(1, -30, 0, 50); content.Position = UDim2.new(0, 15, 0, 50); content.Text = "Bạn có chắc chắn muốn bật nó không?"; content.TextColor3 = Color3.new(1, 1, 1); content.Font = Enum.Font.GothamBold; content.TextSize = 14; content.TextWrapped = true; content.BackgroundTransparency = 1
    local btnNo = Instance.new("TextButton", board)
    btnNo.Size = UDim2.fromOffset(110, 38); btnNo.Position = UDim2.new(0.5, -125, 0.75, 0); btnNo.BackgroundColor3 = Color3.fromRGB(45, 45, 50); btnNo.Text = "Không"; btnNo.TextColor3 = Color3.new(1,1,1); btnNo.Font = Enum.Font.GothamBold; Instance.new("UICorner", btnNo)
    local btnYes = Instance.new("TextButton", board)
    btnYes.Size = UDim2.fromOffset(110, 38); btnYes.Position = UDim2.new(0.5, 15, 0.75, 0); btnYes.BackgroundColor3 = Color3.fromRGB(255, 50, 50); btnYes.Text = "Có"; btnYes.TextColor3 = Color3.new(1,1,1); btnYes.Font = Enum.Font.GothamBold; Instance.new("UICorner", btnYes)
    board.Size = UDim2.fromOffset(0, 0); board.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(board, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.fromOffset(300, 160), Position = UDim2.new(0.5, -150, 0.5, -80)}):Play()
    TweenService:Create(alertBg, TweenInfo.new(0.3), {BackgroundTransparency = 0.5}):Play()
    btnNo.MouseButton1Click:Connect(function() alertBg:Destroy() end)
    btnYes.MouseButton1Click:Connect(function() alertBg:Destroy() callback() end)
end

local handle = Instance.new("TextButton", gui)
handle.Name = "Handle"; handle.Size = UDim2.fromOffset(250, 50); handle.Position = UDim2.new(0.5, -125, 0, 0); handle.BackgroundTransparency = 1; handle.Text = ""
local visualLine = Instance.new("Frame", handle)
visualLine.Size = UDim2.fromOffset(120, 6); visualLine.Position = UDim2.new(0.5, -60, 0, 8); visualLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255); visualLine.BackgroundTransparency = 0.5; Instance.new("UICorner", visualLine).CornerRadius = UDim.new(1, 0)

local mainGroup = Instance.new("CanvasGroup", gui)
mainGroup.Size = UDim2.fromOffset(650, 45); mainGroup.Position = UDim2.new(0.5, -325, 0, -50); mainGroup.BackgroundColor3 = Color3.fromRGB(10, 10, 15); mainGroup.GroupTransparency = 1; mainGroup.BorderSizePixel = 0
Instance.new("UICorner", mainGroup).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", mainGroup); stroke.Color = Color3.fromRGB(0, 170, 255); stroke.Thickness = 1.8

local title = Instance.new("TextLabel", mainGroup)
title.Size = UDim2.new(0, 60, 1, 0); title.Position = UDim2.new(0, 10, 0, 0); title.BackgroundTransparency = 1; title.Text = "WAI"; title.TextColor3 = Color3.fromRGB(0, 170, 255); title.Font = Enum.Font.GothamBlack; title.TextSize = 15

local container = Instance.new("ScrollingFrame", mainGroup)
container.Size = UDim2.new(1, -80, 1, 0); container.Position = UDim2.new(0, 75, 0, 0); container.BackgroundTransparency = 1; container.ScrollBarThickness = 0; container.CanvasSize = UDim2.new(0, 700, 0, 0)
local layout = Instance.new("UIListLayout", container); layout.FillDirection = Enum.FillDirection.Horizontal; layout.Padding = UDim.new(0, 10); layout.VerticalAlignment = Enum.VerticalAlignment.Center

local tpActive = false
local lastTp = tick()

RunService.RenderStepped:Connect(function()
    if tpActive and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
        local hrp = player.Character.HumanoidRootPart
        local hum = player.Character.Humanoid
        if hum.MoveDirection.Magnitude > 0 then
            if tick() - lastTp >= 0.1 then
                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * 2.5)
                lastTp = tick()
            end
        end
    end
end)

local function CreateButton(name, callback, needAlert, isToggle)
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.fromOffset(100, 30); btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50); btn.Text = name; btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamBold; btn.TextSize = 9
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(function()
        local function execute()
            if isToggle then
                tpActive = not tpActive
                btn.BackgroundColor3 = tpActive and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 50)
            else
                callback()
            end
        end
        if needAlert and (not isToggle or not tpActive) then ShowAlert(execute) else execute() end
    end)
end

CreateButton("Aim Head", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/waidaito/aim/main/aimhead.lua"))() end, true, false)
CreateButton("Aim Body", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/waidaito/aim/main/aimbody.lua"))() end, true, false)
CreateButton("Flash Step", nil, true, true)
CreateButton("Jump Power", function() 
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = 120
        player.Character.Humanoid.UseJumpPower = true
    end
end, true, false)
CreateButton("All Kill", function() loadstring(game:HttpGet("https://pastefy.app/3A2T2Wi4/raw?part=ghimlung.lua"))() end, false, false)

local dragging, dragStartPos, menuOpen = false, 0, false
handle.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStartPos = input.Position.Y end end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local deltaY = input.Position.Y - dragStartPos
        local moveY = menuOpen and math.clamp(15 + deltaY, -50, 15) or math.clamp(deltaY - 50, -50, 15)
        local alpha = math.clamp((moveY + 50) / 65, 0, 1)
        mainGroup.Position = UDim2.new(0.5, -325, 0, moveY); handle.Position = UDim2.new(0.5, -125, 0, menuOpen and math.clamp(65 + deltaY, 0, 70) or math.clamp(deltaY, 0, 70)); mainGroup.GroupTransparency = 1 - alpha
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        if mainGroup.Position.Y.Offset > -15 then
            menuOpen = true
            TweenService:Create(mainGroup, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = UDim2.new(0.5, -325, 0, 15), GroupTransparency = 0}):Play()
            TweenService:Create(handle, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = UDim2.new(0.5, -125, 0, 65)}):Play()
        else
            menuOpen = false
            TweenService:Create(mainGroup, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = UDim2.new(0.5, -325, 0, -50), GroupTransparency = 1}):Play()
            TweenService:Create(handle, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = UDim2.new(0.5, -125, 0, 0)}):Play()
        end
    end
end)
