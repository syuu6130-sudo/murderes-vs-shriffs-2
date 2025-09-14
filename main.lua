-- 📍 クリックしたら自分を上空にテレポート
-- 作者: @syu_0316

local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()

mouse.Button1Down:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- 今の位置から100スタッド上に移動
    local pos = hrp.Position
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 100, 0))
end)
