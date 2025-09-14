-- 📝 Hitboxサイズを半分にするGUI（自分 / 全員 切り替え付き）
-- 作者: @syu_0316

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- GUI構築
local screen = Instance.new("ScreenGui")
screen.Name = "HitboxControl"
screen.ResetOnSpawn = false
screen.Parent = localPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 150)
frame.Position = UDim2.new(0.5, -120, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
frame.Parent = screen

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Hitboxサイズ制御"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.Parent = frame

-- 切り替え（対象: 自分 or 全員）
local targetMode = "自分のみ"

local modeButton = Instance.new("TextButton")
modeButton.Size = UDim2.new(1, -20, 0, 30)
modeButton.Position = UDim2.new(0, 10, 0, 40)
modeButton.Text = "対象: 自分のみ"
modeButton.TextColor3 = Color3.new(1,1,1)
modeButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
modeButton.Parent = frame

modeButton.MouseButton1Click:Connect(function()
	if targetMode == "自分のみ" then
		targetMode = "全員"
	else
		targetMode = "自分のみ"
	end
	modeButton.Text = "対象: " .. targetMode
end)

-- Hitbox半分ボタン
local hitboxButton = Instance.new("TextButton")
hitboxButton.Size = UDim2.new(1, -20, 0, 40)
hitboxButton.Position = UDim2.new(0, 10, 0, 80)
hitboxButton.Text = "Hitboxを半分にする"
hitboxButton.TextColor3 = Color3.new(1,1,1)
hitboxButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
hitboxButton.Parent = frame

-- 状態管理
local isHalf = false

-- Hitboxサイズ変更処理
local function setHitboxSize(half)
	local targetPlayers = {}

	if targetMode == "自分のみ" then
		table.insert(targetPlayers, localPlayer)
	else
		for _, p in ipairs(Players:GetPlayers()) do
			table.insert(targetPlayers, p)
		end
	end

	for _, plr in ipairs(targetPlayers) do
		if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = plr.Character.HumanoidRootPart
			if half then
				hrp.Size = Vector3.new(2,2,1)
				hrp.Transparency = 0.5
			else
				hrp.Size = Vector3.new(4,4,2)
				hrp.Transparency = 1
			end
			hrp.CanCollide = false
		end
	end
end

-- ボタン動作
hitboxButton.MouseButton1Click:Connect(function()
	isHalf = not isHalf
	if isHalf then
		hitboxButton.Text = "Hitboxを通常に戻す"
	else
		hitboxButton.Text = "Hitboxを半分にする"
	end
	setHitboxSize(isHalf)
end)
