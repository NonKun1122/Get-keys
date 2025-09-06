let keys = {}; // ต้องแชร์กับ generateKey (ใน DB จริง)
export default function handler(req, res){
  const { userId, key } = req.query;
  if(!userId || !key) return res.status(400).json({valid:false, reason:"Missing userId or key"});

  const data = keys[userId];
  if(data && data.key === key && data.expire > Date.now()){
    return res.json({ valid:true, expire:data.expire });
  }
  res.json({ valid:false, reason:"Key ไม่ถูกต้องหรือหมดอายุ" });
}
