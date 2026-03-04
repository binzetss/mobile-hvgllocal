// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

class PdfIframeWidget extends StatefulWidget {
  final String url;
  const PdfIframeWidget({super.key, required this.url});

  @override
  State<PdfIframeWidget> createState() => _PdfIframeWidgetState();
}

class _PdfIframeWidgetState extends State<PdfIframeWidget> {
  late final String _viewId;

  @override
  void initState() {
    super.initState();
    _viewId = 'pdf-viewer-${DateTime.now().millisecondsSinceEpoch}';
    ui_web.platformViewRegistry.registerViewFactory(
      _viewId,
      (int id) => html.IFrameElement()
        ..src = '${widget.url}#toolbar=0&navpanes=0'
        ..style.cssText = 'border:none;width:100%;height:100%',
    );
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewId);
  }
}
