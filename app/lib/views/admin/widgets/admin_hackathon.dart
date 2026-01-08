import 'package:flutter/material.dart';

class AdminHackathon extends StatefulWidget {
  const AdminHackathon({super.key});

  @override
  State<AdminHackathon> createState() => _AdminHackathonState();
}

class _AdminHackathonState extends State<AdminHackathon> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Text("Admin Hackathon"),
      ),
    );
  }
}
