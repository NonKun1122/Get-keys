// netlify/functions/verifykey.js

exports.handler = async (event, context) => {
  const query = event.queryStringParameters; // ดึง ?key=xxxx จาก URL
  const key = query.key;

  // ✅ Key ที่อนุญาตให้ใช้
  const freeKeys = [
    "AB12-CD34-EF56-GH78-IJ90-KL12", // Key ฟรี อายุ 1 วัน
  ];

  const premiumKeys = [
    "AB12-CD34-EF56-GH78-IJ90-KL12-MN34-OP56", // Key เสีย อายุ 30 วัน
  ];

  let response = {
    valid: false,
    type: null,
    expire: null,
    reason: "Key ไม่ถูกต้อง"
  };

  const now = Date.now();
  const oneDay = 24 * 60 * 60 * 1000;

  if (freeKeys.includes(key)) {
    response.valid = true;
    response.type = "free";
    response.expire = now + oneDay;
    response.reason = null;
  }

  if (premiumKeys.includes(key)) {
    response.valid = true;
    response.type = "premium";
    response.expire = now + (30 * oneDay);
    response.reason = null;
  }

  return {
    statusCode: 200,
    body: JSON.stringify(response)
  };
};
      
