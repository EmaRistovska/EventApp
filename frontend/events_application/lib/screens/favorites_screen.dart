import 'package:flutter/material.dart';
import '../models/favorite_events.dart';
import 'details_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}


class _FavoritesScreenState extends State<FavoritesScreen> {

  @override
  Widget build(BuildContext context) {
    final favorites = FavoriteEvents.favorites;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text(
          "Омилени настани",
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
      body: favorites.isEmpty
          ? Center(
              child: Text(
                "Немате омилени настани",
                style: GoogleFonts.raleway(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final event = favorites[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailsScreen(event: event),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: Stack(
                        children: [
                          /// ================= MAIN CARD CONTENT =================
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// TITLE
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  event.title,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.raleway(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey[700],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              const SizedBox(height: 14),

                              /// IMAGE + INFO
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      event.imageUrl,
                                      width: 120,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              width: 120,
                                              height: 100,
                                              color: Colors.grey.shade300,
                                              child: const Icon(Icons.image),
                                            );
                                          },
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_today,
                                              size: 16,
                                              color: Colors.blueGrey,
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                event.date,
                                                style: GoogleFonts.raleway(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 10),

                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              size: 16,
                                              color: Colors.blueGrey,
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                event.location,
                                                style: GoogleFonts.raleway(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          Positioned(
                            bottom: -2,
                            right: -2,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  FavoriteEvents.toggleFavorite(event);
                                });
                              },
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
