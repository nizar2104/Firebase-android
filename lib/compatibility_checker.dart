import 'package:path/path.dart' as p;
import 'models/dj_gear.dart';
import 'mock_file_system.dart';

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

Future<CompatibilityResult> checkCompatibility(String directoryPath, DjGear selectedGear) async {
  // In a real app, you would use actual file system access.
  // For this web-based simulator, we use a mock file system.
  final mockFileSystem = getMockFileSystemForScenario(directoryPath);

  bool hasPioneerFolder = mockFileSystem.any((path) => path.toLowerCase().contains('/pioneer/'));
  int trackCount = 0;
  List<String> unsupportedFiles = [];

  for (var path in mockFileSystem) {
    final extension = p.extension(path).toLowerCase();
    if (['.mp3', '.wav', '.aiff', '.m4a', '.flac'].contains(extension)) {
      trackCount++;
      if (extension == '.flac' && !selectedGear.hasFlacSupport) {
        unsupportedFiles.add(p.basename(path));
      }
    }
  }

  List<String> errors = [];
  List<String> warnings = [];
  List<String> successes = [];

  // Database Check
  if (hasPioneerFolder) {
    successes.add('✅ REKORDBOX DATABASE\nReady to load cues & grids');
  } else {
    errors.add('❌ NO DATABASE FOUND\nUSB will be slow / No Cues');
  }

  // File Type Check
  if (unsupportedFiles.isNotEmpty) {
    errors.add('⚠️ UNSUPPORTED FILES\nFound ${unsupportedFiles.length} files ${selectedGear.name} cannot play: ${unsupportedFiles.join(', ')}');
  } else {
    successes.add('🎵 $trackCount TRACKS VALIDATED\nAudio format compatible');
  }

  // File System Format Check
  if (selectedGear.hasExfatSupport) {
    successes.add('💾 MODERN FORMAT SUPPORT\n${selectedGear.name} reads exFAT & FAT32');
  } else {
    warnings.add('💾 FORMAT CHECK REQUIRED\nEnsure drive is FAT32 (Not exFAT)');
  }

  String manualCheckMessage = '*NOTE: Browsers cannot detect if your USB is FAT32 or NTFS. If using ${selectedGear.name}, please manually verify your USB is ${selectedGear.hasExfatSupport ? 'exFAT or FAT32' : 'FAT32'}.';

  return CompatibilityResult(
    isReady: errors.isEmpty,
    errors: errors,
    warnings: warnings,
    successes: successes,
    trackCount: trackCount,
    manualCheckMessage: manualCheckMessage,
  );
}
