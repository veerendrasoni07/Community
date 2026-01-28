import 'package:codingera2/controllers/club_controller.dart';
import 'package:codingera2/models/club.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClubProvider extends StateNotifier<AsyncValue<List<Club>>> {
  ClubProvider(): super(const AsyncValue.loading());

  Future<void> loadClub() async {
    try {
      final data = await ClubController().loadClub();
      print(data);
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final clubProvider = StateNotifierProvider<ClubProvider,AsyncValue<List<Club>>>((ref)=>ClubProvider());