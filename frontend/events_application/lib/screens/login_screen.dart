import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen.dart';
import 'register_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool("isLoggedIn", true);
    await prefs.setString("email", emailController.text);
    await prefs.setString(
      "name",
      emailController.text.split("@")[0],
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  Widget buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.raleway(fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.raleway(
          color: Colors.grey,
        ),
        prefixIcon: Icon(icon, color: Colors.blueGrey),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Colors.blueGrey,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.blueGrey[50],

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 40, bottom: 40),
                decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [

                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "Најава",
                      style: GoogleFonts.raleway(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFDF5E6),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Најави се за да продолжиш",
                      style: GoogleFonts.raleway(
                        fontSize: 15,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// FORM
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [

                    buildField(
                      controller: emailController,
                      hint: "Email адреса",
                      icon: Icons.email_outlined,
                    ),

                    const SizedBox(height: 12),

                    buildField(
                      controller: passwordController,
                      hint: "Лозинка",
                      icon: Icons.lock_outline,
                      obscure: true,
                    ),

                    const SizedBox(height: 8),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Заборавена лозинка?",
                          style: GoogleFonts.raleway(
                            color: Colors.blueGrey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Text(
                          "Најави се",
                          style: GoogleFonts.raleway(
                            color: const Color(0xFFFDF5E6),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Немаш профил?",
                          style: GoogleFonts.raleway(
                            color: Colors.blueGrey[400],
                            fontSize: 13,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Регистрирај се",
                            style: GoogleFonts.raleway(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}