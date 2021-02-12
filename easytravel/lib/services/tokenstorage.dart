import 'package:path_provider/path_provider.dart';
import 'dart:io';

String fileToken;
// future get method to obtain directory path of app storage file
Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  // For your reference print the AppDoc directory
  return directory.path;
}

// future get method to get local path of file
Future<File> get localFile async {
  final path = await localPath;
  return File('$path/data.txt');
}

// future method to read content of app data file
Future<String> readContent() async {
  try {
    final File file = await localFile;
    // Read the file
    String contents = await file.readAsString();
    // Returning the contents of the file
    return contents;
  } catch (e) {
    // If encountering an error, return
    return 'Error!';
  }
}

// future method to write content in text file
Future<File> writeContent(String userToken) async {
  final File file = await localFile;
  // Write the file
  return file.writeAsString(userToken);
}
