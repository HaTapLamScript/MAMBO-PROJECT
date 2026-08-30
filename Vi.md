# MAMBO PROJECT

> «A small collection of Roblox scripts, built for fun, experimentation, and questionable amounts of free time.»

---

## 🇻🇳 Tiếng Việt

### Giới thiệu

**MAMBO PROJECT** là một dự án cá nhân được tạo ra chủ yếu để giải trí, thử nghiệm và… vì tác giả tự nhiên muốn code.

Không có studio lớn đứng sau, không có đội ngũ hàng chục người, cũng chẳng có kế hoạch IPO. Chỉ có một kẻ vô danh với một chút kiến thức, một chút thời gian rảnh và khá nhiều ý tưởng linh tinh.

Dự án có thể được cập nhật, thay đổi hoặc xuất hiện thêm những thứ khá khó hiểu bất cứ lúc nào.

---

## Scripts

Dưới đây là danh sách các script hiện có trong repository.

### 🌐 Universal

#### 🎵 Youtube Player

**Mô tả:**  
Trình phát nhạc YouTube dành cho Roblox, cho phép tải và phát audio từ YouTube trực tiếp trong game.

**Execute:**

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/HaTapLamScript/MAMBO_PROJECT/main/Universal/Youtube_player.lua"))()
```

---

#### 🎯 Aimlock

**Mô tả:**  
Script hỗ trợ aimlock dành cho các tựa game PvP/PvE.

**Execute:**

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/HaTapLamScript/MAMBO_PROJECT/main/Universal/Aimlock.lua"))()
```

---

### 🎮 Other Scripts

#### 🥽 R6 FAKE VR — Open Source

**Mô tả:**  
Một project **Open Source**, được công khai nhằm mục đích nghiên cứu, học tập và tùy chỉnh.

Bạn hoàn toàn có thể tải source về, đọc code, chỉnh sửa hoặc biến nó thành một thứ gì đó còn kỳ quặc hơn bản gốc.

**⚠️ Lưu ý:**

Logic hiện tại vẫn đang trong quá trình hoàn thiện và chưa được xem là hoàn toàn ổn định.

Script hoạt động tốt nhất trên tựa game sau:

https://www.roblox.com/games/123974602339071/Title-Unavailable

**Execute:**

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/HaTapLamScript/MAMBO_PROJECT/refs/heads/main/R6%20FAKE%20VR%20(Open%20Source).lua"))()
```

---

#### 🏠 DayCornTheSon2 — Daycare the Story 2

**Mô tả:**  
Một script được xây dựng với triết lý rất đơn giản:

> «Best OP script. EZ win.»

Không cần giải thích quá nhiều. Cứ dùng rồi tự hiểu.

**Execute:**

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/HaTapLamScript/MAMBO_PROJECT/refs/heads/main/DayCornTheSon2.lua"))()
```

---

### ⚡ TSB

#### ⚡ TSB Antilag! — Remake

**Trạng thái:** `Active / Remake`

**Mô tả:**  
TSB Antilag! đã được **xây dựng lại hoàn toàn** và chính thức thay thế phiên bản cũ.

Phiên bản mới được thiết kế theo hướng nhẹ hơn, tối ưu hơn và phù hợp hơn với việc sử dụng lâu dài.

Logic dọn dẹp được cải thiện và có khả năng **điều chỉnh theo FPS** để hạn chế tác động không cần thiết đến hiệu năng.

Ngoài ra, phiên bản remake còn tích hợp các tùy chọn **FFlags** nhằm cung cấp thêm khả năng tinh chỉnh hiệu năng.

Nói ngắn gọn:

> **Bản cũ đã nghỉ hưu. Bản mới lên thay.**

**Execute:**

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/HaTapLamScript/MAMBO_PROJECT/refs/heads/main/TSB/Antilag.lua"))()
```

---

#### 🕺 TSB MAMBO DO TECH

**Trạng thái:** `New`

**Mô tả:**  
Một script mới dành riêng cho **The Strongest Battlegrounds**.

TSB MAMBO DO TECH có hệ thống **config riêng**, cho phép tùy chỉnh một số thông số trước khi chạy script.

**Config + Execute:**

```lua
-- [MAMBO PROJECT] TSB MAMBO DO TECH [CONFIG]
_G.MAMBO_DOTECH_CONFIG = {
    y1 = -3.67,
    y2 = -3.67,
    delay = 0.7,
    dashDelay = 0.45,
    direction = "Up", -- Up or Down
    cooldown = 4 -- 4 or 0
}

-- [MAMBO PROJECT] TSB MAMBO DO TECH [MAIN]
loadstring(game:HttpGet("https://raw.githubusercontent.com/HaTapLamScript/MAMBO_PROJECT/refs/heads/main/TSB/TsbDotech.lua"))()
```

> **Config trước. Execute sau. Đừng đảo thứ tự rồi hỏi tại sao nó không chạy.**

---

## ⚠️ General Notes

- Vì làm cho vui nên chất lượng và độ ổn định của các script có thể không đồng đều.
- Các script có thể được cập nhật không theo một lịch trình cố định.
- Một số bản cập nhật sẽ xuất hiện khi tác giả có thời gian, có hứng hoặc đơn giản là… tự nhiên muốn sửa.
- Tính ổn định có thể thay đổi tùy game, executor và phiên bản Roblox.
- Hãy sử dụng cẩn thận! **Khuyến khích dùng tài khoản phụ.**
- Nếu tài khoản gặp vấn đề (bị cấm) do việc sử dụng script, đừng quay lại tìm tác giả để đòi bồi thường bằng nước mắt.

---

## Final Words

**MAMBO PROJECT** về cơ bản chỉ là một bộ sưu tập những thứ được tạo ra vì có người tự hỏi:

> *“Hmm… không biết mình có làm được cái này không.”*

Đôi khi nó hoạt động.  
Đôi khi nó vỡ.  
Đôi khi bug đơn giản trở thành feature.

Dù thế nào đi nữa, chào mừng đến với **MAMBO PROJECT**.

**Happy scripting.**

— *Một kẻ vô danh với chút thời gian rảnh.* 
