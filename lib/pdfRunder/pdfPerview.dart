import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

class PdfPreviewScreen extends StatelessWidget {
  final String path;

  PdfPreviewScreen({this.path});

  Future sharePdfFile(String pdfPath) async {
   await Share.shareFiles(['$pdfPath'], text: 'Pdf FIle');

    // if (await canLaunch(pdfPath)) {
    //   await launch(pdfPath);
    // } else {
    //   throw 'Could not launch $pdfPath';
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PDFViewerScaffold(
        primary: true,
        appBar: AppBar(
          bottom: PreferredSize(
            child: Container(
              color: Colors.red,
            ),
            preferredSize: Size.fromHeight(30),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                var state = Permission.storage.status;
                state.then((s) async {
                  if (!s.isGranted) {
                    Permission.storage.request().then((ss) async {
                      if (ss.isGranted) {
                        await ImageGallerySaver.saveFile(path).then((_) async {
                          await sharePdfFile(path);
                        });
                      }
                    });
                  } else {
                    await ImageGallerySaver.saveFile(path).then((_) async {
                      await sharePdfFile(path);
                    });
                  }
                });
              },
              icon: Icon(
                Icons.print,
              ),
            )
          ],
        ),
        path: path,
      ),
    );
  }
}
