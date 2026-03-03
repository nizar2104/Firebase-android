
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'scan_provider.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context);
    final results = scanProvider.results;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Results'),
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final key = results.keys.elementAt(index);
          final value = results[key];

          if (key == 'File System Format') {
            final isCompatible = value == 'FAT' || value == 'FAT32' || value == 'exFAT';
            return ListTile(
              leading: Icon(
                isCompatible ? Icons.check_circle : Icons.cancel,
                color: isCompatible ? Colors.green : Colors.red,
              ),
              title: Text(key),
              subtitle: Text(value.toString()),
            );
          } else if (value is bool) {
            return ListTile(
              leading: Icon(
                value ? Icons.check_circle : Icons.cancel,
                color: value ? Colors.green : Colors.red,
              ),
              title: Text(key),
            );
          } else if (value is String) {
            return ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: Text(key),
              subtitle: Text(value),
            );
          } else if (value is List<String> && value.isNotEmpty) {
            return ExpansionTile(
              leading: const Icon(Icons.warning, color: Colors.orange),
              title: Text(key),
              children: value.map((item) => ListTile(title: Text(item))).toList(),
            );
          } else {
            return ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: Text(key),
            );
          }
        },
      ),
    );
  }
}
