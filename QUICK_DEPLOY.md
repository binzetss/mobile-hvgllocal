# Deploy nhanh - Copy build folder lên IIS

## 🚀 Cách deploy đơn giản nhất:

### **Bước 1: Build**
```bash
cd D:\Appmobilenoibo\hvgl
flutter build web --release
```

### **Bước 2: Copy files to Server**

#### **Cách 1: Dùng File Explorer (Đơn giản nhất)**
```
1. Nhấn Win + R, gõ: \\[IP_SERVER]\c$
2. Vào thư mục: inetpub > wwwroot > hvgl
3. Xóa toàn bộ nội dung của folder hvgl
4. Copy nội dung từ: D:\Appmobilenoibo\hvgl\build\web vào folder hvgl trên server
5. Copy file web.config từ local vào thư mục hvgl trên server (nếu chưa có)
```

#### **Cách 2: Dùng Command Line**
```bash
# Sửa IP_SERVER thành IP máy IIS của bạn
xcopy "D:\Appmobilenoibo\hvgl\build\web\*.*" "\\[IP_SERVER]\c$\inetpub\wwwroot\hvgl\" /E /Y

# Copy web.config
xcopy "D:\Appmobilenoibo\hvgl\web\web.config" "\\[IP_SERVER]\c$\inetpub\wwwroot\hvgl\" /Y
```

#### **Cách 3: Dùng PowerShell Script**
```powershell
# Edit deploy.ps1, sửa:
# - $SERVER_IP = "IP_SERVER_CỦA_BẠN"
# - $SERVER_USER = "USERNAME_SERVER"

powershell -ExecutionPolicy Bypass -File "D:\Appmobilenoibo\hvgl\deploy.ps1"
```

### **Bước 3: Reset IIS** (trên server)
```bash
iisreset
```

---

## 📋 Thông tin cần chuẩn bị:

- **IP máy IIS**: Ví dụ `192.168.1.100`
- **Path IIS**: Thường là `C:\inetpub\wwwroot\hvgl\`
- **Username & Password server** (nếu copy từ xa)
- **URL Rewrite Module** (phải cài trên server)

---

## ✅ Kiểm tra sau deploy:

```bash
# Vào server và verify
dir C:\inetpub\wwwroot\hvgl\

# Phải thấy:
# - index.html
# - flutter_bootstrap.js
# - web.config
# - assets/
# - canvaskit/ (tùy vào build settings)
```

---

## 🔧 Các file quan trọng:

| File | Vị trí | Mô tả |
|------|--------|--------|
| `index.html` | Root | Entry point |
| `web.config` | Root | Cấu hình IIS (URL rewrite, CORS) |
| `flutter_bootstrap.js` | Root | Bootstrap Flutter |
| `assets/` | Root | Fonts, images, data |
| `canvaskit/` | Root | WebAssembly runtime |

---

## 💡 Lưu ý quan trọng:

1. **web.config phải ở root folder** - không phải trong subfolder
2. **URL Rewrite Module** - phải cài trên IIS để SPA routing hoạt động
3. **Permissions** - application pool phải có quyền read trên folder
4. **CORS** - Nếu API khác domain, kiểm tra web.config có `Access-Control-Allow-Origin`

---

## 🆘 Gặp lỗi?

| Lỗi | Nguyên nhân | Cách fix |
|-----|------------|---------|
| 404 Not Found | URL Rewrite không hoạt động | Cài URL Rewrite Module + iisreset |
| 403 Forbidden | Không có quyền | Thêm quyền IIS_IUSRS |
| CORS error | API khác domain | Kiểm tra web.config |
| Static files không load | MIME type sai | Kiểm tra web.config |

Gõ `iisreset` trên server nếu gặp vấn đề!
