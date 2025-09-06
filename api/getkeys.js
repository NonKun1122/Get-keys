let keys = {}; // ใน server memory (สำหรับเดโม, ใช้ DB จริงถาวร)

export default function handler(req, res){
  const { userId } = req.query;
  if(!userId) return res.status(400).json({error:"Missing userId"});

  const today = new Date().toDateString();
  if(keys[userId] && keys[userId].day === today){
    return res.json({ key: keys[userId].key, expire: keys[userId].expire });
  }

  // สร้าง Key ใหม่
  const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  let key = "";
  for(let i=0;i<24;i++) key += chars.charAt(Math.floor(Math.random()*chars.length));
  key = key.match(/.{1,4}/g).join("-");

  const expire = Date.now() + 24*60*60*1000;
  keys[userId] = { key, expire, day: today };
  res.json({ key, expire });
}
