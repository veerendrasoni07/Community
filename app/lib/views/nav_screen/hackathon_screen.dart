import 'package:codingera2/views/widgets/hackathon_widget.dart';
import 'package:codingera2/views/widgets/modern_hackathon_tile.dart';
import 'package:flutter/material.dart';

class HackathonScreen extends StatefulWidget {
  const HackathonScreen({super.key});

  @override
  State<HackathonScreen> createState() => _HackathonScreenState();
}

class _HackathonScreenState extends State<HackathonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: ListView.builder(
          itemCount: 10,
            itemBuilder: (context,index){
              return  ModernHackathonTile(index: index,);
            }
        ),
      ),
    );
  }
}