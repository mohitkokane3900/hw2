import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_redirect.dart';
import 'screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const HW2App());
}

class HW2App extends StatelessWidget {
  const HW2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context) => const LoginScreen(),
        '/redirect': (context) => const HomeRedirect(),
        '/register': (context) => const RegisterScreen(),
      },
      home: const SplashScreen(),
    );
  }
}
