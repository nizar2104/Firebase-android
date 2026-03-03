
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'scan_provider.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context, listen: false);
    final results = scanProvider.results;
    final selectedGear = scanProvider.selectedGear;

    return Scaffold(
      backgroundColor: Colors.black, // CDJ Screen Background
      appBar: AppBar(
        title: Text('Report for ${selectedGear?.name ?? "USB"}', style: GoogleFonts.orbitron()),
        backgroundColor: const Color(0xFF1E1E1E),
        automaticallyImplyLeading: false, // Remove back button
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'BACK',
              style: TextStyle(
                color: Color(0xFFF5B50A), // Yellow
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final key = results.keys.elementAt(index);
          final value = results[key];

          // Skip empty lists for a cleaner report
          if (value is List && value.isEmpty) {
            return const SizedBox.shrink();
          }

          return _buildResultTile(context, key, value);
        },
      ),
    );
  }

  Widget _buildResultTile(BuildContext context, String key, dynamic value) {
    Icon leadingIcon;
    Color iconColor;
    Widget trailing = const SizedBox.shrink();

    // Default to success
    iconColor = Colors.green.shade400;
    leadingIcon = Icon(Icons.check_circle, color: iconColor);

    if (key == 'File System Format') {
      final isCompatible = !(value.toString().toLowerCase() == 'exfat' &&
          !(Provider.of<ScanProvider>(context, listen: false).selectedGear?.hasExfatSupport ?? true));
      iconColor = isCompatible ? Colors.green.shade400 : Colors.red.shade400;
      leadingIcon = Icon(isCompatible ? Icons.check_circle : Icons.cancel, color: iconColor);
    } else if (key == 'exFAT Not Supported') {
        iconColor = Colors.red.shade400;
        leadingIcon = Icon(Icons.cancel, color: iconColor);
    } else if (key == 'FLAC Files Found (Not Supported)') {
        iconColor = Colors.red.shade400;
        leadingIcon = Icon(Icons.error, color: iconColor);
        trailing = const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16);
    } else if (key == 'Long File Names (>255 chars)' || key == 'Files with Special Characters') {
        if (value is List && value.isNotEmpty) {
            iconColor = Colors.orange.shade400;
            leadingIcon = Icon(Icons.warning, color: iconColor);
            trailing = const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16);
        }
    } else if (value is bool) {
      iconColor = value ? Colors.green.shade400 : Colors.red.shade400;
      leadingIcon = Icon(value ? Icons.check_circle : Icons.cancel, color: iconColor);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade800)),
      ),
      child: ListTile(
        leading: leadingIcon,
        title: Text(
          key,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: _buildSubtitle(value, key),
        trailing: trailing,
        onTap: (value is List<String> && value.isNotEmpty)
            ? () => _showDetailsDialog(context, key, value)
            : null,
      ),
    );
  }

  Widget _buildSubtitle(dynamic value, String key) {
    String textToShow;
    if (key == 'exFAT Not Supported') {
        textToShow = 'This gear does not support the exFAT file system.';
    } else if (value is bool) {
      textToShow = value ? 'OK' : 'Not Found';
    } else if (value is List<String>) {
      textToShow = '${value.length} issue(s) found';
    } else {
      textToShow = value.toString();
    }

    return Text(
      textToShow,
      style: TextStyle(
        color: Colors.grey.shade400,
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, String title, List<String> items) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(title, style: GoogleFonts.orbitron(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) => Text(
              items[index],
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'CLOSE',
              style: TextStyle(
                color: Color(0xFFF5B50A), // Yellow
              ),
            ),
          ),
        ],
      ),
    );
  }
}
