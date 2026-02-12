import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../core/utils/token_manager.dart';

class FileDownloadService {
  static final FileDownloadService _instance = FileDownloadService._internal();
  factory FileDownloadService() => _instance;
  FileDownloadService._internal();

  final TokenManager _tokenManager = TokenManager();

  /// Download file với Bearer token vào thư mục temp
  Future<File> downloadFile(String url, String fileName) async {
    try {
      final response = await _downloadFileWithAuth(url);

      // Lấy thư mục temp
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/$fileName';

      // Lưu file
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      return file;
    } catch (e) {
      throw Exception('Lỗi khi tải file: $e');
    }
  }

  /// Download file với Bearer token vào thư mục Downloads
  Future<File> downloadFileToDownloads(String url, String fileName) async {
    try {
      final response = await _downloadFileWithAuth(url);

      // Lấy thư mục Downloads
      Directory directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final filePath = '${directory.path}/$fileName';

      // Lưu file
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      return file;
    } catch (e) {
      throw Exception('Lỗi khi tải file: $e');
    }
  }

  /// Private method để download file với authentication
  Future<http.Response> _downloadFileWithAuth(String url) async {
    // Lấy token
    final token = await _tokenManager.getToken();

    // Tạo headers với token
    final headers = {
      'Content-Type': 'application/pdf',
      'Accept': 'application/pdf',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    // Download file - parse URL properly to handle special characters
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 401) {
      await _tokenManager.clearToken();
      throw Exception('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.');
    } else if (response.statusCode == 404) {
      throw Exception('Không tìm thấy file tại đường dẫn: $url');
    } else {
      throw Exception('Không thể tải file. Mã lỗi: ${response.statusCode}\nURL: $url');
    }
  }

  /// Lấy URL để xem file trong WebView với token
  Future<String> getAuthenticatedUrl(String url) async {
    final token = await _tokenManager.getToken();
    if (token != null && token.isNotEmpty) {
      // Thêm token vào URL query parameter (nếu API hỗ trợ)
      final uri = Uri.parse(url);
      final newUri = uri.replace(
        queryParameters: {
          ...uri.queryParameters,
          'token': token,
        },
      );
      return newUri.toString();
    }
    return url;
  }
}
