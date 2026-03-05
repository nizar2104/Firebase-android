import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'models/dj_gear.dart';
import 'compatibility_checker.dart';

class ScanProvider with ChangeNotifier {
  DjGear? _selectedGear;
  bool _isLoading = false;
  CompatibilityResult? _results;

  DjGear? get selectedGear => _selectedGear;
  bool get isLoading => _isLoading;
  CompatibilityResult? get results => _results;

  void selectGear(DjGear? gear) {
    _selectedGear = gear;
    _results = null; // Clear results when gear changes
    notifyListeners();
  }

  void resetScan() {
    _results = null;
    _isLoading = false;
    // Don't reset selected gear, user might want to scan again with the same gear
    notifyListeners();
  }
  
  @visibleForTesting
  void setResults(CompatibilityResult results) {
    _results = results;
    notifyListeners();
  }

  Future<void> selectAndScanDirectory() async {
    if (_selectedGear == null) return;

    _isLoading = true;
    _results = null;
    notifyListeners();

    try {
      // This will use a mock implementation on non-web platforms for testing
      final String? directoryPath = await FilePicker.platform.getDirectoryPath();

      if (directoryPath != null) {
        // In a real scenario, you'd get a list of files from the path.
        // For this simulation, we pass the path to the checker which will use mock data.
        _results = await checkCompatibility(directoryPath, _selectedGear!);
      } else {
        // User canceled the picker
         _results = null; // Stay on the main screen
      }
    } catch (e) {
      _results = CompatibilityResult(errors: ['An unexpected error occurred: ${e.toString()}']);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
