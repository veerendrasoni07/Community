import 'package:codingera2/views/screens/authentication/login_screen.dart';
import 'package:codingera2/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_provider.dart';

enum AuthStatus {
  loading,
  unauthenticated,
  authenticated,
}

class AuthManager extends StateNotifier<AuthStatus> {
  final Ref ref;

  AuthManager(this.ref) : super(AuthStatus.loading) {
    init();
  }


  void init()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('refreshToken');
    String? user = preferences.getString('user');
    if(user != null) ref.read(userProvider.notifier).setUser(user);
    state = token == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
  }

  void setAuthenticated(){
    state = AuthStatus.authenticated;
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    ref.read(userProvider.notifier).signOut();

    state = AuthStatus.unauthenticated;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route)=>false);
  }
}

final authManagerProvider =
StateNotifierProvider<AuthManager, AuthStatus>(
        (ref) => AuthManager(ref));
