--// Loader.lua
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

local API_URL = "https://get-keys-chulexhubx.vercel.app/api"

-- ฟังก์ชันโหลด Script ตาม PlaceId
local function loadScriptForMap()
    local scriptMap = {
        [126884695634066] = "https://raw.githubusercontent.com/NonKun1122/AntiAFK-Module/main/ChulexX.lua",
        [2345678901] = "https://raw.githubusercontent.com/NonKun1122/AntiAFK-Module/main/GardenTow.lua",
        [3456789012] = "https://raw.githubusercontent.com/NonKun1122/AntiAFK-Module/main/HuntZombie.lua"
    }

    local url = scriptMap[PlaceId]
    if not url then
        warn("❌ ไม่มีสคริปต์สำหรับแมพนี้")
        return
    end

    local success, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("โหลดสคริปต์ไม่สำเร็จ:", err)
    end
end

-- สร้าง UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 320, 0, 180)
Frame.Position = UDim2.new(0.5, -160, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0,12)
UICorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,30)
Title.Position = UDim2.new(0,0,0,5)
Title.Text = "🔑 Key System"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.Parent = Frame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1,-20,0,35)
KeyBox.Position = UDim2.new(0,10,0,45)
KeyBox.PlaceholderText = "Key ของคุณ..."
KeyBox.ClearTextOnFocus = false
KeyBox.Text = ""
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
KeyBox.TextColor3 = Color3.fromRGB(0,0,0)
KeyBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
KeyBox.Parent = Frame

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0,8)
UICorner2.Parent = KeyBox

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1,0,0,20)
Status.Position = UDim2.new(0,0,1,-25)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.TextSize = 12
Status.TextColor3 = Color3.fromRGB(255,255,0)
Status.Text = ""
Status.Parent = Frame

-- ปุ่ม Get Key
local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Size = UDim2.new(0.45,-10,0,35)
GetKeyBtn.Position = UDim2.new(0,10,0,90)
GetKeyBtn.Text = "🎁 Get Key"
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextSize = 14
GetKeyBtn.TextColor3 = Color3.fromRGB(255,255,255)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(0,120,255)
GetKeyBtn.Parent = Frame

local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0,8)
UICorner3.Parent = GetKeyBtn

-- ปุ่ม Verify
local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Size = UDim2.new(0.45,-10,0,35)
VerifyBtn.Position = UDim2.new(0.55,0,0,90)
VerifyBtn.Text = "✅ Verify Key"
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextSize = 14
VerifyBtn.TextColor3 = Color3.fromRGB(255,255,255)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
VerifyBtn.Parent = Frame

local UICorner4 = Instance.new("UICorner")
UICorner4.CornerRadius = UDim.new(0,8)
UICorner4.Parent = VerifyBtn

-- ฟังก์ชันช่วยอัพเดท Status
local function updateStatus(txt)
    Status.Text = txt
end

-- กดปุ่ม Get Key
GetKeyBtn.MouseButton1Click:Connect(function()
    updateStatus("⏳ กำลังขอ Key...")
    local ok,res = pcall(function()
        return HttpService:GetAsync(API_URL.."/getKey?userId="..LocalPlayer.UserId)
    end)
    if ok then
        local data = HttpService:JSONDecode(res)
        KeyBox.Text = data.key
        updateStatus("✅ ได้ Key! หมดอายุ: "..os.date("%c",data.expire/1000))
    else
        updateStatus("❌ ไม่สามารถเชื่อมต่อ API ได้")
    end
end)

-- กดปุ่ม Verify
VerifyBtn.MouseButton1Click:Connect(function()
    local key = KeyBox.Text
    if key == "" then
        updateStatus("⚠️ กรุณาใส่ Key")
        return
    end

    updateStatus("⏳ กำลังตรวจสอบ Key...")
    local ok,res = pcall(function()
        return HttpService:GetAsync(API_URL.."/verifyKey?key="..key)
    end)
    if ok then
        local data = HttpService:JSONDecode(res)
        if data.valid then
            updateStatus("✅ Key ถูกต้อง! โหลด Script...")
            wait(1)
            ScreenGui:Destroy()
            loadScriptForMap()
        else
            updateStatus("❌ "..tostring(data.reason))
        end
    else
        updateStatus("❌ ไม่สามารถเชื่อมต่อ API ได้")
    end
end)
