Map<String, List<String>> mockFileSystems = {
  '/': [
    '/artists/Avicii/Levels.mp3',
    '/artists/Avicii/The Nights.mp3',
    '/artists/Daft Punk/album1/track1.mp3',
    '/artists/Daft Punk/album1/track2.flac',
    '/artists/Daft Punk/album2/track1.wav',
    '/artists/Strobe/track1.aiff',
    '/artists/Strobe/track2.flac',
    '/PIONEER/somefile.dat',
  ],
  '/no_pioneer': [
    '/artists/Avicii/Levels.mp3',
    '/artists/Avicii/The Nights.mp3',
  ],
  '/unsupported_files': [
    '/artists/Avicii/Levels.mp3',
    '/artists/Avicii/The Nights.mp3',
    '/artists/Daft Punk/album1/track1.mp3',
    '/artists/Daft Punk/album1/track2.flac',
    '/artists/Daft Punk/album2/track1.wav',
    '/artists/Strobe/track1.aiff',
    '/artists/Strobe/track2.flac',
    '/PIONEER/somefile.dat',
  ],
};

List<String> getMockFileSystemForScenario(String scenario) {
  return mockFileSystems[scenario] ?? [];
}
