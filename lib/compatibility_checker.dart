
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

const platform = MethodChannel('com.example.myapp/filesystem');

Future<String> getFileSystemType(String path) async {
  try {
    final String result = await platform.invokeMethod('getFileSystemType', {'path': path});
    return result;
  } on PlatformException catch (e) {
    return "Failed to get file system type: '${e.message}'.";
  }
}

Future<Map<String, dynamic>> checkCompatibility(String directoryPath) async {
  final Map<String, dynamic> results = {};
  List<String> longFileNames = [];
  List<String> invalidCharFileNames = [];
  bool hasAlbumArt = false;

  final pioneerDir = Directory(p.join(directoryPath, 'PIONEER'));
  results['PIONEER folder exists'] = await pioneerDir.exists();

  final String fileSystemType = await getFileSystemType(directoryPath);
  results['File System Format'] = fileSystemType;

  final audioFiles = <String>['.mp3', '.wav', '.aiff', '.flac'];
  bool hasAudioFiles = false;
  final dir = Directory(directoryPath);

  if (await dir.exists()) {
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      final fileName = p.basename(entity.path);

      // Check for file name length
      if (fileName.length > 255) {
        longFileNames.add(fileName);
      }

      // Check for invalid characters
      if (RegExp(r'[^a-zA-Z0-9._\-\s]').hasMatch(fileName)) {
        invalidCharFileNames.add(fileName);
      }

      if (entity is File) {
        final extension = p.extension(entity.path).toLowerCase();
        // Check for audio files
        if (audioFiles.contains(extension)) {
          hasAudioFiles = true;
        }

        // Check for album art
        if (extension == '.jpg' || extension == '.png') {
          hasAlbumArt = true;
        }
      }
    }
  }

  results['Contains audio files'] = hasAudioFiles;
  results['Has album art'] = hasAlbumArt;
  results['Files with long names (> 255 chars)'] = longFileNames.isEmpty ? 'OK' : longFileNames;
  results['Files with invalid characters'] = invalidCharFileNames.isEmpty ? 'OK' : invalidCharFileNames;

  return results;
}
