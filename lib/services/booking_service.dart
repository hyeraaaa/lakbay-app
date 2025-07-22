import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/booking.dart';

class BookingService {
  static Future<List<Booking>> loadBookings() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/mybookings.json',
      );
      final List<dynamic> jsonData = json.decode(response);
      return jsonData.map((json) => Booking.fromJson(json)).toList();
    } catch (e) {
      print('Error loading bookings: $e');
      return [];
    }
  }
}
