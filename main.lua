-- 📦 多機能UI（上空 / スパムダンス / ランダム敵TP）
-- 📝 無害でBANリスクなし（テスト・演出用）

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- UI作成
local screen = Instance.new("ScreenGui")
screen.Name = "FunUI"
screen.ResetOnSpawn = false
screen.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 270, 0, 330)
frame.Position = UDim2.new(0.35, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
frame.Parent = screen

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "🌈 多機能モード"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.BackgroundTransparency = 1
title.Parent = frame

-- 🔽 最小化
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
	for _, c in ipairs(frame:GetChildren()) do
		if c ~= title and c ~= minimize then
			c.Visible = not minimized
		end
	end
	frame.Size = minimized and UDim2.new(0,270,0,35) or UDim2.new(0,270,0,330)
end)

-- 状態
local skyActive = false
local danceActive = false
local tpActive = false
local height = 100

-- トグルボタン作成ヘルパー
local function createToggle(name, y, defaultTextOn, defaultTextOff, colorOn, colorOff, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,-20,0,40)
	btn.Position = UDim2.new(0,10,0,y)
	btn.Text = defaultTextOff
	btn.TextScaled = true
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = colorOff
	btn.Parent = frame
	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = state and defaultTextOn or defaultTextOff
		btn.BackgroundColor3 = state and colorOn or colorOff
		callback(state)
	end)
	return btn
end

-- 📍 上空モード
local currentLabel = Instance.new("TextLabel")
currentLabel.Size = UDim2.new(1,-20,0,25)
currentLabel.Position = UDim2.new(0,10,0,85)
currentLabel.Text = "高さ: "..tostring(height)
currentLabel.TextColor3 = Color3.new(1,1,1)
currentLabel.TextScaled = true
currentLabel.BackgroundTransparency = 1
currentLabel.Parent = frame

local heights = {50,100,150}
for i,h in ipairs(heights) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0,70,0,30)
	btn.Position = UDim2.new(0,10+(i-1)*80,0,120)
	btn.Text = tostring(h).." ↑"
	btn.TextScaled = true
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	btn.Parent = frame
	btn.MouseButton1Click:Connect(function()
		height = h
		currentLabel.Text = "高さ: "..tostring(height)
	end)
end

createToggle("sky",40,"🟢 上空 ON","🔴 上空 OFF",Color3.fromRGB(0,150,0),Color3.fromRGB(150,0,0),function(state)
	skyActive = state
	if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0,5,0)
	end
end)

Mouse.Button1Down:Connect(function()
	if skyActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local root = LocalPlayer.Character.HumanoidRootPart
		local pos = root.Position
		root.CFrame = CFrame.new(pos.X, height, pos.Z)
	end
end)

-- 💃 スパムダンス
local danceThread
createToggle("dance",170,"🟢 ダンス ON","🔴 ダンス OFF",Color3.fromRGB(0,150,0),Color3.fromRGB(150,0,0),function(state)
	danceActive = state
	if danceThread then
		task.cancel(danceThread)
		danceThread = nil
	end
	if state then
		danceThread = task.spawn(function()
			while danceActive do
				if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
					local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
					local anim = Instance.new("Animation")
					anim.AnimationId = "rbxassetid://3189773368" -- 任意のダンスID
					hum:LoadAnimation(anim):Play()
				end
				task.wait(1)
			end
		end)
	end
end)

-- ⚡ ランダム敵TP
local tpThread
createToggle("tp",220,"🟢 敵TP ON","🔴 敵TP OFF",Color3.fromRGB(0,150,0),Color3.fromRGB(150,0,0),function(state)
	tpActive = state
	if tpThread then
		task.cancel(tpThread)
		tpThread = nil
	end
	if state then
		tpThread = task.spawn(function()
			while tpActive do
				local others = {}
				for _,p in ipairs(Players:GetPlayers()) do
					if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
						table.insert(others, p)
					end
				end
				if #others > 0 then
					local target = others[math.random(1,#others)]
					if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
						LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,2)
					end
				end
				task.wait(1)
			end
		end)
	else
		if Local
