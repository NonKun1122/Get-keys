local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

local API_URL = "https://gat-keys.netlify.app/api" -- เปลี่ยนเป็น URL จริงของคุณ

-- Script map
local scriptMap = {
    [126884695634066] = "https://gat-keys.netlify.app/scripts/growagarden.lua",
    [2345678901] = "https://gat-keys.netlify.app/scripts/gardentow.lua",
    [3456789012] = "https://gat-keys.netlify.app/scripts/huntzombie.lua"
}

local function loadScript()
    local url = scriptMap[PlaceId]
    if url then
        loadstring(game:HttpGet(url))()
    else
        warn("❌ ไม่มีสคริปต์สำหรับแมพนี้")
    end
end

-- UI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 340, 0, 180)
Frame.AnchorPoint = Vector2.new(0.5,0.5)
Frame.Position = UDim2.new(0.5,0,0.5,0)
Frame.BackgroundColor3 = Color3.fromRGB(40,40,40)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundTransparency = 1
Title.Text = "🔑 Key System"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(255,255,255)

local KeyBox = Instance.new("TextBox", Frame)
KeyBox.Size = UDim2.new(1,-20,0,35)
KeyBox.Position = UDim2.new(0,10,0,45)
KeyBox.PlaceholderText = "กรอก Key ที่นี่..."
KeyBox.ClearTextOnFocus = false

local Status = Instance.new("TextLabel", Frame)
Status.Size = UDim2.new(1,0,0,20)
Status.Position = UDim2.new(0,0,1,-25)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.TextSize = 12
Status.TextColor3 = Color3.fromRGB(255,255,0)

local VerifyBtn = Instance.new("TextButton", Frame)
VerifyBtn.Size = UDim2.new(0.48,-15,0,35)
VerifyBtn.Position = UDim2.new(0,10,0,90)
VerifyBtn.Text = "✅ Verify Key"
VerifyBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
VerifyBtn.TextColor3 = Color3.fromRGB(255,255,255)

local GetKeyBtn = Instance.new("TextButton", Frame)
GetKeyBtn.Size = UDim2.new(0.48,-15,0,35)
GetKeyBtn.Position = UDim2.new(0.52,5,0,90)
GetKeyBtn.Text = "🌐 Get Key"
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(50,50,200)
GetKeyBtn.TextColor3 = Color3.fromRGB(255,255,255)

local function updateStatus(msg)
    Status.Text = msg
end

-- Get Key ฟรี
GetKeyBtn.MouseButton1Click:Connect(function()
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

-- Verify Key
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
            loadScript()
        else
            updateStatus("❌ "..tostring(data.reason))
        end
    else
        updateStatus("❌ ไม่สามารถเชื่อมต่อ API ได้")
    end
end)
