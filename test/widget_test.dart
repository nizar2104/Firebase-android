import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:myapp/main.dart';
import 'package:myapp/models/dj_gear.dart';
import 'package:myapp/scan_provider.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Scenario: No PIONEER folder and unsupported FLAC files', (WidgetTester tester) async {
    // 1. Initialize the app with the ScanProvider
    final scanProvider = ScanProvider();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: scanProvider,
        child: const MyApp(),
      ),
    );

    // 2. Select the CDJ-3000, which has specific FLAC support
    final gear = djGearList.firstWhere((g) => g.name == 'CDJ-2000 Nexus (No FLAC)');
    scanProvider.selectGear(gear);
    await tester.pump();

    // 3. Simulate scanning the directory that will trigger our test scenario
    // We use a special path that our mock file system understands
    await scanProvider.selectAndScanDirectory();
    await tester.pump(); // Let the UI update with the results

    // 4. Verify the UI shows the expected errors and warnings

    // Check for the "NO DATABASE FOUND" error
    expect(find.textContaining('NO DATABASE FOUND'), findsOneWidget);

    // Check for the "UNSUPPORTED FILES" warning
    expect(find.textContaining('UNSUPPORTED FILES'), findsOneWidget);
    expect(find.textContaining('Found 2 files'), findsOneWidget);

    // Check for the overall "ISSUES DETECTED" message
  });
}
