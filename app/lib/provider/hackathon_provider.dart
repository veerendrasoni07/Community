import 'package:codingera2/controllers/hackathon_controller.dart';
import 'package:codingera2/models/hackathon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HackathonProvider extends StateNotifier<AsyncValue<List<Hackathon>>>{
  HackathonProvider():super(const AsyncValue.loading());
 // bool _fetched = false;
  Future<void> loadHackathon()async {
  //  if(_fetched) return;
    final data = await HackathonController().loadHackathon();
    state = AsyncValue.data(data);
   // _fetched = true;
  }


  void deleteHackathon(String hackathonId){
    state = state.whenData((data){
      final index = data.indexWhere((hackathon) => hackathon.id == hackathonId);
      if(index != -1){
        data.removeAt(index);
      }
      return data;
    });
  }
  void updateHackathon(Hackathon hackathon){
    state = state.whenData((data){
      final index = data.indexWhere((element) => element.id == hackathon.id);
      if(index != -1){
        data[index] = hackathon;
      }
      return data;
    });
  }

}

final hackathonProvider = StateNotifierProvider<HackathonProvider,AsyncValue<List<Hackathon>>>((ref)=>HackathonProvider());