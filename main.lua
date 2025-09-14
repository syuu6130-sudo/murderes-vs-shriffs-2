-- 📍 上空モード（透明足場式・高さボタン付き）
-- 作者: @syu_0316

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

--============================
-- 🖥 GUI構築
--============================
local screen = Instance.new("ScreenGui")
screen.Name = "SkyWalkUI"
screen.ResetOnSpawn = false
screen.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 170)
frame.Position = UDim2.new(0.35, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
frame.Parent = screen

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -35, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "📍 上空モード"
title.Font = Enum.Font.SourceSansBold
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.BackgroundTransparency = 1
title.Parent = frame

-- 🔽最小化ボタン
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 25, 0, 25)
minimize.Position = UDim2.new(1, -30, 0, 5)
minimize.Text = "―"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.TextScaled = true
minimize.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimize.Parent = frame

-- 🌟ON/OFFトグル
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, -20, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 50)
toggleButton.Text = "🟢 ON（上空モード）"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.TextScaled = true
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.Parent = frame

-- 高さ選択ボタン
local heights = {50,100,150}
local heightButtons = {}
for i, h in ipairs(heights) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 70, 0, 30)
	btn.Position = UDim2.new(0, 10 + (i-1)*80, 0, 95)
	btn.Text = tostring(h).." ↑"
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextScaled = true
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.Parent = frame
	heightButtons[#heightButtons+1] = {button = btn, value = h}
end

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 30)
info.Position = UDim2.new(0, 10, 0, 135)
info.Text = "📱クリックで上空に移動＆空中歩行"
info.TextColor3 = Color3.new(1, 1, 1)
info.TextScaled = true
info.BackgroundTransparency = 1
info.Parent = frame

--============================
-- ⚙ 動作部分
--============================
local enabled = true
local platform
local addY = 150  -- 初期高さ
local targetY

toggleButton.MouseButton1Click:Connect(function()
	enabled = not enabled
	if enabled then
		toggleButton.Text = "🟢 ON（上空モード）"
	else
		toggleButton.Text = "🔴 OFF（地上に戻る）"
		if platform then
			platform:Destroy()
			platform = nil
		end
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = CFrame.new(char.HumanoidRootPart.Position.X, 10, char.HumanoidRootPart.Position.Z)
		end
	end
end)

-- 高さボタン処理
for _, data in ipairs(heightButtons) do
	data.button.MouseButton1Click:Connect(function()
		addY = data.value
	end)
end

-- クリックで上空へ
mouse.Button1Down:Connect(function()
	if not enabled then return end
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp or not mouse.Hit then return end

	local hitPos = mouse.Hit.p
	targetY = hitPos.Y + addY

	if not platform then
		platform = Instance.new("Part")
		platform.Size = Vector3.new(20, 1, 20)
		platform.Anchored = true
		platform.CanCollide = true
		platform.Transparency = 1
		platform.Parent = workspace
	end
	platform.CFrame = CFrame.new(hitPos.X, targetY - 3, hitPos.Z)
	hrp.CFrame = CFrame.new(hitPos.X, targetY, hitPos.Z)
end)

RunService.Heartbeat:Connect(function()
	if enabled and platform and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = player.Character.HumanoidRootPart
		platform.CFrame = CFrame.new(hrp.Position.X, targetY - 3, hrp.Position.Z)
	end
end)

--============================
-- 🔽 最小化機能
--============================
local minimized = false
minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _, child in ipairs(frame:GetChildren()) do
		if child ~= title and child ~= minimize then
			child.Visible = not minimized
		end
	end
	frame.Size = minimized and UDim2.new(0,260,0,35) or UDim2.new(0,260,0,170)
end)
