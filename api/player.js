// api/player.js
export default async function handler(req, res) {
  const { userId } = req.query;

  if (!userId) {
    return res.status(400).json({ error: "Missing userId" });
  }

  try {
    // 🔹 ดึงชื่อผู้เล่น
    const userRes = await fetch(`https://users.roblox.com/v1/users/${userId}`);
    const userData = await userRes.json();

    // 🔹 ดึง Avatar
    const avatarRes = await fetch(
      `https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=${userId}&size=150x150&format=Png`
    );
    const avatarData = await avatarRes.json();

    res.status(200).json({
      id: userId,
      name: userData.name,
      avatar: avatarData.data[0]?.imageUrl || null,
    });
  } catch (err) {
    res.status(500).json({ error: "โหลดข้อมูลผู้เล่นล้มเหลว" });
  }
}
