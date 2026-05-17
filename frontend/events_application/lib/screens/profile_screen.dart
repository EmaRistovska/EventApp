import 'dart:io';
import 'package:events_application/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  String name = "Корисник";
  String email = "user@email.com";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString("name") ?? "Корисник";
      email = prefs.getString("email") ?? "user@email.com";
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blueGrey),
              title: Text("Камера", style: GoogleFonts.raleway()),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blueGrey),
              title: Text("Галерија", style: GoogleFonts.raleway()),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => SplashScreen()),
      (route) => false,
    );
  }

  void _showAboutApp() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: Center(
            child: Text(
              "За НастаниМк",
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
          ),

          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Text(
                "НастаниМК ти помага да ги откриеш најдобрите настани низ Македонија. "
                    "Од концерти и фестивали до спортски случувања — сè е организирано на едно место. "
                    "Зачувај омилени, следи што те интересира и купи билети брзо и едноставно.",
                textAlign: TextAlign.justify,
                style: GoogleFonts.raleway(fontSize: 14, color: Colors.black87),
              ),
            ),
          ),

          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Close",
                  style: GoogleFonts.raleway(
                    color: const Color(0xFFFDF5E6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editProfile() {
    final nameController = TextEditingController(text: name);
    final emailController = TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.all(20),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),

          title: Center(
            child: Text(
              "Edit Profile",
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blueGrey[800],
              ),
            ),
          ),

          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Име и презиме",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Откажи",
                style: GoogleFonts.raleway(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              onPressed: () async {
                SharedPreferences prefs =
                await SharedPreferences.getInstance();

                await prefs.setString("name", nameController.text);
                await prefs.setString("email", emailController.text);

                setState(() {
                  name = nameController.text;
                  email = emailController.text;
                });

                Navigator.pop(context);
              },

              child: Text(
                "Зачувај",
                style: GoogleFonts.raleway(
                  color: const Color(0xFFFDF5E6),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOption(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blueGrey),
            const SizedBox(width: 15),
            Text(
              title,
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[700],
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text(
          "Профил",
          style: GoogleFonts.raleway(
            color: Color(0xFFFDF5E6),
            fontWeight: FontWeight.bold,
            fontSize: 23,
            shadows: [
              Shadow(
                offset: Offset(1, 5),
                blurRadius: 8,
                color: Colors.black26,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 58,
                  backgroundColor: Colors.blueGrey,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? const Icon(Icons.person, size: 65, color: Colors.white)
                      : null,
                ),

                Positioned(
                  bottom: 4,
                  right: 2,
                  child: GestureDetector(
                    onTap: _showImageOptions,
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.teal,
                      child: Icon(
                        Icons.camera_alt,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 4,
                  left: 2,
                  child: GestureDetector(
                    onTap: _editProfile,
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.orangeAccent,
                      child: Icon(Icons.edit, size: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              name,
              style: GoogleFonts.raleway(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              email,
              style: GoogleFonts.raleway(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            _buildOption(Icons.info_outline, "За апликацијата", _showAboutApp),
            _buildOption(Icons.logout, "Logout", logout),
          ],
        ),
      ),
    );
  }
}
