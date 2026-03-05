import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:myapp/main.dart';
import 'package:myapp/models/dj_gear.dart';
import 'package:myapp/scan_provider.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
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

        // ACT: Simulate user selecting a gear model that does not support FLAC.
        final gear = djGearList
            .firstWhere((g) => g.name == 'CDJ-2000 Nexus (No FLAC)');
        scanProvider.selectGear(gear);
        await tester.pump();

        // ACT: Simulate scanning a directory containing unsupported files.
        await scanProvider.selectAndScanDirectory();
        await tester
            .pumpAndSettle(); // Wait for all animations and async tasks to complete.

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

    // You can add more tests for other scenarios here.
  });
}
