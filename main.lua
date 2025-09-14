-- 📝 Hitboxサイズを3倍にするGUI（自分 / 全員 切り替え付き）+ BAN回避
-- 作者: @syu_0316

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- 🛡 BAN対策（ローカル専用適用・イベント監視ブロック）
setfflag("HumanoidParallelRemoveNoPhysics", "False")
pcall(function()
	for _, conn in pairs(getconnections(game:GetService("Players").PlayerRemoving)) do
		conn:Disable()
	end
end)

-- GUI構築
local screen = Instance.new("ScreenGui")
screen.Name = "HitboxControl"
screen.ResetOnSpawn = false
screen.Parent = localPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 170)
frame.Position = UDim2.new(0.5, -130, 0.5, -85)
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

-- 最小化ボタン
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0,30,0,30)
minimize.Position = UDim2.new(1,-35,0,0)
minimize.Text = "-"
minimize.TextScaled = true
minimize.TextColor3 = Color3.new(1,1,1)
minimize.BackgroundColor3 = Color3.fromRGB(60,60,60)
minimize.Parent = frame

local minimized = false
minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _, child in ipairs(frame:GetChildren()) do
		if child ~= title and child ~= minimize then
			child.Visible = not minimized
		end
	end
	if minimized then
		frame.Size = UDim2.new(0,260,0,40)
	else
		frame.Size = UDim2.new(0,260,0,170)
	end
end)

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

-- Hitbox三倍ボタン
local hitboxButton = Instance.new("TextButton")
hitboxButton.Size = UDim2.new(1, -20, 0, 40)
hitboxButton.Position = UDim2.new(0, 10, 0, 80)
hitboxButton.Text = "Hitboxを3倍にする"
hitboxButton.TextColor3 = Color3.new(1,1,1)
hitboxButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
hitboxButton.Parent = frame

-- 状態管理
local isTriple = false

-- Hitboxサイズ変更処理
local function setHitboxSize(triple)
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
			if triple then
				hrp.Size = Vector3.new(9,9,9) -- ←3倍
				hrp.Transparency = 0.5
			else
				hrp.Size = Vector3.new(2,2,1) -- 通常サイズに戻す
				hrp.Transparency = 1
			end
			hrp.CanCollide = false
		end
	end
end

-- ボタン動作
hitboxButton.MouseButton1Click:Connect(function()
	isTriple = not isTriple
	if isTriple then
		hitboxButton.Text = "Hitboxを通常に戻す"
	else
		hitboxButton.Text = "Hitboxを3倍にする"
	end
	setHitboxSize(isTriple)
end)
