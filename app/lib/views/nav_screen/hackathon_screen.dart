import 'package:codingera2/provider/hackathon_provider.dart';
import 'package:codingera2/views/widgets/modern_hackathon_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HackathonScreen extends ConsumerStatefulWidget {
  const HackathonScreen({super.key});

  @override
  ConsumerState<HackathonScreen> createState() => _HackathonScreenState();
}

class _HackathonScreenState extends ConsumerState<HackathonScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(hackathonProvider.notifier).loadHackathon();
  }


  @override
  Widget build(BuildContext context) {
    final hackathons = ref.watch(hackathonProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: ListView.builder(
          itemCount: hackathons.length,
            itemBuilder: (context,index){
            final hackathon = hackathons[index];
            print(hackathon.name);
              return  ModernHackathonTile(index: index,hackathon: hackathon,);
            }
        ),
      ),
    );
  }
}