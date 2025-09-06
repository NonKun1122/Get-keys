-- Loader Script | ใช้กับระบบ Key ฟรี 1 วัน / UserId
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

-- URL เว็บ Key
local VK_PAGE_URL = "https://get-keys-chulexhubx.vercel.app/vk.html"

-- สร้าง UI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "KeyLoaderGUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 350, 0, 180)
Frame.Position = UDim2.new(0.5, -175, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,30)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundTransparency = 1
Title.Text = "🔑 ใส่ Key จากเว็บ"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(255,255,255)

local KeyBox = Instance.new("TextBox", Frame)
KeyBox.Size = UDim2.new(1,-20,0,40)
KeyBox.Position = UDim2.new(0,10,0,45)
KeyBox.PlaceholderText = "วาง Key จากเว็บ..."
KeyBox.Text = ""
KeyBox.ClearTextOnFocus = false
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
KeyBox.TextColor3 = Color3.fromRGB(0,0,0)
KeyBox.BackgroundColor3 = Color3.fromRGB(255,255,255)

local VerifyBtn = Instance.new("TextButton", Frame)
VerifyBtn.Size = UDim2.new(1,-20,0,40)
VerifyBtn.Position = UDim2.new(0,10,0,95)
VerifyBtn.Text = "✅ Verify Key"
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextSize = 14
VerifyBtn.TextColor3 = Color3.fromRGB(255,255,255)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)

local Status = Instance.new("TextLabel", Frame)
Status.Size = UDim2.new(1,0,0,20)
Status.Position = UDim2.new(0,0,1,-25)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.TextSize = 12
Status.TextColor3 = Color3.fromRGB(255,255,0)
Status.Text = ""

local GetKeyBtn = Instance.new("TextButton", Frame)
GetKeyBtn.Size = UDim2.new(1,-20,0,30)
GetKeyBtn.Position = UDim2.new(0,10,0,145)
GetKeyBtn.Text = "🌐 ไปสร้าง Key"
GetKeyBtn.Font = Enum.Font.Gotham
GetKeyBtn.TextSize = 14
GetKeyBtn.TextColor3 = Color3.fromRGB(255,255,255)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(50,50,200)

-- ปุ่ม Get Key
GetKeyBtn.MouseButton1Click:Connect(function()
    -- เปิดเว็บ
    pcall(function()
        LocalPlayer:Kick("เปิดเว็บสร้าง Key: "..VK_PAGE_URL)
    end)
end)

-- ฟังก์ชันตรวจสอบ Key (จำลอง)
local function checkKey(key)
    -- สำหรับระบบฟรี, Key จะต้องตรงกับ pattern XXXX-XXXX-XXXX-XXXX-XXXX-XXXX
    if key:match("^%u%u%u%u%-%u%u%u%u%-%u%u%u%u%-%u%u%u%u%-%u%u%u%u%-%u%u%u%u$") then
        return true, 24*60*60 -- ใช้เวลาหมดอายุ 24 ชั่วโมง (วินาที)
    end
    return false, 0
end

-- ฟังก์ชันโหลดสคริปต์ตามแมพ
local function loadScriptForMap()
    local scriptMap = {
        [126884695634066] = "https://raw.githubusercontent.com/NonKun1122/AntiAFK-Module/main/ChulexX.lua",
        [1234567890] = "https://gat-keys.netlify.app/scripts/growagarden.lua",
        [2345678901] = "https://gat-keys.netlify.app/scripts/gardentow.lua",
        [3456789012] = "https://gat-keys.netlify.app/scripts/huntzombie.lua"
    }

    local url = scriptMap[PlaceId]
    if not url then
        Status.Text = "❌ ไม่มีสคริปต์สำหรับแมพนี้"
        return
    end

    local success, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not success then
        Status.Text = "❌ โหลดสคริปต์ไม่สำเร็จ: "..err
    else
        Status.Text = "✅ โหลดสคริปต์เรียบร้อย!"
    end
end

-- ปุ่ม Verify
VerifyBtn.MouseButton1Click:Connect(function()
    local key = KeyBox.Text
    if key == "" then
        Status.Text = "⚠️ กรุณาใส่ Key"
        return
    end

    Status.Text = "⏳ กำลังตรวจสอบ..."
    wait(0.5)
    local ok, expire = checkKey(key)
    if not ok then
        Status.Text = "❌ Key ไม่ถูกต้อง"
    else
        Status.Text = "✅ Key ถูกต้อง! ใช้งานได้ 24 ชั่วโมง"
        wait(0.5)
        Frame:Destroy()
        loadScriptForMap()
    end
end)
