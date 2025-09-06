// Node.js (Vercel Serverless)
let keys = {}; // เก็บ key ตาม UserId

export default function handler(req, res) {
    const userId = req.query.userId;
    if (!userId) return res.status(400).json({error: "No userId"});

    const now = Date.now();
    const today = new Date().toDateString();

    // ถ้าเคยสร้างวันนี้แล้ว
    if (keys[userId] && keys[userId].date === today) {
        return res.json(keys[userId]);
    }

    // สร้าง key ใหม่
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    let key = "";
    for(let i=0;i<24;i++) key += chars.charAt(Math.floor(Math.random()*chars.length));
    key = key.match(/.{1,4}/g).join("-");

    const expire = now + 24*60*60*1000;

    keys[userId] = { key, expire, date: today };
    res.json(keys[userId]);
          }
