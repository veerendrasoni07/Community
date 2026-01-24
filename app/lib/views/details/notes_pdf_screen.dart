import 'package:codingera2/provider/pdf_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../models/pdf.dart';

class NotesPdfScreen extends ConsumerStatefulWidget {
  const NotesPdfScreen({super.key});

  @override
  ConsumerState<NotesPdfScreen> createState() => _NotesPdfScreenState();
}

class _NotesPdfScreenState extends ConsumerState<NotesPdfScreen> {
  @override
  Widget build(BuildContext context) {
    final pdfs = ref.watch(pdfProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: pdfs.length,
            itemBuilder: (context,index){
              final pdf = pdfs[index];
              return pdfTile(pdf);
            },
          )
        ],
      )
    );
  }

  Widget pdfTile(Pdf pdf){
    return GestureDetector(
      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>PdfViewPage(pdf: pdf,))),
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              spreadRadius: 2
            )
          ],
        ),
        child: Column(
          children: [
            Text(pdf.subject,style: GoogleFonts.poppins(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),),
            Text(pdf.semester,style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
          ],
        ),
      ),
    );
  }

}
Widget PdfViewPage({required Pdf pdf}){
  final PdfViewerController controller = PdfViewerController();
  return Scaffold(
    appBar: AppBar(
      title: Text(pdf.chapter,style: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),),

    ),
    body: SfPdfViewer.network(
      pdf.pdf,
      controller: controller,
      scrollDirection: PdfScrollDirection.vertical,
      enableTextSelection: true,
      enableDoubleTapZooming: true,
      canShowPaginationDialog: true,
      canShowScrollHead: true,
      canShowScrollStatus: true,
      canShowSignaturePadDialog: true,
      canShowTextSelectionMenu: true,
      canShowHyperlinkDialog: true,
      canShowPageLoadingIndicator: true,
    ),
  );
}
