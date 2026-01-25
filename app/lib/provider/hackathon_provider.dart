import 'package:codingera2/controllers/hackathon_controller.dart';
import 'package:codingera2/models/hackathon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HackathonProvider extends StateNotifier<List<Hackathon>>{
  HackathonProvider():super([]);
  bool _fetched = false;
  void loadHackathon()async {
    if(_fetched) return;
    state = await HackathonController().loadHackathon();
    _fetched = true;
  }

}

final hackathonProvider = StateNotifierProvider<HackathonProvider,List<Hackathon>>((ref)=>HackathonProvider());