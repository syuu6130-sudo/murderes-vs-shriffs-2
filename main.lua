-- 📍 クリックした地点の真上にテレポート → ☁ゆっくり落下
-- 作者: @syu_0316

local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()

mouse.Button1Down:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end

    -- クリックした地点の位置
    local hitPos = mouse.Hit and mouse.Hit.p
    if not hitPos then return end

    -- 高い位置にテレポート
    hrp.CFrame = CFrame.new(hitPos + Vector3.new(0, 150, 0))

    -- 落下速度を一時的に遅くする（パラシュート効果）
    local originalGravity = workspace.Gravity
    workspace.Gravity = 20 -- 通常は196.2

    -- 5秒後に重力を元に戻す
    task.delay(5, function()
        workspace.Gravity = originalGravity
    end)
end)
