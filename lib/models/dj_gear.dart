
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
  // CDJ Media Players
  DjGear(name: 'CDJ-3000', category: 'CDJ Media Players'),
  DjGear(name: 'CDJ-2000 Nexus 2', category: 'CDJ Media Players'),
  DjGear(name: 'CDJ-2000 Nexus', category: 'CDJ Media Players', hasFlacSupport: false),

  // XDJ Media Players
  DjGear(name: 'XDJ-1000 MK2', category: 'XDJ Media Players'),
  DjGear(name: 'XDJ-1000 MK1', category: 'XDJ Media Players', hasFlacSupport: false),
  DjGear(name: 'XDJ-700', category: 'XDJ Media Players', hasFlacSupport: false),

  // All-In-One DJ Systems
  DjGear(name: 'AlphaTheta XDJ-AZ', category: 'All-In-One DJ Systems'),
  DjGear(name: 'Pioneer DJ OPUS-QUAD', category: 'All-In-One DJ Systems'),
  DjGear(name: 'AlphaTheta OMNIS-DUO', category: 'All-In-One DJ Systems'),
  DjGear(name: 'Pioneer DJ XDJ-RX3', category: 'All-In-One DJ Systems'),
  DjGear(name: 'Pioneer DJ XDJ-XZ', category: 'All-In-One DJ Systems', hasExfatSupport: false),
  DjGear(name: 'Pioneer DJ XDJ-RR', category: 'All-In-One DJ Systems', hasFlacSupport: false),
];
