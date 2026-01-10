import 'package:codingera2/controllers/hackathon_controller.dart';
import 'package:codingera2/models/hackathon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HackathonProvider extends StateNotifier<List<Hackathon>>{
  HackathonProvider():super([]);

  void loadHackathon()async {
    state = await HackathonController().loadHackathon();
  }

}

final hackathonProvider = StateNotifierProvider<HackathonProvider,List<Hackathon>>((ref)=>HackathonProvider());