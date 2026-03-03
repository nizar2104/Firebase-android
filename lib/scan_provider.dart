
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'compatibility_checker.dart';
import 'models/dj_gear.dart'; // Import the new model

class ScanProvider with ChangeNotifier {
  bool _isLoading = false;
  Map<String, dynamic> _results = {};
  DjGear? _selectedGear; // To hold the selected gear model

  bool get isLoading => _isLoading;
  Map<String, dynamic> get results => _results;
  DjGear? get selectedGear => _selectedGear;

  // Method to update the selected gear
  void selectGear(DjGear gear) {
    _selectedGear = gear;
    notifyListeners();
  }

  Future<void> selectAndScanDirectory() async {
    if (_selectedGear == null) {
      // Optionally, handle the case where no gear is selected
      print("No DJ gear selected!");
      return;
    }

    // Request permissions before picking a directory
    if (Platform.isAndroid || Platform.isIOS) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (!status.isGranted) {
          _results = {'Error': 'Storage permission not granted.'};
          notifyListeners();
          return;
        }
      }
    }

    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      _isLoading = true;
      _results = {};
      notifyListeners();

      try {
        // Pass the selected gear to the compatibility checker
        final results = await checkCompatibility(selectedDirectory, _selectedGear!);
        _results = results;
      } catch (e) {
        _results = {'Error': 'An error occurred: ${e.toString()}'};
      }

      _isLoading = false;
      notifyListeners();
    } else {
      _results = {'Error': 'No directory selected.'};
      notifyListeners();
    }
  }
}
