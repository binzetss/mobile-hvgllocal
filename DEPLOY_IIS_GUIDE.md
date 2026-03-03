# Hướng dẫn Deploy Flutter Web lên IIS

## 📦 Chuẩn bị

Sau khi build xong, thư mục `build/web` chứa tất cả các file cần thiết:
- `index.html` - Entry point
- `flutter_bootstrap.js` - Bootstrap file
- `assets/` - Font, image, asset khác
- `web.config` - Cấu hình cho IIS

## 🚀 Các bước deploy:

### **Bước 1: Copy build folder**
Sao chép nội dung từ `build/web` vào thư mục trên IIS Server, ví dụ:
```
C:\inetpub\wwwroot\hvgl\
```

### **Bước 2: Tạo Application Pool trên IIS**
1. Mở **Internet Information Services (IIS) Manager**
2. Right-click **Application Pools** → **Add Application Pool**
3. Cấu hình:
   - **Name**: `hvgl_app`
   - **.NET CLR version**: `No Managed Code`
   - **Managed pipeline mode**: `Integrated`
4. Click **OK**

### **Bước 3: Tạo Website/Application**
1. Right-click **Sites** → **Add Website**
2. Cấu hình:
   - **Site name**: `HVGL`
   - **Application pool**: `hvgl_app` (vừa tạo)
   - **Physical path**: `C:\inetpub\wwwroot\hvgl\`
   - **Binding**: 
     - Type: `http`
     - IP: `All Unassigned`
     - Port: `80` (hoặc port khác nếu cần)
     - Hostname: `yourdomain.com` (optional)
3. Click **OK**

### **Bước 4: Kích hoạt URL Rewrite**
IIS cần cài đặt **URL Rewrite Module**:
1. Download từ: https://www.iis.net/downloads/microsoft/url-rewrite
2. Cài đặt file `.msi`
3. Restart IIS

**File `web.config` đã được tạo tự động với URL rewrite rules**

### **Bước 5: Cấu hình CORS (nếu API khác domain)**
File `web.config` đã bao gồm CORS headers. Nếu cần điều chỉnh:
```xml
<add name="Access-Control-Allow-Origin" value="*" />
```
Thay `*` bằng domain cụ thể để bảo mật.

### **Bước 6: Enable Static Content Compression**
1. Tại server level hoặc site level
2. Compression sẽ giảm size file từ 50MB → ~10MB

## ✅ Kiểm tra deployment

```bash
# Vào thư mục web và kiểm tra file
dir build\web

# Hoặc vào đường dẫn trên IIS để kiểm tra
C:\inetpub\wwwroot\hvgl\
```

Sau đó truy cập:
```
http://localhost:80
hoặc
http://yourdomain.com
```

## 🔧 Xử lý lỗi thường gặp

### **1. Lỗi 404 - Page Not Found**
**Nguyên nhân**: URL Rewrite không hoạt động
**Cách fix**:
- Kiểm tra URL Rewrite Module đã cài chưa
- Kiểm tra `web.config` có đúng vị trí không
- Reset IIS: `iisreset` (cmd as admin)

### **2. Lỗi 403 - Forbidden**
**Nguyên nhân**: Không có quyền truy cập thư mục
**Cách fix**:
- Right-click thư mục `hvgl` → **Properties** → **Security**
- Thêm quyền cho user `IIS_IUSRS` (Read, List Folder Contents)

### **3. API không hoạt động trên web**
**Nguyên nhân**: CORS headers
**Cách fix**:
- Đảm bảo `Access-Control-Allow-Origin` trong `web.config` tương thích với API
- Hoặc yêu cầu backend enable CORS cho domain web của bạn

### **4. Static files không load (CSS, JS)**
**Kiểm tra**:
- Mở Developer Tools (F12) → Network
- Kiểm tra MIME types trong IIS có đúng không
- `web.config` đã include các MIME types cần thiết (wasm, dart)

## 📝 Lệnh IIS hữu ích

```powershell
# Restart IIS
iisreset

# Stop IIS
iisreset /stop

# Start IIS
iisreset /start

# List websites
Get-Website

# Start website
Start-Website -Name "HVGL"

# Stop website
Stop-Website -Name "HVGL"
```

## 🎯 Performance Tips

1. **Enable Gzip Compression** - đã cấu hình trong `web.config`
2. **Set Static Content Cache** - file js, css cache 365 ngày
3. **HTTP/2** - Enable nếu https
4. **Keep-Alive** - Default true

## 📊 File Sizes sau khi deploy

Trước optimization: ~50-100MB  
Sau compression: ~10-20MB

## 🔐 Bảo mật

- Restrict direct access to `assets`, `build` folders nếu không cần
- Set proper permissions trên file
- Disable Directory Browsing
- Set Security Headers trong `web.config`

---

**Lưu ý**: Đảm bảo backup `web.config` trước khi edit. IIS sẽ sử dụng file này để routing URL SPA.
