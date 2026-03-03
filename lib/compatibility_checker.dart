
import 'dart:io';

Future<Map<String, bool>> checkCompatibility(String directoryPath) async {
  final Map<String, bool> results = {};

  final pioneerDir = Directory('$directoryPath/PIONEER');
  results['PIONEER folder exists'] = await pioneerDir.exists();

  final audioFiles = <String>['.mp3', '.wav', '.aiff', '.flac'];
  bool hasAudioFiles = false;
  final dir = Directory(directoryPath);
  if (await dir.exists()) {
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) {
        for (final extension in audioFiles) {
          if (entity.path.toLowerCase().endsWith(extension)) {
            hasAudioFiles = true;
            break;
          }
        }
      }
      if (hasAudioFiles) break;
    }
  }
  results['Contains audio files'] = hasAudioFiles;

  // More checks to be added here in the future

  return results;
}
