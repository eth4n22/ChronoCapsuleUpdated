class Capsule {
  final String title;
  final DateTime date;
  final List<String> uploadedPhotos; // List of photo paths
  final List<String> letters; // List of letters

  Capsule({
    required this.title,
    required this.date,
    required this.uploadedPhotos,
    required this.letters,
  });
}
