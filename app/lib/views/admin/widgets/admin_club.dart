import 'package:flutter/material.dart';

class AdminClub extends StatefulWidget {
  const AdminClub({super.key});

  @override
  State<AdminClub> createState() => _AdminClubState();
}

class _AdminClubState extends State<AdminClub> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Text("Admin Club"),
      ),
    );
  }
}
