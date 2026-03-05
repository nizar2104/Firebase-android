import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:myapp/main.dart';
import 'package:myapp/models/dj_gear.dart';
import 'package:myapp/scan_provider.dart';
import 'package:myapp/compatibility_checker.dart';
import 'package:myapp/home_page.dart';
import 'package:mockito/mockito.dart';

// Mocks
class MockScanProvider extends Mock implements ScanProvider {}

void main() {
  testWidgets('Happy Path - Full Compatibility', (WidgetTester tester) async {
    final scanProvider = ScanProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: scanProvider,
        child: const MyApp(),
      ),
    );

    // 1. Select Gear
    scanProvider.selectGear(djGearList.firstWhere((g) => g.name == 'CDJ-3000'));
    await tester.pump();

    // 2. Mock the scan result
    final successfulResult = CompatibilityResult(
      isReady: true,
      successes: [
        '✅ REKORDBOX DATABASE\nReady to load cues & grids',
        '🎵 150 TRACKS VALIDATED\nAudio format compatible',
        '💾 MODERN FORMAT SUPPORT\nCDJ-3000 reads exFAT & FAT32',
      ],
      manualCheckMessage: '*NOTE: Browsers cannot detect if your USB is FAT32 or NTFS. If using CDJ-3000, please manually verify your USB is exFAT or FAT32.',
    );
    scanProvider.setResults(successfulResult);
    await tester.pump(); 

    // 3. Verify the Results UI
    expect(find.text('READY FOR GIG 🚀'), findsOneWidget);
    expect(find.textContaining('REKORDBOX DATABASE'), findsOneWidget);
    expect(find.textContaining('150 TRACKS VALIDATED'), findsOneWidget);
    expect(find.textContaining('MODERN FORMAT SUPPORT'), findsOneWidget);
  });

  testWidgets('Error Path - FLAC Not Supported', (WidgetTester tester) async {
    final scanProvider = ScanProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: scanProvider,
        child: const MyApp(),
      ),
    );

    // 1. Select Gear that doesn't support FLAC
    scanProvider.selectGear(djGearList.firstWhere((g) => g.name == 'CDJ-2000 Nexus (No FLAC)'));
    await tester.pump();

    // 2. Mock the scan result for FLAC error
    final flacErrorResult = CompatibilityResult(
      isReady: false,
      errors: ['⚠️ UNSUPPORTED FILES\nCDJ-2000 Nexus (No FLAC) cannot play FLAC'],
      successes: ['✅ REKORDBOX DATABASE\nReady to load cues & grids'],
      warnings: ['💾 FORMAT CHECK REQUIRED\nEnsure drive is FAT32 (Not exFAT)'],
      manualCheckMessage: '*NOTE: Browsers cannot detect if your USB is FAT32 or NTFS. If using CDJ-2000 Nexus (No FLAC), please manually verify your USB is FAT32.',
    );
    scanProvider.setResults(flacErrorResult);
    await tester.pump();

    // 3. Verify the Results UI
    expect(find.text('ISSUES DETECTED:'), findsOneWidget);
    expect(find.textContaining('UNSUPPORTED FILES'), findsOneWidget);
    expect(find.textContaining('cannot play FLAC'), findsOneWidget);
    expect(find.textContaining('FORMAT CHECK REQUIRED'), findsOneWidget);
  });

  testWidgets('Error Path - No Rekordbox Database', (WidgetTester tester) async {
    final scanProvider = ScanProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: scanProvider,
        child: const MyApp(),
      ),
    );

    // 1. Select any gear
    scanProvider.selectGear(djGearList.first);
    await tester.pump();

    // 2. Mock the scan result for missing database
    final noDbResult = CompatibilityResult(
      isReady: false,
      errors: ['❌ NO DATABASE FOUND\nUSB will be slow / No Cues'],
      successes: ['🎵 0 TRACKS VALIDATED\nAudio format compatible'],
      warnings: ['💾 FORMAT CHECK REQUIRED\nEnsure drive is FAT32 (Not exFAT)'],
       manualCheckMessage: '*NOTE: Browsers cannot detect if your USB is FAT32 or NTFS. If using ${djGearList.first.name}, please manually verify your USB is FAT32.',
    );
    scanProvider.setResults(noDbResult);
    await tester.pump();

    // 3. Verify the Results UI
    expect(find.text('ISSUES DETECTED:'), findsOneWidget);
    expect(find.textContaining('NO DATABASE FOUND'), findsOneWidget);
    expect(find.textContaining('USB will be slow'), findsOneWidget);
  });
}
