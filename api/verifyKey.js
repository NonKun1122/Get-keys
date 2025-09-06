// Node.js (Vercel Serverless)
let keys = {}; // ต้องเหมือน getKey.js

export default function handler(req, res) {
    const key = req.query.key;
    if (!key) return res.status(400).json({valid:false, reason:"No key"});

    const found = Object.values(keys).find(k => k.key === key);
    if (!found) return res.json({valid:false, reason:"Key ไม่ถูกต้องหรือหมดอายุ"});
    if (found.expire < Date.now()) return res.json({valid:false, reason:"Key หมดอายุ"});

    res.json({valid:true, expire:found.expire});
              }
