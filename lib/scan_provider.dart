
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'models/dj_gear.dart';
import 'compatibility_checker.dart';

class ScanProvider with ChangeNotifier {
  DjGear? _selectedGear;
  bool _isLoading = false;
  Map<String, dynamic> _results = {};

  DjGear? get selectedGear => _selectedGear;
  bool get isLoading => _isLoading;
  Map<String, dynamic> get results => _results;

  void selectGear(DjGear? gear) {
    _selectedGear = gear;
    notifyListeners();
  }

  Future<void> selectAndScanDirectory() async {
    if (_selectedGear == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory != null) {
        _results = await checkCompatibility(selectedDirectory, _selectedGear!);
      }
    } catch (e) {
      _results = {'Error': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
