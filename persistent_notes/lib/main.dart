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
  String _savedNote = 'No notes saved yet.';

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _loadSavedNote();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
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

  Future<void> _loadSavedNote() async {
    final note = await _storage.readNote();
    if (!mounted) return;
    setState(() {
      _savedNote = note;
      _noteController.text =
          note == 'No notes saved yet.' ? '' : note;
    });
  }

  Future<void> _saveNote() async {
    await _storage.writeNote(_noteController.text);
    if (!mounted) return;
    setState(() {
      _savedNote = _noteController.text;
      _status = 'Note saved to disk!';
    });
  }

  Future<void> _printNote() async {
    final content = await _storage.readRawContent();
    debugPrint(content);
    if (!mounted) return;
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              const SizedBox(height: 12),
              Text(_status),
              const SizedBox(height: 20),
              const Text(
                'Saved Note:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_savedNote),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}