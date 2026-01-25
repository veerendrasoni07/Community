import 'package:codingera2/controllers/club_controller.dart';
import 'package:codingera2/models/club.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClubProvider extends StateNotifier<List<Club>>{
  ClubProvider():super([]);
  bool _fetched = false;
  void loadClub()async {
    if(_fetched) return;
    state = await ClubController().loadClub();
    _fetched = true;
  }

}
final clubProvider = StateNotifierProvider<ClubProvider,List<Club>>((ref)=>ClubProvider());