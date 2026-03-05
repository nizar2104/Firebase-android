import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'scan_provider.dart';
import 'compatibility_checker.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context);
    final CompatibilityResult? results = scanProvider.results;

    if (results == null) {
      return const Center(
        child: Text(
          'WAITING FOR USB...',
          style: TextStyle(color: Colors.white, fontFamily: 'Courier New'),
        ),
      );
    }

    final allMessages = [
      ...results.successes,
      ...results.warnings,
      ...results.errors,
    ];

    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: const Color(0xFF333333), width: 4),
      ),
      child: Column(
        children: [
          ...allMessages.map((message) => _buildResultRow(message)).toList(),
          _buildFooter(context, results),
        ],
      ),
    );
  }

  Widget _buildResultRow(String message) {
    final parts = message.split('\n');
    final title = parts.isNotEmpty ? parts[0] : '';
    final meta = parts.length > 1 ? parts[1] : '';

    String icon = ' ';
    Color iconColor = Colors.grey;
    String cleanTitle = title;

    if (title.startsWith('✅')) {
      icon = '✅';
      iconColor = const Color(0xFF00ff00);
      cleanTitle = title.substring(2);
    } else if (title.startsWith('❌')) {
      icon = '❌';
      iconColor = const Color(0xffff0044);
      cleanTitle = title.substring(2);
    } else if (title.startsWith('⚠️')) {
      icon = '⚠️';
      iconColor = const Color(0xffffcc00);
      cleanTitle = title.substring(2);
    } else if (title.startsWith('🎵')) {
      icon = '🎵';
      iconColor = const Color(0xFF00ff00);
      cleanTitle = title.substring(2);
    } else if (title.startsWith('💾')) {
      icon = '💾';
      iconColor = title.contains('MODERN') ? const Color(0xFF00ff00) : const Color(0xffffcc00);
      cleanTitle = title.substring(2);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(icon, style: TextStyle(fontSize: 24, color: iconColor)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cleanTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.6, // 1.1rem
                    color: Colors.white,
                    fontFamily: 'Courier New',
                  ),
                ),
                if (meta.isNotEmpty)
                  Text(
                    meta,
                    style: const TextStyle(
                      fontSize: 12.8, // 0.8rem
                      color: Color(0xFF666666),
                      fontFamily: 'Courier New',
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, CompatibilityResult results) {
    final scanProvider = Provider.of<ScanProvider>(context, listen: false);
    final gear = scanProvider.selectedGear;
    final issues = [...results.errors, ...results.warnings];

    return Column(
      children: [
        if (issues.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFF333333))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ISSUES DETECTED:',
                  style: TextStyle(
                    color: Color(0xffffcc00),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Courier New',
                  ),
                ),
                const SizedBox(height: 5),
                ...issues.map((e) => Text(
                  '• ${e.split('\n').first.substring(2)}',
                  style: const TextStyle(color: Color(0xffffcc00), fontFamily: 'Courier New'),
                )),
              ],
            ),
          ),
        if (issues.isEmpty)
            Container(
              margin: const EdgeInsets.only(top: 20),
               decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFF333333))),
              ),
              padding: const EdgeInsets.only(top:15),
              child: const Center(
                child: Text(
                  'READY FOR GIG 🚀',
                  style: TextStyle(
                    color: Color(0xFF00ff00),
                    fontSize: 19.2, // 1.2rem
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Courier New',
                  ),
                ),
              ),
            ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.only(top: 10),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFF333333))),
          ),
          child: Text(
            '*NOTE: Browsers cannot detect if your USB is FAT32 or NTFS.\nIf using ${gear?.name}, please manually verify your USB is ${gear?.hasExfatSupport == true ? 'exFAT or FAT32' : 'FAT32'}.',
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 11.2, // 0.7rem
              fontFamily: 'Courier New',
            ),
          ),
        ),
      ],
    );
  }
}
