-- 📍 上空テレポートUI（最小化 + 移動可能 + ON/OFF切り替え）
-- 作者: @syu_0316

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

--============================
-- 🖥 GUI構築
--============================
local screen = Instance.new("ScreenGui")
screen.Name = "TeleportUI"
screen.ResetOnSpawn = false
screen.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 130)
frame.Position = UDim2.new(0.35, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
frame.Parent = screen

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -35, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "📍 上空テレポート"
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

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 30)
info.Position = UDim2.new(0, 10, 0, 95)
info.Text = "📱クリックで上空にテレポート"
info.TextColor3 = Color3.new(1, 1, 1)
info.TextScaled = true
info.BackgroundTransparency = 1
info.Parent = frame

--============================
-- ⚙ トグル機能と動作
--============================
local enabled = true
local originalPos = nil

toggleButton.MouseButton1Click:Connect(function()
	enabled = not enabled
	if enabled then
		toggleButton.Text = "🟢 ON（上空モード）"
		-- クリックで上空テレポートを有効にする
	else
		toggleButton.Text = "🔴 OFF（地上に戻る）"
		-- 地上に戻す
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position.X, 10, workspace.CurrentCamera.CFrame.Position.Z)
		end
	end
end)

-- クリックイベント（ON時のみ）
mouse.Button1Down:Connect(function()
	if not enabled then return end
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	if mouse.Hit then
		local hitPos = mouse.Hit.p
		hrp.CFrame = CFrame.new(hitPos + Vector3.new(0, 150, 0))
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
	frame.Size = minimized and UDim2.new(0,260,0,35) or UDim2.new(0,260,0,130)
end)
