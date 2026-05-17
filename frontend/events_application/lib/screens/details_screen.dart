import 'package:flutter/material.dart';
import '../models/event.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';


class DetailsScreen extends StatefulWidget {
  final Event event;

  const DetailsScreen({super.key, required this.event});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _descriptionKey = GlobalKey();

  void _openBuyUrl() async {
    if (widget.event.buyUrl.isEmpty) return;

    final Uri url = Uri.parse(widget.event.buyUrl);

    await launchUrl(
      url,
      mode: LaunchMode.platformDefault,
    );
  }

  void _scrollToDescription() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.pixels + 440,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
            widget.event.title,
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
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// ================= FULL EVENT CARD =================
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFFDF5E6),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color: Color(0xFFFDF5E6),
                          width: 1.5
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          offset: const Offset(8, 15),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// IMAGE
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.40),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.network(
                                widget.event.imageUrl,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    color: Colors.grey.shade300,
                                    child: const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),

                        /// INFO PART
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                widget.event.title,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.raleway(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[700],
                                ),
                              ),
                              const SizedBox(height: 16),

                              /// DATE
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 20,
                                    color: Colors.teal,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.event.date,
                                    style: GoogleFonts.raleway(
                                        fontSize: 10,fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.blueGrey[700],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              /// LOCATION
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 20,
                                    color: Colors.teal,
                                  ),
                                  Text(
                                      widget.event.location,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.raleway(
                                          fontSize: 10,
                                      fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey[700],
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// DESCRIPTION
                  Container(
                    key: _descriptionKey,
                    decoration: BoxDecoration(
                      color: Color(0xFFFDF5E6),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: Color(0xFFFDF5E6),
                        width: 1.5,
                      ),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        leading: const Icon(
                          Icons.description,
                          color: Colors.teal,
                        ),
                        onExpansionChanged: (expanded) {
                          if (expanded) {
                            _scrollToDescription();
                          }
                        },
                        title: Text(
                          "Опис на настанот",
                          style: GoogleFonts.raleway(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                        iconColor: Colors.teal,
                        collapsedIconColor: Colors.teal,
                        childrenPadding: const EdgeInsets.all(16),
                        children: [
                          Builder(
                            builder: (context) {
                              final isEmpty = widget.event.description.trim().isEmpty;

                              if (isEmpty) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.redAccent[700],
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "Нема достапен опис за овој настан.",
                                        style: GoogleFonts.raleway(
                                          fontSize: 10,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.redAccent[700],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                );
                              }

                              return Text(
                                widget.event.description,
                                style: GoogleFonts.raleway(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.justify,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// BUTTON
                  Center(
                    child: SizedBox(
                      width: 350,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFDF5E6),
                          elevation: 12,
                          shadowColor: Colors.black.withOpacity(0.7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                              color: Color(0xFFFDF5E6),
                              width: 1.5,
                            ),
                          ),
                        ),
                        onPressed: _openBuyUrl,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              "Купи карта",
                              style: GoogleFonts.raleway(
                                fontSize: 16,
                                color: Colors.blueGrey[700],
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Icon(
                                  Icons.confirmation_number,
                                  size: 20,
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}