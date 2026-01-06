import 'package:codingera2/controllers/auth_controller.dart';
import 'package:codingera2/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateProfile extends ConsumerStatefulWidget {


  UpdateProfile({super.key});

  @override
  ConsumerState<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends ConsumerState<UpdateProfile> {

  
  final AuthController _authController = AuthController();

 final TextEditingController _nameController = TextEditingController();

 final TextEditingController _stateController = TextEditingController();

 final TextEditingController _cityController = TextEditingController();

 final TextEditingController _localityController = TextEditingController();

 final TextEditingController _hobbiesController = TextEditingController();

 final TextEditingController _laptopController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    _nameController.text = user?.fullname ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _localityController.dispose();
    _hobbiesController.dispose();
    _laptopController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    
    final updateUser = ref.read(userProvider.notifier);
    
    return AlertDialog(
      elevation: 20,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text("Edit Profile",style: TextStyle(fontSize: 36,fontWeight: FontWeight.bold,color: Colors.white),),
            const SizedBox(height: 20,),
            SizedBox(height: 20,),
            TextField(
              controller: _nameController,
              style: TextStyle(
                  color: Colors.white
              ),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                label: Text("Name"),
                  labelStyle: TextStyle(color: Colors.white),
                  contentPadding: EdgeInsets.all(10),
                  fillColor: Colors.blueAccent[700],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabled: true,
                  hintText: "Enter Name Here.",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  )
              ),
            ),
            const SizedBox(height: 20,),
            TextField(
              controller: _stateController,
              style: TextStyle(
                  color: Colors.white,
              ),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                  label: Text("State"),
                  labelStyle: TextStyle(color: Colors.white),
                  contentPadding: EdgeInsets.all(10),
                  fillColor: Colors.blueAccent[700],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabled: true,
                  hintText: "Enter State Here.",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  )
              ),
            ),
            const SizedBox(height: 20,),
            TextField(
              controller: _cityController,
              style: TextStyle(
                  color: Colors.white
              ),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                  label: Text("City"),
                  labelStyle: TextStyle(color: Colors.white),
                  contentPadding: EdgeInsets.all(10),
                  fillColor: Colors.blueAccent[700],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabled: true,
                  hintText: "Enter City Here.",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  )
              ),
            ),
            const SizedBox(height: 20,),
            TextField(
              controller: _localityController,
              style: TextStyle(
                  color: Colors.white
              ),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                  label: Text("Locality"),
                  labelStyle: TextStyle(color: Colors.white),
                  contentPadding: EdgeInsets.all(10),
                  fillColor: Colors.blueAccent[700],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabled: true,
                  hintText: "Enter Locality Here.",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  )
              ),
            ),
            const SizedBox(height: 20,),
            TextField(
              style: TextStyle(
                  color: Colors.white
              ),
              cursorColor: Colors.white,
              controller: _hobbiesController,
              decoration: InputDecoration(
                  label: Text("Hobbies"),
                  labelStyle: TextStyle(color: Colors.white),
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.blueAccent[700],
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black87),
                  borderRadius: BorderRadius.circular(10),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black87),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabled: true,
                  hintText: "Enter Hobbies Here.",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  )
              ),
            ),
            const SizedBox(height: 20,),
            TextField(
              style: TextStyle(
                  color: Colors.white
              ),
              cursorColor: Colors.white,
              controller: _laptopController,
              decoration: InputDecoration(
                  label: Text("Laptop Name"),
                  labelStyle: TextStyle(color: Colors.white),
                  contentPadding: EdgeInsets.all(10),

                  fillColor: Colors.blueAccent[700],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabled: true,
                  hintText: "Enter Laptop Name Here.",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  )
              ),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(onPressed: ()async{
              Center(child: CircularProgressIndicator(),);
              // await _authController.updateUserDetails(
              //     context: context,
              //     id: ref.read(userProvider)!.id,
              //     fullname: _nameController.text,
              //     state: _stateController.text,
              //     city: _cityController.text,
              //     locality: _localityController.text,
              //     hobbies: _hobbiesController.text,
              //     laptopname: _laptopController.text).whenComplete((){
              //       updateUser.recreateUserState(
              //           fullname: _nameController.text,
              //           newstate: _stateController.text,
              //           city: _cityController.text,
              //           locality: _localityController.text,
              //           hobbies: _hobbiesController.text,
              //           laptopname: _laptopController.text
              //       );
              // });
              // Navigator.pop(context);
            }, child: Text("Update"))

          ],
        ),
      ),
    );
  }
}
