import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void register() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Лозинките не се совпаѓаат")),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool("isLoggedIn", true);
    await prefs.setString("name", nameController.text);
    await prefs.setString("email", emailController.text);

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
    return SizedBox(
      height: 55,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: GoogleFonts.raleway(fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.raleway(color: Colors.grey),
          prefixIcon: Icon(icon, color: Colors.blueGrey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20, bottom: 45),
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
                      child: const Icon(
                        Icons.person_add_alt_1,
                        size: 60,
                        color: Color(0xFFFDF5E6),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Регистрација",
                      style: GoogleFonts.raleway(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFDF5E6),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Креирај нов профил",
                      style: GoogleFonts.raleway(
                        fontSize: 15,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              /// FORM
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [

                    buildField(
                      controller: nameController,
                      hint: "Име и презиме",
                      icon: Icons.person,
                    ),

                    const SizedBox(height: 12),

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

                    const SizedBox(height: 12),

                    buildField(
                      controller: confirmPasswordController,
                      hint: "Потврди лозинка",
                      icon: Icons.lock,
                      obscure: true,
                    ),

                    const SizedBox(height: 20),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Text(
                          "Регистрирај се",
                          style: GoogleFonts.raleway(
                            color: const Color(0xFFFDF5E6),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(
                          "Веќе имаш профил?",
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
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Најави се",
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