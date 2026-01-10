// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import 'provider/auth_manager_provider.dart';
// import 'views/screens/authentication/login_screen.dart';
// import 'views/screens/authentication/onboarding_screen.dart';
// import 'views/screens/main_screen.dart';
//
// class AppRoot extends ConsumerWidget {
//   const AppRoot({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authState = ref.watch(authManagerProvider);
//
//     debugPrint("🧠 AppRoot authState = $authState");
//
//     switch (authState) {
//       case AuthStatus.loading:
//         return const Scaffold(
//           body: Center(child: CircularProgressIndicator()),
//         );
//
//       case AuthStatus.onboarding:
//         return OnboardingScreen();
//
//       case AuthStatus.unauthenticated:
//         return const LoginScreen();
//
//       case AuthStatus.authenticated:
//         return MainScreen(); // ❌ NOT const
//     }
//   }
// }
