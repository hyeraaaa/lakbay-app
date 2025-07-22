import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/feedback.dart';

class FeedbackService {
  static Future<List<FeedbackEntry>> loadFeedback() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/feedback.json',
      );
      final List<dynamic> jsonData = json.decode(response);
      return jsonData.map((json) => FeedbackEntry.fromJson(json)).toList();
    } catch (e) {
      print(
        'Error loading feedback: '
                '[31m'
                '[0m' +
            e.toString(),
      );
      return [];
    }
  }
}
