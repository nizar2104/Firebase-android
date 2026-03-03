
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

    return Scaffold(
      backgroundColor: Colors.black, // CDJ Screen Background
      appBar: AppBar(
        title: Text('USB Analysis Report', style: GoogleFonts.orbitron()),
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

          return _buildResultTile(context, key, value);
        },
      ),
    );
  }

  Widget _buildResultTile(BuildContext context, String key, dynamic value) {
    Icon leadingIcon;
    Color iconColor;
    Widget trailing = const SizedBox.shrink();

    if (key == 'File System Format') {
      final isCompatible = value == 'FAT' || value == 'FAT32' || value == 'exFAT';
      iconColor = isCompatible ? Colors.green.shade400 : Colors.red.shade400;
      leadingIcon = Icon(isCompatible ? Icons.check_circle : Icons.cancel, color: iconColor);
    } else if (value is bool) {
      iconColor = value ? Colors.green.shade400 : Colors.red.shade400;
      leadingIcon = Icon(value ? Icons.check_circle : Icons.cancel, color: iconColor);
    } else if (value is List<String> && value.isNotEmpty) {
      iconColor = Colors.orange.shade400;
      leadingIcon = Icon(Icons.warning, color: iconColor);
      trailing = const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16);
    } else {
      iconColor = Colors.green.shade400;
      leadingIcon = Icon(Icons.check_circle, color: iconColor);
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
        subtitle: _buildSubtitle(value),
        trailing: trailing,
        onTap: (value is List<String> && value.isNotEmpty)
            ? () => _showDetailsDialog(context, key, value)
            : null,
      ),
    );
  }

  Widget _buildSubtitle(dynamic value) {
    String textToShow;
    if (value is bool) {
      textToShow = value ? 'OK' : 'Not Found';
    } else if (value is List<String>) {
      textToShow = value.isEmpty ? 'OK' : '${value.length} issue(s) found';
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
