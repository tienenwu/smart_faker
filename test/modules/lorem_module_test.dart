import 'package:flutter_test/flutter_test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  group('LoremModule', () {
    late SmartFaker faker;

    setUp(() {
      faker = SmartFaker();
    });

    group('Word Generation', () {
      test('should generate a word', () {
        final word = faker.lorem.word();
        expect(word, isNotEmpty);
        expect(word, matches(RegExp(r'^[a-z]+$')));
      });

      test('should generate multiple words', () {
        final words = faker.lorem.words(count: 5);
        final wordList = words.split(' ');
        expect(wordList, hasLength(5));
      });
    });

    group('Sentence Generation', () {
      test('should generate a sentence', () {
        final sentence = faker.lorem.sentence();
        expect(sentence, isNotEmpty);
        expect(sentence, endsWith('.'));
        expect(sentence[0], matches(RegExp(r'[A-Z]')));
      });

      test('should generate sentence with specific word count', () {
        final sentence = faker.lorem.sentence(wordCount: 10);
        final words = sentence.replaceAll('.', '').split(' ');
        expect(words.length, greaterThanOrEqualTo(8));
        expect(words.length, lessThanOrEqualTo(12));
      });

      test('should generate multiple sentences', () {
        final sentences = faker.lorem.sentences(count: 3);
        final sentenceList = sentences.split('. ');
        expect(sentenceList.length, greaterThanOrEqualTo(3));
      });
    });

    group('Paragraph Generation', () {
      test('should generate a paragraph', () {
        final paragraph = faker.lorem.paragraph();
        expect(paragraph, isNotEmpty);
        expect(paragraph, contains('. '));
      });

      test('should generate paragraph with specific sentence count', () {
        final paragraph = faker.lorem.paragraph(sentenceCount: 5);
        final sentences = paragraph.split('. ');
        expect(sentences.length, greaterThanOrEqualTo(4));
        expect(sentences.length, lessThanOrEqualTo(6));
      });

      test('should generate multiple paragraphs', () {
        final paragraphs = faker.lorem.paragraphs(count: 3);
        final paragraphList = paragraphs.split('\n\n');
        expect(paragraphList, hasLength(3));
      });
    });

    group('Text Generation', () {
      test('should generate text with specific length', () {
        final text = faker.lorem.text(maxLength: 100);
        expect(text.length, lessThanOrEqualTo(100));
        expect(text, isNotEmpty);
      });

      test('should generate lines of text', () {
        final lines = faker.lorem.lines(count: 4);
        final lineList = lines.split('\n');
        expect(lineList, hasLength(4));
      });
    });

    group('Slug Generation', () {
      test('should generate a slug', () {
        final slug = faker.lorem.slug();
        expect(slug, matches(RegExp(r'^[a-z-]+$')));
        expect(slug, contains('-'));
      });

      test('should generate slug with specific word count', () {
        final slug = faker.lorem.slug(wordCount: 4);
        final parts = slug.split('-');
        expect(parts, hasLength(4));
      });
    });

    group('Locale-specific Generation', () {
      test('should generate English lorem text', () {
        final faker = SmartFaker(locale: 'en_US');
        final word = faker.lorem.word();
        expect(word, matches(RegExp(r'^[a-z]+$')));
      });

      test('should generate Traditional Chinese lorem text', () {
        final faker = SmartFaker(locale: 'zh_TW');
        final word = faker.lorem.word();
        expect(word, isNotEmpty);
      });

      test('should generate Japanese lorem text', () {
        final faker = SmartFaker(locale: 'ja_JP');
        final word = faker.lorem.word();
        expect(word, isNotEmpty);
      });
    });

    group('Seeded Generation', () {
      test('should generate reproducible lorem text with seed', () {
        final faker1 = SmartFaker(seed: 42);
        final faker2 = SmartFaker(seed: 42);

        expect(faker1.lorem.word(), equals(faker2.lorem.word()));
        expect(faker1.lorem.sentence(), equals(faker2.lorem.sentence()));
        expect(faker1.lorem.paragraph(), equals(faker2.lorem.paragraph()));
      });
    });
  });
}
