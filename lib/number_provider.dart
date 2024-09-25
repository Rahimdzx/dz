import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NumberProvider extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;
  bool isLoading = true;
  int totalCount = 0;
  double average = 0.0;
  List<int> numbers = [];

  NumberProvider() {
    if (_client != null) {
      fetchNumbers();
    } else {
      print('Supabase is not initialized yet');
    }
  }

  Future<void> fetchNumbers() async {
    isLoading = true;
    notifyListeners();
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
      notifyListeners();
    }
  }

  Future<void> insertNumber(int number) async {
    isLoading = true;
    notifyListeners();
    try {
      await _client.from('numbers').insert({'value': number}).select();
      await fetchNumbers(); // Ensure fetch completes
    } catch (e) {
      print('Error inserting number: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetNumbers() async {
    try {
      await _client.from('numbers').delete().neq('id', 0);
      numbers.clear();
      _calculateAverage();
    } catch (e) {
      print('Error resetting numbers: $e');
    }
  }

  void _calculateAverage() {
    totalCount = numbers.length;
    if (totalCount > 0) {
      average = numbers.reduce((a, b) => a + b) / totalCount;
    } else {
      average = 0.0;
    }
    notifyListeners();
  }
}

