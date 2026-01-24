import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../controllers/admin_controller.dart';


class AdminHackathon extends ConsumerStatefulWidget {
  const AdminHackathon({super.key});

  @override
  ConsumerState<AdminHackathon> createState() => _AdminHackathonState();
}

class _AdminHackathonState extends ConsumerState<AdminHackathon> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _description = TextEditingController();
  final _venue = TextEditingController();
  final _eventTime = TextEditingController();
  final _prize = TextEditingController();
  final _teamSize = TextEditingController();
  final _totalTeam = TextEditingController();
  final _level = TextEditingController();
  final _link = TextEditingController();
  final _duration = TextEditingController();

  DateTime? eventDate;
  DateTime? deadline;
  XFile? pickedImage;

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

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => pickedImage = image);
    }
  }

  void submit() async {
    if (!_formKey.currentState!.validate() ||
        eventDate == null ||
        deadline == null ||
        pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    await AdminController().uploadHackathon(
      name: _name.text.trim(),
      description: _description.text.trim(),
      venue: _venue.text.trim(),
      eventDate: eventDate!,
      deadline: deadline!,
      teamSize: int.parse(_teamSize.text),
      totalTeam: int.parse(_totalTeam.text),
      eventTime: _eventTime.text.trim(),
      link: _link.text.trim(),
      context: context,
      ref: ref,
      image: pickedImage!,
      level: _level.text.trim(),
      prize: int.parse(_prize.text),
      duration: _duration.text.trim(),
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Hackathon Published")),
    );
  }

  Widget input(String label, TextEditingController c,
      {TextInputType? type}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        keyboardType: type,
        validator: (v) => v!.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Hackathon")),
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
              input("Hackathon Name", _name),
              input("Description", _description),
              input("Venue", _venue),
              input("Event Time", _eventTime),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => pickDate(true),
                      child: Text(eventDate == null
                          ? "Event Date"
                          : eventDate!.toString().split(" ")[0]),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => pickDate(false),
                      child: Text(deadline == null
                          ? "Deadline"
                          : deadline!.toString().split(" ")[0]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              input("Prize", _prize, type: TextInputType.number),
              input("Team Size", _teamSize, type: TextInputType.number),
              input("Total Teams", _totalTeam, type: TextInputType.number),
              input("Level", _level),
              input("Duration", _duration),
              input("Registration Link", _link),
              const SizedBox(height: 30),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submit,
                  child: const Text("Publish Hackathon"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
