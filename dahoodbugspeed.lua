if _G.SpeedAnimRunning then return end
_G.SilentAimRunning = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local TargetAnimID = "rbxassetid://3152394906"
local SpeedAmount = 200

RunService.RenderStepped:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character:FindFirstChild("HumanoidRootPart") then
        local hum = lp.Character.Humanoid
        local hrp = lp.Character.HumanoidRootPart
        local isPlaying = false

        local tracks = hum:GetPlayingAnimationTracks()
        for _, track in pairs(tracks) do
            if track.Animation and track.Animation.AnimationId == TargetAnimID then
                isPlaying = true
                break
            end
        end

        if isPlaying then
            if hum.Sit then 
                hum.Sit = false 
            end

            if hum.MoveDirection.Magnitude > 0 then
                hrp.Velocity = Vector3.new(hum.MoveDirection.X * SpeedAmount, hrp.Velocity.Y, hum.MoveDirection.Z * SpeedAmount)
                hum.CameraOffset = Vector3.new(0, 0, 0)
            end
        else
            hum.CameraOffset = Vector3.new(0, 0, 0)
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        local hum = lp.Character.Humanoid
        if hum.Sit then
            hum.Sit = false
        end
    end
end)
