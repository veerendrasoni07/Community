import 'package:codingera2/controllers/auth_controller.dart';
import 'package:codingera2/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class UpdateProfileSheet extends ConsumerStatefulWidget {
  const UpdateProfileSheet({super.key});

  @override
  ConsumerState<UpdateProfileSheet> createState() =>
      _UpdateProfileSheetState();
}

class _UpdateProfileSheetState extends ConsumerState<UpdateProfileSheet> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _semController = TextEditingController();
  final _localityController = TextEditingController();
  final _laptopController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    _nameController.text = user?.fullname ?? '';
    _phoneController.text = user?.phone.toString() ?? '';
    _semController.text = user?.currentSemester.toString() ?? '';
    _localityController.text = user?.location ?? '';
    _laptopController.text = user?.laptop ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _semController.dispose();
    _localityController.dispose();
    _laptopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.98,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),

          /// Drag Handle
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white38,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Edit Profile",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _input("Full Name", _nameController,TextInputType.name),
                  _input("Phone", _phoneController,TextInputType.phone),
                  _input("Current Semester", _semController,TextInputType.number),
                  _input("Locality", _localityController,TextInputType.name),
                  _input("Laptop Name", _laptopController,TextInputType.name),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () async {
                        // TODO: connect API
                        showDialog(context: context, builder: (context){
                          return Center(child: CircularProgressIndicator(color: Colors.blue.shade900,),);
                        });
                        await AuthController().updateUserProfile(fullname: _nameController.text, phone: int.parse(_phoneController.text), laptop: _laptopController.text, location: _localityController.text, currentSemester: int.parse(_semController.text), ref: ref, context: context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Update Profile",
                        style: TextStyle(fontSize: 18,color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(String label, TextEditingController controller,TextInputType type) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.blueAccent.shade700,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
