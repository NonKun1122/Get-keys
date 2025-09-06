const fs = require("fs");
const path = require("path");

const filePath = path.join(__dirname, "../../data/keys.json");

function loadKeys() {
  if (!fs.existsSync(filePath)) return {};
  return JSON.parse(fs.readFileSync(filePath));
}

export default function handler(req, res) {
  const { key } = req.query;
  if (!key) return res.status(400).json({ valid: false, reason: "Missing key" });

  const keys = loadKeys();

  for (const userId in keys) {
    if (keys[userId].key === key && keys[userId].expire > Date.now()) {
      return res.json({ valid: true, expire: keys[userId].expire, userId });
    }
  }

  return res.json({ valid: false, reason: "Invalid or expired key" });
}
