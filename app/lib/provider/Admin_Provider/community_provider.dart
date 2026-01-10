import 'package:codingera2/controllers/admin_controller.dart';
import 'package:codingera2/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityProvider extends StateNotifier<List<User>>{
  CommunityProvider() : super([]);



  Future<void> addCommunityMember() async {
    final List<User> members = await AdminController().getAllMembersOfCommunity();
    state = members;
  }



}

final communityProvider = StateNotifierProvider<CommunityProvider, List<User>>((ref) => CommunityProvider());