import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import '../../data/models/vanban_model.dart';
import '../../providers/vanban_chitiet_provider.dart';
import '../../widgets/common/app_dialogs.dart';
import '../../widgets/vanban_chitiet/hop_thoai_chon_file.dart';

class VanbanChitietActions {
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  static Future<void> handleOpenPdf(
    BuildContext context,
    VanbanModel document,
  ) async {
    if (document.hasMultipleFiles) {
      final parentContext = context; 
      showDialog(
        context: context,
        builder: (dialogContext) => FileSelectionDialog(
          files: document.allFiles,
          onFileSelected: (index) => openPdfAtIndex(parentContext, document, index),
        ),
      );
    } else {
      await openPdfAtIndex(context, document, 0);
    }
  }

  static Future<void> handleDownloadPdf(
    BuildContext context,
    VanbanModel document,
  ) async {
    if (document.hasMultipleFiles) {
      final parentContext = context;
      showDialog(
        context: context,
        builder: (dialogContext) => FileSelectionDialog(
          files: document.allFiles,
          onFileSelected: (index) => downloadPdfAtIndex(parentContext, document, index),
        ),
      );
    } else {
      await downloadPdfAtIndex(context, document, 0);
    }
  }

  static Future<void> openPdfAtIndex(
    BuildContext context,
    VanbanModel document,
    int index,
  ) async {
    final provider =
        Provider.of<VanbanChitietProvider>(context, listen: false);
    final filePath = document.allFiles[index];

    final modifiedDoc = document.copyWith(filePath: filePath);
    final success = await provider.downloadAndOpenPdf(modifiedDoc);

    if (!success && context.mounted) {
      showErrorDialog(
        context,
        message: provider.errorMessage ?? 'Không thể tải tài liệu',
      );
      return;
    }

    if (provider.downloadedFile != null) {
      try {
        final result = await OpenFilex.open(provider.downloadedFile!.path);

        if (result.type != ResultType.done && context.mounted) {
          showErrorDialog(
            context,
            message: 'Không thể mở tài liệu: ${result.message}',
          );
        }
      } catch (e) {
        if (context.mounted) {
          showErrorDialog(context, message: 'Lỗi khi mở tài liệu: $e');
        }
      }
    }
  }

  static Future<void> downloadPdfAtIndex(
    BuildContext context,
    VanbanModel document,
    int index,
  ) async {
    final provider =
        Provider.of<VanbanChitietProvider>(context, listen: false);
    final filePath = document.allFiles[index];

    final modifiedDoc = document.copyWith(filePath: filePath);
    final success = await provider.downloadPdfToDownloads(modifiedDoc);

    if (!success && context.mounted) {
      showErrorDialog(
        context,
        message: provider.errorMessage ?? 'Không thể tải tài liệu',
      );
      return;
    }

    if (context.mounted) {
      showSuccessDialog(
        context,
        title: 'Thành công!',
        message: 'Tài liệu đã được tải về thư mục Downloads',
        autoCloseDuration: const Duration(milliseconds: 2000),
      );
    }
  }
}
