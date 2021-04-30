import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

// this is the prescription pdf viewere
class PdfPreviewScreen extends StatelessWidget {
  final String path;
  PdfPreviewScreen({this.path});
  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      path: path,
    );
  }
}
