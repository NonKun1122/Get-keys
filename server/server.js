const express = require("express");
const app = express();
const port = process.env.PORT || 3000;

let keyDB = {}; // keyDB[userId] = { key, expire }
const paidKeys = ["PAID-KEY-EXAMPLE-1234", "PAID-KEY-5678-ABCD"];

function generateKey() {
  const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  let key = "";
  for (let i=0;i<24;i++) key += chars.charAt(Math.floor(Math.random()*chars.length));
  return key.match(/.{1,4}/g).join("-");
}

app.get("/api/getKey", (req,res)=>{
  const userId = req.query.userId;
  const now = Date.now();
  if(keyDB[userId] && keyDB[userId].expire > now){
    return res.json({ key: keyDB[userId].key, expire: keyDB[userId].expire, type:"free" });
  }
  const newKey = generateKey();
  keyDB[userId] = { key:newKey, expire: now + 24*60*60*1000 };
  res.json({ key:newKey, expire: keyDB[userId].expire, type:"free" });
});

app.get("/api/verifyKey", (req,res)=>{
  const key = req.query.key;
  const now = Date.now();

  for(const userId in keyDB){
    const data = keyDB[userId];
    if(data.key === key && data.expire > now){
      return res.json({ valid:true, type:"free", expire:data.expire });
    }
  }

  if(paidKeys.includes(key)){
    return res.json({ valid:true, type:"paid", expire:now + 24*60*60*1000 });
  }

  res.json({ valid:false, reason:"Key ไม่ถูกต้องหรือหมดอายุ" });
});

app.listen(port, ()=>console.log(`Key API running on port ${port}`));
