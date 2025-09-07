// เก็บ Key แบบง่าย ๆ (ถ้า refresh หรือ deploy ใหม่ Key จะหายเพราะไม่ได้ใช้ database จริง)
let keys = {};

export default function handler(req, res) {
  const { userId } = req.query;

  if (!userId) {
    return res.status(400).json({ error: "❌ Missing userId" });
  }

  // ถ้ามี key เดิมที่ยังไม่หมดอายุ → ส่งกลับไปเลย
  if (keys[userId] && keys[userId].expire > Date.now()) {
    return res.status(200).json({ key: keys[userId].key, expire: keys[userId].expire });
  }

  // สร้าง Key ใหม่
  const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  let newKey = "";
  for (let i = 0; i < 24; i++) newKey += chars.charAt(Math.floor(Math.random() * chars.length));
  newKey = newKey.match(/.{1,4}/g).join("-"); // แบ่งเป็นกลุ่ม 4 ตัว เช่น ABCD-EFGH...

  const expire = Date.now() + 24 * 60 * 60 * 1000; // 24 ชั่วโมง

  // เก็บ Key ลง memory
  keys[userId] = { key: newKey, expire };

  res.status(200).json({ key: newKey, expire });
}
