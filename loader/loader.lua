-- Loader Script Roblox
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

-- URL API ของคุณบน Vercel
local API_VERIFY = "https://get-keys-chulexhubx.vercel.app/api/keys"

-- UI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,380,0,220)
Frame.Position = UDim2.new(0.5,-190,0.5,-110)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true

-- UserId
local UserIdLabel = Instance.new("TextLabel", Frame)
UserIdLabel.Size = UDim2.new(1,-20,0,30)
UserIdLabel.Position = UDim2.new(0,10,0,10)
UserIdLabel.Text = "UserId: "..LocalPlayer.UserId
UserIdLabel.TextColor3 = Color3.fromRGB(255,255,255)
UserIdLabel.BackgroundTransparency = 1
UserIdLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ปุ่มคัดลอก UserId
local CopyBtn = Instance.new("TextButton", Frame)
CopyBtn.Size = UDim2.new(0,100,0,30)
CopyBtn.Position = UDim2.new(1,-110,0,10)
CopyBtn.Text = "📋 Copy"
CopyBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
CopyBtn.TextColor3 = Color3.fromRGB(255,255,255)
CopyBtn.MouseButton1Click:Connect(function()
    setclipboard(tostring(LocalPlayer.UserId))
    UserIdLabel.Text = "✅ UserId คัดลอกแล้ว!"
end)

-- ช่องใส่ Key
local KeyBox = Instance.new("TextBox", Frame)
KeyBox.Size = UDim2.new(1,-20,0,40)
KeyBox.Position = UDim2.new(0,10,0,55)
KeyBox.PlaceholderText = "วาง Key ที่ได้จากเว็บ"
KeyBox.ClearTextOnFocus = false

-- ปุ่ม Verify
local VerifyBtn = Instance.new("TextButton", Frame)
VerifyBtn.Size = UDim2.new(1,-20,0,40)
VerifyBtn.Position = UDim2.new(0,10,0,105)
VerifyBtn.Text = "✅ Verify Key"
VerifyBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
VerifyBtn.TextColor3 = Color3.fromRGB(255,255,255)

-- สถานะ
local Status = Instance.new("TextLabel", Frame)
Status.Size = UDim2.new(1,0,0,20)
Status.Position = UDim2.new(0,0,1,-25)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(255,255,0)

-- ฟังก์ชันตรวจสอบ Key
VerifyBtn.MouseButton1Click:Connect(function()
    local key = KeyBox.Text
    if key == "" then Status.Text = "⚠️ ใส่ Key ก่อน"; return end

    Status.Text = "⏳ กำลังตรวจสอบ..."
    local ok, res = pcall(function()
        return HttpService:JSONDecode(
            game:HttpGet(API_VERIFY.."?action=verify&userId="..LocalPlayer.UserId.."&key="..key)
        )
    end)

    if not ok then
        Status.Text = "❌ ไม่สามารถเชื่อมต่อ API ได้"
        return
    end

    if not res.valid then
        Status.Text = "❌ Key ไม่ถูกต้อง หรือหมดอายุ"
        return
    end

    Status.Text = "✅ Key ถูกต้อง!"
    wait(1)
    ScreenGui:Destroy()

    -- โหลดสคริปต์ตามแมพ
    local scriptMap = {
        [1234567890] = "https://raw.githubusercontent.com/NonKun1122/AntiAFK-Module/main/ChulexX.lua",
        [2345678901] = "https://gat-keys.netlify.app/scripts/gardentow.lua",
        [3456789012] = "https://gat-keys.netlify.app/scripts/huntzombie.lua"
    }
    local url = scriptMap[PlaceId]
    if url then
        local s, e = pcall(function()
            loadstring(game:HttpGet(url))()
        end)
        if not s then
            warn("โหลดสคริปต์ไม่สำเร็จ: "..e)
        end
    end
end)
