import 'dart:convert';
import 'dart:io';
import 'package:codingera2/controllers/admin_controller.dart';
import 'package:codingera2/models/user.dart';
import 'package:codingera2/provider/Admin_Provider/community_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AdminClub extends ConsumerStatefulWidget {
  const AdminClub({super.key});

  @override
  ConsumerState<AdminClub> createState() => _AdminClubState();
}

class _AdminClubState extends ConsumerState<AdminClub> {

  final _formKey = GlobalKey<FormState>();
  User? selectedLeader;
  User? selectedManager;
  final clubNameCtrl = TextEditingController();
  final techNameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final detailDescCtrl = TextEditingController();
  final leaderIdCtrl = TextEditingController();
  final managerIdCtrl = TextEditingController();
  final joinLinkCtrl = TextEditingController();

  List<TextEditingController> ruleCtrls = [];
  List<TextEditingController> activityCtrls = [];
  XFile? pickedImage;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    addRule();
    addActivity();
  }

  void addRule() => ruleCtrls.add(TextEditingController());
  void addActivity() => activityCtrls.add(TextEditingController());

  Future<void> uploadClub() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final body = {
      "clubname": clubNameCtrl.text.trim(),
      "techname": techNameCtrl.text.trim(),
      "desc": descCtrl.text.trim(),
      "detailDesc": detailDescCtrl.text.trim(),
      "clubLeader": leaderIdCtrl.text.trim(),
      "clubManager": managerIdCtrl.text.trim(),
      "clubRule": ruleCtrls.map((e) => e.text.trim()).toList(),
      "clubActivities": activityCtrls.map((e) => e.text.trim()).toList(),
      "joinLink": joinLinkCtrl.text.trim(),
    };
    
    await AdminController().uploadClub(clubname: clubNameCtrl.text,ref: ref ,techname: techNameCtrl.text, desc: descCtrl.text, clubLeader: selectedLeader!.id, clubManager: selectedManager!.id, clubRule: ruleCtrls.map((e) => e.text.trim()).toList(),clubActivities: activityCtrls.map((e) => e.text.trim()).toList(), image: pickedImage!, detailDesc: detailDescCtrl.text, joinLink: joinLinkCtrl.text, context: context);
    Navigator.pop(context);
    setState(() => loading = false);
  }
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => pickedImage = image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(communityProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Club")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: pickedImage == null
                      ? const Center(child: Text("Tap to select banner image"))
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(
                      File(pickedImage!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _field("Club Name", clubNameCtrl),
              _field("Tech Name", techNameCtrl),
              _field("Short Description", descCtrl),
              _field("Detailed Description", detailDescCtrl, max: 5),
              _dropDownMembers(members, (value){
                setState(() {
                  selectedLeader = value;
                });
              }, "Select Club Leader", "Club Leader"),
              _dropDownMembers(members, (value){
                setState(() {
                  selectedManager = value;
                });
              }, "Select Club Manager", "Club Manager"),

              const SizedBox(height: 20),
              _dynamicSection("Club Rules", ruleCtrls, addRule),
              const SizedBox(height: 20),
              _dynamicSection("Club Activities", activityCtrls, addActivity),
              _field("Join Link", joinLinkCtrl),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: loading ? null : uploadClub,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("UPLOAD CLUB"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {bool required = true, int max = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        maxLines: max,
        validator: required
            ? (v) => v == null || v.isEmpty ? "Required" : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _dynamicSection(
      String title,
      List<TextEditingController> ctrls,
      VoidCallback onAdd,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...ctrls.map((c) => _field(title, c)),
        TextButton.icon(
          onPressed: () => setState(onAdd),
          icon: const Icon(Icons.add),
          label: const Text("Add"),
        )
      ],
    );
  }

  Widget _dropDownMembers(List<User> members,Function(User?) onChanged,String text,String heading){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading,style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),),
          DropdownButtonFormField(
            hint: Text(text),
              items: members.map((m)=>DropdownMenuItem(
                value: m,
                  child: Text(m.fullname)
              )).toList(),
              onChanged:onChanged,
            validator: (v) => v == null ? "Required" : null,
          ),
        ],
      ),
    );

  }

}
