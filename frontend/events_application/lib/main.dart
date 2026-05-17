import 'package:events_application/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: false,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {

  bool? isLoggedIn;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {

    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    bool logged =
        prefs.getBool("isLoggedIn") ?? false;

    setState(() {
      isLoggedIn = logged;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (isLoggedIn == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (isLoggedIn!) {
      return const MainScreen();
    }

    return const LoginScreen();
  }
}
