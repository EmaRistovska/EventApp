import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],

      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 40,
            ),

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),

              child: Column(
                children: [

                  const SizedBox(height: 20),

                  /// IMAGE
                  Image.asset(
                    "assets/images/event.png",
                    height: 230,
                  ),

                  /// TITLE
                  Text(
                    "Откриј настани низ цела Македонија",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// SUBTITLE
                  Text(
                    "Истражувај концерти, фестивали, спортски настани и многу повеќе — сè на едно место.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                      fontSize: 13,
                      height: 1.6,
                      color: Colors.blueGrey[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 110),

                  /// BUTTONS
                  Row(
                    children: [

                      /// LOGIN
                      Expanded(
                        child: SizedBox(
                          height: 50,

                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),

                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },

                            child: Text(
                              "Најава",
                              style: GoogleFonts.raleway(
                                color: const Color(0xFFFDF5E6),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      /// REGISTER
                      Expanded(
                        child: SizedBox(
                          height: 50,

                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.blueGrey,
                                width: 1.7,
                              ),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),

                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              );
                            },

                            child: Text(
                              "Регистрација",
                              style: GoogleFonts.raleway(
                                color: Colors.blueGrey,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}