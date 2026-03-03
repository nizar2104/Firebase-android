
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            flex: 2,
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
                        ).then((_) => scanProvider.results.clear()));

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
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Color(0xFF121212),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const _HardwareButtons(),
                    const SizedBox(height: 20),
                    const _SupportLink(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GearSelectionScreen extends StatefulWidget {
  const _GearSelectionScreen({super.key});

  @override
  State<_GearSelectionScreen> createState() => _GearSelectionScreenState();
}

class _GearSelectionScreenState extends State<_GearSelectionScreen> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context);
    final gearCategories = djGearList.map((e) => e.category).toSet().toList();
    final gearInCategory = _selectedCategory == null
        ? <DjGear>[]
        : djGearList.where((gear) => gear.category == _selectedCategory).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButton<String>(
            value: _selectedCategory,
            hint: const Text('Select a category', style: TextStyle(color: Colors.white)),
            isExpanded: true,
            dropdownColor: const Color(0xFF1E1E1E),
            underline: const SizedBox(),
            onChanged: (String? value) {
              setState(() {
                _selectedCategory = value;
                scanProvider.selectGear(null);
              });
            },
            items: gearCategories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        if (_selectedCategory != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButton<DjGear>(
              value: scanProvider.selectedGear,
              hint: const Text('Select a gear', style: TextStyle(color: Colors.white)),
              isExpanded: true,
              dropdownColor: const Color(0xFF1E1E1E),
              underline: const SizedBox(),
              onChanged: (DjGear? value) {
                if (value != null) {
                  scanProvider.selectGear(value);
                }
              },
              items: gearInCategory.map<DropdownMenuItem<DjGear>>((DjGear value) {
                return DropdownMenuItem<DjGear>(
                  value: value,
                  child: Text(value.name, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),
          ),
      ],
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
          child: const Text('SCAN',
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

class _SupportLink extends StatelessWidget {
  const _SupportLink({super.key});

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Liked this tool? Support me here:',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => _launchURL('https://www.instagram.com/no.mad.dj_/'),
          icon: const FaIcon(FontAwesomeIcons.instagram, color: Colors.white),
          label: const Text('Follow me on Instagram'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE1306C),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () => _launchURL('https://buymeacoffee.com/baklavaproject'),
          icon: const FaIcon(FontAwesomeIcons.coffee, color: Colors.white),
          label: const Text('Buy me a Coffee'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFDD00),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          ),
        ),
      ],
    );
  }
}
