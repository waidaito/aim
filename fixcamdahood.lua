local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

local Multiplier = 3.3

local function ApplyCameraFix()
    local camera = workspace.CurrentCamera
    local connection
    
    connection = UserInputService.InputChanged:Connect(function(input, processed)
        if not processed and input.UserInputType == Enum.UserInputType.Touch then
            local screenWidth = camera.ViewportSize.X
            if input.Position.X > (screenWidth / 2) then
                local delta = input.Delta
                if delta.Magnitude > 0 then
                    local x = -delta.X * (Multiplier / 15)
                    local y = -delta.Y * (Multiplier / 15)
                    
                    camera.CFrame = camera.CFrame * CFrame.Angles(0, math.rad(x), 0)
                    camera.CFrame = camera.CFrame * CFrame.Angles(math.rad(y), 0, 0)
                    
                    local _, _, z = camera.CFrame:ToEulerAnglesYXZ()
                    camera.CFrame = camera.CFrame * CFrame.Angles(0, 0, -z)
                end
            end
        end
    end)
    
    lp.CharacterRemoving:Connect(function()
        if connection then connection:Disconnect() end
    end)
end

lp.CharacterAdded:Connect(ApplyCameraFix)
if lp.Character then ApplyCameraFix() end

RunService.RenderStepped:Connect(function()
    workspace.CurrentCamera.FieldOfView = 90
end)
