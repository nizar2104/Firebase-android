
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'compatibility_checker.dart';

class ScanProvider with ChangeNotifier {
  bool _isLoading = false;
  Map<String, dynamic> _results = {};

  bool get isLoading => _isLoading;
  Map<String, dynamic> get results => _results;

  Future<void> selectAndScanDirectory() async {
    _isLoading = true;
    _results = {};
    notifyListeners();

    if (await Permission.manageExternalStorage.request().isGranted) {
      final String? directoryPath = await FilePicker.platform.getDirectoryPath();

      if (directoryPath != null) {
        _results = await checkCompatibility(directoryPath);
      }
    } else {
      // Handle the case where the user denies the permission
      _results = {'Permission Denied': 'Could not access storage to perform checks.'};
    }

    _isLoading = false;
    notifyListeners();
  }
}
