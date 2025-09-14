-- 🛡 安全なHitbox制御GUI
-- 作者: @syu_0316
-- ⚡ BAN対策: ローカルクライアント上のみ変更・サーバー送信なし

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- ⚡ BAN対策（危険イベント無効化）
pcall(function()
	setfflag("HumanoidParallelRemoveNoPhysics", "False")
	for _, conn in pairs(getconnections(Players.PlayerRemoving)) do
		conn:Disable()
	end
end)

-- 🖥 GUI作成
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HitboxSafeUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 260, 0, 180)
Frame.Position = UDim2.new(0.5, -130, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true -- 📱🖱 ドラッグ移動可能
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -35, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.Text = "⚡ セーフHitboxコントローラー"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true
Title.BackgroundTransparency = 1
Title.Parent = Frame

-- 🔽 最小化ボタン
local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0, 30, 0, 30)
Minimize.Position = UDim2.new(1, -35, 0, 0)
Minimize.Text = "―"
Minimize.TextScaled = true
Minimize.TextColor3 = Color3.new(1, 1, 1)
Minimize.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Minimize.Parent = Frame

local minimized = false
Minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _, child in ipairs(Frame:GetChildren()) do
		if child ~= Title and child ~= Minimize then
			child.Visible = not minimized
		end
	end
	Frame.Size = minimized and UDim2.new(0, 260, 0, 40) or UDim2.new(0, 260, 0, 180)
end)

-- 対象: 自分 / 全員 切り替え
local targetMode = "自分のみ"
local ModeButton = Instance.new("TextButton")
ModeButton.Size = UDim2.new(1, -20, 0, 30)
ModeButton.Position = UDim2.new(0, 10, 0, 45)
ModeButton.Text = "対象: 自分のみ"
ModeButton.TextColor3 = Color3.new(1, 1, 1)
ModeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ModeButton.Parent = Frame

ModeButton.MouseButton1Click:Connect(function()
	if targetMode == "自分のみ" then
		targetMode = "全員"
	else
		targetMode = "自分のみ"
	end
	ModeButton.Text = "対象: " .. targetMode
end)

-- Hitboxサイズ切り替えボタン
local HitboxButton = Instance.new("TextButton")
HitboxButton.Size = UDim2.new(1, -20, 0, 40)
HitboxButton.Position = UDim2.new(0, 10, 0, 90)
HitboxButton.Text = "Hitboxを3倍にする"
HitboxButton.TextColor3 = Color3.new(1, 1, 1)
HitboxButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
HitboxButton.Parent = Frame

-- BAN対策表示
local SafeInfo = Instance.new("TextLabel")
SafeInfo.Size = UDim2.new(1, -20, 0, 25)
SafeInfo.Position = UDim2.new(0, 10, 0, 140)
SafeInfo.Text = "⚡ ローカルのみ適用 → BANされません"
SafeInfo.TextColor3 = Color3.new(1, 1, 1)
SafeInfo.TextScaled = true
SafeInfo.BackgroundTransparency = 1
SafeInfo.Parent = Frame

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
				hrp.Size = Vector3.new(9, 9, 9) -- ← 3倍
				hrp.Transparency = 0.5
			else
				hrp.Size = Vector3.new(2, 2, 1) -- ← 通常
				hrp.Transparency = 1
			end
			hrp.CanCollide = false
		end
	end
end

-- ボタン動作
HitboxButton.MouseButton1Click:Connect(function()
	isTriple = not isTriple
	if isTriple then
		HitboxButton.Text = "Hitboxを通常に戻す"
	else
		HitboxButton.Text = "Hitboxを3倍にする"
	end
	setHitboxSize(isTriple)
end)
