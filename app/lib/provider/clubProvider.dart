

import 'package:codingera2/controllers/admin_controller.dart';
import 'package:codingera2/controllers/club_controller.dart';
import 'package:codingera2/models/club.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClubProvider extends StateNotifier<List<Club>>{
  ClubProvider():super([]);

  void loadClub()async {
    state = await ClubController().loadClub();
  }

}
final clubProvider = StateNotifierProvider<ClubProvider,List<Club>>((ref)=>ClubProvider());