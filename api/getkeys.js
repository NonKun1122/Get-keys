export default function handler(req, res) {
  const { userId } = req.query;
  if (!userId) return res.status(400).json({ error: "Missing userId" });

  let keys = loadKeys();

  // ถ้ามี key วันนี้แล้ว → ใช้เดิม
  if (keys[userId] && keys[userId].expire > Date.now()) {
    return res.json(keys[userId]);
  }

  // สร้าง key ใหม่
  const key = generateKey();
  const expire = Date.now() + 24*60*60*1000;

  keys[userId] = { key, expire };
  saveKeys(keys);

  return res.json({ key, expire, userId });
}
