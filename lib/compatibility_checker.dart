
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart';
import 'models/dj_gear.dart'; // Import the DjGear model

const platform = MethodChannel('com.example.myapp/filesystem');

Future<String> getFileSystemType(String path) async {
  try {
    final String result = await platform.invokeMethod('getFileSystemType', {'path': path});
    return result;
  } on PlatformException catch (e) {
    return "Error: ${e.message}";
  }
}

Future<Map<String, dynamic>> checkCompatibility(String directoryPath, DjGear selectedGear) async {
  final results = <String, dynamic>{};

  final dir = Directory(directoryPath);
  if (!await dir.exists()) {
    results['Error'] = 'Directory not found.';
    return results;
  }

  // Check 1: File System Format
  final fileSystemType = await getFileSystemType(directoryPath);
  results['File System Format'] = fileSystemType;
  if (!selectedGear.hasExfatSupport && fileSystemType.toLowerCase() == 'exfat') {
      results['exFAT Not Supported'] = true;
  }


  // Check 2: File & Folder Structure
  bool pioneerFolderFound = false;
  List<String> audioFiles = [];
  List<String> flacFiles = []; // Specifically track FLAC files

  await for (var entity in dir.list(recursive: true)) {
    if (entity is Directory && p.basename(entity.path).toUpperCase() == 'PIONEER') {
      pioneerFolderFound = true;
    }
    if (entity is File) {
      final extension = p.extension(entity.path).toLowerCase();
      if (['.mp3', '.wav', '.aiff'].contains(extension)) {
        audioFiles.add(entity.path);
      } else if (extension == '.flac') {
        flacFiles.add(entity.path);
      }
    }
  }
  results['PIONEER Folder Found'] = pioneerFolderFound;
  results['Standard Audio Files Found'] = audioFiles.isNotEmpty;

  // Check for FLAC files and if the gear supports them
  if (flacFiles.isNotEmpty) {
      if (!selectedGear.hasFlacSupport) {
          results['FLAC Files Found (Not Supported)'] = flacFiles;
      } else {
          results['FLAC Files Found (Supported)'] = flacFiles.length;
      }
  }

  // Check 3: File Name Analysis
  List<String> longFileNames = [];
  List<String> specialCharFileNames = [];
  final specialCharRegex = RegExp(r'[^a-zA-Z0-9._\-/]');

  await for (var entity in dir.list(recursive: true)) {
    final fileName = p.basename(entity.path);
    if (fileName.length > 255) {
      longFileNames.add(fileName);
    }
    if (specialCharRegex.hasMatch(fileName)) {
      specialCharFileNames.add(fileName);
    }
  }
  results['Long File Names (>255 chars)'] = longFileNames;
  results['Files with Special Characters'] = specialCharFileNames;

  // Check 4: Album Art
  List<String> imageFiles = [];
  await for (var entity in dir.list(recursive: true)) {
    if (entity is File) {
      final extension = p.extension(entity.path).toLowerCase();
      if (['.jpg', '.jpeg', '.png'].contains(extension)) {
        imageFiles.add(entity.path);
      }
    }
  }
  results['Potential Album Art Files'] = imageFiles;

  return results;
}
