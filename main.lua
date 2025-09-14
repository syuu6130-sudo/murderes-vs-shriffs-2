-- 📍 上空モードUI（ドラッグ移動 / 最小化 / 上空ON・OFF / 高さボタン / 高さ表示）
-- 📝 このUIは無害です。BANリスクはありません。

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- UI構築
local screen = Instance.new("ScreenGui")
screen.Name = "SkyWalkUI"
screen.ResetOnSpawn = false
screen.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 200)
frame.Position = UDim2.new(0.35, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
frame.Parent = screen

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "📍 上空モード"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.BackgroundTransparency = 1
title.Parent = frame

-- 最小化ボタン
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -35, 0, 0)
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
	frame.Size = minimized and UDim2.new(0,260,0,35) or UDim2.new(0,260,0,200)
end)

-- 上空モードトグル
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 40)
toggle.Position = UDim2.new(0, 10, 0, 40)
toggle.Text = "🟢 ON（上空モード）"
toggle.TextScaled = true
toggle.TextColor3 = Color3.new(1,1,1)
toggle.BackgroundColor3 = Color3.fromRGB(0,150,0)
toggle.Parent = frame

local active = true
local height = 100

-- 高さ選択ボタン（50 / 100 / 150）
local heights = {50, 100, 150}
for i, h in ipairs(heights) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 70, 0, 30)
	btn.Position = UDim2.new(0, 10 + (i-1)*80, 0, 90)
	btn.Text = tostring(h).." ↑"
	btn.TextScaled = true
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	btn.Parent = frame

	btn.MouseButton1Click:Connect(function()
		height = h
		currentLabel.Text = "現在: " .. tostring(height)
	end)
end

-- 現在高さ表示
local currentLabel = Instance.new("TextLabel")
currentLabel.Size = UDim2.new(1, -20, 0, 25)
currentLabel.Position = UDim2.new(0, 10, 0, 130)
currentLabel.Text = "現在: "..tostring(height)
currentLabel.TextColor3 = Color3.new(1,1,1)
currentLabel.TextScaled = true
currentLabel.BackgroundTransparency = 1
currentLabel.Parent = frame

-- 説明
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 30)
info.Position = UDim2.new(0, 10, 0, 160)
info.Text = "📱クリックで上空に移動＆空中歩行"
info.TextColor3 = Color3.new(1,1,1)
info.TextScaled = true
info.BackgroundTransparency = 1
info.Parent = frame

-- トグル機能
toggle.MouseButton1Click:Connect(function()
	active = not active
	if active then
		toggle.Text = "🟢 ON（上空モード）"
		toggle.BackgroundColor3 = Color3.fromRGB(0,150,0)
	else
		toggle.Text = "🔴 OFF（地上）"
		toggle.BackgroundColor3 = Color3.fromRGB(150,0,0)
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 5, 0)
		end
	end
end)

-- クリックで上空へ
Mouse.Button1Down:Connect(function()
	if active and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local root = LocalPlayer.Character.HumanoidRootPart
		local pos = root.Position
		root.CFrame = CFrame.new(pos.X, height, pos.Z)
	end
end)
