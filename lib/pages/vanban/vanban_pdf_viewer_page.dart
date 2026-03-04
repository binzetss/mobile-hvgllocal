import 'package:flutter/material.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../widgets/vanban/pdf_iframe_widget.dart';

class VanbanPdfViewerPage extends StatelessWidget {
  final String url;
  final String title;

  const VanbanPdfViewerPage({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        backgroundColor: context.cardColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              size: 18, color: context.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: context.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: PdfIframeWidget(url: url),
    );
  }
}
