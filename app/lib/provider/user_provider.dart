import 'package:codingera2/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProvider extends StateNotifier<User?> {
  UserProvider()
    : super(null);

  User? get user => state;

  void setUser(String userJson) {
    state = User.fromJson(userJson);
  }


  void recreateUserState({
    required String fullname,
    required String newstate,
    required String city,
    required String locality,
    required String hobbies,
    required String laptopname,
}){
    if(state != null){
      state = User(
          id: this.state!.id,
          fullname: fullname,
          email: this.state!.email,
          profilePic: this.state!.profilePic,
          gender: this.state!.gender,
          bio: this.state!.bio,
          phone: this.state!.phone,
          username: this.state!.username,
          isOnline: this.state!.isOnline,
          createdAt: this.state!.createdAt,
          location: this.state!.location,
          connections: this.state!.connections,
          token: this.state!.token
      );
    }
  }



  void signOut() {
    state = null;
  }


}

final userProvider = StateNotifierProvider<UserProvider, User?>(
  (ref) => UserProvider(),
);
