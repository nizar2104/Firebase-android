
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart';
import 'models/dj_gear.dart';

// New result class to structure the output
class CompatibilityResult {
  final bool isReady;
  final List<String> errors;
  final List<String> warnings;
  final List<String> successes;
  final int trackCount;
  final String manualCheckMessage;

  CompatibilityResult({
    this.isReady = false,
    this.errors = const [],
    this.warnings = const [],
    this.successes = const [],
    this.trackCount = 0,
    this.manualCheckMessage = "",
  });
}

const platform = MethodChannel('com.example.myapp/filesystem');

Future<String> getFileSystemType(String path) async {
  try {
    final String result = await platform.invokeMethod('getFileSystemType', {'path': path});
    return result;
  } on PlatformException {
    // Return "Unknown" on error and let the manual check message guide the user.
    return "Unknown";
  }
}

Future<CompatibilityResult> checkCompatibility(String directoryPath, DjGear selectedGear) async {
  final dir = Directory(directoryPath);
  if (!await dir.exists()) {
    return CompatibilityResult(errors: ['Directory not found.']);
  }

  // 1. ANALYSIS VARIABLES
  bool hasPioneerFolder = false;
  int trackCount = 0;
  List<String> flacErrors = [];
  List<String> successMessages = [];
  List<String> warningMessages = [];
  List<String> errorMessages = [];

  // 2. SCANNING LOGIC
  try {
    final entities = await dir.list(recursive: true).toList();
    for (var entity in entities) {
      final path = entity.path;
      final name = p.basename(path).toLowerCase();

      if (entity is Directory && (name.toUpperCase() == 'PIONEER' || name.toUpperCase() == '.PIONEER')) {
        hasPioneerFolder = true;
      }

      if (entity is File) {
        final extension = p.extension(name);
        if (['.mp3', '.wav', '.aiff', '.m4a', '.flac'].contains(extension)) {
          trackCount++;
        }
        
        if (extension == '.flac' && !selectedGear.hasFlacSupport) {
          if (flacErrors.isEmpty) { // Add error only once
            flacErrors.add("Found FLAC files. ${selectedGear.name} does not support FLAC.");
          }
        }
      }
    }
  } catch (e) {
    return CompatibilityResult(errors: ['Failed to read directory contents. Check permissions.']);
  }

  // 3. GENERATE REPORT
  
  // CHECK 1: Database
  if (hasPioneerFolder) {
    successMessages.add("✅ REKORDBOX DATABASE\nReady to load cues & grids.");
  } else {
    errorMessages.add("❌ NO DATABASE FOUND\nUSB will be slow / No Cues. Did you export from Rekordbox?");
  }

  // CHECK 2: Tracks (FLAC)
  if (flacErrors.isNotEmpty) {
    errorMessages.addAll(flacErrors);
  } else {
    successMessages.add("🎵 $trackCount TRACKS VALIDATED\nAudio formats are compatible.");
  }
  
  // CHECK 3: File System
  String manualCheck = "";
  if (!selectedGear.hasExfatSupport) {
    // For older gear that needs FAT32
    warningMessages.add("💾 FORMAT CHECK REQUIRED\nEnsure drive is FAT32 (Not exFAT).");
    manualCheck = "NOTE: Browsers cannot detect the USB format. For ${selectedGear.name}, please manually verify your USB is FAT32.";
  } else {
    // For modern gear
    successMessages.add("💾 MODERN FORMAT SUPPORT\n${selectedGear.name} reads exFAT & FAT32.");
    manualCheck = "NOTE: Browsers cannot detect the USB format. For ${selectedGear.name}, please manually verify your USB is exFAT or FAT32.";
  }

  final bool isSuccess = errorMessages.isEmpty;

  return CompatibilityResult(
    isReady: isSuccess,
    errors: errorMessages,
    warnings: warningMessages,
    successes: successMessages,
    trackCount: trackCount,
    manualCheckMessage: manualCheck,
  );
}
