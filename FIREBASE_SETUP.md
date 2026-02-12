# Hướng dẫn Setup Firebase Cloud Messaging (FCM)

## 📋 Yêu cầu
- Node.js đã cài đặt
- Firebase CLI
- Tài khoản Firebase (đã tạo project)

## 🚀 Bước 1: Cài đặt Firebase CLI

```bash
npm install -g firebase-tools
```

## 🔐 Bước 2: Login Firebase

```bash
firebase login
```

## 📱 Bước 3: Tạo Firebase Project

1. Vào [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" hoặc chọn project có sẵn
3. Tên project: `hvgl-app` (hoặc tên khác)
4. Enable Google Analytics (optional)

## ⚙️ Bước 4: Cấu hình Flutter với Firebase

### 4.1. Cài đặt FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

### 4.2. Chạy FlutterFire Configure

```bash
cd d:\Appmobilenoibo\hvgl
flutterfire configure
```

**Chọn:**
- Project: Chọn project vừa tạo
- Platforms: Android, iOS (nếu cần), Windows (optional)

Script sẽ tự động:
- ✅ Tạo file `firebase_options.dart`
- ✅ Tạo `google-services.json` (Android)
- ✅ Tạo `GoogleService-Info.plist` (iOS)
- ✅ Cấu hình `android/app/build.gradle`

## 📲 Bước 5: Cấu hình Android

### 5.1. Kiểm tra `android/app/build.gradle`

Đảm bảo có:

```gradle
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
    id "com.google.gms.google-services"  // ✅ Thêm dòng này
}

dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
    implementation 'com.google.firebase:firebase-messaging'
}
```

### 5.2. Kiểm tra `android/build.gradle`

Đảm bảo có:

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'  // ✅ Thêm dòng này
    }
}
```

### 5.3. Cấu hình AndroidManifest.xml

File: `android/app/src/main/AndroidManifest.xml`

Thêm trong `<application>`:

```xml
<application>
    <!-- Existing code -->

    <!-- Firebase Messaging -->
    <meta-data
        android:name="com.google.firebase.messaging.default_notification_channel_id"
        android:value="high_importance_channel" />

    <service
        android:name="com.google.firebase.messaging.FirebaseMessagingService"
        android:exported="false">
        <intent-filter>
            <action android:name="com.google.firebase.MESSAGING_EVENT" />
        </intent-filter>
    </service>
</application>
```

## 📦 Bước 6: Install Dependencies

```bash
flutter pub get
```

## 🔓 Bước 7: Uncomment Code trong main.dart

Mở `lib/main.dart` và uncomment:

```dart
import 'firebase_options.dart';  // ✅ Uncomment

await Firebase.initializeApp(    // ✅ Uncomment toàn bộ block này
  options: DefaultFirebaseOptions.currentPlatform,
);
```

## ✅ Bước 8: Test Firebase

### 8.1. Chạy app

```bash
flutter run
```

### 8.2. Kiểm tra console log

Tìm dòng này trong console:
```
📱 FCM Token: <your-token-here>
```

Copy FCM Token này để test.

### 8.3. Test gửi notification từ Firebase Console

1. Vào [Firebase Console](https://console.firebase.google.com/)
2. Chọn project của bạn
3. Vào **Cloud Messaging** (menu bên trái)
4. Click **Send your first message**
5. Điền:
   - **Notification title**: Test notification
   - **Notification text**: Đây là test từ Firebase
6. Click **Next**
7. Chọn **Target**:
   - Option 1: Topic → Nhập `all_users`
   - Option 2: User segment → All users
   - Option 3: Single device → Paste FCM token
8. Click **Next** → **Review** → **Publish**

## 🎯 Bước 9: Subscribe to Topics (Optional)

Trong code, bạn có thể subscribe users vào topics:

```dart
// Subscribe tất cả users vào topic "all_users"
await FirebaseNotificationService().subscribeToTopic('all_users');

// Subscribe theo vai trò
await FirebaseNotificationService().subscribeToTopic('doctors');
await FirebaseNotificationService().subscribeToTopic('nurses');
```

## 🔔 Bước 10: Gửi Notification từ Server (Backend)

Server cần gửi POST request đến Firebase Cloud Messaging API:

### 10.1. Lấy Server Key

1. Firebase Console → Project Settings
2. Tab **Cloud Messaging**
3. Copy **Server key**

### 10.2. API Endpoint

```
POST https://fcm.googleapis.com/fcm/send
```

### 10.3. Headers

```
Content-Type: application/json
Authorization: key=<YOUR_SERVER_KEY>
```

### 10.4. Body Example (Send to specific device)

```json
{
  "to": "<FCM_TOKEN>",
  "notification": {
    "title": "Thông báo mới",
    "body": "Bạn có văn bản mới cần xem"
  },
  "data": {
    "type": "vanban",
    "id": "123",
    "click_action": "FLUTTER_NOTIFICATION_CLICK"
  }
}
```

### 10.5. Body Example (Send to topic)

```json
{
  "to": "/topics/all_users",
  "notification": {
    "title": "Thông báo hệ thống",
    "body": "Hệ thống sẽ bảo trì lúc 22:00"
  },
  "data": {
    "type": "system",
    "priority": "high"
  }
}
```

## 🐛 Troubleshooting

### Lỗi: "Default FirebaseApp is not initialized"

**Giải pháp:**
- Chạy lại `flutterfire configure`
- Uncomment code trong main.dart
- Rebuild app

### Không nhận được notification

**Kiểm tra:**
1. ✅ App có permission notification chưa?
2. ✅ FCM token đã được generate chưa? (check console log)
3. ✅ `google-services.json` đã đúng chưa?
4. ✅ Test gửi từ Firebase Console trước

### Icon notification không hiện

**Giải pháp:**
- Thêm icon notification vào `android/app/src/main/res/drawable/`
- Update `@mipmap/ic_launcher` trong code

## 📚 Next Steps

1. ✅ Tích hợp API gửi FCM token lên server (khi user login)
2. ✅ Handle navigation khi click notification
3. ✅ Tạo notification categories (vanban, daotao, etc.)
4. ✅ Test trên real device (APK)

## 🔗 Resources

- [Firebase Docs](https://firebase.google.com/docs/flutter/setup)
- [FCM Docs](https://firebase.google.com/docs/cloud-messaging)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/)
