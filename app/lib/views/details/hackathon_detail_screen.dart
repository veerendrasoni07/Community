import 'dart:io';

import 'package:codingera2/components/alert_dialog_warning.dart';
import 'package:codingera2/components/inside_app_button.dart';
import 'package:codingera2/controllers/admin_controller.dart';
import 'package:codingera2/models/hackathon.dart';
import 'package:codingera2/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';



class HackathonDetailScreen extends ConsumerStatefulWidget {
  final Hackathon hackathon;
  const HackathonDetailScreen({super.key, required this.hackathon});

  @override
  ConsumerState<HackathonDetailScreen> createState() => _HackathonDetailScreenState();
}

class _HackathonDetailScreenState extends ConsumerState<HackathonDetailScreen> {
  bool isEditing = false;

  TextEditingController nameEditController = TextEditingController();

  TextEditingController descriptionEditController = TextEditingController();

  TextEditingController venueEditController = TextEditingController();

  TextEditingController eventDateEditController = TextEditingController();

  TextEditingController eventTimeEditController = TextEditingController();

  TextEditingController deadlineEditController = TextEditingController();

  TextEditingController teamSizeEditController = TextEditingController();

  TextEditingController totalTeamEditController = TextEditingController();

  TextEditingController durationEditController = TextEditingController();

  TextEditingController prizeEditController = TextEditingController();

  TextEditingController linkEditController = TextEditingController();

  TextEditingController levelEditController = TextEditingController();
  TextEditingController statusEditController = TextEditingController();
  TextEditingController registeredEditController = TextEditingController();


  XFile? pickedImage;
  DateTime? eventDate;
  DateTime? deadline;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameEditController.text = widget.hackathon.name;
    descriptionEditController.text = widget.hackathon.description;
    venueEditController.text = widget.hackathon.venue;
    eventDateEditController.text = widget.hackathon.eventdate.toString().split("T")[0];
    eventTimeEditController.text = widget.hackathon.eventTime;
    eventDate = DateTime.parse(widget.hackathon.eventdate);
    deadline = DateTime.parse(widget.hackathon.deadline);
    deadlineEditController.text = widget.hackathon.deadline;
    teamSizeEditController.text = widget.hackathon.teamsize.toString();
    totalTeamEditController.text = widget.hackathon.totalTeam.toString();
    durationEditController.text = widget.hackathon.duration;
    prizeEditController.text = widget.hackathon.prize.toString();
    linkEditController.text = widget.hackathon.link;
    statusEditController.text = widget.hackathon.status;
    levelEditController.text = widget.hackathon.level;
    registeredEditController.text = widget.hackathon.registered.toString();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => pickedImage = image);
    }
  }


  Future<void> updateHackathon()async{
    showDialog(context: context, builder: (context){
      return Center(child: CircularProgressIndicator(color: Colors.white,),);
    });

    Map<String, dynamic> data = {
      "name": nameEditController.text.trim(),
      "description": descriptionEditController.text.trim(),
      "venue": venueEditController.text.trim(),
      "eventdate": eventDate?.toIso8601String(),
      "eventTime": eventTimeEditController.text.trim(),
      "deadline": deadline?.toIso8601String(),
      "prize": int.parse(prizeEditController.text.trim()),
      "teamsize": int.parse(teamSizeEditController.text.trim()),
      "totalTeam": int.parse(totalTeamEditController.text.trim()),
      "duration": durationEditController.text.trim(),
      "status":statusEditController.text.trim(),
      "level": levelEditController.text.trim(),
      "link": linkEditController.text.trim(),
      "registered": int.parse(registeredEditController.text),
    };

    await AdminController().hackathonUpdate(
        details: data,
        hackathonId: widget.hackathon.id,
        context: context,
        ref: ref,
        image: pickedImage,
        currentImage: widget.hackathon.url,
    );
    Navigator.pop(context);
    Navigator.pop(context);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameEditController.dispose();
    descriptionEditController.dispose();
    venueEditController.dispose();
    eventDateEditController.dispose();
    eventTimeEditController.dispose();
    deadlineEditController.dispose();
    teamSizeEditController.dispose();
    totalTeamEditController.dispose();
    durationEditController.dispose();
    prizeEditController.dispose();
    linkEditController.dispose();
    levelEditController.dispose();
    statusEditController.dispose();
    registeredEditController.dispose();
    eventDate = null;
    deadline = null;
  }

  @override
  Widget build(BuildContext context) {
    final _url = Uri.parse(widget.hackathon.link);
    Future<void> _launchUrl() async {
      if (!await launchUrl(_url)) {
        throw Exception('Could not launch $_url');
      }
    }
    final user = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.black,
            leading: IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)),
            actions: user!.role == "admin" ? [
              IconButton(onPressed: (){
                showDialog(context: context, builder: (context){
                  return AlertDialogWarning(
                    title: Text("Hackathon Delete",style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),),
                    content: Text("Are you sure you want to delete this hackathon?",style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w400
                    ),
                    ),
                    onSave: ()async{
                      showDialog(context: context, builder: (context){
                        return Center(child: CircularProgressIndicator(color: Colors.white,),);
                      });
                      await AdminController().deleteHackathon(hackathonId: widget.hackathon.id, context: context, ref: ref);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  );
                });
              },icon: Icon(Icons.delete,color: Colors.red,)
              ),
              IconButton(
                icon: Icon(
                  isEditing ? Icons.check : Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () async{
                  if (isEditing) {
                    await updateHackathon();
                  } else {
                    setState(() => isEditing = true);
                  }
                },
              )
            ] : [],
            flexibleSpace: FlexibleSpaceBar(
              title: isEditing ? TextField(
                controller: nameEditController,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colors.white54),
              ) : Text(
                widget.hackathon.name,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colors.white54),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  pickedImage != null ? Image.file(File(pickedImage!.path)) : Image.network(widget.hackathon.url, fit: BoxFit.cover),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black, Colors.transparent],
                      ),
                    ),
                  ),
                  if(isEditing)
                    Center(
                      child: IconButton(onPressed:pickImage, icon: Icon(Icons.image_rounded,color: Colors.white70,size: 40,)),
                    )
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GlassStats(hackathon: widget.hackathon),

                  const SizedBox(height: 28),

                  Text('About the Hackathon',
                      style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  const SizedBox(height: 10),
                  isEditing ? TextField(
                    controller: descriptionEditController,
                    maxLines: null,
                    style: GoogleFonts.inter(
                        color: Colors.white70, height: 1.6
                    ),
                  ) : Text(widget.hackathon.description,
                      style: GoogleFonts.inter(
                          color: Colors.white70, height: 1.6)),

                  const SizedBox(height: 32),

                  InfoTile(icon: Icons.calendar_today, label: 'Date', value: widget.hackathon.eventdate.toString().split("T")[0],isDate: true,controller: eventDateEditController,isDeadline: false),
                  InfoTile(icon: Icons.calendar_today, label: 'Deadline', value: widget.hackathon.deadline.toString().split("T")[0],isDate: false,controller: deadlineEditController,isDeadline: true),
                  InfoTile(icon: Icons.access_time, label: 'Time', value: widget.hackathon.eventTime,controller: eventTimeEditController,isDate: false,isDeadline: false),
                  InfoTile(icon: Icons.location_on, label: 'Venue', value: widget.hackathon.venue,controller: venueEditController,isDate: false,isDeadline: false),

                  const SizedBox(height: 36),


                  isEditing ? SizedBox() : Center(child: appButton(onPressed: _launchUrl, text: "Register Now",context: context))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _GlassStats({required Hackathon hackathon}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.12),
            Colors.white.withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _GlassStatItem(
              icon: Icons.emoji_events,
              label: 'Prize',
              controller: prizeEditController,
              value: '₹${hackathon.prize}',
            ),
          ),
          Expanded(
            child: _GlassStatItem(
              icon: Icons.groups,
              controller: totalTeamEditController ,
              label: 'Teams',
              value: '${hackathon.totalTeam}',
            ),
          ),
          Expanded(
            child: _GlassStatItem(
              icon: Icons.person,
              label: 'Team Size',
              controller: teamSizeEditController,
              value: '${hackathon.teamsize}',
            ),
          ),
          Expanded(
            child: _GlassStatItem(
              icon: Icons.trending_up,
              controller: levelEditController,
              label: 'Level',
              value: hackathon.level,
            ),
          ),
        ],
      ),
    );
  }
  Widget _GlassStatItem({required IconData icon, required String label, required String value,required TextEditingController controller}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF6366F1).withOpacity(0.18),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 10),
        isEditing ? SizedBox(
          width: 60,
          child: TextField(
            controller: controller,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            )
          ),
        ) : Text(
          value,
          maxLines: 1,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 1,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.white60,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget InfoTile({
    required IconData icon,
    required String label,
    required String value,
    required TextEditingController controller,
    required isDate,
    required isDeadline
}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54, size: 20),
          const SizedBox(width: 12),
          Text('$label: ', style: GoogleFonts.inter(color: Colors.white60)),
          isEditing && isDate ? ElevatedButton(
            onPressed: () => pickDate(true),
            child: Text(eventDate == null
                ? "Event Date"
                : eventDate!.toString().split(" ")[0]),
          ) : isEditing && isDeadline ? ElevatedButton(
            onPressed: () => pickDate(false),
            child: Text(deadline == null
                ? "Deadline"
                : deadline!.toString().split(" ")[0]),
          ) : isEditing && !isDate && !isDeadline ? Expanded(
            child: TextField(
              controller: controller,
              maxLines: null,
              style: GoogleFonts.inter(color: Colors.white),
            ),
          ) : Expanded(child: Text(value, style: GoogleFonts.inter(color: Colors.white))),
        ],
      ),
    );
  }

  Future<void> pickDate(bool isEvent) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      setState(() {
        isEvent ? eventDate = date : deadline = date;
      });
    }
  }



}



