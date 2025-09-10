local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

-- ไฟล์เก็บบัญชี
local saveFile = "ChulexX_Account.json"

-- ฟังก์ชันบันทึก / โหลด
local function saveAccount(username, password)
    local data = { username = username, password = password }
    writefile(saveFile, HttpService:JSONEncode(data))
end

local function loadAccount()
    if isfile(saveFile) then
        return HttpService:JSONDecode(readfile(saveFile))
    end
    return nil
end

-- ฟังก์ชันโหลดสคริปต์ตามแมพ
local function loadScriptForMap()
    local scriptMap = {
        [1234567890] = "https://raw.githubusercontent.com/YourUser/Hub/main/game1.lua",
        [2345678901] = "https://raw.githubusercontent.com/YourUser/Hub/main/game2.lua",
        [3456789012] = "https://raw.githubusercontent.com/YourUser/Hub/main/game3.lua"
    }
    local url = scriptMap[PlaceId]
    if url then
        loadstring(game:HttpGet(url))()
    else
        warn("❌ ไม่มีสคริปต์สำหรับเกมนี้")
    end
end

-- UI หลัก
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,400,0,280)
Frame.Position = UDim2.new(0.5,-200,0.5,-140)
Frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
Frame.Active = true
Frame.Draggable = true
Frame.BorderSizePixel = 0
Frame.BackgroundTransparency = 0.1

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0,12)

-- Title
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "🆕 Register"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22

-- Username
local UserBox = Instance.new("TextBox", Frame)
UserBox.Size = UDim2.new(1,-40,0,35)
UserBox.Position = UDim2.new(0,20,0,60)
UserBox.PlaceholderText = "Username"
UserBox.Text = ""
UserBox.ClearTextOnFocus = false

-- Password
local PassBox = Instance.new("TextBox", Frame)
PassBox.Size = UDim2.new(1,-40,0,35)
PassBox.Position = UDim2.new(0,20,0,110)
PassBox.PlaceholderText = "Password"
PassBox.Text = ""
PassBox.ClearTextOnFocus = false

-- Status
local Status = Instance.new("TextLabel", Frame)
Status.Size = UDim2.new(1,0,0,20)
Status.Position = UDim2.new(0,0,1,-25)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(255,200,0)
Status.Font = Enum.Font.Gotham
Status.TextSize = 16
Status.Text = ""

-- ปุ่ม Action (Register / Login)
local ActionBtn = Instance.new("TextButton", Frame)
ActionBtn.Size = UDim2.new(1,-40,0,35)
ActionBtn.Position = UDim2.new(0,20,0,160)
ActionBtn.Text = "🆕 Register"
ActionBtn.BackgroundColor3 = Color3.fromRGB(0,170,90)
ActionBtn.TextColor3 = Color3.fromRGB(255,255,255)
ActionBtn.Font = Enum.Font.GothamBold
ActionBtn.TextSize = 18

local BtnCorner = Instance.new("UICorner", ActionBtn)
BtnCorner.CornerRadius = UDim.new(0,8)

-- ปุ่มสลับ Register <-> Login
local SwitchBtn = Instance.new("TextButton", Frame)
SwitchBtn.Size = UDim2.new(1,-40,0,30)
SwitchBtn.Position = UDim2.new(0,20,0,205)
SwitchBtn.Text = "มีบัญชีแล้ว? 🔐 Login"
SwitchBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
SwitchBtn.TextColor3 = Color3.fromRGB(200,200,200)
SwitchBtn.Font = Enum.Font.Gotham
SwitchBtn.TextSize = 14
local SwitchCorner = Instance.new("UICorner", SwitchBtn)
SwitchCorner.CornerRadius = UDim.new(0,6)

-- ตัวแปรโหมด
local mode = "register"

-- สลับโหมด
local function switchMode(newMode)
    mode = newMode
    if mode == "register" then
        Title.Text = "🆕 Register"
        ActionBtn.Text = "🆕 Register"
        ActionBtn.BackgroundColor3 = Color3.fromRGB(0,170,90)
        SwitchBtn.Text = "มีบัญชีแล้ว? 🔐 Login"
    else
        Title.Text = "🔐 Login"
        ActionBtn.Text = "✅ Login"
        ActionBtn.BackgroundColor3 = Color3.fromRGB(0,120,255)
        SwitchBtn.Text = "ยังไม่มีบัญชี? 🆕 Register"
    end
    Status.Text = ""
end

SwitchBtn.MouseButton1Click:Connect(function()
    if mode == "register" then
        switchMode("login")
    else
        switchMode("register")
    end
end)

-- Event ปุ่มหลัก
ActionBtn.MouseButton1Click:Connect(function()
    local username = UserBox.Text
    local password = PassBox.Text

    if username == "" or password == "" then
        Status.Text = "⚠️ กรอก Username และ Password ก่อน"
        return
    end

    if mode == "register" then
        saveAccount(username, password)
        Status.Text = "✅ สมัครสำเร็จ! กำลังเข้าสู่ระบบ..."
        wait(1)
        ScreenGui:Destroy()
        loadScriptForMap()
    elseif mode == "login" then
        local acc = loadAccount()
        if acc and acc.username == username and acc.password == password then
            Status.Text = "✅ เข้าสู่ระบบสำเร็จ!"
            wait(1)
            ScreenGui:Destroy()
            loadScriptForMap()
        else
            Status.Text = "❌ Username หรือ Password ไม่ถูกต้อง"
        end
    end
end)

-- ถ้ามีไฟล์อยู่แล้ว → เปิดหน้า Login ทันที
local account = loadAccount()
if account then
    UserBox.Text = account.username
    PassBox.Text = account.password
    switchMode("login")
end
