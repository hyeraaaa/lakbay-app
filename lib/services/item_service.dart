import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/item.dart';

class ItemService {
  static Future<List<Item>> loadItems() async {
    try {
      final String response = await rootBundle.loadString('assets/items.json');
      final List<dynamic> jsonData = json.decode(response);
      return jsonData.map((json) => Item.fromJson(json)).toList();
    } catch (e) {
      print('Error loading items: $e');
      return [];
    }
  }
}
