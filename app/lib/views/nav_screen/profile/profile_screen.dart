import 'package:codingera2/components/alert_dialog_warning.dart';
import 'package:codingera2/controllers/auth_controller.dart';
import 'package:codingera2/provider/auth_manager_provider.dart';
import 'package:codingera2/provider/user_provider.dart';
import 'package:codingera2/views/nav_screen/profile/info_container.dart';
import 'package:codingera2/views/nav_screen/profile/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    print(user);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Profile",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.signOut,color: Colors.white,),
            onPressed: () =>showDialog(context: context, builder: (context){
              return AlertDialogWarning(title: Text("Logout Warning"), content: Text("Do you really want to logout?"), onSave: (){
                  ref.read(authManagerProvider.notifier).logout(context);

              });
            })
          )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: user == null
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.blueAccent.shade700,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Text(
                        user.fullname[0].toUpperCase(),
                        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      user.fullname,
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.email ?? "No email",
                      style: const TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const UpdateProfileSheet(),
                  );
                },
                child: const Text("Edit Profile"),
              )
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text("Your Information",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white70,)),
              ),
              const SizedBox(height: 20),
              InfoContainer(icon: FontAwesomeIcons.locationPin, title: "Username", subtitle: user.username),
              const SizedBox(height: 20),
              InfoContainer(icon: FontAwesomeIcons.city, title: "Address", subtitle: user.location),
              const SizedBox(height: 20),
              InfoContainer(icon: FontAwesomeIcons.locationDot, title: "Phone", subtitle: user.phone.toString()),
              const SizedBox(height: 20),
              InfoContainer(icon: FontAwesomeIcons.solidHeart, title: "Address", subtitle: user.location),
              const SizedBox(height: 20),
              InfoContainer(icon: FontAwesomeIcons.laptopCode, title: "Laptop Name", subtitle: user.laptop),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
