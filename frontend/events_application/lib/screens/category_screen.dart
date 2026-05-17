import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'event_list_screen.dart';

class CategoryScreen extends StatefulWidget {
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> categories = [
    {"title": "Стенд Апови", "genre": "standup", "icon": Icons.mic},
    {"title": "Концерти", "genre": "concert", "icon": Icons.music_note},
    {"title": "Спортски настани", "genre": "sport", "icon": Icons.sports_soccer},
    {"title": "Театар", "genre": "theatre", "icon": Icons.theater_comedy},
    {"title": "Фестивали", "genre": "festival", "icon": Icons.festival},
    {"title": "Класична музика", "genre": "classical", "icon": Icons.music_note},
    {"title": "Останато", "genre": "other", "icon": Icons.music_note_outlined},
  ];

  final List<Color> pastelColors = [
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.amber.shade100,
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {

    final filteredCategories = categories.where((category) {
      final title = category["title"].toString().toLowerCase();
      return title.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text("Категории",
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
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Пребарај категорија...",
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),

            SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = filteredCategories[index];
                  final color = pastelColors[index % pastelColors.length];

                  return Card(
                    color: color,
                    elevation: 6,
                    shadowColor: Colors.black.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        color: Colors.white70,
                        width: 1.5,
                      ),
                    ),
                    margin: const EdgeInsets.only(bottom: 11),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventListScreen(
                              genre: category["genre"],
                              title: category["title"],
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              category["icon"],
                              color: Colors.blueGrey,
                              size: 26,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                category["title"],
                                style: GoogleFonts.raleway(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}