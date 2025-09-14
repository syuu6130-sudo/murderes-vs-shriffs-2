-- // UI作成
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local originalPosition -- ランダムTP用保存位置

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

-- メインフレーム
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 250, 0, 300)
main.Position = UDim2.new(0.4, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(40,40,40)
main.Active = true
main.Draggable = true
main.Parent = gui

-- 最小化ボタン
local mini = Instance.new("TextButton")
mini.Size = UDim2.new(0, 30, 0, 30)
mini.Position = UDim2.new(1, -35, 0, 5)
mini.Text = "-"
mini.BackgroundColor3 = Color3.fromRGB(80,80,80)
mini.Parent = main

-- コンテンツフレーム
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -10, 1, -45)
content.Position = UDim2.new(0, 5, 0, 40)
content.BackgroundTransparency = 1
content.Parent = main

-- 最小化処理
local minimized = false
mini.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    main.Size = minimized and UDim2.new(0,250,0,40) or UDim2.new(0,250,0,300)
end)

-- ボタン生成用関数
local function makeButton(text, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, y)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = content
    return btn
end

-- 上空テレポートボタン
local tp50 = makeButton("⛅ 高さ50に移動 (Toggle)", 0)
local tp100 = makeButton("⛅ 高さ100に移動 (Toggle)", 40)
local tp150 = makeButton("⛅ 高さ150に移動 (Toggle)", 80)

local tpEnabled = false
local tpHeight = 0
local originalY = nil

local function toggleTP(height)
    if tpEnabled then
        -- OFF
        tpEnabled = false
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and originalY then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position.X, originalY, LocalPlayer.Character.HumanoidRootPart.Position.Z)
        end
    else
        -- ON
        tpEnabled = true
        tpHeight = height
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            originalY = root.Position.Y
            root.CFrame = root.CFrame + Vector3.new(0,tpHeight,0)
        end
    end
end

tp50.MouseButton1Click:Connect(function() toggleTP(50) end)
tp100.MouseButton1Click:Connect(function() toggleTP(100) end)
tp150.MouseButton1Click:Connect(function() toggleTP(150) end)

-- Spam Dance
local danceBtn = makeButton("💃 Spam Dance (Toggle)", 120)
local dancing = false

danceBtn.MouseButton1Click:Connect(function()
    dancing = not dancing
    if dancing then
        task.spawn(function()
            while dancing do
                game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("/e dance", "All")
                task.wait(1)
            end
        end)
    end
end)

-- ランダムテレポート
local randBtn = makeButton("⚡ ランダム敵TP (Toggle)", 160)
local randOn = false

randBtn.MouseButton1Click:Connect(function()
    randOn = not randOn
    if randOn then
        -- 元位置保存
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            originalPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
        end
        task.spawn(function()
            while randOn do
                local enemies = {}
                for _,plr in pairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        table.insert(enemies, plr)
                    end
                end
                if #enemies > 0 then
                    local target = enemies[math.random(1,#enemies)]
                    LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
                end
                task.wait(1)
            end
        end)
    else
        -- OFFで元の位置に戻す
        if originalPosition and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = originalPosition
        end
    end
end)
