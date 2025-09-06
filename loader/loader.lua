--// Loader Script with Key System
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local USER_ID = LocalPlayer.UserId

-- แก้เป็นโดเมนเว็บของคุณ (Vercel หรือ Netlify)
local API_BASE = "https://get-keys-chulexhubx.vercel.app/api"
local REDEEM_URL = "https://get-keys-chulexhubx.vercel.app/?userId="..USER_ID

--// ฟังก์ชันตรวจสอบ Key
local function verifyKey(key)
    local ok, res = pcall(function()
        return game:HttpGet(API_BASE.."/vk?key="..key.."&userId="..USER_ID)
    end)
    if not ok then return false,"ไม่สามารถเชื่อมต่อ API ได้" end

    local data = HttpService:JSONDecode(res)
    if data.valid then
        return true,"หมดอายุ: "..os.date("%c", data.expire/1000)
    else
        return false,data.reason or "Key ไม่ถูกต้อง"
    end
end

--// ฟังก์ชันโหลดสคริปต์ตามแมพ
local function loadScriptForMap()
    local scriptMap = {
        [1234567890] = "https://YOUR-SITE.vercel.app/scripts/growagarden.lua",
        [2345678901] = "https://YOUR-SITE.vercel.app/scripts/gardentow.lua",
        [3456789012] = "https://YOUR-SITE.vercel.app/scripts/huntzombie.lua"
    }
    local url = scriptMap[game.PlaceId]
    if not url then
        LocalPlayer:Kick("❌ ไม่มีสคริปต์สำหรับแมพนี้")
        return
    end
    local success, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("โหลดสคริปต์ไม่สำเร็จ:", err)
        LocalPlayer:Kick("❌ Error โหลดสคริปต์")
    end
end

--// UI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 320, 0, 200)
Frame.Position = UDim2.new(0.5, -160, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
Frame.Active, Frame.Draggable = true, true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,30)
Title.Text = "🔑 Key Verification System"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1

local KeyBox = Instance.new("TextBox", Frame)
KeyBox.Size = UDim2.new(1,-20,0,35)
KeyBox.Position = UDim2.new(0,10,0,45)
KeyBox.PlaceholderText = "กรอก Key ที่นี่..."
KeyBox.ClearTextOnFocus = false
KeyBox.Text = ""
KeyBox.TextSize = 14
KeyBox.Font = Enum.Font.Gotham
KeyBox.BackgroundColor3 = Color3.fromRGB(255,255,255)

local VerifyBtn = Instance.new("TextButton", Frame)
VerifyBtn.Size = UDim2.new(0.5,-15,0,35)
VerifyBtn.Position = UDim2.new(0,10,0,90)
VerifyBtn.Text = "✅ Verify Key"
VerifyBtn.TextSize = 14
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextColor3 = Color3.fromRGB(255,255,255)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0,8)

local GetKeyBtn = Instance.new("TextButton", Frame)
GetKeyBtn.Size = UDim2.new(0.5,-15,0,35)
GetKeyBtn.Position = UDim2.new(0.5,5,0,90)
GetKeyBtn.Text = "🌐 Get Key"
GetKeyBtn.TextSize = 14
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextColor3 = Color3.fromRGB(255,255,255)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(0,120,255)
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0,8)

local Status = Instance.new("TextLabel", Frame)
Status.Size = UDim2.new(1,-20,0,30)
Status.Position = UDim2.new(0,10,0,140)
Status.Text = "⚠️ กรุณากรอก Key"
Status.TextSize = 12
Status.Font = Enum.Font.Gotham
Status.TextColor3 = Color3.fromRGB(255,255,0)
Status.BackgroundTransparency = 1

-- กด Get Key
GetKeyBtn.MouseButton1Click:Connect(function()
    setclipboard(REDEEM_URL)
    Status.Text = "🌐 คัดลอกลิงก์แล้ว เปิดใน Browser!"
end)

-- กด Verify
VerifyBtn.MouseButton1Click:Connect(function()
    local key = KeyBox.Text
    if key == "" then
        Status.Text = "⚠️ กรุณากรอก Key"
        return
    end
    Status.Text = "⏳ กำลังตรวจสอบ..."
    local ok, msg = verifyKey(key)
    if ok then
        Status.Text = "✅ Key ถูกต้อง! "..msg
        wait(1)
        ScreenGui:Destroy()
        loadScriptForMap()
    else
        Status.Text = "❌ "..msg
    end
end)
