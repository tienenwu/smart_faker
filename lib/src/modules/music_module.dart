import '../core/locale_manager.dart';
import '../core/random_generator.dart';

/// Module for generating music-related data.
class MusicModule {
  /// Random generator instance for generating random values.
  final RandomGenerator random;

  /// Locale manager for handling localization.
  final LocaleManager localeManager;

  /// Creates a new instance of [MusicModule].
  ///
  /// [random] is used for generating random values.
  /// [localeManager] handles localization of music data.
  MusicModule(this.random, this.localeManager);

  /// Gets the current locale code.
  String get currentLocale => localeManager.currentLocale;

  /// Generates a song name.
  String songName() {
    final patterns = [
      () => '${random.element(_adjectives)} ${random.element(_nouns)}',
      () => 'The ${random.element(_nouns)}',
      () => '${random.element(_verbs)} Me',
      () => '${random.element(_adjectives)} ${random.element(_emotions)}',
      () => '${random.element(_nouns)} of ${random.element(_emotions)}',
      () => 'When ${random.element(_timeWords)} ${random.element(_verbs)}',
    ];

    return patterns[random.nextInt(patterns.length)]();
  }

  /// Generates an artist name.
  String artistName() {
    if (random.boolean()) {
      // Band-style name
      return bandName();
    } else {
      // Solo artist name
      final firstName = random.element(_firstNames);
      final lastName = random.element(_lastNames);
      return '$firstName $lastName';
    }
  }

  /// Generates an album name.
  String albumName() {
    final patterns = [
      () => songName(),
      () => '${random.element(_adjectives)} ${random.element(_concepts)}',
      () => 'The ${random.element(_concepts)} Sessions',
      () => '${random.element(_colors)} ${random.element(_nouns)}',
      () => random.element(_concepts),
    ];

    return patterns[random.nextInt(patterns.length)]();
  }

  /// Generates a band name.
  String bandName() {
    final patterns = [
      () =>
          'The ${random.element(_adjectives)} ${random.element(_pluralNouns)}',
      () => '${random.element(_nouns)} ${random.element(_bandSuffixes)}',
      () => '${random.element(_adjectives)} ${random.element(_animals)}',
      () => '${random.element(_colors)} ${random.element(_objects)}',
      () => random.element(_singleBandNames),
    ];

    return patterns[random.nextInt(patterns.length)]();
  }

  /// Generates a music genre.
  String genre() {
    return random.element(_genres);
  }

  /// Generates a music sub-genre.
  String subGenre() {
    final mainGenre = genre();
    final prefix = random.element(
        ['Alternative', 'Neo', 'Post', 'Indie', 'Progressive', 'Experimental']);
    return '$prefix $mainGenre';
  }

  /// Generates a musical instrument.
  String instrument() {
    return random.element(_instruments);
  }

  /// Generates a composer name.
  String composer() {
    return random.element(_composers);
  }

  /// Generates a song duration.
  String duration() {
    final minutes = random.integer(min: 2, max: 8);
    final seconds = random.integer(min: 0, max: 59);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Generates BPM (beats per minute).
  int bpm() {
    return random.integer(min: 60, max: 200);
  }

  /// Generates a musical key signature.
  String keySignature() {
    final note = random.element(['C', 'D', 'E', 'F', 'G', 'A', 'B']);
    final accidental = random.element(['', '#', 'b']);
    final mode = random.element(['major', 'minor']);
    return '$note$accidental $mode';
  }

  /// Generates a time signature.
  String timeSignature() {
    return random
        .element(['4/4', '3/4', '6/8', '2/4', '5/4', '7/8', '9/8', '12/8']);
  }

  /// Generates a tempo marking.
  String tempoMarking() {
    return random.element([
      'Largo',
      'Adagio',
      'Andante',
      'Moderato',
      'Allegro',
      'Vivace',
      'Presto'
    ]);
  }

  /// Generates a dynamics marking.
  String dynamics() {
    return random.element(['pp', 'p', 'mp', 'mf', 'f', 'ff', 'ppp', 'fff']);
  }

  /// Generates a record label name.
  String recordLabel() {
    final patterns = [
      () => '${random.element(_adjectives)} Records',
      () => '${random.element(_nouns)} Music',
      () => '${random.element(_colors)} Label',
      () => '${random.element(_concepts)} Recordings',
      () => random.element(_realLabels),
    ];

    return patterns[random.nextInt(patterns.length)]();
  }

  /// Generates a producer name.
  String producer() {
    final firstName = random.element(_firstNames);
    final lastName = random.element(_lastNames);
    final nicknames = ['Dr.', 'DJ', 'MC', '', '', ''];
    final nickname = random.element(nicknames);

    if (nickname.isNotEmpty) {
      return '$nickname $firstName';
    }
    return '$firstName $lastName';
  }

  /// Generates a studio name.
  String studio() {
    final patterns = [
      () => '${random.element(_adjectives)} Sound Studios',
      () => '${random.element(_nouns)} Recording',
      () => 'The ${random.element(_concepts)} Room',
      () => '${random.element(_cities)} Studios',
    ];

    return patterns[random.nextInt(patterns.length)]();
  }

  /// Generates a release year.
  int releaseYear() {
    final currentYear = DateTime.now().year;
    return random.integer(min: 1950, max: currentYear);
  }

  /// Generates a chart position.
  String chartPosition() {
    final position = random.integer(min: 1, max: 100);
    return '#$position';
  }

  /// Generates a music award.
  String award() {
    return random.element(_awards);
  }

  /// Generates an audio format.
  String audioFormat() {
    return random.element(
        ['MP3', 'FLAC', 'WAV', 'AAC', 'OGG', 'WMA', 'ALAC', 'DSD', 'AIFF']);
  }

  /// Generates a streaming service name.
  String streamingService() {
    return random.element(_streamingServices);
  }

  /// Generates a playlist name.
  String playlistName() {
    final patterns = [
      () => '${random.element(_moods)} Vibes',
      () => '${random.element(_activities)} Playlist',
      () => '${random.element(_timeWords)} ${random.element(_moods)}',
      () => 'Best of ${genre()}',
      () => '${random.element(_adjectives)} Beats',
    ];

    return patterns[random.nextInt(patterns.length)]();
  }

  /// Generates a sound effect name.
  String soundEffect() {
    return random.element(_soundEffects);
  }

  /// Generates a classical music period.
  String classicalPeriod() {
    return random.element(
        ['Baroque', 'Classical', 'Romantic', 'Modern', 'Contemporary']);
  }

  /// Generates an orchestra section.
  String orchestraSection() {
    return random.element(['Strings', 'Woodwinds', 'Brass', 'Percussion']);
  }

  /// Generates a musical form.
  String musicalForm() {
    return random.element(_musicalForms);
  }

  /// Generates a song lyric line.
  String lyricLine() {
    final patterns = [
      () => 'I ${random.element(_verbs)} you like ${random.element(_nouns)}',
      () =>
          'We are ${random.element(_adjectives)} in the ${random.element(_timeWords)}',
      () => 'Take me to the ${random.element(_places)}',
      () => 'Your ${random.element(_nouns)} is my ${random.element(_emotions)}',
      () =>
          'Dancing through the ${random.element(_adjectives)} ${random.element(_timeWords)}',
    ];

    return patterns[random.nextInt(patterns.length)]();
  }

  /// Generates a rhyme scheme.
  String rhymeScheme() {
    return random.element(['ABAB', 'ABBA', 'AABB', 'ABCB', 'AAAA', 'ABAC']);
  }

  static final List<String> _genres = [
    'Rock',
    'Pop',
    'Jazz',
    'Classical',
    'Electronic',
    'Hip Hop',
    'R&B',
    'Country',
    'Blues',
    'Reggae',
    'Folk',
    'Metal',
    'Punk',
    'Soul',
    'Funk',
    'Disco',
    'House',
    'Techno',
    'Dubstep',
    'Trap',
    'Latin',
    'Gospel',
    'Opera',
    'Ambient',
    'Indie',
  ];

  static final List<String> _instruments = [
    'Guitar',
    'Piano',
    'Drums',
    'Bass',
    'Violin',
    'Saxophone',
    'Trumpet',
    'Flute',
    'Cello',
    'Clarinet',
    'Trombone',
    'Harmonica',
    'Accordion',
    'Synthesizer',
    'Keyboard',
    'Ukulele',
    'Banjo',
    'Mandolin',
    'Harp',
    'Oboe',
    'French Horn',
    'Tuba',
    'Xylophone',
    'Marimba',
    'Tambourine',
  ];

  static final List<String> _composers = [
    'Johann Sebastian Bach',
    'Wolfgang Amadeus Mozart',
    'Ludwig van Beethoven',
    'Johannes Brahms',
    'Richard Wagner',
    'Claude Debussy',
    'Igor Stravinsky',
    'Pyotr Ilyich Tchaikovsky',
    'Frédéric Chopin',
    'Antonio Vivaldi',
    'George Gershwin',
    'Philip Glass',
    'John Williams',
    'Hans Zimmer',
  ];

  static final List<String> _adjectives = [
    'Electric',
    'Golden',
    'Silver',
    'Cosmic',
    'Midnight',
    'Crystal',
    'Velvet',
    'Neon',
    'Silent',
    'Eternal',
    'Broken',
    'Wild',
    'Sacred',
    'Hidden',
    'Lost',
    'Flying',
    'Burning',
    'Frozen',
    'Dancing',
    'Shining',
  ];

  static final List<String> _nouns = [
    'Heart',
    'Soul',
    'Dream',
    'Fire',
    'Ocean',
    'Mountain',
    'Star',
    'Moon',
    'Sun',
    'Rain',
    'Thunder',
    'Lightning',
    'Shadow',
    'Light',
    'Love',
    'Hope',
    'Fear',
    'Joy',
    'Pain',
    'Memory',
  ];

  static final List<String> _pluralNouns = [
    'Hearts',
    'Souls',
    'Dreams',
    'Stars',
    'Shadows',
    'Lights',
    'Memories',
    'Moments',
    'Echoes',
    'Waves',
    'Flames',
    'Stones',
  ];

  static final List<String> _emotions = [
    'Love',
    'Joy',
    'Sorrow',
    'Hope',
    'Fear',
    'Anger',
    'Peace',
    'Longing',
    'Happiness',
    'Melancholy',
    'Ecstasy',
    'Despair',
  ];

  static final List<String> _verbs = [
    'Love',
    'Need',
    'Want',
    'Feel',
    'Dream',
    'Believe',
    'Dance',
    'Sing',
    'Fly',
    'Fall',
    'Rise',
    'Shine',
    'Burn',
    'Break',
  ];

  static final List<String> _timeWords = [
    'Night',
    'Day',
    'Morning',
    'Evening',
    'Dawn',
    'Dusk',
    'Midnight',
    'Summer',
    'Winter',
    'Spring',
    'Autumn',
    'Yesterday',
    'Tomorrow',
  ];

  static final List<String> _colors = [
    'Red',
    'Blue',
    'Green',
    'Yellow',
    'Purple',
    'Orange',
    'Black',
    'White',
    'Silver',
    'Gold',
    'Crimson',
    'Azure',
    'Emerald',
  ];

  static final List<String> _animals = [
    'Lions',
    'Tigers',
    'Bears',
    'Wolves',
    'Eagles',
    'Dragons',
    'Phoenixes',
    'Ravens',
    'Serpents',
    'Panthers',
    'Falcons',
  ];

  static final List<String> _objects = [
    'Roses',
    'Diamonds',
    'Mirrors',
    'Bridges',
    'Towers',
    'Gates',
    'Crowns',
    'Swords',
    'Shields',
    'Arrows',
    'Chains',
    'Keys',
  ];

  static final List<String> _concepts = [
    'Revolution',
    'Evolution',
    'Redemption',
    'Liberation',
    'Ascension',
    'Transformation',
    'Illumination',
    'Revelation',
    'Constellation',
  ];

  static final List<String> _bandSuffixes = [
    'Project',
    'Collective',
    'Orchestra',
    'Ensemble',
    'Experience',
    'Movement',
    'Coalition',
    'Society',
    'Union',
    'Alliance',
  ];

  static final List<String> _singleBandNames = [
    'Genesis',
    'Journey',
    'Rush',
    'Yes',
    'Kansas',
    'Boston',
    'Chicago',
    'America',
    'Europe',
    'Asia',
    'Toto',
    'Styx',
    'Heart',
    'Poison',
  ];

  static final List<String> _firstNames = [
    'John',
    'Paul',
    'George',
    'David',
    'Michael',
    'James',
    'Robert',
    'Mary',
    'Jennifer',
    'Lisa',
    'Sarah',
    'Emma',
    'Taylor',
    'Alex',
  ];

  static final List<String> _lastNames = [
    'Smith',
    'Johnson',
    'Williams',
    'Brown',
    'Jones',
    'Garcia',
    'Miller',
    'Davis',
    'Rodriguez',
    'Martinez',
    'Wilson',
    'Anderson',
  ];

  static final List<String> _realLabels = [
    'Universal Music',
    'Sony Music',
    'Warner Music',
    'EMI',
    'Columbia',
    'Atlantic',
    'Capitol',
    'Def Jam',
    'Motown',
    'Blue Note',
    'Sub Pop',
  ];

  static final List<String> _cities = [
    'Abbey Road',
    'Nashville',
    'Memphis',
    'Detroit',
    'Los Angeles',
    'New York',
    'London',
    'Berlin',
    'Tokyo',
    'Paris',
  ];

  static final List<String> _awards = [
    'Grammy Award',
    'Billboard Music Award',
    'MTV Music Award',
    'American Music Award',
    'BRIT Award',
    'Mercury Prize',
    'Gold Record',
    'Platinum Record',
    'Diamond Record',
  ];

  static final List<String> _streamingServices = [
    'Spotify',
    'Apple Music',
    'YouTube Music',
    'Amazon Music',
    'Tidal',
    'Deezer',
    'Pandora',
    'SoundCloud',
    'Bandcamp',
  ];

  static final List<String> _moods = [
    'Chill',
    'Happy',
    'Sad',
    'Energetic',
    'Relaxing',
    'Motivational',
    'Romantic',
    'Melancholic',
    'Uplifting',
    'Peaceful',
    'Intense',
  ];

  static final List<String> _activities = [
    'Workout',
    'Study',
    'Party',
    'Road Trip',
    'Coffee Shop',
    'Sleep',
    'Focus',
    'Meditation',
    'Running',
    'Cooking',
    'Reading',
  ];

  static final List<String> _places = [
    'Stars',
    'Moon',
    'Ocean',
    'Mountain',
    'City',
    'Highway',
    'Rainbow',
    'Paradise',
    'Heaven',
    'Universe',
    'Horizon',
  ];

  static final List<String> _soundEffects = [
    'Reverb',
    'Echo',
    'Delay',
    'Chorus',
    'Flanger',
    'Phaser',
    'Distortion',
    'Overdrive',
    'Compression',
    'EQ',
    'Filter',
    'Pitch Shift',
    'Auto-Tune',
    'Vocoder',
    'Tremolo',
    'Vibrato',
  ];

  static final List<String> _musicalForms = [
    'Sonata',
    'Symphony',
    'Concerto',
    'Fugue',
    'Canon',
    'Rondo',
    'Minuet',
    'Scherzo',
    'Waltz',
    'March',
    'Prelude',
    'Etude',
    'Nocturne',
    'Rhapsody',
    'Variations',
    'Suite',
  ];
}
