import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NumberProvider extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;
  bool isLoading = true;
  int totalCount = 0;
  double average = 0.0;
  List<int> numbers = []; // List to store numbers

  NumberProvider() {
    fetchNumbers();
  }

  // Fetch numbers from the database
  Future<void> fetchNumbers() async {
    try {
      final List<dynamic> response =
          await _client.from('numbers').select('value');

      if (response.isNotEmpty) {
        numbers = response.map((e) => e['value'] as int).toList();
        _calculateAverage();
      }
    } catch (e) {
      print('Error fetching numbers: $e');
    } finally {
      isLoading = false;
      notifyListeners(); // Notify listeners to update the UI
    }
  }

  // Insert a new number into the database
  Future<void> insertNumber(int number) async {
    try {
      await _client
          .from('numbers')
          .insert({'value': number}).select(); // Use select() to return data
      fetchNumbers(); // Re-fetch numbers after inserting
    } catch (e) {
      print('Error inserting number: $e');
    }
  }

  // Reset all numbers in the database
  Future<void> resetNumbers() async {
    try {
      await _client.from('numbers').delete().neq('id', 0); // Delete all rows
      numbers.clear();
      totalCount = 0;
      average = 0.0;
      notifyListeners(); // Notify listeners to update the UI
    } catch (e) {
      print('Error resetting numbers: $e');
    }
  }

  // Calculate the average of numbers
  void _calculateAverage() {
    totalCount = numbers.length;
    if (totalCount > 0) {
      average = numbers.reduce((a, b) => a + b) / totalCount;
    } else {
      average = 0.0;
    }
    notifyListeners(); // Notify listeners to update the UI
  }
}
