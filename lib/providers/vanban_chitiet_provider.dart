import 'package:flutter/foundation.dart';
import '../data/models/vanban_model.dart';
import '../data/services/file_download_service.dart';
import 'dart:io';

class VanbanChitietProvider extends ChangeNotifier {
  final FileDownloadService _fileService = FileDownloadService();

  bool _isLoadingView = false;
  bool _isLoadingDownload = false;
  String? _errorMessage;
  File? _downloadedFile;
  bool _isDisposed = false;

  bool get isLoadingView => _isLoadingView;
  bool get isLoadingDownload => _isLoadingDownload;
  String? get errorMessage => _errorMessage;
  File? get downloadedFile => _downloadedFile;
  bool get hasError => _errorMessage != null;

  /// Helper để gọi notifyListeners an toàn
  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Future<bool> downloadAndOpenPdf(VanbanModel document) async {
    _isLoadingView = true;
    _errorMessage = null;
    _safeNotifyListeners();
    try {
      final safeFileName = _getSafeFileName(document);
      if (kDebugMode) {
        print('Downloading PDF from: ${document.fullFilePath}');
        print('File name: $safeFileName');
      }
      _downloadedFile = await _fileService.downloadFile(
        document.fullFilePath,
        safeFileName,
      );
      _isLoadingView = false;
      _safeNotifyListeners();
      return true;
    } catch (e) {
      _isLoadingView = false;
      _handleDownloadError(e);
      _safeNotifyListeners();
      return false;
    }
  }

  Future<bool> downloadPdfToDownloads(VanbanModel document) async {
    _isLoadingDownload = true;
    _errorMessage = null;
    _safeNotifyListeners();
    try {
      final safeFileName = _getSafeFileName(document);
      if (kDebugMode) {
        print('Downloading PDF to Downloads from: ${document.fullFilePath}');
        print('File name: $safeFileName');
      }
      _downloadedFile = await _fileService.downloadFileToDownloads(
        document.fullFilePath,
        safeFileName,
      );
      _isLoadingDownload = false;
      _safeNotifyListeners();
      return true;
    } catch (e) {
      _isLoadingDownload = false;
      _handleDownloadError(e);
      _safeNotifyListeners();
      return false;
    }
  }

  void _handleDownloadError(dynamic e) {
    final errorStr = e.toString();
    if (errorStr.contains('404')) {
      _errorMessage =
          'Không tìm thấy tài liệu. File có thể đã bị xóa hoặc di chuyển.';
    } else if (errorStr.contains('401')) {
      _errorMessage = 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
    } else if (errorStr.contains('Network error')) {
      _errorMessage = 'Lỗi kết nối mạng. Vui lòng kiểm tra Internet.';
    } else {
      _errorMessage = 'Lỗi khi tải tài liệu: ${e.toString()}';
    }

    if (kDebugMode) {
      print('Error downloading PDF: $e');
    }
  }

  String _getSafeFileName(VanbanModel document) {
    final fileName = document.fileName
        .replaceAll(RegExp(r'[^\w\s\-\.]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .trim();

    if (fileName.toLowerCase().endsWith('.pdf')) {
      return '${document.fileId}_$fileName';
    } else {
      return '${document.fileId}_$fileName.pdf';
    }
  }

  void clearError() {
    _errorMessage = null;
    _safeNotifyListeners();
  }

  void reset() {
    _isLoadingView = false;
    _isLoadingDownload = false;
    _errorMessage = null;
    _downloadedFile = null;
    _safeNotifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
