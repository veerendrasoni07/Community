import 'package:codingera2/models/user.dart';
import 'package:codingera2/provider/clubProvider.dart';
import 'package:codingera2/views/widgets/modern_club_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClubScreen extends ConsumerStatefulWidget {
  const ClubScreen({super.key});

  @override
  ConsumerState<ClubScreen> createState() => _ClubScreenState();
}

class _ClubScreenState extends ConsumerState<ClubScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(clubProvider.notifier).loadClub();
  }


  @override
  Widget build(BuildContext context) {
    final clubs = ref.watch(clubProvider);
    return  Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: ListView.builder(
            itemCount: clubs.length,
            itemBuilder: (context,index){
              final club = clubs[index];
              print(club.clubname);
              return  ModernClubTile(index: index,club: club,);
            }
        ),
      ),
    );
  }
}