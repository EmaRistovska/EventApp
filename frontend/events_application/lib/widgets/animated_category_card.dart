import 'package:flutter/material.dart';
import 'package:events_application/screens/event_list_screen.dart';

class AnimatedCategoryCard extends StatefulWidget {

  final Map<String, dynamic> category;
  final Color color;

  const AnimatedCategoryCard({required this.category, required this.color});

  @override
  State<AnimatedCategoryCard> createState() => _AnimatedCategoryCardState();
}

class _AnimatedCategoryCardState extends State<AnimatedCategoryCard> {

  double scale = 1.0;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTapDown: (_) {
        setState(() => scale = 0.93);
      },

      onTapUp: (_) {
        setState(() => scale = 1.0);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventListScreen(
              genre: widget.category["genre"],
              title: widget.category["title"],
            ),
          ),
        );
      },

      onTapCancel: () {
        setState(() => scale = 1.0);
      },

      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: scale,

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                widget.color.withOpacity(0.8),
                widget.color,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              )
            ],
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.category["icon"],
                  size: 40,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  widget.category["title"],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}