// เก็บ Key ไว้ใน memory (เหมือน genKey.js)
let keys = {};

export default function handler(req, res) {
  const { userId, key } = req.query;

  if (!userId || !key) {
    return res.status(400).json({ valid: false, reason: "❌ Missing params" });
  }

  const data = keys[userId];
  if (data && data.key === key && data.expire > Date.now()) {
    return res.status(200).json({
      valid: true,
      expire: data.expire
    });
  }

  return res.status(200).json({
    valid: false,
    reason: "❌ Key ไม่ถูกต้องหรือหมดอายุ"
  });
}
