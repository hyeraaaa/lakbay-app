class Booking {
  final int id;
  final int userId;
  final int itemId;
  final String status;
  final String date;
  final int amount;

  Booking({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.status,
    required this.date,
    required this.amount,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['userId'],
      itemId: json['itemId'],
      status: json['status'],
      date: json['date'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'itemId': itemId,
      'status': status,
      'date': date,
      'amount': amount,
    };
  }
}
