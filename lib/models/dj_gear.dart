class DjGear {
  final String name;
  final String category;
  final bool hasFlacSupport;
  final bool hasExfatSupport;

  const DjGear({
    required this.name,
    required this.category,
    this.hasFlacSupport = true,
    this.hasExfatSupport = true,
  });
}

const List<DjGear> djGearList = [
  // Multi Players (CDJ/XDJ)
  DjGear(name: 'CDJ-3000', category: 'Multi Players (CDJ/XDJ)'),
  DjGear(name: 'CDJ-2000 Nexus 2', category: 'Multi Players (CDJ/XDJ)', hasExfatSupport: false),
  DjGear(name: 'CDJ-2000 Nexus (No FLAC)', category: 'Multi Players (CDJ/XDJ)', hasFlacSupport: false, hasExfatSupport: false),
  DjGear(name: 'XDJ-1000 MK2', category: 'Multi Players (CDJ/XDJ)', hasExfatSupport: false),
  DjGear(name: 'XDJ-1000 MK1 (No FLAC)', category: 'Multi Players (CDJ/XDJ)', hasFlacSupport: false, hasExfatSupport: false),
  DjGear(name: 'XDJ-700 (No FLAC)', category: 'Multi Players (CDJ/XDJ)', hasFlacSupport: false, hasExfatSupport: false),

  // All-In-One Systems
  DjGear(name: 'AlphaTheta XDJ-AZ', category: 'All-In-One Systems'),
  DjGear(name: 'Pioneer DJ OPUS-QUAD', category: 'All-In-One Systems'),
  DjGear(name: 'AlphaTheta OMNIS-DUO', category: 'All-In-One Systems'),
  DjGear(name: 'Pioneer DJ XDJ-RX3', category: 'All-In-One Systems'),
  DjGear(name: 'Pioneer DJ XDJ-XZ (No exFAT)', category: 'All-In-One Systems', hasExfatSupport: false),
  DjGear(name: 'Pioneer DJ XDJ-RR (No FLAC)', category: 'All-In-One Systems', hasFlacSupport: false, hasExfatSupport: false),
];
