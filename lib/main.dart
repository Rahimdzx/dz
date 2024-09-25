import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'number_provider.dart'; // Import NumberProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url:
        'https://ctuarfuffxadxspbrgia.supabase.co', // Replace with your Supabase project URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN0dWFyZnVmZnhhZHhzcGJyZ2lhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjcyMTIyNzksImV4cCI6MjA0Mjc4ODI3OX0.lzgP8Sd6nKbT-QMqs6GBBJMHtABbS9n1sRun_LvIak0', // Replace with your Supabase anon key
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NumberProvider>(
      // Ensure NumberProvider is used correctly
      create: (_) => NumberProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: NumberScreen(),
      ),
    );
  }
}

class NumberScreen extends StatefulWidget {
  @override
  _NumberScreenState createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NumberProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Real-Time Average Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter a number'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  provider.insertNumber(int.parse(_controller.text));
                  _controller.clear();
                }
              },
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                provider.resetNumbers(); // Reset numbers when clicked
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Reset'),
            ),
            SizedBox(height: 40),
            provider.isLoading
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      Text(
                        'Total Numbers: ${provider.totalCount}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Average: ${provider.average.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
