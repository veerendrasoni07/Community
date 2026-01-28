import 'package:codingera2/controllers/club_controller.dart';
import 'package:codingera2/models/club.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClubProvider extends StateNotifier<AsyncValue<List<Club>>>{
  ClubProvider():super(const AsyncValue.loading());
  // bool _fetched = false;
  Future<void> loadClub()async {
    // if(_fetched) return;
    final data = await ClubController().loadClub();
    state = AsyncValue.data(data);
    // _fetched = true;
  }

}
final clubProvider = StateNotifierProvider<ClubProvider,AsyncValue<List<Club>>>((ref)=>ClubProvider());