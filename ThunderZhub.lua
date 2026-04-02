-- สร้างตารางเก็บ PlaceId และลิงก์ของสคริปต์
local allowedMaps = {
    [77747658251236] = "https://raw.githubusercontent.com/Thunder-Zhub/ThunderZhub/refs/heads/main/SailorPiece.lua",
    [123741668193208] = "https://raw.githubusercontent.com/Thunder-Zhub/ThunderZhub/refs/heads/main/The1MJumpRope.lua"
}

-- ตรวจสอบ PlaceId ของแมพที่กำลังเล่น
local placeId = game.PlaceId

-- เช็คว่า PlaceId ที่กำลังเล่นอยู่มีในลิสต์ที่อนุญาตไหม
if allowedMaps[placeId] then
    -- โหลดและรันสคริปต์จาก URL
    loadstring(game:HttpGet(allowedMaps[placeId]))()
else
    -- ถ้า PlaceId ไม่ตรงกับที่กำหนด, เตะผู้เล่นออกจากเกม
    game:Shutdown()
end
