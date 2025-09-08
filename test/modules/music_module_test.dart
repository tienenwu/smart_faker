import 'package:flutter_test/flutter_test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  group('MusicModule', () {
    late SmartFaker faker;

    setUp(() {
      faker = SmartFaker();
    });

    group('Music Basics', () {
      test('should generate song name', () {
        final song = faker.music.songName();
        expect(song, isNotEmpty);
      });

      test('should generate artist name', () {
        final artist = faker.music.artistName();
        expect(artist, isNotEmpty);
      });

      test('should generate album name', () {
        final album = faker.music.albumName();
        expect(album, isNotEmpty);
      });

      test('should generate band name', () {
        final band = faker.music.bandName();
        expect(band, isNotEmpty);
      });

      test('should generate genre', () {
        final genre = faker.music.genre();
        expect(genre, isNotEmpty);
      });

      test('should generate sub-genre', () {
        final subGenre = faker.music.subGenre();
        expect(subGenre, isNotEmpty);
      });

      test('should generate instrument', () {
        final instrument = faker.music.instrument();
        expect(instrument, isNotEmpty);
      });

      test('should generate composer name', () {
        final composer = faker.music.composer();
        expect(composer, isNotEmpty);
      });
    });

    group('Music Properties', () {
      test('should generate song duration', () {
        final duration = faker.music.duration();
        expect(duration, matches(RegExp(r'^\d{1,2}:\d{2}$')));
      });

      test('should generate BPM', () {
        final bpm = faker.music.bpm();
        expect(bpm, greaterThanOrEqualTo(60));
        expect(bpm, lessThanOrEqualTo(200));
      });

      test('should generate key signature', () {
        final key = faker.music.keySignature();
        expect(key, matches(RegExp(r'^[A-G](#|b)?\s(major|minor)$')));
      });

      test('should generate time signature', () {
        final time = faker.music.timeSignature();
        expect(['4/4', '3/4', '6/8', '2/4', '5/4', '7/8', '9/8', '12/8'],
            contains(time));
      });

      test('should generate tempo marking', () {
        final tempo = faker.music.tempoMarking();
        expect([
          'Largo',
          'Adagio',
          'Andante',
          'Moderato',
          'Allegro',
          'Vivace',
          'Presto'
        ], contains(tempo));
      });

      test('should generate dynamics marking', () {
        final dynamics = faker.music.dynamics();
        expect(['pp', 'p', 'mp', 'mf', 'f', 'ff', 'ppp', 'fff'],
            contains(dynamics));
      });
    });

    group('Music Industry', () {
      test('should generate record label', () {
        final label = faker.music.recordLabel();
        expect(label, isNotEmpty);
      });

      test('should generate producer name', () {
        final producer = faker.music.producer();
        expect(producer, isNotEmpty);
      });

      test('should generate studio name', () {
        final studio = faker.music.studio();
        expect(studio, isNotEmpty);
      });

      test('should generate release year', () {
        final year = faker.music.releaseYear();
        expect(year, greaterThanOrEqualTo(1950));
        expect(year, lessThanOrEqualTo(DateTime.now().year));
      });

      test('should generate chart position', () {
        final position = faker.music.chartPosition();
        expect(position, matches(RegExp(r'^#\d{1,3}$')));
      });

      test('should generate award', () {
        final award = faker.music.award();
        expect(award, isNotEmpty);
      });
    });

    group('Music Formats', () {
      test('should generate audio format', () {
        final format = faker.music.audioFormat();
        expect(
            ['MP3', 'FLAC', 'WAV', 'AAC', 'OGG', 'WMA', 'ALAC', 'DSD', 'AIFF'],
            contains(format));
      });

      test('should generate streaming service', () {
        final service = faker.music.streamingService();
        expect(service, isNotEmpty);
      });

      test('should generate playlist name', () {
        final playlist = faker.music.playlistName();
        expect(playlist, isNotEmpty);
      });

      test('should generate sound effect', () {
        final effect = faker.music.soundEffect();
        expect(effect, isNotEmpty);
      });
    });

    group('Classical Music', () {
      test('should generate classical period', () {
        final period = faker.music.classicalPeriod();
        expect(['Baroque', 'Classical', 'Romantic', 'Modern', 'Contemporary'],
            contains(period));
      });

      test('should generate orchestra section', () {
        final section = faker.music.orchestraSection();
        expect(
            ['Strings', 'Woodwinds', 'Brass', 'Percussion'], contains(section));
      });

      test('should generate musical form', () {
        final form = faker.music.musicalForm();
        expect(form, isNotEmpty);
      });
    });

    group('Lyrics', () {
      test('should generate song lyric line', () {
        final lyric = faker.music.lyricLine();
        expect(lyric, isNotEmpty);
      });

      test('should generate rhyme scheme', () {
        final scheme = faker.music.rhymeScheme();
        expect(
            ['ABAB', 'ABBA', 'AABB', 'ABCB', 'AAAA', 'ABAC'], contains(scheme));
      });
    });

    group('Seeded Generation', () {
      test('should generate reproducible music data with seed', () {
        final faker1 = SmartFaker(seed: 42);
        final faker2 = SmartFaker(seed: 42);

        expect(faker1.music.songName(), equals(faker2.music.songName()));
        expect(faker1.music.artistName(), equals(faker2.music.artistName()));
        expect(faker1.music.genre(), equals(faker2.music.genre()));
      });
    });
  });
}
