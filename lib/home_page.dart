
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'scan_provider.dart';
import 'results_page.dart';
import 'models/dj_gear.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('CDJ-3000 Simulator'),
            Text(
              'By No-Mad',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFF1E1E1E),
      body: Column(
        children: [
          // CDJ Screen
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: Consumer<ScanProvider>(
                builder: (context, scanProvider, child) {
                  if (scanProvider.isLoading) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF0000)),
                          ),
                          SizedBox(height: 20),
                          Text('Analyzing USB...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (scanProvider.results.isNotEmpty) {
                    Future.microtask(() => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ResultsPage()),
                        ).then((_) => scanProvider.results.clear())); // Clear results on return

                    return const Center(
                      child: Text('Scan complete. Loading results...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    );
                  } else {
                    return const _GearSelectionScreen();
                  }
                },
              ),
            ),
          ),
          // CDJ Body
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Color(0xFF121212),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _UsbSlot(),
                  SizedBox(height: 20),
                  _HardwareButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GearSelectionScreen extends StatelessWidget {
  const _GearSelectionScreen();

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context);
    final gearCategories = djGearList.map((e) => e.category).toSet().toList();

    return ListView.builder(
      itemCount: gearCategories.length,
      itemBuilder: (context, index) {
        final category = gearCategories[index];
        final gearInCategory = djGearList.where((gear) => gear.category == category).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              child: Text(category, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: const Color(0xFFFFFF00))),
            ),
            ...gearInCategory.map((gear) => RadioListTile<DjGear>(
              title: Text(gear.name, style: const TextStyle(color: Colors.white)),
              value: gear,
              groupValue: scanProvider.selectedGear,
              onChanged: (DjGear? value) {
                if (value != null) {
                  scanProvider.selectGear(value);
                }
              },
              activeColor: const Color(0xFFFF0000),
              controlAffinity: ListTileControlAffinity.trailing,
            )),
          ],
        );
      },
    );
  }
}


class _UsbSlot extends StatelessWidget {
  const _UsbSlot();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'USB',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Icon(
            Icons.usb,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}

class _HardwareButtons extends StatelessWidget {
  const _HardwareButtons();

  @override
  Widget build(BuildContext context) {
    return Consumer<ScanProvider>(
      builder: (context, scanProvider, child) {
        final isGearSelected = scanProvider.selectedGear != null;
        return ElevatedButton(
          onPressed: isGearSelected && !scanProvider.isLoading
              ? () => scanProvider.selectAndScanDirectory()
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isGearSelected ? const Color(0xFFFFFF00) : Colors.grey,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(32),
          ),
          child: const Text('SCAN', // Changed from USB to SCAN
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        );
      },
    );
  }
}
