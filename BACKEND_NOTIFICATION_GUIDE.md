# Hướng dẫn Backend gửi Push Notification qua Firebase

## ✅ Phần App (đã hoàn thành)

- ✅ Firebase FCM đã tích hợp
- ✅ App có thể nhận notifications
- ✅ FCM Token đã được generate

## ❌ Phần Backend (cần làm thêm)

### Bước 1: Tạo API endpoint lưu FCM Token

Backend cần tạo endpoint để lưu FCM token của user khi họ login:

**Endpoint:** `POST /api/FCMToken`

**Request Body:**
```json
{
  "token": "cpknEICgSIyWOiWTARvEvskP:APA91bF87ltR...",
  "deviceType": "android"
}
```

**Headers:**
```
Authorization: Bearer <user_token>
Content-Type: application/json
```

**Database Schema (ví dụ):**
```sql
CREATE TABLE fcm_tokens (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  fcm_token VARCHAR(255) NOT NULL,
  device_type VARCHAR(50),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY unique_user_token (user_id, fcm_token)
);
```

### Bước 2: Lấy Firebase Server Key

1. Vào [Firebase Console](https://console.firebase.google.com/)
2. Chọn project **HVGL App**
3. Click ⚙️ (Settings) → **Project Settings**
4. Tab **Cloud Messaging**
5. Copy **Server key** (hoặc tạo Service Account JSON)

### Bước 3: Gửi notification khi có văn bản mới

Khi có văn bản mới được tạo, backend gửi notification đến tất cả users:

#### Option A: Sử dụng HTTP API (Legacy)

**Endpoint:** `https://fcm.googleapis.com/fcm/send`

**Headers:**
```
Content-Type: application/json
Authorization: key=<YOUR_SERVER_KEY>
```

**Body (gửi đến 1 user):**
```json
{
  "to": "FCM_TOKEN_CUA_USER",
  "notification": {
    "title": "Văn bản mới",
    "body": "Có văn bản mới: Thông báo họp khẩn"
  },
  "data": {
    "type": "vanban",
    "vanban_id": "123",
    "click_action": "FLUTTER_NOTIFICATION_CLICK"
  }
}
```

**Body (gửi đến nhiều users):**
```json
{
  "registration_ids": [
    "FCM_TOKEN_USER_1",
    "FCM_TOKEN_USER_2",
    "FCM_TOKEN_USER_3"
  ],
  "notification": {
    "title": "Văn bản mới",
    "body": "Có văn bản mới: Thông báo họp khẩn"
  },
  "data": {
    "type": "vanban",
    "vanban_id": "123"
  }
}
```

#### Option B: Sử dụng Topic (Khuyên dùng)

Nếu dùng Topics, không cần lưu từng FCM token:

**Body:**
```json
{
  "to": "/topics/all_users",
  "notification": {
    "title": "Văn bản mới",
    "body": "Có văn bản mới: Thông báo họp khẩn"
  },
  "data": {
    "type": "vanban",
    "vanban_id": "123"
  }
}
```

### Bước 4: Code ví dụ Backend (C# .NET)

```csharp
using System.Net.Http;
using System.Text;
using Newtonsoft.Json;

public class FirebaseService
{
    private readonly string _serverKey = "YOUR_FIREBASE_SERVER_KEY";
    private readonly HttpClient _httpClient;

    public FirebaseService()
    {
        _httpClient = new HttpClient();
        _httpClient.DefaultRequestHeaders.Add("Authorization", $"key={_serverKey}");
    }

    public async Task SendNotificationToUser(string fcmToken, string title, string body, Dictionary<string, string> data = null)
    {
        var payload = new
        {
            to = fcmToken,
            notification = new { title, body },
            data = data ?? new Dictionary<string, string>()
        };

        var json = JsonConvert.SerializeObject(payload);
        var content = new StringContent(json, Encoding.UTF8, "application/json");

        var response = await _httpClient.PostAsync(
            "https://fcm.googleapis.com/fcm/send",
            content
        );

        if (!response.IsSuccessStatusCode)
        {
            var error = await response.Content.ReadAsStringAsync();
            throw new Exception($"FCM Error: {error}");
        }
    }

    public async Task SendNotificationToAllUsers(string title, string body, Dictionary<string, string> data = null)
    {
        // Lấy tất cả FCM tokens từ database
        var tokens = await GetAllFcmTokens(); // Implement này

        foreach (var token in tokens)
        {
            await SendNotificationToUser(token, title, body, data);
        }
    }

    public async Task SendNotificationToTopic(string topic, string title, string body)
    {
        var payload = new
        {
            to = $"/topics/{topic}",
            notification = new { title, body }
        };

        var json = JsonConvert.SerializeObject(payload);
        var content = new StringContent(json, Encoding.UTF8, "application/json");

        await _httpClient.PostAsync("https://fcm.googleapis.com/fcm/send", content);
    }
}
```

**Sử dụng:**
```csharp
// Khi có văn bản mới
var firebaseService = new FirebaseService();

await firebaseService.SendNotificationToTopic(
    "all_users",
    "Văn bản mới",
    "Có văn bản mới: Thông báo họp khẩn"
);
```

### Bước 5: Test thông báo

#### Test từ Firebase Console (không cần code):

1. Vào [Firebase Console](https://console.firebase.google.com/)
2. Chọn project **HVGL App**
3. Menu bên trái → **Cloud Messaging**
4. Click **"Send your first message"**
5. Điền:
   - **Notification title**: Test thông báo
   - **Notification text**: Đây là test
6. Click **Next** → Target:
   - **Topic**: `all_users`
7. Click **Review** → **Publish**

#### Test từ Postman:

**URL:** `https://fcm.googleapis.com/fcm/send`

**Headers:**
```
Authorization: key=YOUR_SERVER_KEY
Content-Type: application/json
```

**Body:**
```json
{
  "to": "/topics/all_users",
  "notification": {
    "title": "Test",
    "body": "Hello from Postman"
  }
}
```

## 📝 Tóm tắt các bước

1. ✅ **App:** Đã tích hợp Firebase FCM (DONE)
2. ⚠️ **Backend:** Tạo API `/api/FCMToken` để lưu token (TODO)
3. ⚠️ **Backend:** Lấy Firebase Server Key từ Console (TODO)
4. ⚠️ **Backend:** Implement logic gửi notification khi có văn bản mới (TODO)
5. ✅ **Test:** Có thể test ngay từ Firebase Console

## 🎯 Quick Start - Test ngay bây giờ

Không cần đợi backend! Bạn có thể test ngay:

1. Vào Firebase Console → Cloud Messaging
2. Click "Send your first message"
3. Target: Topic → Nhập `all_users`
4. Gửi thử → App sẽ nhận notification ngay!

## 📚 Tài liệu tham khảo

- [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
- [FCM HTTP v1 API](https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages)
- [Send messages to topics](https://firebase.google.com/docs/cloud-messaging/android/topic-messaging)
