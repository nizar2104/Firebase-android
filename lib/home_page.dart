
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'scan_provider.dart';
import 'results_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CDJ-3000 Simulator'),
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
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDF1F26)),
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
                    // Navigate to results page after scan
                    Future.microtask(() => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ResultsPage()),
                        ));
                    return const Center(
                      child: Text('Scan complete. Loading results...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'Insert USB and press "USB" button',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    );
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
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                if (!scanProvider.isLoading) {
                  scanProvider.selectAndScanDirectory();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5B50A), // Yellow
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(24),
              ),
              child: const Text('USB',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
