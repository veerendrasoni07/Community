// Modern aesthetic Hackathon & Club detail screens
// Drop this file into your Flutter project and use Navigator.push

import 'package:codingera2/controllers/pdf_controller.dart';
import 'package:codingera2/models/club.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../provider/download_progress_provider.dart';
import '../../provider/isdownload_provider.dart';

class ClubDetailScreen extends ConsumerStatefulWidget {
  final Club club;
  ClubDetailScreen({super.key, required this.club});

  @override
  ConsumerState<ClubDetailScreen> createState() => _ClubDetailScreenState();
}

class _ClubDetailScreenState extends ConsumerState<ClubDetailScreen> {



   List<String> clubRules = [
    "Download the membership form below",
    "Fill out all required information in the form",
    "Visit the C-211 Class Beside the Incubation center during college working hours",
    "Submit the completed form to the club coordinators or Community Secretary"
  ];

  @override
  Widget build(BuildContext context) {
    var isDownloading = ref.watch(isDownloadingProvider);
    final downloadProgress = ref.watch(downloadProgressProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            leading: IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)),
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.club.clubname,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colors.white54)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(widget.club.image, fit: BoxFit.cover),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black, Colors.transparent],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF020617),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(widget.club.techname,
                        style: GoogleFonts.inter(color: Colors.white)),
                  ),

                  const SizedBox(height: 18),
                  Text(widget.club.desc,
                      style: GoogleFonts.inter(color: Colors.white70, height: 1.6)),

                  const SizedBox(height: 28),

                  Text('Leadership',
                      style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      _LeaderCard(title: 'Leader', name: widget.club.clubLeader.fullname),
                      const SizedBox(width: 12),
                      _LeaderCard(title: 'Manager', name: widget.club.clubManager.fullname),
                    ],
                  ),

                  const SizedBox(height: 32),

                  _Section(title: 'Activities', items: widget.club.clubActivities),
                  _Section(title: 'Rules', items: widget.club.clubRule),

                  const SizedBox(height: 36),

                  SafeArea(
                    bottom: true,
                    maintainBottomViewPadding: true,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.group_add),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF22C55E),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                        ),
                        onPressed: () async{
                          await showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.black.withValues(alpha: 0.84),
                              isScrollControlled: true,
                              enableDrag: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),

                              builder: (context){
                                return Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.35),
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(18),topRight: Radius.circular(18)),
                                      border: Border.all(color: Colors.white24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.deepPurpleAccent.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: Offset(0,10),
                                        )
                                      ]
                                  ),
                                  child:  Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if(isDownloading)
                                         ...[
                                           Center(
                                             child: LinearProgressIndicator(
                                               value: downloadProgress,
                                               minHeight: 8,
                                               color: Colors.deepPurpleAccent,
                                               backgroundColor: Colors.white,
                                             ),
                                           ),
                                           Text("${(downloadProgress * 100).toStringAsFixed(0)}%"),
                                         ],
                                        Text('Join ${widget.club.clubname}',style: GoogleFonts.montserrat(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),textAlign: TextAlign.center,),
                                        SizedBox(height: 16,),
                                        Text('To join the ${widget.club.clubname}, please follow these steps:',style: GoogleFonts.montserrat(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),),
                                        ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: clubRules.length,
                                            itemBuilder: (context,index){
                                              return ListTile(
                                                title: Text(clubRules[index],style: GoogleFonts.montserrat(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                )),
                                                leading: Icon(Icons.circle,color: Colors.deepPurpleAccent,size: 20,),
                                              );
                                            }
                                        ),
                                        SizedBox(height: 16,),
                                        SafeArea(
                                          bottom: true,
                                          child: ElevatedButton(
                                            onPressed: ()async{
                                            isDownloading ? null : await PdfController().downloadPdf(ref: ref, context: context, pdfUrl: widget.club.joinLink, fileName: widget.club.clubname.replaceAll(" ", "_"));
                                            },
                                            child:  Text("Download",style: GoogleFonts.montserrat(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurpleAccent,
                                            )),
                                          ),
                                        )
                                      ]
                                  ),
                                );
                          });
                        },
                        label: Text('Join Club',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget clubRulesForm({required BuildContext context,required List<String> clubRules,required Club club,required WidgetRef ref}){
  //
  //   return
  // }
}
class _LeaderCard extends StatelessWidget {
  final String title;
  final String name;
  const _LeaderCard({required this.title, required this.name});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white.withOpacity(0.06),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          children: [
            Text(title,
                style: GoogleFonts.poppins(
                    color: Colors.white70, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            Text(name,
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}



class _Section extends StatelessWidget {
  final String title;
  final List<String> items;

  const _Section({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 14),

        // Section Card
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF020617),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: Colors.white.withOpacity(0.06),
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      height: 8,
                      width: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF6366F1),
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Text
                    Expanded(
                      child: Text(
                        items[index],
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

