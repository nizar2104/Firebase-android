import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:myapp/main.dart';
import 'package:myapp/models/dj_gear.dart';
import 'package:myapp/scan_provider.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  testWidgets('Scenario: No PIONEER folder and unsupported FLAC files', (WidgetTester tester) async {
    // Wrap the test in mockNetworkImagesFor to prevent network errors
    mockNetworkImagesFor(() async {
    await mockNetworkImagesFor(() async {
      // 1. Initialize the app with the ScanProvider
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

      // 3. Simulate scanning the directory that will trigger our test scenario
      await scanProvider.selectAndScanDirectory();
      await tester.pumpAndSettle(); // Use pumpAndSettle to wait for UI to stabilize

      // 4. Verify the UI shows the expected errors and warnings
      expect(find.textContaining('NO DATABASE FOUND', findRichText: true), findsOneWidget);

      // Check for the "UNSUPPORTED FILES" warning
      expect(find.textContaining('UNSUPPORTED FILES', findRichText: true), findsOneWidget);
      expect(find.textContaining('Found 2 FLAC files', findRichText: true), findsOneWidget);

      // Check for the overall "ISSUES DETECTED" message
      expect(find.textContaining('ISSUES DETECTED', findRichText: true), findsOneWidget);
    });
  });
}
