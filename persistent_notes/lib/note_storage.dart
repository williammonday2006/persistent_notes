import 'dart:io';
import 'package:path_provider/path_provider.dart';

class NoteStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/notes.txt');
  }

  Future<void> writeNote(String text) async {
    final file = await _localFile;
    await file.writeAsString(text);
  }

  Future<String> readRawContent() async {
    final file = await _localFile;
    return await file.readAsString();
  }

  Future<String> readNote() async {
    try {
      final file = await _localFile;
      return await file.readAsString();
    } catch (e) {
      return 'No notes saved yet.';
    }
  }
}