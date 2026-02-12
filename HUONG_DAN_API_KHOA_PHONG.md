# Hướng dẫn sử dụng API Khoa Phòng

## Tổng quan
API này dùng để lấy danh sách các khoa phòng từ server.

**Endpoint:** `GET https://api-mobile.bvhvgl.com/api/ThongTinHanhChinh/DmKhoaPhong`

**Response format:**
```json
[
  {
    "id_khoa": 1037,
    "tenKhoa": "Khách hàng"
  },
  {
    "id_khoa": 1038,
    "tenKhoa": "Khoa Nội"
  }
]
```

---

## Cấu trúc code đã tạo

### 1. **Model** (`lib/data/models/department_model.dart`)
```dart
class DepartmentModel {
  final int idKhoa;
  final String tenKhoa;

  // fromJson: Convert JSON -> Model
  // toJson: Convert Model -> JSON
}
```

### 2. **Service** (`lib/data/services/department_service.dart`)
```dart
class DepartmentService {
}
```

### 3. **Provider** (`lib/providers/department_provider.dart`)
```dart
class DepartmentProvider extends ChangeNotifier {
  List<DepartmentModel> _departments = [];
  bool _isLoading = false;
  String? _error;


}
```

### 4. **UI Page** (`lib/pages/department/departments_page.dart`)
- Danh sách khoa phòng với card đẹp
- Search bar để tìm kiếm
- Pull to refresh
- Loading, Error, Empty states

---

## Cách sử dụng trong code

### Cách 1: Navigate đến trang Khoa Phòng

```dart

Navigator.pushNamed(context, AppRoutes.departments);
```

### Cách 2: Sử dụng Provider để lấy data

```dart
import 'package:provider/provider.dart';
import 'package:hvgl/providers/department_provider.dart';

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {

    context.read<DepartmentProvider>().init();
  });
}

@override
Widget build(BuildContext context) {
  return Consumer<DepartmentProvider>(
    builder: (context, provider, child) {
      if (provider.isLoading) {
        return CircularProgressIndicator();
      }

      if (provider.hasError) {
        return Text('Lỗi: ${provider.error}');
      }


      return ListView.builder(
        itemCount: provider.departments.length,
        itemBuilder: (context, index) {
          final dept = provider.departments[index];
          return ListTile(
            title: Text(dept.tenKhoa),
            subtitle: Text('ID: ${dept.idKhoa}'),
          );
        },
      );
    },
  );
}
```

### Cách 3: Gọi API trực tiếp từ Service (không khuyến khích)

```dart
import 'package:hvgl/data/services/department_service.dart';

final service = DepartmentService();


try {
  final departments = await service.getDepartments();
  print('Có ${departments.length} khoa phòng');

  for (var dept in departments) {
    print('${dept.idKhoa}: ${dept.tenKhoa}');
  }
} catch (e) {
  print('Lỗi: $e');
}


final results = await service.searchDepartments('Nội');
```

---

## Test API

### Cách 1: Thêm button vào HomePage

Mở file `lib/widgets/home/home_content.dart` và thêm button:

```dart
ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, AppRoutes.departments);
  },
  child: Text('Xem Khoa Phòng'),
)
```

### Cách 2: Test trực tiếp từ trang DepartmentsPage

```dart
// Navigate từ bất kỳ đâu
Navigator.pushNamed(context, '/departments');
```

---

## Xử lý lỗi

### Các lỗi phổ biến:

1. **Lỗi 404 - Not Found**
   - Kiểm tra URL endpoint có đúng không
   - Kiểm tra API có hoạt động không

2. **Lỗi kết nối**
   - Kiểm tra Internet
   - Kiểm tra server có online không

3. **Lỗi parse JSON**
   - Kiểm tra format JSON trả về có đúng không
   - Kiểm tra mapping trong `fromJson()`

### Debug:

Thêm print để debug trong `DepartmentService`:

```dart
Future<List<DepartmentModel>> getDepartments() async {
  try {
    print('🚀 Calling API: ${ApiEndpoints.baseUrl}/ThongTinHanhChinh/DmKhoaPhong');

    final response = await http.get(...);

    print('📡 Response status: ${response.statusCode}');
    print('📦 Response body: ${response.body}');

    // ... rest of code
  } catch (e) {
    print('❌ Error: $e');
    rethrow;
  }
}
```

---

## Mở rộng

### Thêm chức năng mới:

1. **Thêm field vào Model**
```dart
class DepartmentModel {
  final int idKhoa;
  final String tenKhoa;
  final String? moTa;  // Thêm mô tả
  final int? soNhanVien;  // Thêm số nhân viên

  // Update fromJson và toJson
}
```

2. **Thêm filter/sort trong Provider**
```dart
void sortByName() {
  _departments.sort((a, b) => a.tenKhoa.compareTo(b.tenKhoa));
  notifyListeners();
}

void filterByKeyword(String keyword) {
  _filteredDepartments = _departments
    .where((d) => d.tenKhoa.contains(keyword))
    .toList();
  notifyListeners();
}
```

3. **Cache dữ liệu**
```dart
// Sử dụng shared_preferences để cache
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveCacheDepartments(List<DepartmentModel> departments) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = json.encode(
    departments.map((d) => d.toJson()).toList()
  );
  await prefs.setString('cached_departments', jsonString);
}
```

---

## Checklist hoàn thành

- [x] Tạo Model (DepartmentModel)
- [x] Tạo Service (DepartmentService)
- [x] Tạo Provider (DepartmentProvider)
- [x] Tạo UI Page (DepartmentsPage)
- [x] Đăng ký Provider trong main.dart
- [x] Đăng ký Route trong app_routes.dart
- [ ] Test API xem có hoạt động không
- [ ] Xử lý các trường hợp edge cases
- [ ] Thêm analytics tracking nếu cần

---

## Liên hệ

Nếu có vấn đề, kiểm tra:
1. API endpoint có đúng không
2. Internet connection
3. Response format từ API
4. Console logs để debug

Good luck! 🚀
