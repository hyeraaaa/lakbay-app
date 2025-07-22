class FeedbackEntry {
  final int itemId;
  final int userId;
  final int rating;
  final String comment;
  final String date;

  FeedbackEntry({
    required this.itemId,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory FeedbackEntry.fromJson(Map<String, dynamic> json) {
    return FeedbackEntry(
      itemId: json['itemId'],
      userId: json['userId'],
      rating: json['rating'],
      comment: json['comment'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'date': date,
    };
  }
}
