
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'scan_provider.dart';
import 'compatibility_checker.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context, listen: false);
    final CompatibilityResult? results = scanProvider.results;
    final gearName = scanProvider.selectedGear?.name ?? "USB";

    // Combine all result messages into a single list for the ListView
    final allMessages = [
      ...results?.successes ?? [],
      ...results?.warnings ?? [],
      ...results?.errors ?? [],
    ];

    return Scaffold(
      backgroundColor: Colors.black, // CDJ Screen Background
      appBar: AppBar(
        title: Text('Report for $gearName'),
        backgroundColor: const Color(0xFF1E1E1E),
        automaticallyImplyLeading: false, 
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'BACK',
              style: TextStyle(
                color: Color(0xFFFFFF00), 
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: results == null
          ? const Center(child: Text("No scan results found.", style: TextStyle(color: Colors.white)))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: allMessages.length,
                    itemBuilder: (context, index) {
                      return _buildResultRow(context, allMessages[index]);
                    },
                  ),
                ),
                _buildFooter(context, results),
              ],
            ),
    );
  }

  Widget _buildResultRow(BuildContext context, String message) {
    final parts = message.split('\n');
    final title = parts.isNotEmpty ? parts[0] : '';
    final subtitle = parts.length > 1 ? parts[1] : '';

    IconData iconData = Icons.help;
    Color iconColor = Colors.grey;

    if (title.startsWith('✅')) {
      iconData = Icons.check_circle;
      iconColor = const Color(0xFF00FF00); // Green
    } else if (title.startsWith('🎵')) {
      iconData = Icons.music_note;
      iconColor = const Color(0xFF00FF00); // Green
    } else if (title.startsWith('💾')) {
      iconData = Icons.storage;
      iconColor = title.contains("MODERN") ? const Color(0xFF00FF00) : const Color(0xFFFFA500); // Green or Orange
    } else if (title.startsWith('❌')) {
      iconData = Icons.cancel;
      iconColor = const Color(0xFFFF0000); // Red
    } else if (title.startsWith('⚠️')) {
      iconData = Icons.warning;
      iconColor = const Color(0xFFFFA500); // Orange
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade800, width: 1),
      ),
      child: Row(
        children: [
          Icon(iconData, color: iconColor, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.substring(2), // Remove icon from text
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, CompatibilityResult results) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: results.isReady ? const Color(0xFF00FF00) : const Color(0xFFFF0000),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            results.isReady ? 'READY FOR GIG 🚀' : 'ISSUES DETECTED:',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold,
              color: results.isReady ? const Color(0xFF00FF00) : const Color(0xFFFF0000),
            ),
          ),
          if (!results.isReady)
            ...' '.split(' ').map((e) => Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    e.startsWith('❌') || e.startsWith('⚠️') ? e.substring(2) : e,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                )),
          const SizedBox(height: 16),
          Text(
            results.manualCheckMessage,
            style: TextStyle(color: Colors.grey.shade500, fontStyle: FontStyle.italic, fontSize: 12),
          ),
        ],
      ),
    );
  }

}
