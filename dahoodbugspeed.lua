if _G.SpeedAnimRunning then return end
_G.SpeedAnimRunning = true

local lp = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local cam = workspace.CurrentCamera
local TargetAnimID = "rbxassetid://3152394906"
local SpeedAmount = 150
local lastToggle = 0
local lockState = false

rs.Stepped:Connect(function()
    local char = lp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if hum and hrp then
        local isPlaying = false
        for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
            if track.Animation.AnimationId == TargetAnimID then
                isPlaying = true
                break
            end
        end

        if isPlaying then
            if hum.Sit then hum.Sit = false end

            if tick() - lastToggle >= 0.01 then
                lockState = not lockState
                lastToggle = tick()
            end

            if lockState then
                local look = cam.CFrame.LookVector
                hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(look.X, 0, look.Z))
            end

            if hum.MoveDirection.Magnitude > 0 then
                local camLook = cam.CFrame.LookVector
                local dot = hum.MoveDirection:Dot(Vector3.new(camLook.X, 0, camLook.Z).Unit)

                if dot > 0.5 then
                    hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
                elseif dot < -0.5 then
                    local forward = Vector3.new(camLook.X, 0, camLook.Z).Unit
                    hrp.Velocity = Vector3.new(forward.X * SpeedAmount, hrp.Velocity.Y, forward.Z * SpeedAmount)
                else
                    hrp.Velocity = Vector3.new(hum.MoveDirection.X * SpeedAmount, hrp.Velocity.Y, hum.MoveDirection.Z * SpeedAmount)
                end
                hrp.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)
