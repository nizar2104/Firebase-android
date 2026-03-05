
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'models/dj_gear.dart';
import 'compatibility_checker.dart';

class ScanProvider with ChangeNotifier {
  DjGear? _selectedGear;
  bool _isLoading = false;
  CompatibilityResult? _results; // Use the new result class

  DjGear? get selectedGear => _selectedGear;
  bool get isLoading => _isLoading;
  CompatibilityResult? get results => _results;

  void selectGear(DjGear? gear) {
    _selectedGear = gear;
    notifyListeners();
  }

  // Method for tests to inject mock results
  @visibleForTesting
  void setResults(CompatibilityResult results) {
    _results = results;
    notifyListeners();
  }

  Future<void> selectAndScanDirectory() async {
    if (_selectedGear == null) return;

    _isLoading = true;
    _results = null; // Clear previous results
    notifyListeners();

    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory != null) {
        _results = await checkCompatibility(selectedDirectory, _selectedGear!);
      } else {
        // User canceled the picker
        _results = CompatibilityResult(warnings: ['Scan canceled.']);
      }
    } catch (e) {
      _results = CompatibilityResult(errors: ['An unexpected error occurred: ${e.toString()}']);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
