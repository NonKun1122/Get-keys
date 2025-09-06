local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

-- URL API ของเว็บ
local API_URL = "https://get-keys-chulexhubx.vercel.app/api/vk"

-- UI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,350,0,180)
Frame.Position = UDim2.new(0.5,-175,0.5,-90)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true

local KeyBox = Instance.new("TextBox", Frame)
KeyBox.Size = UDim2.new(1,-20,0,40)
KeyBox.Position = UDim2.new(0,10,0,45)
KeyBox.PlaceholderText = "วาง Key จากเว็บ"
KeyBox.ClearTextOnFocus = false

local VerifyBtn = Instance.new("TextButton", Frame)
VerifyBtn.Size = UDim2.new(1,-20,0,40)
VerifyBtn.Position = UDim2.new(0,10,0,95)
VerifyBtn.Text = "✅ Verify Key"

local Status = Instance.new("TextLabel", Frame)
Status.Size = UDim2.new(1,0,0,20)
Status.Position = UDim2.new(0,0,1,-25)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(255,255,0)
Status.Text = ""

-- ปุ่ม Verify
VerifyBtn.MouseButton1Click:Connect(function()
    local key = KeyBox.Text
    if key == "" then Status.Text="⚠️ ใส่ Key"; return end

    Status.Text = "⏳ ตรวจสอบ Key..."
    local ok, res = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(API_URL.."?userId="..LocalPlayer.UserId.."&key="..key))
    end)
    if not ok or not res.valid then
        Status.Text = "❌ Key ไม่ถูกต้องหรือหมดอายุ"
        return
    end

    Status.Text = "✅ Key ถูกต้อง!"
    wait(0.5)
    Frame:Destroy()

    -- โหลดสคริปต์ตามแมพ
    local scriptMap = {
        [1234567890] = "https://raw.githubusercontent.com/NonKun1122/AntiAFK-Module/main/ChulexX.lua",
        [2345678901] = "https://gat-keys.netlify.app/scripts/gardentow.lua",
        [3456789012] = "https://gat-keys.netlify.app/scripts/huntzombie.lua"
    }
    local url = scriptMap[PlaceId]
    if url then
        loadstring(game:HttpGet(url))()
    end
end)
