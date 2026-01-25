import 'package:codingera2/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProvider extends StateNotifier<User?> {
  UserProvider()
    : super(null);

  User? get user => state;

  void setUser(String userJson) {
    state = User.fromJson(userJson);
  }






  void signOut() {
    state = null;
  }


}

final userProvider = StateNotifierProvider<UserProvider, User?>(
  (ref) => UserProvider(),
);
