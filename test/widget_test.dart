import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:myapp/main.dart';
import 'package:myapp/models/dj_gear.dart';
import 'package:myapp/scan_provider.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  testWidgets('Scenario: No PIONEER folder and unsupported FLAC files', (WidgetTester tester) async {
    // Wrap the test in mockNetworkImagesFor to prevent network errors
    await mockNetworkImagesFor(() async {
      // 1. Initialize the app with the ScanProvider
      final scanProvider = ScanProvider();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: scanProvider,
          child: const MyApp(),
        ),
      );
  group('USB Validator Widget Tests', () {
    testWidgets(
        'Scenario: Shows compatibility issues for gear without FLAC support',
        (WidgetTester tester) async {
      // Using mockNetworkImagesFor to prevent network errors during tests.
      await mockNetworkImagesFor(() async {
        // ARRANGE: Set up the application state and dependencies.
        final scanProvider = ScanProvider();
        await tester.pumpWidget(
          ChangeNotifierProvider.value(
            value: scanProvider,
            child: const MyApp(),
          ),
        );

      // 2. Select the CDJ-2000 Nexus, which does not support FLAC
      final gear = djGearList.firstWhere((g) => g.name == 'CDJ-2000 Nexus (No FLAC)');
      scanProvider.selectGear(gear);
      await tester.pump();
        // ACT: Simulate user selecting a gear model that does not support FLAC.
        final gear = djGearList
            .firstWhere((g) => g.name == 'CDJ-2000 Nexus (No FLAC)');
        scanProvider.selectGear(gear);
        await tester.pump();

      // 3. Simulate scanning the directory that will trigger our test scenario
      await scanProvider.selectAndScanDirectory();
      await tester.pumpAndSettle(); // Use pumpAndSettle to wait for UI to stabilize
        // ACT: Simulate scanning a directory containing unsupported files.
        await scanProvider.selectAndScanDirectory();
        await tester
            .pumpAndSettle(); // Wait for all animations and async tasks to complete.

      // 4. Verify the UI shows the expected errors and warnings
      expect(find.textContaining('NO DATABASE FOUND', findRichText: true), findsOneWidget);
        // ASSERT: Verify that the results page displays the correct warnings and errors.
        expect(find.textContaining('ISSUES DETECTED', findRichText: true),
            findsOneWidget);
        expect(find.textContaining('NO DATABASE FOUND', findRichText: true),
            findsOneWidget);
        expect(find.textContaining('UNSUPPORTED FILES', findRichText: true),
            findsOneWidget);
        expect(find.textContaining('Found 2 FLAC files', findRichText: true),
            findsOneWidget);
      });
    });

      // Check for the "UNSUPPORTED FILES" warning
      expect(find.textContaining('UNSUPPORTED FILES', findRichText: true), findsOneWidget);
      expect(find.textContaining('Found 2 FLAC files', findRichText: true), findsOneWidget);

      // Check for the overall "ISSUES DETECTED" message
      expect(find.textContaining('ISSUES DETECTED', findRichText: true), findsOneWidget);
    });
    // You can add more tests for other scenarios here.
  });
}
