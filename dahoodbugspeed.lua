if _G.SpeedAnimRunning then return end
_G.SpeedAnimRunning = true

local lp = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local TargetAnimID = "rbxassetid://3152394906"
local SpeedAmount = 200

rs.Stepped:Connect(function()
    local char = lp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if hum and hrp and not hum.Sit then
        local isPlaying = false
        for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
            if track.Animation.AnimationId == TargetAnimID then
                isPlaying = true
                break
            end
        end

        if isPlaying and hum.MoveDirection.Magnitude > 0 then
            hrp.Velocity = Vector3.new(hum.MoveDirection.X * SpeedAmount, hrp.Velocity.Y, hum.MoveDirection.Z * SpeedAmount)
            hrp.RotVelocity = Vector3.new(0, 0, 0)
        end
    end
end)
