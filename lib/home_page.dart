import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

import 'scan_provider.dart';
import 'models/dj_gear.dart';
import 'results_page.dart'; // We'll build the results here directly

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Dark Overlay
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1571266028243-371695039980?q=80&w=2070&auto=format&fit=crop'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.85),
            ),
          ),

          // Main Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: 650,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(26, 26, 26, 0.95),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF333333)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 87, 231, 0.4),
                      blurRadius: 50,
                    )
                  ],
                ),
                child: const _ContentBody(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentBody extends StatelessWidget {
  const _ContentBody();

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const Text(
          'CDJ SIMULATOR',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'BY NO-MAD',
          style: TextStyle(
            color: Color(0xFF0057e7),
            fontSize: 19.2, // 1.2rem
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          'USB VALIDATOR & COMPATIBILITY CHECKER',
          style: TextStyle(
            color: Color(0xFF888888),
            fontSize: 14.4, // 0.9rem
          ),
        ),
        const SizedBox(height: 15),
        const Divider(color: Color(0xFF333333)),
        const SizedBox(height: 15),

        // Controls
        const _GearSelectionDropdown(),
        const SizedBox(height: 20),
        const _LoadUsbButton(),
        const SizedBox(height: 30),

        // Result Screen or Loading state
        if (scanProvider.isLoading)
          const _LoadingScreen()
        else if (scanProvider.results != null)
          const ResultsPage(), // Display results directly

        const SizedBox(height: 30),

        // Social Box
        const _SocialBox(),
      ],
    );
  }
}

class _GearSelectionDropdown extends StatefulWidget {
  const _GearSelectionDropdown();

  @override
  _GearSelectionDropdownState createState() => _GearSelectionDropdownState();
}

class _GearSelectionDropdownState extends State<_GearSelectionDropdown> {
  
  List<DropdownMenuItem<DjGear>> _buildDropdownItems() {
    final List<DropdownMenuItem<DjGear>> items = [];
    final categories = djGearList.map((e) => e.category).toSet().toList();

    for (var category in categories) {
      // Add a non-selectable header
      items.add(
        DropdownMenuItem(
          enabled: false,
          child: Text(
            category,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF0057e7),
            ),
          ),
        ),
      );

      // Add gear for this category
      final gearInCategory = djGearList.where((gear) => gear.category == category);
      for (var gear in gearInCategory) {
        items.add(
          DropdownMenuItem(
            value: gear,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(gear.name, style: const TextStyle(color: Colors.white)),
            ),
          ),
        );
      }
    }
    return items;
  }
  
  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context, listen: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TARGET EQUIPMENT',
          style: TextStyle(color: Color(0xFFaaaaaa), fontSize: 12.8), // 0.8rem
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF333333),
            border: Border.all(color: const Color(0xFF444444)),
          ),
          child: DropdownButton<DjGear>(
            value: scanProvider.selectedGear,
            hint: const Text('Select Equipment...', style: TextStyle(color: Colors.white70)),
            isExpanded: true,
            dropdownColor: const Color(0xFF222222),
            underline: const SizedBox(),
            style: const TextStyle(color: Colors.white, fontSize: 16),
            onChanged: (DjGear? value) {
              if (value != null) {
                scanProvider.selectGear(value);
              }
            },
            items: _buildDropdownItems(),
          ),
        ),
      ],
    );
  }
}


class _LoadUsbButton extends StatelessWidget {
  const _LoadUsbButton();

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context);
    final bool isGearSelected = scanProvider.selectedGear != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SELECT YOUR USB DRIVE',
          style: TextStyle(color: Color(0xFFaaaaaa), fontSize: 12.8),
        ),
        const SizedBox(height: 5),
        ElevatedButton.icon(
          icon: const Text('💿', style: TextStyle(fontSize: 20)),
          label: const Text('LOAD USB FOLDER'),
          style: ElevatedButton.styleFrom(
            backgroundColor: isGearSelected ? const Color(0xFF0057e7) : Colors.grey.shade700,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          onPressed: isGearSelected && !scanProvider.isLoading
              ? () {
                  scanProvider.selectAndScanDirectory();
                }
              : null,
        ),
      ],
    );
  }
}


class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.all(20),
      height: 150,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: const Color(0xFF333333), width: 4),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0057e7)),
            ),
            SizedBox(height: 20),
            Text(
              'SCANNING...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Courier New',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialBox extends StatelessWidget {
  const _SocialBox();

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      margin: const EdgeInsets.only(top: 30),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF333333))),
      ),
      child: Column(
        children: [
          const Text(
            'Liked this tool? Support me here:',
            style: TextStyle(color: Color(0xFF888888), fontSize: 12.8),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () => _launchURL('https://www.instagram.com/no.mad.dj_/'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF405de6),
                    Color(0xFF5851db),
                    Color(0xFF833ab4),
                    Color(0xFFc13584),
                    Color(0xFFe1306c),
                    Color(0xFFfd1d1d),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: const Center(
                child: Text(
                  'Follow No-Mad on Instagram 🇬🇷',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}