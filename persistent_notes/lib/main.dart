import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'note_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  final NoteStorage _storage = NoteStorage();
  final TextEditingController _noteController = TextEditingController();
  String _status = '';

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _updateTheme(bool value) async {
    setState(() {
      _isDarkMode = value;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  Future<void> _saveNote() async {
    await _storage.writeNote(_noteController.text);
    setState(() {
      _status = 'Note saved to disk!';
    });
  }

  Future<void> _printNote() async {
    final content = await _storage.readRawContent();
    debugPrint(content);
    setState(() {
      _status = 'Note printed to console!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Persistent Notes'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: _isDarkMode,
                onChanged: _updateTheme,
              ),
              TextField(
                controller: _noteController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Type your notes here...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveNote,
                child: const Text('Save Note'),
              ),
              OutlinedButton(
                onPressed: _printNote,
                child: const Text('Print File to Console'),
              ),
              Text(_status),
            ],
          ),
        ),
      ),
    );
  }
}