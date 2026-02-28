if _G.SilentAimRunning then return end
_G.SilentAimRunning = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

local MaxDistance = 300
local AimPart = "Head"
local MinHealth = 5

local function IsPauseKeyPressed()
    return UserInputService:IsKeyDown(Enum.KeyCode.X) 
end

local function CreateFaceCircle(targetChar)
    if targetChar:FindFirstChild("FaceCircleGui") then return end
    
    local bg = Instance.new("BillboardGui")
    bg.Name = "FaceCircleGui"
    bg.Adornee = targetChar:WaitForChild("Head")
    bg.Size = UDim2.new(4, 0, 4, 0) 
    bg.AlwaysOnTop = true
    bg.Parent = targetChar

    local img = Instance.new("ImageLabel", bg)
    img.BackgroundTransparency = 1
    img.Size = UDim2.new(1, 0, 1, 0)
    img.Image = "rbxassetid://6031097229" 
    
    task.spawn(function()
        local hue = 0
        while bg.Parent do
            hue = hue + 0.01
            if hue > 1 then hue = 0 end
            img.ImageColor3 = Color3.fromHSV(hue, 1, 1)
            img.Rotation = img.Rotation + 3
            task.wait()
        end
    end)
end

local function IsVisible(targetPart)
    local origin = camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * (targetPart.Position - origin).Magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {lp.Character, camera}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(origin, direction, raycastParams)
    return result and result.Instance:IsDescendantOf(targetPart.Parent)
end

local function GetClosestTarget()
    if IsPauseKeyPressed() then return nil end
    local target, shortest = nil, math.huge
    local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild(AimPart) then
            local hum = v.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > MinHealth then
                local head = v.Character[AimPart]
                local distToMe = (head.Position - camera.CFrame.Position).Magnitude
                if distToMe <= MaxDistance and IsVisible(head) then
                    local pos, onScreen = camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local screenDist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if screenDist < shortest then
                            target = v
                            shortest = screenDist
                        end
                    end
                end
            end
        end
    end
    return target
end

local mt = getrawmetatable(game)
local old = mt.__index
setreadonly(mt, false)
mt.__index = newcclosure(function(t, k)
    if not IsPauseKeyPressed() and t:IsA("Mouse") and (k == "Hit" or k == "Target") then
        local target = GetClosestTarget()
        if target and target.Character and target.Character:FindFirstChild(AimPart) then
            return (k == "Hit" and target.Character[AimPart].CFrame or target.Character[AimPart])
        end
    end
    return old(t, k)
end)
setreadonly(mt, true)

RunService.RenderStepped:Connect(function()
    local currentTarget = GetClosestTarget()
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character then
            local hum = v.Character:FindFirstChildOfClass("Humanoid")
            local isTarget = (v == currentTarget)
            
            if isTarget and hum and hum.Health > MinHealth then
                CreateFaceCircle(v.Character)
                if v.Character:FindFirstChild("FaceCircleGui") then
                    v.Character.FaceCircleGui.Enabled = true
                end
            else
                if v.Character:FindFirstChild("FaceCircleGui") then
                    v.Character.FaceCircleGui.Enabled = false
                end
            end

            local highlight = v.Character:FindFirstChild("SilentESP") or Instance.new("Highlight", v.Character)
            highlight.Name = "SilentESP"
            highlight.FillTransparency = 1
            highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
            highlight.Enabled = (hum and hum.Health > MinHealth)
        end
    end
end)
