import 'package:codingera2/controllers/pdf_controller.dart';
import 'package:codingera2/provider/download_progress_provider.dart';
import 'package:codingera2/provider/isdownload_provider.dart';
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
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title:  Text("Notes",style: GoogleFonts.montserrat(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.2,
        ),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)),
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
    final isDownloading = ref.watch(isDownloadingProvider);
    final downloadProgress = ref.watch(downloadProgressProvider);
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
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
          isDownloading ? Center(child: LinearProgressIndicator(
            color: Colors.deepPurpleAccent,
            semanticsLabel: "Downloading",
            value: downloadProgress,
          )) :
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>PdfViewPage(pdf: pdf,))), child: Text("View",style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent
              ),)),
              ElevatedButton(onPressed: ()async{
                isDownloading==true ? null :
                await PdfController().downloadPdf(ref: ref, context: context, pdfUrl: pdf.pdf, fileName: pdf.subject.replaceAll(" ", "_"));
              }, child: Text("Download",style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent
              ),)),
            ],
          ),
        ],
      ),
    );
  }

}
Widget PdfViewPage({required Pdf pdf}){
  final PdfViewerController controller = PdfViewerController();
  return Scaffold(
    backgroundColor: Colors.black,
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
