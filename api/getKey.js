const fs = require("fs");
const path = require("path");

const filePath = path.join(__dirname, "../../data/keys.json");

// โหลดข้อมูลเก่า
function loadKeys() {
  if (!fs.existsSync(filePath)) return {};
  return JSON.parse(fs.readFileSync(filePath));
}

// บันทึก
function saveKeys(data) {
  fs.writeFileSync(filePath, JSON.stringify(data, null, 2));
}

function generateKey(len = 24) {
  const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  let key = "";
  for (let i = 0; i < len; i++) key += chars.charAt(Math.floor(Math.random() * chars.length));
  return key.match(/.{1,4}/g).join("-");
}

export default function handler(req, res) {
  const { userId } = req.query;
  if (!userId) return res.status(400).json({ error: "Missing userId" });

  let keys = loadKeys();

  // ถ้ามี key วันนี้แล้ว → ใช้ key เดิม
  if (keys[userId] && keys[userId].expire > Date.now()) {
    return res.json(keys[userId]);
  }

  // สร้าง key ใหม่
  const key = generateKey();
  const expire = Date.now() + 24 * 60 * 60 * 1000;

  keys[userId] = { key, expire };
  saveKeys(keys);

  return res.json({ key, expire });
}
