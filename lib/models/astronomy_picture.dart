class AstronomyPicture {
  final String title;
  final String url;
  final String explanation;
  final String date;

  AstronomyPicture({
    required this.title,
    required this.url,
    required this.explanation,
    required this.date,
  });

  // Factory constructor untuk membuat objek AstronomyPicture dari JSON
  factory AstronomyPicture.fromJson(Map<String, dynamic> json) {
    return AstronomyPicture(
      title: json['title'],
      url: json['url'],
      explanation: json['explanation'],
      date: json['date'],
    );
  }
}
