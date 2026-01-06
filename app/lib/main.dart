
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:codingera2/provider/auth_manager_provider.dart';
import 'package:codingera2/provider/user_provider.dart';
import 'package:codingera2/views/screens/authentication/login_screen.dart';
import 'package:codingera2/views/screens/authentication/onboarding_screen.dart';
import 'package:codingera2/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() {
  // Run the flutter app wrapped in a ProviderScope for managing state.
  runApp(ProviderScope(child: const MyApp()));
}



// Changing root stateless widget of the application to the consumer widget to consume state chnages
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          primary: const Color.fromARGB(255, 3, 53, 134),
          seedColor: const Color.fromARGB(
            255,
            3,
            53,
            134,
          ), // or any primary color
          brightness: Brightness.light,
        ),
        useMaterial3: true, // optional if you're using Material 3
      ),
      home:  ref.watch(authManagerProvider) == AuthStatus.authenticated ? const MainScreen() :  OnboardingScreen() ,
      
      
      
      
      // FutureBuilder(
      //   future: _checkTokenAndSetUser(ref),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     }
      //     final user = ref.watch(userProvider);
      //     return user != null
      //         ? AnimatedSplashScreen(
      //           splash: Center(
      //             child: ClipRRect(
      //               borderRadius: BorderRadius.circular(20),
      //               child: Image.asset(
      //                 "assets/images/coding era logo.jpg",
      //                 fit: BoxFit.fill,
      //               ),
      //             ),
      //           ),
      //           nextScreen: MainScreen(),
      //           splashIconSize: 200,
      //           duration: 3000,
      //           backgroundColor: Theme.of(context).colorScheme.primary,
      //         )
      //         : AnimatedSplashScreen(
      //           splash: Center(
      //             child: ClipRRect(
      //               borderRadius: BorderRadius.circular(20),
      //               child: Image.asset(
      //                 "assets/images/coding era logo.jpg",
      //                 fit: BoxFit.fill,
      //               ),
      //             ),
      //           ),
      //           nextScreen: OnboardingScreen(),
      //           splashIconSize: 200,
      //           duration: 3000,
      //           backgroundColor: Theme.of(context).colorScheme.primary,
      //         );
      //   },
      // ),
    );
  }
}
