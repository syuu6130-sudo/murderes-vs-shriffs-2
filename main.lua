-- 📍 クリックした地点の真上にテレポート
-- 作者: @syu_0316

local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()

mouse.Button1Down:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- マウスのヒット地点を取得
    local hitPos = mouse.Hit and mouse.Hit.p
    if not hitPos then return end

    -- クリックした地点から上に100スタッド移動
    hrp.CFrame = CFrame.new(hitPos + Vector3.new(0, 100, 0))
end)
