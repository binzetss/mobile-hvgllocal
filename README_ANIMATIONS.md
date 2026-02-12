# 🎬 Hướng Dẫn Sử Dụng Animations & Effects

## 🚀 Quick Start

### 1. Chạy App
```bash
flutter clean
flutter pub get
flutter run
```

### 2. Trải Nghiệm Các Hiệu Ứng

#### Login Page 🎨
- Mở app → thấy **animated gradient background**
- Nhìn các **particles bay** trên nền
- Logo **scale up** mượt mà
- Form **slide in** từ dưới lên
- Các field xuất hiện **lần lượt**
- Tick "Nhớ đăng nhập" → **lưu tài khoản**
- Nhấn "Đăng nhập" → **button press animation**

#### Page Transition 💫
- Login → Home: **Hero zoom** (logo phóng to)
- Vuốt giữa các tabs: **content transition**
- Các card **fade + slide in** staggered

#### Home Page 🏠
- Card đầu tiên xuất hiện (100ms delay)
- Card thứ hai xuất hiện (250ms delay)
- Icon "Under development" **thở** (fade + scale)

---

## 📚 Cách Thêm Animations Mới

### 1. Fade In Animation
```dart
Widget()
  .animate()
  .fadeIn(duration: 400.ms)
```

### 2. Slide Animation
```dart
Widget()
  .animate()
  .slideY(begin: 0.3, end: 0, duration: 400.ms)
```

### 3. Scale Animation
```dart
Widget()
  .animate()
  .scale(begin: const Offset(0.8, 0.8), duration: 400.ms)
```

### 4. Kết Hợp Animations
```dart
Widget()
  .animate()
  .fadeIn(delay: 100.ms, duration: 400.ms)
  .slideY(begin: 0.2, end: 0)
  .scale(begin: const Offset(0.9, 0.9))
```

### 5. Repeating Animation
```dart
Widget()
  .animate(onPlay: (controller) => controller.repeat(reverse: true))
  .fade(begin: 0.5, end: 1.0, duration: 1500.ms)
```

---

## 🎯 Page Transitions

### Cách 1: Sử dụng AppPageTransitions
```dart
Navigator.push(
  context,
  AppPageTransitions.fadeTransition(NextPage()),
);
```

### Cách 2: Các Loại Transitions

#### Fade Transition
```dart
AppPageTransitions.fadeTransition(NextPage())
```

#### Scale Transition (iOS-like)
```dart
AppPageTransitions.scaleTransition(NextPage())
```

#### Slide Right (iOS native)
```dart
AppPageTransitions.slideRightTransition(NextPage())
```

#### Slide Up (Material style)
```dart
AppPageTransitions.slideUpTransition(NextPage())
```

#### Hero Zoom
```dart
AppPageTransitions.heroZoomTransition(NextPage())
```

---

## 🌟 Hero Animations

### Bước 1: Wrap widget ở page đầu
```dart
// Page 1
Hero(
  tag: 'user_avatar',
  child: CircleAvatar(
    backgroundImage: NetworkImage(url),
  ),
)
```

### Bước 2: Wrap widget ở page thứ 2
```dart
// Page 2
Hero(
  tag: 'user_avatar', // PHẢI GIỐNG TAG
  child: CircleAvatar(
    backgroundImage: NetworkImage(url),
  ),
)
```

### Bước 3: Navigate
```dart
Navigator.push(
  context,
  AppPageTransitions.heroZoomTransition(DetailPage()),
);
```

---

## 💫 Shimmer Loading

### Basic Shimmer
```dart
ShimmerLoading(
  width: 100,
  height: 20,
  borderRadius: 8,
)
```

### Card Shimmer
```dart
isLoading
  ? const ShimmerCard()
  : const ActualCard()
```

### List Shimmer
```dart
ListView.builder(
  itemCount: isLoading ? 5 : data.length,
  itemBuilder: (context, index) {
    if (isLoading) {
      return const ShimmerListTile();
    }
    return ActualListTile(data[index]);
  },
)
```

---

## 🎨 Tùy Chỉnh Animations

### Thay Đổi Duration
```dart
Widget()
  .animate()
  .fadeIn(duration: 600.ms) // Chậm hơn
  .slideY(duration: 300.ms)  // Nhanh hơn
```

### Thay Đổi Delay
```dart
Widget()
  .animate()
  .fadeIn(delay: 200.ms, duration: 400.ms)
  .slideY(delay: 300.ms, duration: 400.ms)
```

### Thay Đổi Curve
```dart
Widget()
  .animate()
  .fadeIn(curve: Curves.easeOutBack)
  .slideY(curve: Curves.easeOutCubic)
```

### Staggered List
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(...)
      .animate()
      .fadeIn(delay: (index * 100).ms)
      .slideX(begin: -0.2, end: 0);
  },
)
```

---

## 🎭 Best Practices

### ✅ DO

1. **Giữ animations ngắn**
```dart
// Good - 300-400ms
.fadeIn(duration: 400.ms)

// Bad - quá dài
.fadeIn(duration: 2000.ms)
```

2. **Sử dụng staggered cho lists**
```dart
items.asMap().entries.map((entry) {
  return Widget()
    .animate()
    .fadeIn(delay: (entry.key * 100).ms);
}).toList()
```

3. **Combine animations hợp lý**
```dart
// Good - fade + slide
Widget()
  .animate()
  .fadeIn(duration: 400.ms)
  .slideY(begin: 0.2, end: 0)
```

4. **Dispose controllers**
```dart
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

### ❌ DON'T

1. **Quá nhiều animations cùng lúc**
```dart
// Bad - overwhelming
Widget()
  .animate()
  .fadeIn()
  .slideY()
  .slideX()
  .scale()
  .rotate()
  .blur()
```

2. **Blocking UI**
```dart
// Bad - chờ animation xong mới cho tương tác
await Future.delayed(Duration(seconds: 2));
```

3. **Animations không có mục đích**
```dart
// Bad - animation vô duyên
Text("Hello").animate().rotate(duration: 5000.ms)
```

---

## 🔧 Troubleshooting

### Animation không chạy?
1. Check import `flutter_animate`
2. Check widget có rebuild không
3. Thử hot restart (không phải hot reload)

### Animation giật lag?
1. Giảm duration
2. Đơn giản hóa animation
3. Sử dụng `RepaintBoundary`
4. Profile với `flutter run --profile`

### Hero animation không hoạt động?
1. Check tag phải GIỐNG NHAU
2. Check hero widget ở CẢ 2 pages
3. Thử `flightShuttleBuilder` nếu widgets khác nhau

---

## 📊 Performance Tips

### 1. Sử dụng const
```dart
const Widget().animate()...
```

### 2. RepaintBoundary
```dart
RepaintBoundary(
  child: ExpensiveWidget().animate()...,
)
```

### 3. Lazy loading
```dart
// Load animations chỉ khi cần
if (isVisible) {
  return Widget().animate()...;
}
```

### 4. Dispose đúng cách
```dart
@override
void dispose() {
  _controller.dispose();
  _scrollController.dispose();
  super.dispose();
}
```

---

## 🎬 Example: Complete Animated Page

```dart
class AnimatedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animated Page')),
      body: ListView(
        children: [
          // Header với fade + slide
          Text('Welcome')
            .animate()
            .fadeIn(delay: 100.ms, duration: 400.ms)
            .slideY(begin: -0.2, end: 0),

          // Cards staggered
          ...items.asMap().entries.map((entry) {
            return Card(...)
              .animate()
              .fadeIn(delay: (200 + entry.key * 100).ms)
              .slideX(begin: 0.2, end: 0);
          }),

          // Button với shimmer khi loading
          isLoading
            ? ShimmerLoading(width: 200, height: 50)
            : ElevatedButton(...)
                .animate()
                .fadeIn(delay: 800.ms)
                .scale(),
        ],
      ),
    );
  }
}
```

---

## 🎯 Next Steps

1. **Thử nghiệm** các animations trong app
2. **Tùy chỉnh** duration, delay, curves
3. **Thêm** hero animations cho các elements quan trọng
4. **Optimize** performance nếu cần
5. **Sáng tạo** animations riêng của bạn!

---

## 📚 Resources

- [Flutter Animate Package](https://pub.dev/packages/flutter_animate)
- [Shimmer Package](https://pub.dev/packages/shimmer)
- [Page Transition Package](https://pub.dev/packages/page_transition)
- [Material Motion Guidelines](https://m3.material.io/styles/motion)
- [iOS Human Interface Guidelines - Motion](https://developer.apple.com/design/human-interface-guidelines/motion)

---

**Happy Animating! 🎬✨**
