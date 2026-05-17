import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/api_service.dart';
import 'details_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/favorite_events.dart';
import 'package:events_application/screens/favorites_screen.dart';


class EventListScreen extends StatelessWidget {
  final String genre;
  final String title;

  EventListScreen({
    required this.genre,
    required this.title,
  });

  final ApiService apiService = ApiService();

  Widget _buildBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
          title: Text(
              title,
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
        actions: [

          IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoritesScreen(),
                ),
              );

            },
          ),

          const SizedBox(width: 8),

        ],
      ),
      body: FutureBuilder<List<Event>>(
        future: apiService.getEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final allEvents = snapshot.data!;

            final events = allEvents
                .where((event) => event.genre == genre)
                .toList();

            if (events.isEmpty) {
              return Center(
                child: Text("Нема настани во оваа категорија"),
              );
            }

            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                            offset: Offset(0, 4),
                          )
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
                                      errorBuilder: (context, error, stackTrace) {
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_today,
                                                size: 16, color: Colors.blueGrey),
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
                                            const Icon(Icons.location_on,
                                                size: 16, color: Colors.blueGrey),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                event.location,
                                                style: GoogleFonts.raleway(
                                                  fontSize: 9.5,
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
                            bottom: -3,
                            right: -2,
                            child: GestureDetector(
                              onTap: () {
                                FavoriteEvents.toggleFavorite(event);
                                (context as Element).markNeedsBuild();
                              },
                              child: Icon(
                                FavoriteEvents.isFavorite(event)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
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
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error loading events"),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}