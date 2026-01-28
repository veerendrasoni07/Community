import 'package:codingera2/controllers/admin_controller.dart';
import 'package:codingera2/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityProvider extends StateNotifier<AsyncValue<List<User>>>{
  CommunityProvider() : super(const AsyncValue.loading());



  Future<void> addCommunityMember({required BuildContext context,required WidgetRef ref}) async {
    final List<User> members = await AdminController().getAllMembersOfCommunity(context: context, ref: ref);
    state = AsyncValue.data(members);
  }



}

final communityProvider = StateNotifierProvider<CommunityProvider,AsyncValue<List<User>>>((ref) => CommunityProvider());