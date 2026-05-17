class Event {
  final String title;
  final String date;
  final String location;
  final String imageUrl;
  final String price;
  final String buyUrl;
  final String source;
  final String genre;
  final String description;
  final String eventId;

  Event({
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.price,
    required this.buyUrl,
    required this.source,
    required this.genre,
    required this.description,
    required this.eventId,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      location: json['location'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: json['price'] ?? '',
      buyUrl: json['buyUrl'] ?? '',
      source: json['source'] ?? '',
      genre: json['genre'] ?? '',
      description: json['description'] ?? '',
      eventId: json['eventId'].toString(),
    );
  }
}
