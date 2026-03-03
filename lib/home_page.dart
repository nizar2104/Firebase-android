
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';
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
          children: [
            const Text('CDJ-3000 Simulator', textAlign: TextAlign.center),
            Text(
              'By No-Mad',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
        centerTitle: true,
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
                    const SizedBox(height: 30),
                    const _SupportSection(),
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

class _GearSelectionScreen extends StatelessWidget {
  const _GearSelectionScreen();

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownSearch<DjGear>(
            asyncItems: (String filter) async {
                final allGear = djGearList;
                if (filter.isEmpty) {
                    return allGear;
                }
                return allGear.where((gear) => gear.name.toLowerCase().contains(filter.toLowerCase())).toList();
            },
            popupProps: PopupProps.menu(
              showSearchBox: true,
               searchFieldProps: TextFieldProps(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search for your gear...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade800),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFFF00)),
                  ),
                ),
              ),
              menuProps: const MenuProps(
                backgroundColor: Color(0xFF1E1E1E),
              ),
              itemBuilder: (context, item, isSelected) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    item.name,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFFFFFF00) : Colors.white,
                    ),
                  ),
                );
              },
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              baseStyle: const TextStyle(color: Colors.white),
              dropdownSearchDecoration: InputDecoration(
                labelText: "Select your DJ Gear",
                labelStyle: const TextStyle(color: Color(0xFFFFFF00)),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey.shade800),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey.shade800),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Color(0xFFFFFF00)),
                ),
              ),
            ),
            itemAsString: (DjGear gear) => gear.name,
            onChanged: (DjGear? gear) {
              scanProvider.selectGear(gear);
            },
            selectedItem: scanProvider.selectedGear,
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
        return SizedBox(
          width: 150,
          height: 150,
          child: ElevatedButton(
            onPressed: isGearSelected && !scanProvider.isLoading
                ? () => scanProvider.selectAndScanDirectory()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isGearSelected ? const Color(0xFFFFFF00) : Colors.grey.shade800,
              foregroundColor: Colors.black,
              shape: const CircleBorder(),
              elevation: 8,
              shadowColor: isGearSelected ? const Color(0xFFFFFF00).withOpacity(0.5) : Colors.transparent,
            ),
            child: const Text(
              'SCAN',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SupportSection extends StatelessWidget {
  const _SupportSection();

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade800)
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'SUPPORT THE PROJECT',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFFFFF00),
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _launchURL('https://www.instagram.com/no.mad.dj_/'),
            icon: const FaIcon(FontAwesomeIcons.instagram, color: Colors.white),
            label: const Text('Follow on Instagram'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE1306C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () => _launchURL('https://buymeacoffee.com/baklavaproject'),
            icon: const FaIcon(FontAwesomeIcons.coffee, color: Colors.black),
            label: const Text('Buy me a Coffee'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFDD00),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
