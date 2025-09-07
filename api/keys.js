let keys = {}; // เก็บทั้งหมดในตัวแปรเดียว

export default function handler(req, res) {
  const { action, userId, key } = req.query;

  if (!userId) {
    return res.status(400).json({ success: false, reason: "❌ Missing userId" });
  }

  if (action === "gen") {
    // สร้าง key ใหม่
    const newKey = [...Array(24)].map(() => "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"[Math.floor(Math.random()*36)]).join("");
    const formattedKey = newKey.match(/.{1,4}/g).join("-");
    const expire = Date.now() + 24*60*60*1000;

    keys[userId] = { key: formattedKey, expire };

    return res.status(200).json({ success: true, key: formattedKey, expire });
  }

  if (action === "verify") {
    const data = keys[userId];
    if (data && data.key === key && data.expire > Date.now()) {
      return res.status(200).json({ valid: true, expire: data.expire });
    }
    return res.status(200).json({ valid: false, reason: "❌ Key ไม่ถูกต้องหรือหมดอายุ" });
  }

  return res.status(400).json({ success: false, reason: "❌ Unknown action" });
}
