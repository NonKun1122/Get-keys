export default function handler(req, res) {
  const { key, userId } = req.query;
  if (!key || !userId) return res.status(400).json({ valid:false, reason:"Missing key or userId" });

  const keys = loadKeys();

  if(keys[userId] && keys[userId].key === key && keys[userId].expire > Date.now()){
    return res.json({ valid:true, expire:keys[userId].expire });
  }

  return res.json({ valid:false, reason:"Invalid or expired key" });
}
